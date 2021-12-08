name "pyopenssl"
# If you upgrade pyopenssl, you'll probably have to upgrade `cryptography` as well
default_version "19.0.0"

dependency "python"
dependency "pip"
dependency "openssl"
dependency "libffi"
dependency "cryptography"

build do
  license "Apache-2.0"
  license_file "https://raw.githubusercontent.com/pyca/pyopenssl/master/LICENSE"
  build_env = {
    "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include/",
  }
  pip "install pyOpenSSL==#{version}", env: build_env
end
