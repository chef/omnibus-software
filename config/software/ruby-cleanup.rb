#
# Copyright:: Copyright (c) 2014-2020, Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Common cleanup routines for ruby apps (InSpec, Workstation, Chef, etc)
# expeditor/ignore: logic only

require "fileutils"

name "ruby-cleanup"
default_version "1.0.0"

license :project_license
skip_transitive_dependency_licensing true

dependency "zlib" # just so we clear health-check & zlib is ruby dependency

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # patchelf was only installed to change the rpath for adoptopenjre binary
  # delete
  command "find #{install_dir} -name patchelf -exec rm -rf \\{\\} \\;" unless windows?

  # Remove static object files for all platforms
  # except AIX which uses them at runtime.
  unless aix?
    block "Remove static libraries" do
      gemfile = "#{install_dir}/embedded/bin/gem"
      next unless File.exist?(gemfile)

      gemdir = shellout!("#{gemfile} environment gemdir", env: env).stdout.chomp

      # find all the static *.a files and delete them
      Dir.glob("#{gemdir}/**/*.a").each do |f|
        puts "Deleting #{f}"
        File.delete(f)
      end
    end
  end

  # Clear the now-unnecessary git caches, docs, and build information
  block "Delete bundler git cache, docs, and build info" do
    gemfile = "#{install_dir}/embedded/bin/gem"
    next unless File.exist?(gemfile)

    gemdir = shellout!("#{gemfile} environment gemdir", env: env).stdout.chomp

    remove_directory "#{gemdir}/cache"
    remove_directory "#{gemdir}/doc"
    remove_directory "#{gemdir}/build_info"
  end

  block "Remove bundler gem caches" do
    gemfile = "#{install_dir}/embedded/bin/gem"
    next unless File.exist?(gemfile)

    gemdir = shellout!("#{gemfile} environment gemdir", env: env).stdout.chomp

    Dir.glob("#{gemdir}/bundler/gems/**").each do |f|
      puts "Deleting #{f}"
      remove_directory f
    end
  end

  block "Remove leftovers from compiling gems" do
    # find the embedded ruby gems dir and clean it up for globbing
    next unless File.directory?("#{install_dir}/embedded/lib/ruby/gems")

    target_dir = "#{install_dir}/embedded/lib/ruby/gems/*/".tr("\\", "/")

    # find gem_make.out and mkmf.log files
    Dir.glob(Dir.glob("#{target_dir}/**/{gem_make.out,mkmf.log}")).each do |f|
      puts "Deleting #{f}"
      File.delete(f)
    end
  end

  # Clean up docs
  delete "#{install_dir}/embedded/docs"
  delete "#{install_dir}/embedded/share/man"
  delete "#{install_dir}/embedded/share/doc"
  delete "#{install_dir}/embedded/share/gtk-doc"
  delete "#{install_dir}/embedded/ssl/man"
  delete "#{install_dir}/embedded/man"
  delete "#{install_dir}/embedded/share/info"
  delete "#{install_dir}/embedded/info"

  block "Remove leftovers from compiling gems" do
    gemfile = "#{install_dir}/embedded/bin/gem"
    next unless File.exist?(gemfile)

    gemdir = shellout!("#{gemfile} environment gemdir", env: env).stdout.chomp

    # find gem_make.out and mkmf.log files
    Dir.glob("#{gemdir}/extensions/**/{gem_make.out,mkmf.log}").each do |f|
      puts "Deleting #{f}"
      File.delete(f)
    end
  end

  block "Removing random non-code files from installed gems" do
    gemfile = "#{install_dir}/embedded/bin/gem"
    next unless File.exist?(gemfile)

    gemdir = shellout!("#{gemfile} environment gemdir", env: env).stdout.chomp

    # find the embedded ruby gems dir and clean it up for globbing
    files = %w{
      .appveyor.yml
      .autotest
      .bnsignore
      .circleci
      .codeclimate.yml
      .concourse.yml
      .coveralls.yml
      .dockerignore
      .document
      .ebert.yml
      .gemtest
      .github
      .gitignore
      .gitmodules
      .hound.yml
      .irbrc
      .kokoro
      .pelusa.yml
      .repo-metadata.json
      .rock.yml
      .rspec
      .rubocop_*.yml
      .rubocop.yml
      .ruby-gemset
      .ruby-version
      .rvmrc
      .simplecov
      .tool-versions
      .travis.yml
      .yardopts
      .yardopts_guide
      .yardopts_i18n
      .yardstick.yml
      .zuul.yaml
      *.blurb
      **/.gitkeep
      *Upgrade.md
      Appraisals
      appveyor.yml
      ARCHITECTURE.md
      autotest
      azure-pipelines.yml
      bench
      benchmark
      benchmarks
      bundle_install_all_ruby_versions.sh
      CHANGELOG
      CHANGELOG.md
      CHANGELOG.rdoc
      CHANGELOG.txt
      CHANGES
      CHANGES.md
      CHANGES.txt
      CODE_OF_CONDUCT.md
      Code-of-Conduct.md
      codecov.yml
      concourse
      CONTRIBUTING.md
      CONTRIBUTING.rdoc
      CONTRIBUTORS.md
      design_rationale.rb
      doc
      doc-api
      docker-compose.yml
      Dockerfile*
      docs
      donate.png
      ed25519.png
      FAQ.txt
      features
      frozen_old_spec
      Gemfile.devtools
      Gemfile.travis
      Gemfile.noed25519*
      Guardfile
      GUIDE.md
      HISTORY
      HISTORY.md
      History.rdoc
      HISTORY.txt
      INSTALL
      INSTALL.txt
      ISSUE_TEMPLATE.md
      JSON-Schema-Test-Suite
      logo.png
      man
      Manifest
      Manifest.txt
      MIGRATING.md
      minitest
      NEWS.md
      on_what.rb
      README
      README_INDEX.rdoc
      README.*md
      readme.erb
      README.euc
      README.markdown
      README.rdoc
      README.txt
      release-script.txt
      run_specs_all_ruby_versions.sh
      samus.json
      SECURITY.md
      SPEC.rdoc
      test
      tests
      THANKS.txt
      TODO
      TODO*.md
      travis_build_script.sh
      UPGRADING.md
      website
      yard-template
    }

    Dir.glob(Dir.glob("#{gemdir}/gems/*/{#{files.join(",")}}")).each do |f|
      puts "Deleting #{f}"
      if File.directory?(f)
        # recursively removes files and the dir
        FileUtils.remove_dir(f)
      else
        File.delete(f)
      end
    end
  end

  # Check for multiple versions of the `bundler` gem and fail the build if we find more than 1.
  # Having multiple versions has burned us too many times in the past - causes warnings when
  # invoking binaries.
  # block "Ensure only 1 copy of bundler is installed" do
  #   # The bundler regex must be surrounded by double-quotes (not single) for Windows
  #   # Under powershell, it would have to be escaped with a ` character, i.e. `"^bundler$`"
  #   bundler = shellout!("#{install_dir}/embedded/bin/gem list \"^bundler$\"", env: env).stdout.chomp
  #   if bundler.include?(",")
  #     raise "Multiple copies of bundler installed, ensure only 1 remains. Output:\n" + bundler
  #   end
  # end

  block "Remove empty gem dirs from Ruby's built-in gems" do
    Dir.glob("#{install_dir}/embedded/lib/ruby/gems/*/gems/*".tr("\\", "/")).each do |d|
      # skip unless the dir is empty
      next unless Dir.children(d).empty?

      puts "Deleting empty gem dir: #{d}"
      FileUtils.rm_rf(d)
    end
  end
end
