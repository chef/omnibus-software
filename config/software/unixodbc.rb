name "unixodbc"
default_version "2.3.4"

version "2.3.4" do
  source :sha256 => "2e1509a96bb18d248bf08ead0d74804957304ff7c6f8b2e5965309c632421e39"
end

source :url => "https://downloads.sourceforge.net/unixodbc/unixODBC-#{version}.tar.gz"

build do
  ship_license "LGPLv2"
  env = with_standard_compiler_flags(with_embedded_path)

  configure_args = [
    "--disable-readline",
    "--prefix=#{install_dir}/embedded",
  ]

  configure_command = configure_args.unshift("./configure").join(" ")

  command configure_command, cwd: "#{Omnibus::Config.source_dir}/unixodbc/unixODBC-#{version}", env: env, in_msys_bash: true
  make env: env, cwd: "#{Omnibus::Config.source_dir}/unixodbc/unixODBC-#{version}"
  make "install", cwd: "#{Omnibus::Config.source_dir}/unixodbc/unixODBC-#{version}", env: env
end
