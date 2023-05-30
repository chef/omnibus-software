name "flex"
default_version "2.6.0"

relative_path "flex-#{version}"

source url: "https://downloads.sourceforge.net/project/flex/flex-#{version}.tar.gz",
       sha256: "fc367e9deb570ee7fc7893ce5066c2dbdedf3cf27e93f2f39d1318703b028f0c"

env = with_standard_compiler_flags

build do
  command "./configure --prefix=#{install_dir}/embedded", env: env
  command "make -j #{workers}", env: env
  command "make -j #{workers} install", env: env
end
