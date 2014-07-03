name "python-rrdtool"
default_version "1.4.8"
dependency "python"

build do
  if ENV['PKG_TYPE'] == 'deb'
    command "wget http://dd-agent.s3.amazonaws.com/python-rrdtool/deb/#{ENV['ARCH']}/rrdtool.so", :cwd => "#{install_dir}/embedded/lib/python2.7/"
  elsif ENV['PKG_TYPE'] == 'rpm'
   command "sudo yum -y install cairo-devel libxml2-devel pango-devel pango libpng-devel freetype freetype-devel libart_lgpl-devel gcc groff perl-ExtUtils-MakeMaker"
   command "sudo wget http://files.directadmin.com/services/9.0/ExtUtils-MakeMaker-6.31.tar.gz", :cwd => "/root/"
   command "sudo tar xvzf ExtUtils-MakeMaker-6.31.tar.gz", :cwd => "/root/"
   command "sudo perl Makefile.PL", :cwd => "/root/ExtUtils-MakeMaker-6.31"
   command "sudo make", :cwd => "/root/ExtUtils-MakeMaker-6.31"
   command "sudo make install", :cwd => "/root/ExtUtils-MakeMaker-6.31"
   command "sudo wget http://oss.oetiker.ch/rrdtool/pub/rrdtool-#{version}.tar.gz", :cwd => "/opt/"
   command "sudo tar -xzvf rrdtool-#{version}.tar.gz", :cwd => "/opt/"
   command "sudo .configure", :cwd => "/opt/rrdtool-#{version}", :env => {"PKG_CONFIG_PATH" => "/usr/lib/pkgconfig/"}
   command "sudo make", :cwd => "/opt/rrdtool-#{version}", :env => {"PKG_CONFIG_PATH" => "/usr/lib/pkgconfig/"}
   command "sudo make install", :cwd => "/opt/rrdtool-#{version}", :env => {"PKG_CONFIG_PATH" => "/usr/lib/pkgconfig/"}
   command "sudo #{install_dir}/embedded/bin/python setup.py install", :cwd => "/opt/rrdtool-#{version}/bindings/python/"
   command "sudo cp /opt/rrdtool-#{version}/lib/librrd.s* #{install_dir}/embedded/lib"

  end
  
end
