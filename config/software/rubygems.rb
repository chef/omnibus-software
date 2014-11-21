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

name "rubygems"
default_version "1.8.24"

if windows?
  dependency "ruby-windows"
  dependency "ruby-windows-devkit"
else
  dependency "ruby"
end

unless windows?
  version "1.8.29" do
    source md5: "a57fec0af33e2e2e1dbb3a68f6cc7269"
  end

  version "1.8.24" do
    source md5: "3a555b9d579f6a1a1e110628f5110c6b"
  end

  version "2.2.1" do
    source md5: "1f0017af0ad3d3ed52665132f80e7443"
  end

  version "2.4.1" do
    source md5: "7e39c31806bbf9268296d03bd97ce718"
  end

  source url: "http://production.cf.rubygems.org/rubygems/rubygems-#{version}.tgz"
end

relative_path "rubygems-#{version}"

build do
  block do
    env = with_embedded_path

    if windows?
      command "gem update --system #{version} --no-ri --no-rdoc", env: env
    else
      ruby "setup.rb --destdir=#{dest_dir} --no-ri --no-rdoc", env: env
    end
  end
end
