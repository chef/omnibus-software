name "bison"
default_version "3.0.4"

relative_path "bison-3.0.4"

source :url => "http://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.gz",
       :md5 => "a586e11cd4aff49c3ff6d3b6a4c9ccf8"

env = with_standard_compiler_flags()

build do
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{workers}", :env => env
  command "make -j #{workers} install", :env => env
end
