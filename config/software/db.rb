name "db"
version "4.8.30"

source :url => "http://download.oracle.com/berkeley-db/#{name}-#{version}.tar.gz",
       :md5 => "f80022099c5742cd179343556179aa8c"

relative_path "#{name}-#{version}/build_unix"

build do
  configure_command = ["../dist/configure",
                       "--prefix=#{install_dir}/embedded",
                       "--enable-shared"]

  make_binary = 'make'

  command configure_command.join(" ")
  command "#{make_binary} -j #{max_build_jobs}"
  command "#{make_binary} -j #{max_build_jobs} install"
end
