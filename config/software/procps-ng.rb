name "procps-ng"
default_version "3.3.9"

source :url => "http://downloads.sourceforge.net/project/#{name}/Production/#{name}-#{version}.tar.xz",
       :md5 => '0980646fa25e0be58f7afb6b98f79d74'

relative_path "procps-ng-3.3.9"

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
  command "make install"
  command "mv #{install_dir}/embedded/usr/bin/* #{install_dir}/embedded/bin/"
  command "rm -rf #{install_dir}/embedded/usr/bin"
end
