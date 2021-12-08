name "libsqlite3"
default_version "3.35.5"

dependency "config_guess"

source url: "https://www.sqlite.org/2021/sqlite-autoconf-3350500.tar.gz",
       sha256: "f52b72a5c319c3e516ed7a92e123139a6e87af08a2dc43d7757724f6132e6db0"

relative_path "sqlite-autoconf-3350500"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

build do
  license "Public-Domain"

  update_config_guess
  command(["./configure",
       "--prefix=#{install_dir}/embedded",
       "--disable-nls"].join(" "),
    env: env)
  command "make -j #{workers}", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
  command "make install"
  delete "#{install_dir}/embedded/bin/sqlite3"
end
