name "libsqlite3"
default_version "3.33.0"

dependency "config_guess"

source url: "https://www.sqlite.org/2020/sqlite-autoconf-3330000.tar.gz",
       sha256: "106a2c48c7f75a298a7557bcc0d5f4f454e5b43811cc738b7ca294d6956bbb15"

relative_path "sqlite-autoconf-3330000"

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
