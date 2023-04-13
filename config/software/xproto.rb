
name "xproto"
default_version "7.0.27"

source url: "https://xorg.freedesktop.org/releases/individual/proto/xproto-#{version}.tar.gz",
       sha256: "693d6ae50cb642fc4de6ab1f69e3f38a8e5a67eb41ac2aca253240f999282b6b",
       extract: :seven_zip

relative_path "xproto-#{version}"

configure_env =
  case ohai["platform"]
  when "aix"
    {
      "CC" => "xlc -q64",
      "CXX" => "xlC -q64",
      "CFLAGS" => "-q64 -I#{install_dir}/embedded/include -O",
      "LDFLAGS" => "-q64 -Wl,-blibpath:/usr/lib:/lib",
      "ARFLAGS" => "-X64 cru",
      "LD" => "ld -b64",
      "OBJECT_MODE" => "64",
    }
  when "mac_os_x"
    {
      "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-I#{install_dir}/embedded/include -L#{install_dir}/embedded/lib",
    }
  when "solaris2"
    {
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    }
  else
    {
      "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-I#{install_dir}/embedded/include -L#{install_dir}/embedded/lib",
    }
  end

build do
  license "MIT"
  license_file "./COPYING"

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --disable-static", env: configure_env
  command "make -j #{workers}", env: configure_env
  command "make -j #{workers} install", env: configure_env
end
