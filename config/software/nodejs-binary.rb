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

# These are the last versions of their series that provide both ppc64 and ppc64le versions
version "8.9.1" do
  source_hash = if ppc64le?
                  "d3e11a9ef301afdecb10ed26470492fd03402b86bf9efc3f89a9aef541bf9a2c"
                elsif ppc64?
                  "7ab8c4bf36364624b6bc7610319f1e2c32a7c882aa6392ce285faaee39597dce"
                elsif s390x?
                  "48160ddaa7397cf85ca0cf333cc87dc3485956c75a3cdf98f04735bb81b37da6"
                else # x64
                  "0e49da19cdf4c89b52656e858346775af21f1953c308efbc803b665d6069c15c"
                end
  source sha256: source_hash
end

# These are the last versions of their series that provide both ppc64 and ppc64le versions
version "9.2.0" do
  source_hash = if ppc64le?
                  "9a173db0c0b88dcddf08542736c597c87bf86d536df8fa65a4fdff75e7bb4243"
                elsif ppc64?
                  "34b3d6d7e6036e38aacab6754f55711ac9582a3d963a06f5f75e07e2d986d2a2"
                elsif s390x?
                  "c5f6315da901bbb54ffa0b23b58cd0b46f0ebfbe2a4f1847ec1d330602000bfd"
                else # x64
                  "36ef2b3d1a99555390835d6fd4ad194a769df6841cbcc46cba0dffbaf6e6aa34"
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
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "node-v#{version}-linux-#{arch_ext}"

build do
  mkdir "#{install_dir}/embedded/nodejs"
  sync "#{project_dir}/", "#{install_dir}/embedded/nodejs"
end
