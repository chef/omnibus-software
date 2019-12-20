name "unixodbc"
default_version "2.3.7"

version "2.3.7" do
  source :sha256 => "d4d4dd039e0cc4d8ae7a0b0d09c25630521cf616921ec8c9293734ba70988fbc"
end

source :url => "https://downloads.sourceforge.net/unixodbc/unixODBC-#{version}.tar.gz"

relative_path "unixODBC-#{version}"

build do
  ship_license "./COPYING"
  env = with_standard_compiler_flags(with_embedded_path)

  configure_args = [
    "--disable-readline",
    "--prefix=#{install_dir}/embedded",
    "--with-included-ltdl",
    "--enable-ltdl-install",
  ]

  configure_command = configure_args.unshift("./configure").join(" ")

  command configure_command, env: env, in_msys_bash: true
  make env: env
  make "install", env: env
end
