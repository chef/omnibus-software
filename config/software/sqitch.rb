#
# Copyright 2014 Chef Software, Inc.
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

name "sqitch"
default_version "0.973"

license "MIT"
license_file "https://raw.githubusercontent.com/theory/sqitch/master/README.md"

dependency "perl"
dependency "cpanminus"

# install a LGPL-licensed version of libintl-perl:
dependency "libintl-perl"

version "0.9994" do
  source md5: "7227dfcd141440f23d99f01a2b01e0f2"
end

version "0.973" do
  source md5: "0994e9f906a7a4a2e97049c8dbaef584"
end

source url: "https://github.com/theory/#{name}/releases/download/v#{version}/app-sqitch-#{version}.tar.gz"

relative_path "App-Sqitch-#{version}"

# See https://github.com/theory/sqitch for more
build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "perl Build.PL", env: env
  command "./Build installdeps --cpan_client 'cpanm -v --notest'", env: env
  command "./Build", env: env
  command "./Build install", env: env

  # Here is another licensing fun. Some of the dependencies of sqitch
  # unfortunately have GPL3 and LGPL3 licenses which are requiring us to remove
  # them from our packages after installing sqitch. Here we are uninstalling
  # them without breaking the licensing information collection.
  %w{Test-MockModule}.each do |package_name|
    module_name = package_name.gsub("-", "::")

    # Here we run cpanm --uninstall with a different PERL_CPANM_HOME. The reason
    # for this is to keep the licensing information for sqitch intact. The way
    # license_scout works is to look into PERL_CPANM_HOME/latest-build (by
    # default ~/.cpanm/latest-build) which contains the modules installed during
    # the last install. This directory is a symlink that points to the directory
    # contains the information about the latest build. Without changing
    # PERL_CPANM_HOME we would overwrite the link and will not be able to
    # collect the dependencies installed to our package while doing the actual
    # sqitch install.
    Dir.mktmpdir do |tmpdir|
      command "cpanm --force --uninstall #{module_name}", env: env.merge({
        "PERL_CPANM_HOME" => tmpdir,
      })
    end

    # Here we are removing the problematic package from the original
    # PERL_CPANM_HOME cache directory. This ensures that we do not add
    # licensing information about these components to our package.
    cpanm_root = File.expand_path("~/.cpanm/latest-build")
    delete "#{cpanm_root}/#{package_name}*"
  end

end
