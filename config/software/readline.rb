name "readline"
default_version "7.0"

relative_path "readline-7.0"

source :url => "https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz",
       :md5 => "205b03a87fc83dab653b628c59b9fc91"

env = with_standard_compiler_flags()

build do
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{workers}", :env => env
  command "make -j #{workers} install", :env => env
end
