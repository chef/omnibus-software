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

name "rabbitmq"
default_version "3.6.6"

license "MPL-2.0"
license_file "LICENSE"
skip_transitive_dependency_licensing true

dependency "erlang"

version("2.7.1")  { source md5: "34a5f9fb6f22e6681092443fcc80324f" }
version("2.8.7")  { source md5: "35e8d78f8d7ae4372db23fe50db82c64" }
version("3.3.4")  { source md5: "61a3822f3af0aaa30da7230dccb17067" }
version("3.6.0")  { source md5: "61a3822f3af0aaa30da7230dccb17067" }
version("3.6.15") { source md5: "1dd9a5d000e11064efec23c1a76e5d5c" }
version("3.7.6")  { source md5: "d8db2d979a66e520b23be29d9b43af70" }

version("3.6.6") do
  source(sha256: "781d17a6c8bbfbcd749d23913218de38e692a5e3093cf47eecf499532ac25d61",
            url: "http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-generic-unix-3.6.6.tar.xz" )
end

version("3.6.15") do
  source(sha256: "04e6a291642f80e87fc892d5e8ea309fb3fab85ebb64a79a70dfe6c6cfde36fb",
            url: "https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.15/rabbitmq-server-generic-unix-3.6.15.tar.xz" )
end

version("3.7.6") do
  source(sha256: "23e61ec405fea9903c2de9532013feb124a5bc667a43a010c949276eda17e1d4",
            url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.6/rabbitmq-server-generic-unix-3.7.6.tar.xz" )
end

################# testing multiple versions for update-erlang22 work
# version("3.7.7") do
#   source(sha256: "",
#             url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.6/rabbitmq-server-generic-unix-3.7.6.tar.xz" )
# end
# version("3.7.8") do
#   source(sha256: "",
#             url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.6/rabbitmq-server-generic-unix-3.7.6.tar.xz" )
# end
# version("3.7.9") do
#   source(sha256: "",
#             url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.6/rabbitmq-server-generic-unix-3.7.6.tar.xz" )
# end
# version("3.7.10") do
#   source(sha256: "",
#             url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.6/rabbitmq-server-generic-unix-3.7.6.tar.xz" )
# end
# version("3.7.11") do
#   source(sha256: "",
#             url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.6/rabbitmq-server-generic-unix-3.7.6.tar.xz" )
# end
# version("3.7.12") do
#   source(sha256: "",
#             url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.6/rabbitmq-server-generic-unix-3.7.6.tar.xz" )
# end
# version("3.7.13") do
#   source(sha256: "",
#             url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.6/rabbitmq-server-generic-unix-3.7.6.tar.xz" )
# end
# version("3.7.14") do
#   source(sha256: "",
#             url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.6/rabbitmq-server-generic-unix-3.7.6.tar.xz" )
# end
version("3.7.15") do
  source(sha256: "4d70e4d057c6e40022369584626fd7c2bdaa24997aae5cc7f8f182c6d46456cf",
            url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.15/rabbitmq-server-generic-unix-3.7.15.tar.xz" )
end
version("3.7.16") do
  source(sha256: "a34011f8ff1682a1601d4b8e0167ad39b91fd8f0fb35b484c41efde9f104ed08",
            url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.16/rabbitmq-server-generic-unix-3.7.16.tar.xz" )
end
version("3.7.17") do
  source(sha256: "83abd26dc2f27ea6eee85324163aecd36f1b861e58a027df83f631cbd89ead5d",
            url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.17/rabbitmq-server-generic-unix-3.7.17.tar.xz" )
end
version("3.7.18") do
  source(sha256: "30a8439671f44f0fc9611782fdfaabba5c1773da85fca279e2850ad28442a2d5",
            url: "https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.18/rabbitmq-server-generic-unix-3.7.18.tar.xz" )
end
#################

relative_path "rabbitmq_server-#{version}"

build do
  mkdir "#{install_dir}/embedded/service/rabbitmq"
  sync  "#{project_dir}/", "#{install_dir}/embedded/service/rabbitmq/"

  %w{rabbitmqctl rabbitmq-env rabbitmq-server}.each do |bin|
    link "#{install_dir}/embedded/service/rabbitmq/sbin/#{bin}", "#{install_dir}/embedded/bin/#{bin}"
  end
end
