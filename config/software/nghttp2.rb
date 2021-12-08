name "nghttp2"
default_version "1.41.0"

dependency "openssl"

source url: "https://github.com/nghttp2/nghttp2/releases/download/v#{version}/nghttp2-#{version}.tar.gz"

version("1.12.0") { source md5: "04235f1d7170a2efce535068319180a1" }
version("1.41.0") { source md5: "bd9a2745f5bbc13f8c8f0c151e1fc557" }

relative_path "nghttp2-#{version}"

env = {
  "OPENSSL_CFLAGS" => "-I#{install_dir}/embedded/include/openssl",
  "OPENSSL_LIBS" => "-L#{install_dir}/embedded/lib",
}

build do
  license "MIT"
  license_file "./COPYING"

  command [
    "./configure",
    "--disable-app",
    "--disable-examples",
    "--disable-hpack-tools",
    "--prefix=#{install_dir}/embedded",
  ].join(" "), env: env
  command "make -j #{workers}", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
  command "make install"
end
