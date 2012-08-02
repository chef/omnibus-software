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

name "openssl"
version "1.0.0f"

dependencies ["zlib"]

source :url => "http://www.openssl.org/source/openssl-1.0.0f.tar.gz",
       :md5 => "e358705fb4a8827b5e9224a73f442025"

relative_path "openssl-1.0.0f"

build do
  # configure
  if platform == "mac_os_x"
    command ["./Configure",
             "darwin64-x86_64-cc",
             "--prefix=#{install_dir}/embedded",
             "--with-zlib-lib=#{install_dir}/embedded/lib",
             "--with-zlib-include=#{install_dir}/embedded/include",
             "zlib",
             "shared"].join(" ")
  elsif (platform == "solaris2" and Omnibus.config.solaris_compiler == "gcc" and architecture == "sun")
    command ["/bin/sh ./Configure",
             "solaris-sparcv9-gcc",
             "--prefix=#{install_dir}/embedded",
             "--with-zlib-lib=#{install_dir}/embedded/lib",
             "--with-zlib-include=#{install_dir}/embedded/include",
             "zlib",
             "shared",
             "-L#{install_dir}/embedded/lib",
             "-I#{install_dir}/embedded/include",
             "-R#{install_dir}/embedded/lib"].join(" ")
  elsif (platform == "solaris2" and Omnibus.config.solaris_compiler == "gcc" and architecture == "intel")
    # This should not require a /bin/sh, but without it we get
    # Errno::ENOEXEC: Exec format error
    command ["/bin/sh ./Configure",
             "solaris-x86-gcc",
             "--prefix=#{install_dir}/embedded",
             "--with-zlib-lib=#{install_dir}/embedded/lib",
             "--with-zlib-include=#{install_dir}/embedded/include",
             "zlib",
             "shared",
             "-L#{install_dir}/embedded/lib",
             "-I#{install_dir}/embedded/include",
             "-R#{install_dir}/embedded/lib"].join(" ")
  else
    command(["./config",
             "--prefix=#{install_dir}/embedded",
             "--with-zlib-lib=#{install_dir}/embedded/lib",
             "--with-zlib-include=#{install_dir}/embedded/include",
             "zlib",
             "shared",
             "-L#{install_dir}/embedded/lib",
             "-I#{install_dir}/embedded/include"].join(" "),
            :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"})
  end

  # make and install
  command "make", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "make install"

#  if (platform == "solaris2" and Omnibus.config.solaris_compiler == "gcc")
#    engines = %w{lib4758cca.so libaep.so libatalla.so libcswift.so libgmp.so libchil.so libnuron.so libsureware.so libubsec.so libpadlock.so libcapi.so libgost.so}
#    libraries = %w{libssl.so.1.0.0 libcrypto.so.1.0.0}
#    engines.each do |engine|
#      command "/opt/omnibus/bootstrap/bin/chrpath -r #{install_dir}/embedded/lib #{install_dir}/embedded/lib/engines/#{engine}"
#    end
#    libraries.each do |library|
#      command "/opt/omnibus/bootstrap/bin/chrpath -r #{install_dir}/embedded/lib #{install_dir}/embedded/lib/#{library}"
#    end
#  end
end
