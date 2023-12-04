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

name "perl_pg_driver"
default_version "3.16.0"

dependency "perl"
dependency "cpanminus"
dependency "postgresql"

license "Artistic"
license_file "README"
license_file "LICENSES/artistic.txt"

# version_list: url=https://cpan.metacpan.org/authors/id/T/TU/TURNSTEP/ filter=*.tar.gz

version("3.17.0") { source sha256: "8d900d4c0e749f37218752a6661fb0d3557ab1fccc8dea384cb587c382de219b" }
version("3.16.0") { source sha256: "2c31163d8bdaaf8beaef9c97b8f260432d67a534bc7b69e7265c21cb841432b8" }
version("3.15.1") { source sha256: "13c7543b545c9a5253c86550ccd9204d06fe5f34a7dc51769d3dd665563fc17e" }
version("3.15.0") { source sha256: "69cc19870f9d935f16530be39d0ed60afadc5e560e29c3a17af4498e7e3082d9" }
version("3.14.2") { source sha256: "c973e98458960a78ec54032a71b3840f178418dd7e69d063e462a0f10ec68e4d" }
version("3.5.3")  { source sha256: "7e98a9b975256a4733db1c0e974cad5ad5cb821489323e395ed97bd058e0a90e" }
version("3.3.0")  { source sha256: "52f43de5b2d916d447d7ed252b127f728b226dc88db57d4fe9712e21d3586ffe" }

source url: "https://search.cpan.org/CPAN/authors/id/T/TU/TURNSTEP/DBD-Pg-#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"
relative_path "DBD-Pg-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "cpanm -v --notest .", env: env
end
