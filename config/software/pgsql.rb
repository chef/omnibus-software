name "pgsql"
default_version "9.4.4"

# Even though this is called pgsql it ships only the few things we need for the agent
# WINDOWS ONLY !!!! (we ship binaries in ehre)

source :url => "http://get.enterprisedb.com/postgresql/postgresql-9.4.4-3-windows-x64-binaries.zip",
       :md5 => "094d18f3534d1a6c1cab17d37fb88319"

build do
  ship_license "https://raw.githubusercontent.com/lpsmith/postgresql-libpq/master/LICENSE"

  # After trying to compile unsuccessfully with VisualC++ and MinGW let's stick to the
  # standard windows "solutions" : download the binaries and making a nice copy of it :)
  mkdir "#{windows_safe_path(install_dir)}\\embedded\\include\\postgresql"
  command "COPY bin\\pg_config.exe #{windows_safe_path(install_dir)}\\embedded\\Scripts"
end

