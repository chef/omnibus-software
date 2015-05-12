
name "util-macros"
default_version "1.19.0"

source :url => "http://xorg.freedesktop.org/releases/individual/util/util-macros-#{version}.tar.gz",
  :md5 => '40e1caa49a71a26e0aa68ddd00203717'

relative_path "util-macros-#{version}"

configure_env =
  case ohai['platform']
  when "aix"
    {
      "CC" => "xlc -q64",
      "CXX" => "xlC -q64",
      "LD" => "ld -b64",
      "CFLAGS" => "-q64 -I#{install_dir}/embedded/include -O",
      "LDFLAGS" => "-q64 -Wl,-blibpath:/usr/lib:/lib",
      "OBJECT_MODE" => "64",
      "ARFLAGS" => "-X64 cru",
      "LD" => "ld -b64",
      "OBJECT_MODE" => "64",
      "ARFLAGS" => "-X64 cru "
    }
  when "mac_os_x"
    {
      "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-I#{install_dir}/embedded/include -L#{install_dir}/embedded/lib"
    }
  when "solaris2"
    {
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
    }
  else
    {
      "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-I#{install_dir}/embedded/include -L#{install_dir}/embedded/lib"
    }
  end

build do
  ship_license "http://cgit.freedesktop.org/xorg/util/macros/plain/COPYING"
  command "./configure --prefix=#{install_dir}/embedded", :env => configure_env
  command "make -j #{workers}", :env => configure_env
  command "make -j #{workers} install", :env => configure_env
end
