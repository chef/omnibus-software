#
# Copyright:: Copyright (c) Chef Software Inc.
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

name "cgi"
default_version "0.3.7"

license "BSD-2-Clause"
license_file "https://github.com/ruby/cgi/blob/master/BSDL"
license_file "https://github.com/ruby/cgi/blob/master/COPYING"

dependency "ruby"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  gem "install cgi" \
    " --version '#{version}'" \
    " --no-document", env: env
end
