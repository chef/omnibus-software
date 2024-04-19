#
# Copyright:: Copyright (c) 2014-2017, Chef Software Inc.
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

# This software makes sure that SSL_CERT_FILE environment variable is pointed
# to the bundled CA certificates that ship with omnibus. With this, Chef
# tools can be used with https URLs out of the box.
# expeditor/ignore: logic only

name "openssl-customization"

license :project_license
skip_transitive_dependency_licensing true

source path: "#{project.files_path}/#{name}"

dependency "ruby"

build do
  block "Add OpenSSL customization file" do
    # gets directories for RbConfig::CONFIG and sanitizes them.
    def get_sanitized_rbconfig(config)
      ruby = windows_safe_path("#{install_dir}/embedded/bin/ruby")

      config_dir = Bundler.with_clean_env do
        command_output = `#{ruby} -rrbconfig -e "puts RbConfig::CONFIG['#{config}']"`.strip
        windows_safe_path(command_output)
      end

      if config_dir.nil? || config_dir.empty?
        raise "could not determine embedded ruby's RbConfig::CONFIG['#{config}']"
      end

      config_dir
    end

    embedded_ruby_lib_dir = get_sanitized_rbconfig("rubylibdir")

    # use the value from the else clause here and remove the if/else once Ruby < 3.1
    # is not supported in combination with OpenSSL >= 3.0
    source_openssl_rb = if project.overrides[:openssl] && project.overrides[:ruby] &&
        ChefUtils::VersionString.new(project.overrides[:ruby][:version]).satisfies?("< 3.1") &&
        ChefUtils::VersionString.new(project.overrides[:openssl][:version]).satisfies?(">= 3.0")
                          # ruby 3.0 by default is built with < OpenSSL 3.0, and we'll
                          # have an openssl gem separately installed as part of this
                          Dir["#{install_dir}/**/openssl-*/lib/openssl.rb"].last
                        else
                          File.join(embedded_ruby_lib_dir, "openssl.rb")
                        end

    if windows?
      embedded_ruby_site_dir = get_sanitized_rbconfig("sitelibdir")
      source_ssl_env_hack      = File.join(project_dir, "windows", "ssl_env_hack.rb")
      destination_ssl_env_hack = File.join(embedded_ruby_site_dir, "ssl_env_hack.rb")

      create_directory(embedded_ruby_site_dir)

      copy(source_ssl_env_hack, destination_ssl_env_hack)

      # Unfortunately there is no patch on windows, but luckily we only need to append a line to the openssl.rb
      # to pick up our script which find the CA bundle in omnibus installations and points SSL_CERT_FILE to it
      # if it's not already set
      File.open(source_openssl_rb, "r+") do |f|
        unpatched_openssl_rb = f.read
        f.rewind
        f.write("\nrequire 'ssl_env_hack'\n")
        f.write(unpatched_openssl_rb)
      end
    else
      File.open(source_openssl_rb, "r+") do |f|
        unpatched_openssl_rb = f.read
        f.rewind
        f.write(unpatched_openssl_rb)
      end
    end
  end
end
