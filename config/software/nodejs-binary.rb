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

#
# nodejs-binary provides nodejs using the binary packages provided by
# the upstream.  It does not install it into any of our standard
# paths, so builds that require nodejs need to add embedded/nodejs/bin
# to their path.
#
# Since nodejs is often a build-time-only dependency, it can then be
# easily removed with remove-nodejs.
#
name "nodejs-binary"
default_version "6.7.0"

license "MIT"
license_file "LICENSE"
skip_transitive_dependency_licensing true

version "6.7.0" do
  source_hash = if ppc64le?
                  "de8e4ca71caa8be6eaf80e65b89de2a6d152fa4ce08efcbc90ce7e1bfdf130e7"
                elsif ppc64?
                  "e8ce540b592d337304a10f4eb19bb4efee889c6676c5f188d072bfb2a8089927"
                elsif s390x?
                  "e0f2616b4beb4c2505edb19e3cbedbf3d1c958441517cc9a1e918f6feaa4b95b"
                else
                  "abe81b4150917cdbbeebc6c6b85003b80c972d32c8f5dfd2970d32e52a6877af"
                end
  source sha256: source_hash
end

arch_ext = if ppc64le?
             "ppc64le"
           elsif ppc64?
             "ppc64"
           elsif s390x?
             "s390x"
           else
             "x64"
           end

source url: "https://nodejs.org/dist/v#{version}/node-v#{version}-linux-#{arch_ext}.tar.gz"
relative_path "node-v#{version}-linux-#{arch_ext}"

build do
  mkdir "#{install_dir}/embedded/nodejs"
  sync "#{project_dir}/", "#{install_dir}/embedded/nodejs"
end
