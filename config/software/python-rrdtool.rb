name "python-rrdtool"
default_version "1.3.8"
dependency "python"

build do
  license "https://raw.githubusercontent.com/oetiker/rrdtool-1.x/master/COPYRIGHT"
  
  if Ohai['platform_family'] == 'debian'
    command "wget http://dd-agent.s3.amazonaws.com/python-rrdtool/deb/#{Ohai['kernel']['machine']}/rrdtool.so", :cwd => "#{install_dir}/embedded/lib/python2.7/"
  elsif Ohai['platform_family'] == 'rhel'
   command "sudo yum -y install intltool gettext cairo-devel libxml2-devel pango-devel pango libpng-devel freetype freetype-devel libart_lgpl-devel gcc groff perl-ExtUtils-MakeMaker"
   command "sudo wget http://files.directadmin.com/services/9.0/ExtUtils-MakeMaker-6.31.tar.gz", :cwd => "/tmp/"
   command "sudo tar xvzf ExtUtils-MakeMaker-6.31.tar.gz", :cwd => "/tmp/"
   command "sudo perl Makefile.PL", :cwd => "/tmp/ExtUtils-MakeMaker-6.31"
   command "sudo make", :cwd => "/tmp/ExtUtils-MakeMaker-6.31"
   command "sudo make install", :cwd => "/tmp/ExtUtils-MakeMaker-6.31"
   command "sudo wget http://oss.oetiker.ch/rrdtool/pub/rrdtool-#{version}.tar.gz", :cwd => "/opt/"
   command "sudo tar -xzvf rrdtool-#{version}.tar.gz", :cwd => "/opt/"
   command "sudo ./configure", :cwd => "/opt/rrdtool-#{version}", :env => {"PKG_CONFIG_PATH" => "/usr/lib/pkgconfig/"}
   command "sudo make", :cwd => "/opt/rrdtool-#{version}", :env => {"PKG_CONFIG_PATH" => "/usr/lib/pkgconfig/"}
   command "sudo make install", :cwd => "/opt/rrdtool-#{version}", :env => {"PKG_CONFIG_PATH" => "/usr/lib/pkgconfig/"}
   command "sudo #{install_dir}/embedded/bin/python setup.py install", :cwd => "/opt/rrdtool-#{version}/bindings/python/"


  end
  
end
