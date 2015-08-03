name 'cmake'
default_version '3.1.3'

if ohai['platform'] != 'windows'
  source :url => "http://www.cmake.org/files/v#{version[0..2]}/cmake-#{version}.tar.gz",
         :md5 => '5697a77503bb5636f4b4057dcc02aa32'

  relative_path "cmake-#{version}"

  build do
    command "./configure --prefix=#{install_dir}/embedded"
    patch :source => "build_on_mac_10.10.patch" if ohai['platform_family'] == 'mac_os_x'
    command "make -j #{workers}"
    command "make install"
  end

else
  # We create a dummy file for the omnibus git_cache to work on Windows
  build do
    command "touch #{install_dir}/uselessfile"
  end
end
