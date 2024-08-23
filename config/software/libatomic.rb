name "libatomic"
default_version "7.5.0"
dependency "gcc"
build do
  env = with_standard_compiler_flags(with_embedded_path)
  command "cd #{install_dir}/embedded/lib && ln -s libatomic.so.1.2.0 libatomic.so", env: env
end
