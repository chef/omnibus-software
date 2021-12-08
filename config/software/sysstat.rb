name "sysstat"
default_version "11.1.3"

ship_source true

source url: "https://github.com/sysstat/sysstat/archive/v#{version}.tar.gz",
       sha256: "e76dff7fa9246b94c4e1efc5ca858422856e110f09d6a58c5bf6000ae9c9d16e"

relative_path "sysstat-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

build do
  license "GPL-2.0"
  license_file "https://raw.githubusercontent.com/sysstat/sysstat/master/COPYING"
  command(["./configure",
       "--prefix=#{install_dir}/embedded",
       "--disable-nls", "--disable-sensors"].join(" "),
    env: env)
  command "make -j #{workers}", env: { "LD_RUN_PATH" => "#{install_dir}/embedded/lib" }
  command "make install"
end
