name "unixodbc"
default_version "2.3.4"

version "2.3.4" do
  source :sha256 => "2e1509a96bb18d248bf08ead0d74804957304ff7c6f8b2e5965309c632421e39"
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
