#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
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

name "nokogiri"
version "1.5.4"

dependencies ["ruby", "rubygems", "libxml2", "libxslt", "libiconv"]

build do
  gem ["install",
       "nokogiri",
       "-v #{version}",
       "--",
       "--with-xml2-lib=#{install_dir}/embedded/lib",
       "--with-xml2-include=#{install_dir}/embedded/include/libxml2",
       "--with-xslt-lib=#{install_dir}/embedded/lib",
       "--with-xslt-include=#{install_dir}/embedded/include/libxslt",
       "--with-iconv-include=#{install_dir}/embedded/include",
       "--with-iconv-lib=#{install_dir}/embedded/lib"].join(" ")
end
