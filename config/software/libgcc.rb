name "libgcc"
description "On UNIX systems where we bootstrap a compiler, copy the libgcc"

build do
  if File.exists?("/usr/lib/libgcc_s.so.1")
    command "cp /usr/lib/libgcc_s.so.1 #{install_dir}/embedded/lib/"
  else
    command "cp /usr/local/lib/libgcc_s.so.1 #{install_dir}/embedded/lib/"
  end
end
