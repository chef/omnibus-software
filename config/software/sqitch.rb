name "sqitch"
default_version "0.973"

dependency "perl"
dependency "cpanminus"

source :url => "http://www.cpan.org/authors/id/D/DW/DWHEELER/App-Sqitch-#{version}.tar.gz",
       :md5 => "0994e9f906a7a4a2e97049c8dbaef584"

relative_path "App-Sqitch-#{version}"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
}

# See https://github.com/theory/sqitch for more
build do
  command "perl Build.PL", :env => env
  command "./Build installdeps --cpan_client 'cpanm -v --notest'", :env => env
  command "./Build", :env => env
  command "./Build install", :env => env
end
