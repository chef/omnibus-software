## This is necessary because nokogiri is built using native libraries. 
## It needs to know to use the embedded libraries.

name "ruby-mysql"
version "2.9.1"

dependencies [ 
        "ruby", 
        "rubygems",
]

build do
  gem [
        "install",
        "mysql",
        "-v #{version}",
        "--",
        "--with-xml2-lib=#{install_dir}/embedded/lib",
        "--with-xml2-include=#{install_dir}/embedded/include/libxml2",
        "--with-xslt-lib=#{install_dir}/embedded/lib",
        "--with-xslt-include=#{install_dir}/embedded/include/libxslt",
        "--with-zlib-lib=#{install_dir}/embedded/lib",
        "--with-zlib-include=#{install_dir}/embedded/include",
        "--with-iconv-include=#{install_dir}/embedded/include",
        "--with-iconv-lib=#{install_dir}/embedded/lib"].join(" ")
end
