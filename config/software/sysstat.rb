name "sysstat"
default_version "11.0.1"

source :url => "http://perso.orange.fr/sebastien.godard/sysstat-11.0.1.tar.xz",
       :md5 => "7d19d02294dc1befd48846caf2f3cafe"

relative_path 'sysstat-11.0.1'

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  add_source "http://perso.orange.fr/sebastien.godard/sysstat-11.0.1.tar.xz"
  license "https://raw.githubusercontent.com/sysstat/sysstat/master/COPYING"
  command(["./configure",
       "--prefix=#{install_dir}/embedded",
       "--disable-nls"].join(" "),
    :env => env)
  command "make -j #{workers}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "sudo make install"
  command "sudo chown -R vagrant #{install_dir}"
end