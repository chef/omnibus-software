#
# Copyright 2012-2014 Chef Software, Inc.
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

name "cacerts"

# We always pull the latest version,
# so the hashsum check will break every time the file is updated on the remote
default_version "latest"

source url: "https://curl.haxx.se/ca/cacert.pem",
       sha256: "533610ad2b004c1622a40622f86ced5e89762e1c0e4b3ae08b31b240d863e91f",
       target_filename: "cacert.pem"

relative_path "cacerts-#{version}"

build do
  ship_license "https://www.mozilla.org/media/MPL/2.0/index.815ca599c9df.txt"

  if windows?
    if with_python_runtime? "2"
      mkdir "#{python_2_embedded}/ssl/certs"
      copy "#{project_dir}/cacert.pem", "#{python_2_embedded}/ssl/certs/cacert.pem"
      copy "#{project_dir}/cacert.pem", "#{python_2_embedded}/ssl/cert.pem"
    end
    if with_python_runtime? "3"
      mkdir "#{python_3_embedded}/ssl/certs"
      copy "#{project_dir}/cacert.pem", "#{python_3_embedded}/ssl/certs/cacert.pem"
      copy "#{project_dir}/cacert.pem", "#{python_3_embedded}/ssl/cert.pem"
    end
  else
    mkdir "#{install_dir}/embedded/ssl/certs"
    copy "#{project_dir}/cacert.pem", "#{install_dir}/embedded/ssl/certs/cacert.pem"

    link "#{install_dir}/embedded/ssl/certs/cacert.pem", "#{install_dir}/embedded/ssl/cert.pem"

    block { File.chmod(0644, "#{install_dir}/embedded/ssl/certs/cacert.pem") }
  end
end
