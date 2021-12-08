name "net-snmp-lib"
default_version "5.7.3"

# This definition differs from `net-snmp` in that this one will only ship
# libnetsnmp and not the rest of the package. Headers are also installed
# but not shipped, so they're provided for building (if needed).
#
version "5.7.3" do
  source sha256: "12ef89613c7707dc96d13335f153c1921efc9d61d3708ef09f3fc4a7014fb4f0"
end

dependency "zlib"
dependency "openssl"

source url: "https://dd-agent.s3.amazonaws.com/net-snmp/net-snmp-#{version}.tar.gz",
       extract: :seven_zip

relative_path "net-snmp-#{version}"

build_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib",
  "CFLAGS" => "-I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
}

net_snmp_configure = ["./configure",
                      "--with-defaults",
                      "--enable-ipv6",
                      "--with-ldflags=-L#{install_dir}/embedded/lib",
                      "--with-cflags=-I#{install_dir}/embedded/include",
                      "--with-zlib=#{install_dir}/embedded/lib",
                      "--libdir=#{install_dir}/embedded/lib",
                      "--disable-embedded-perl",
                      "--without-perl-modules",
                      "--enable-shared",
                      "--disable-static"]
build do
  license "BSD-style"
  license_file "https://gist.githubusercontent.com/truthbk/219266c31f7d664c749dba525eb8a7b0/raw/82539d51d5b1e545e1ceb241b25f476956b636f9/net-snmp.license"

  if mac_os_x?
    copy "include/net-snmp/system/darwin13.h", "include/net-snmp/system/darwin14.h"
    copy "include/net-snmp/system/darwin13.h", "include/net-snmp/system/darwin15.h"
    copy "include/net-snmp/system/darwin13.h", "include/net-snmp/system/darwin16.h"
  end

  command net_snmp_configure.join(" "), env: build_env
  command "make -j #{workers}", env: build_env

  mkdir "#{install_dir}/embedded/lib"

  command "make installheaders"
  command "make -C snmplib installlibs"
end
