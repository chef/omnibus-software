name "libsqlite3"
default_version "3.31.1"

dependency "config_guess"

source url: "https://www.sqlite.org/2020/sqlite-autoconf-3310100.tar.gz",
       sha256: "62284efebc05a76f909c580ffa5c008a7d22a1287285d68b7825a2b6b51949ae"

relative_path "sqlite-autoconf-3310100"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

build do
  update_config_guess
  command(["./configure",
       "--prefix=#{install_dir}/embedded",
       "--disable-nls"].join(" "),
    env: env)
  command "make -j #{workers}", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
  command "make install"
  delete "#{install_dir}/embedded/bin/sqlite3"
end
