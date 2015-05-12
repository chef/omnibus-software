name "libsqlite3"
default_version "3.7.7.1"

source :git => 'git://github.com/LuaDist/libsqlite3.git'

relative_path 'libsqlite3'

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command(["./configure",
       "--prefix=#{install_dir}/embedded",
       "--disable-nls"].join(" "),
    :env => env)
  command "make -j #{workers}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "make install"
  delete "#{install_dir}/embedded/bin/sqlite3"
end
