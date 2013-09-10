#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
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

name "chef"

dependency "ruby"
dependency "rubygems"
dependency "yajl"
dependency "bundler"

version ENV["CHEF_GIT_REV"] || "master"

source :git => "git://github.com/opscode/chef"

relative_path "chef"

always_build true

env =
  case platform
  when "solaris2"
    if Omnibus.config.solaris_compiler == "studio"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
    elsif Omnibus.config.solaris_compiler == "gcc"
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
      "LD_OPTIONS" => "-R#{install_dir}/embedded/lib"
    }
    else
      raise "Sorry, #{Omnibus.config.solaris_compiler} is not a valid compiler selection."
    end
  when "aix"
    {
      "LDFLAGS" => "-Wl,-blibpath:#{install_dir}/embedded/lib:/usr/lib:/lib -L#{install_dir}/embedded/lib",
      "CFLAGS" => "-I#{install_dir}/embedded/include"
    }
  else
    {
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  end

build do
  #####################################################################
  #
  # nasty nasty nasty hack for setting artifact version
  #
  #####################################################################
  #
  # since omnibus-ruby is not architected to intentionally let the
  # software definitions define the #build_version and
  # #build_iteration of the package artifact, we're going to implement
  # a temporary hack here that lets us do so. this type of use case
  # will become a feature of omnibus-ruby in the future, but in order
  # to get things shipped, we'll hack it up here.
  #
  # <3 Stephen
  #
  #####################################################################
  block do
    project = self.project
    if project.name == "chef"
      git_cmd = "git describe --tags"
      src_dir = self.project_dir
      shell = Mixlib::ShellOut.new(git_cmd,
                                   :cwd => src_dir)
      shell.run_command
      shell.error!
      build_version = shell.stdout.chomp

      project.build_version   build_version
      project.build_iteration ENV["CHEF_PACKAGE_ITERATION"].to_i || 1
    end
  end

  # COMPAT HACK :( - Chef 11 finally has the core Chef code in the root of the
  # project repo. Since the Chef Client pipeline needs to build/test Chef 10.x
  # and 11 releases our software definition need to handle both cases
  # gracefully.
  block do
    build_commands = self.builder.build_commands
    chef_root = File.join(self.project_dir, "chef")
    if File.exists?(chef_root)
      build_commands.each_index do |i|
        cmd = build_commands[i].dup
        if cmd.is_a? Array
          if cmd.last.is_a? Hash
            cmd_opts = cmd.pop.dup
            cmd_opts[:cwd] = chef_root
            cmd << cmd_opts
          else
            cmd << {:cwd => chef_root}
          end
          build_commands[i] = cmd
        end
      end
    end
  end

  # install the whole bundle, so that we get dev gems (like rspec) and can later test in CI
  # against all the exact gems that we ship (we will run rspec unbundled in the test phase).
  bundle "install --without server docgen", :env => env.merge({"PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"})

  rake "gem", :env => env.merge({"PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"})

  gem ["install pkg/chef*.gem",
      "-n #{install_dir}/bin",
      "--no-rdoc --no-ri"].join(" "), :env => env.merge({"PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"})

  auxiliary_gems = ["highline", "net-ssh-multi"]
  auxiliary_gems << "ruby-shadow" unless platform == "mac_os_x" || platform == "freebsd" || platform == "aix"

  gem ["install",
       auxiliary_gems.join(" "),
       "-n #{install_dir}/bin",
       "--no-rdoc --no-ri"].join(" "), :env => env.merge({"PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"})

  #
  # TODO: the "clean up" section below was cargo-culted from the
  # clojure version of omnibus that depended on the build order of the
  # tasks and not dependencies. if we really need to clean stuff up,
  # we should probably stick the clean up steps somewhere else
  #

  # clean up
  ["docs",
   "share/man",
   "share/doc",
   "share/gtk-doc",
   "ssl/man",
   "man",
   "info"].each do |dir|
    command "rm -rf #{install_dir}/embedded/#{dir}"
  end
end
