name "libgcc"
description "On UNIX systems where we bootstrap a compiler, copy the libgcc"

if (platform == "solaris2" && Omnibus.config.solaris_compiler == "gcc")
  build do
    if File.exists?("/opt/csw/lib/libgcc_s.so.1")
      command "cp /opt/csw/lib/libgcc_s.so.1 #{install_dir}/embedded/lib/"
    else
      raise "cannot find libgcc_s.so.1 -- where is your gcc compiler?"
    end
  end
end

