name "nghttp2"
default_version "1.12.0"

dependency "openssl"
dependency "cython"

source :url => "https://github.com/nghttp2/nghttp2/releases/download/v1.12.0/nghttp2-#{version}.tar.gz",
       :md5 => "04235f1d7170a2efce535068319180a1"

relative_path "nghttp2-#{version}"

env = {
  "CYTHON" => "#{install_dir}/embedded/bin/cython",
  "PYTHON" => "#{install_dir}/embedded/bin/python2.7",
  "PYTHON_CPPFLAGS" => "-I#{install_dir}/embedded/include/python2.7",
  "PYTHON_LDFLAGS" => "-L#{install_dir}/embedded/lib -lpython2.7 -lm",
  "OPENSSL_CFLAGS" => "-I#{install_dir}/embedded/include/openssl",
  "OPENSSL_LIBS" => "-L#{install_dir}/embedded/lib"
}

build do
  command [
    "./configure",
    "--enable-python-bindings",
    "--disable-app",
    "--disable-examples",
    "--disable-hpack-tools",
    "--prefix=#{install_dir}/embedded",
    ""
  ].join(" "), :env => env
  command "make -j #{workers}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "make install"
end
