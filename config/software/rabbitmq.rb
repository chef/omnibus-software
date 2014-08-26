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
default_version "2.7.1"

dependency "erlang"

version("2.7.1") { source md5: "34a5f9fb6f22e6681092443fcc80324f" }
version("3.3.4") { source md5: "61a3822f3af0aaa30da7230dccb17067" }

source url: "http://www.rabbitmq.com/releases/rabbitmq-server/v#{version}/rabbitmq-server-generic-unix-#{version}.tar.gz"

relative_path "rabbitmq_server-#{version}"

build do
  mkdir "#{install_dir}/embedded/service/rabbitmq"
  sync  "#{project_dir}/", "#{install_dir}/embedded/service/rabbitmq/"

  %w(rabbitmqctl rabbitmq-env rabbitmq-server).each do |bin|
    link "#{install_dir}/embedded/service/rabbitmq/sbin/#{bin}", "#{install_dir}/embedded/bin/#{bin}"
  end
end
