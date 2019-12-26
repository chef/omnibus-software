name "expat"
default_version "2.1.1"

relative_path "expat-2.1.1"

source url: "http://downloads.sourceforge.net/project/expat/expat/2.1.1/expat-2.1.1.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fexpat%2F&ts=1465411104&use_mirror=heanet",
       md5: "7380a64a8e3a9d66a9887b01d0d7ea81"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

build do
  command ["./configure",
           "--prefix=#{install_dir}/embedded"].join(" "), env: env

  command "make -j #{workers}", env: env
  command "make install"
end
