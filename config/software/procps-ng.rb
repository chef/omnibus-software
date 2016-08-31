name "procps-ng"
default_version "3.3.9"

dependency 'ncurses'

source :url => "https://gitlab.com/procps-ng/procps/repository/archive.tar.gz?ref=v#{version}",
       :sha256 => '86421ed15ad84895c0defe6f4e42a1c1e3e901a2a8fced4ac5457157a3448237'

relative_path "procps-ng-3.3.9"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  ship_source "https://gitlab.com/procps-ng/procps/repository/archive.tar.gz?ref=v#{version}"
  ship_license "https://gitlab.com/procps-ng/procps/raw/master/COPYING"
  command(["./configure",
           "--prefix=#{install_dir}/embedded",
           "--without-ncurses",
           ""].join(" "),
          :env => env)
  command "make -j #{workers}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "make install"
  move "#{install_dir}/embedded/usr/bin/*", "#{install_dir}/embedded/bin/"
  delete "#{install_dir}/embedded/usr/bin"
end
