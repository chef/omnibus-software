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

dependency "ruby"

version "1.8.29" do
  source sha256: "a6369a13e32b550b1bc1b17126ad729e9e542326696d9f872486eae78dfd4e63"
end

version "1.8.24" do
  source sha256: "4b61fa51869b3027bcfe67184b42d2e8c23fa6ab17d47c5c438484b9be2821dd"
end

# NOTE: this is the last version of rubygems before the 2.2.x change to native gem install location
#
#  https://github.com/rubygems/rubygems/issues/874
#
# This is a breaking change for omnibus clients.  Chef-11 needs to be pinned to 2.1.11 for eternity.
version "2.1.11" do
  source sha256: "75b841bfbbafe1cfc556630d2368e654dd2f5aec457d12d1a3ae69d2e487a2b7"
end

version "2.2.1" do
  source sha256: "7f1de72e965583fb41048ae80f7b7c628f51a126a665bbcccf8da99c4784556b"
end

version "2.4.1" do
  source sha256: "8e40e23fa995d064b00c474c3d3e5c4022755e27975c06d69d9e1c383a33f932"
end

version "2.4.4" do
  source sha256: "c2658ffc6f9c75b34fea5498defa003f6e4e5df79eeeca84a1d57614ade5d2ab"
end

source url: "https://production.cf.rubygems.org/rubygems/rubygems-#{version}.tgz"

relative_path "rubygems-#{version}"

build do
  ruby "setup.rb"
end
