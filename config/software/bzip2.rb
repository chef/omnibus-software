# Install bzip2 and its shared library, libbz2.so
# This library object is required for building Python with the bz2 module,
# and should be picked up automatically when building Python.

name "bzip2"
version "1.0.6"

dependency "zlib"
dependency "openssl"

source :url => "http://www.bzip.org/#{version}/#{name}-#{version}.tar.gz",
       :md5 => "00b516f4704d4a7cb50a1d97e6e8e15b"

relative_path "#{name}-#{version}"

prefix="#{install_dir}/embedded"
libdir="#{prefix}/lib"

env = {
  "LDFLAGS" => "-L#{libdir} -I#{prefix}/include",
  "CFLAGS" => "-L#{libdir} -I#{prefix}/include -fPIC",
  "LD_RUN_PATH" => libdir
}

build do
  patch :source => 'makefile_take_env_vars.patch'
  command "make PREFIX=#{prefix} VERSION=#{version}", :env => env
  command "make PREFIX=#{prefix} VERSION=#{version} -f Makefile-libbz2_so", :env => env
  command "make install VERSION=#{version} PREFIX=#{prefix}", :env => env
end
