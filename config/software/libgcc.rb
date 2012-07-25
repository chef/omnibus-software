name "libgcc"
description "On UNIX systems where we bootstrap a compiler, copy the libgcc"

build do
  command "cp /opt/omnibus/bootstrap/gcc34/lib/libgcc_s.so.1 #{install_dir}/embedded/lib/"
end
