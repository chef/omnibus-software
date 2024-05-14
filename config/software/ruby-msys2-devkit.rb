#
# Copyright 2022 Progress Software, Inc.
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

name "ruby-msys2-devkit"
default_version "3.0.6-1"

license "BSD-3-Clause"
license_file "https://raw.githubusercontent.com/oneclick/rubyinstaller2/master/LICENSE.txt"
skip_transitive_dependency_licensing true
arch = "x64"
msys_dir = "msys64"

version "3.3.0-1" do
  source url: "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-#{version}/rubyinstaller-devkit-#{version}-x64.exe",
          sha256: "01fc7d7889f161e94ae515c15fc1c22b7db506ab91af891cf7e1a764e96d8298"
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/rubyinstaller-devkit-#{version}-x64.exe",
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "3.3.1-1" do
  source url: "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-#{version}/rubyinstaller-devkit-#{version}-x64.exe",
          sha256: "dc590fb3d1c4254e7d33179bb84df378ead943fece2159eada5f3582bf643cc3"
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/rubyinstaller-devkit-#{version}-x64.exe",
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "3.0.6-1" do
  source url: "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-#{version}/rubyinstaller-devkit-#{version}-x64.exe",
          sha256: "c44256eae6a934db39e4f3a56d39178ac87b8b754e9b66221910417adb59a3a1"
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/rubyinstaller-devkit-#{version}-x64.exe",
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "3.1.2-1" do
  source url: "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-#{version}/rubyinstaller-devkit-#{version}-x64.exe",
          sha256: "5f0fd4a206b164a627c46e619d2babbcafb0ed4bc3e409267b9a73b6c58bdec1"
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/rubyinstaller-devkit-#{version}-x64.exe",
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "3.1.4-1" do
  source url: "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-#{version}/rubyinstaller-devkit-#{version}-x64.exe",
          sha256: "d3dd7451bdae502894925a90c9e87685ec18fd3f73a6ca50e4282b8879d385e2"
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/rubyinstaller-devkit-#{version}-x64.exe",
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

version "3.2.2-1" do
  source url: "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-#{version}/rubyinstaller-devkit-#{version}-x64.exe",
          sha256: "678619631c7e0e9b06bd53fd50689b47770fb577a8e49a35f615d2c8691aa6b7"
  internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/rubyinstaller-devkit-#{version}-x64.exe",
                  authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
end

build do
  if windows?
    embedded_dir = "#{install_dir}/embedded"

    Dir.mktmpdir do |tmpdir|
      command "#{project_dir}/rubyinstaller-devkit-#{version}-#{arch}.exe /SP- /NORESTART /VERYSILENT /SUPPRESSMSGBOXES /NOPATH /DIR=#{tmpdir}"
      copy "#{tmpdir}/#{msys_dir}", embedded_dir
      if version.start_with?("3.0")
        copy "#{tmpdir}/lib/ruby/site_ruby/3.0.0/devkit.rb", "#{embedded_dir}/lib/ruby/site_ruby/3.0.0"
        copy "#{tmpdir}/lib/ruby/site_ruby/3.0.0/ruby_installer.rb", "#{embedded_dir}/lib/ruby/site_ruby/3.0.0"
        copy "#{tmpdir}/lib/ruby/site_ruby/3.0.0/ruby_installer", "#{embedded_dir}/lib/ruby/site_ruby/3.0.0"
        copy "#{tmpdir}/lib/ruby/3.0.0/rubygems/defaults", "#{embedded_dir}/lib/ruby/3.0.0/rubygems/defaults"
      elsif version.start_with?("3.1")
        copy "#{tmpdir}/lib/ruby/site_ruby/3.1.0/devkit.rb", "#{embedded_dir}/lib/ruby/site_ruby/3.1.0"
        copy "#{tmpdir}/lib/ruby/site_ruby/3.1.0/ruby_installer.rb", "#{embedded_dir}/lib/ruby/site_ruby/3.1.0"
        copy "#{tmpdir}/lib/ruby/site_ruby/3.1.0/ruby_installer", "#{embedded_dir}/lib/ruby/site_ruby/3.1.0"
        copy "#{tmpdir}/lib/ruby/3.1.0/rubygems/defaults", "#{embedded_dir}/lib/ruby/3.1.0/rubygems/defaults"
      elsif version.start_with?("3.2")
        copy "#{tmpdir}/lib/ruby/site_ruby/3.2.0/devkit.rb", "#{embedded_dir}/lib/ruby/site_ruby/3.2.0"
        copy "#{tmpdir}/lib/ruby/site_ruby/3.2.0/ruby_installer.rb", "#{embedded_dir}/lib/ruby/site_ruby/3.2.0"
        copy "#{tmpdir}/lib/ruby/site_ruby/3.2.0/ruby_installer", "#{embedded_dir}/lib/ruby/site_ruby/3.2.0"
        copy "#{tmpdir}/lib/ruby/3.2.0/rubygems/defaults", "#{embedded_dir}/lib/ruby/3.2.0/rubygems/defaults"
      end

      # Normally we would symlink the required unix tools.
      # However with the introduction of git-cache to speed up omnibus builds,
      # we can't do that anymore since git on windows doesn't support symlinks.
      # https://groups.google.com/forum/#!topic/msysgit/arTTH5GmHRk
      # Therefore we copy the tools to the necessary places.
      # We need tar for 'knife cookbook site install' to function correctly and
      # many gems that ship with native extensions assume tar will be available
      # in the PATH.
      copy "#{tmpdir}/#{msys_dir}/usr/bin/bsdtar.exe", "#{install_dir}/bin/tar.exe"
    end

    command "#{embedded_dir}/#{msys_dir}/msys2_shell.cmd -defterm -no-start -c exit", env: { "CONFIG" => "" }
  end
end
