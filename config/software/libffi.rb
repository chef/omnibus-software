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

name "libffi"
version "3.0.9"

source :url => "ftp://sourceware.org/pub/libffi/libffi-3.0.9.tar.gz",
       :md5 => "1f300a7a7f975d4046f51c3022fa5ff1"

relative_path "libffi-3.0.9"

build do
  command "./configure --prefix=#{install_dir}/embedded"
  command "make -j #{max_build_jobs}  BINOWN=root BINGRP=wheel" # TODO: is this a leftover from os x, a bug?
  command "make install"
end
