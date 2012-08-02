name "libgcc"
description "On UNIX systems where we bootstrap a compiler, copy the libgcc"

build do
  if File.exists?("/opt/csw/lib/libgcc_s.so.1")
    command "cp /opt/csw/lib/libgcc_s.so.1 #{install_dir}/embedded/lib/"
  elsif File.exists?("/usr/local/liblibgcc_s.so.1")
    command "cp /usr/local/lib/libgcc_s.so.1 #{install_dir}/embedded/lib/"
  elsif File.exists?("/usr/lib/libgcc_s.so.1")
    command "cp /usr/lib/libgcc_s.so.1 #{install_dir}/embedded/lib/"
  else
    raise "cannot find libgcc_s.so.1 -- where is your gcc compiler?"
  end
end
