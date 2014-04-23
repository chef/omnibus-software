name "sysstat"
default_version "10.2.1"

source :url => "http://pagesperso-orange.fr/sebastien.godard/sysstat-10.2.1.tar.gz",
       :md5 => "039dcd235dfcfb3d4acc0a05730f9512"

relative_path 'sysstat-10.2.1'

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
  command "make -j #{max_build_jobs}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "sudo make install"
  command "sudo chown -R vagrant #{install_dir}"
end
