#
# Copyright 2014 Chef Software, Inc.
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
# openssl 1.0.0m fixes a security vulnerability:
#   https://www.openssl.org/news/secadv_20140605.txt
# Since the rubyinstaller.org doesn't release ruby when a dependency gets
# patched, we are manually patching the dependency until we get a new
# ruby release on windows.
# This component should be removed when we upgrade to the next version of
# rubyinstaller > 1.9.3-p545 and 2.0.0-p451
#
# openssl 1.0.0n fixes more security vulnerabilities...
#   https://www.openssl.org/news/secadv_20140806.txt

name "openssl-windows"
default_version "1.0.1p"

# Let's assume ruby is installed on windows so we don't have to ship it with the agent
# dependency "ruby-windows"

source url: "http://dl.bintray.com/oneclick/OpenKnapsack/x86/openssl-#{version}-x86-windows.tar.lzma"

version('1.0.0n') { source md5: "9506530353f3b984680ec27b7270874a" }
version('1.0.0q') { source md5: "577dbe528415c6f178a9431fd0554df4" }
version('1.0.0r') { source md5: "25402ddce541aa54eb5e114721926e72" }
version('1.0.1m') do
  source url: "https://github.com/jdmundrawala/knapsack-recipes/releases/download/openssl-1.0.1m/openssl-1.0.1m-x86-windows.tar.lzma",
         md5: "789c307a560386a55e14f3e04cd69865"
end

version('1.0.1p') do
  source url: "https://github.com/jaym/windows-openssl-build/releases/download/openssl-1.0.1p/openssl-1.0.1p-x86-windows.tar.lzma",
         md5: "013c0f27c4839c89e33037acc72f17c5"
end

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Make sure the OpenSSL version is suitable for our path:
  # OpenSSL version is something like
  # OpenSSL 1.0.0k 5 Feb 2013
  # Forget that check, no way I'll install ruby, let's assume it's in the path already
  command "ruby -e \"require 'openssl'; puts 'OpenSSL patch version check expecting <= #{version}'; exit(1) if OpenSSL::OPENSSL_VERSION.split(' ')[1] >= '#{version}'\""

  tmpdir = File.join(Omnibus::Config.cache_dir, "openssl-cache")

  # Ensure the directory exists
  mkdir tmpdir

  # First extract the tar file out of lzma archive.
  command "7z.exe x #{project_file} -o#{tmpdir} -r -y", env: env

  # Now extract the files out of tar archive.
  command "7z.exe x #{File.join(tmpdir, "openssl-#{version}-x86-windows.tar")} -o#{tmpdir} -r -y", env: env

  # In case...
  mkdir "#{install_dir}/embedded/bin"

  # Copy over the required dlls into embedded/bin
  copy "#{tmpdir}/bin/libeay32.dll", "#{install_dir}/embedded/bin/"
  copy "#{tmpdir}/bin/ssleay32.dll", "#{install_dir}/embedded/bin/"

  # Also copy over the openssl executable for debugging
  copy "#{tmpdir}/bin/openssl.exe", "#{install_dir}/embedded/bin/"
end
