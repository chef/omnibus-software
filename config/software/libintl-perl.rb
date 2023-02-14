#
# Copyright 2016 Chef Software, Inc.
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

# ## libintl-perl
# libintl-perl is a localization library. Normally it would be installed
# automatically by `cpanm` when you install whatever application you want, and
# you wouldn't need an explict software definition for it. Unfortunately,
# libintl-perl changed the license from LGPLv2 to GPLv3 in version 1.24, making
# it unusable in products that cannot ship GPLv3 code. By pre-installing
# version 1.23 or earlier, it's possible to workaround the licensing change for
# now.

name "libintl-perl"

default_version "1.23" # see above before setting this to something newer

# See above. If you set the version to something above 1.23, the license data
# here will be wrong.
license "LGPL-2.1"

# This is a (seldom updated) mirror. The primary repo is at
# git://git.guido-flohr.net/perl/libintl-perl.git
license_file "https://raw.githubusercontent.com/theory/libintl-perl/a92bda4e01cdecbf7e40f78c1444a8ca22e6fdfc/COPYING.LESSER"

dependency "perl"
dependency "cpanminus"

# version_list: url=https://cpan.metacpan.org/authors/id/G/GU/GUIDO/ filter=libintl-perl-*.tar.gz

version("1.33") { source sha256: "5126eda9ccd0eeb10db82ddef63cbcaf7dbd771e78cc0fb110cc3b5a6b8679e7" }
version("1.32") { source sha256: "80108298f2564ecbfc7110a3042008e665ed00c2e155b36b0188e6c1135ceba5" }
version("1.23") { source sha256: "60da16356c2fa89a0c542c825d626c8c2811202b6002b56d8574b928a1379ffa" }

source url: "https://search.cpan.org/CPAN/authors/id/G/GU/GUIDO/libintl-perl-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "libintl-perl-#{version}"

# See https://github.com/theory/sqitch for more

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "cpanm -v --notest .", env: env
end
