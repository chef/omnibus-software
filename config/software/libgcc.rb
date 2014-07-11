#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
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

#
# NOTE: Instead of depending on this software definition, there is no
#       reason not to include "-static-libgcc" in your LDFLAGS instead.
#       That will probably be the best solution going forwards rather than
#       fuss around with the dynamic linking business here.
#
name "libgcc"
description "On UNIX systems where we bootstrap a compiler, copy the libgcc"
version "0.0.1"

libgcc_file =
  case Ohai['platform']
  when "solaris2"
    "/opt/csw/lib/libgcc_s.so.1"
  when "aix"
    "/opt/freeware/lib/pthread/ppc64/libgcc_s.a"
  when "freebsd"
    "/lib/libgcc_s.so.1"
  else
    nil
  end

build do
  if libgcc_file
    if File.exists?(libgcc_file)
      command "cp #{libgcc_file} #{install_dir}/embedded/lib/"
    else
      raise "cannot find libgcc -- where is your gcc compiler?"
    end
  end
end
