name "python-rrdtool"
default_version "1.4.7"
dependency "python"

build do
  ship_license "https://raw.githubusercontent.com/oetiker/rrdtool-1.x/master/COPYRIGHT"

  if ohai['platform_family'] == 'debian'
    command "curl -O http://dd-agent.s3.amazonaws.com/python-rrdtool/deb/#{ohai['kernel']['machine']}/rrdtool.so", :cwd => "#{install_dir}/embedded/lib/python2.7/"
  elsif ohai['platform_family'] == 'rhel'
   command "curl -O http://files.directadmin.com/services/9.0/ExtUtils-MakeMaker-6.31.tar.gz", :cwd => "/tmp/"
   command "tar xvzf ExtUtils-MakeMaker-6.31.tar.gz", :cwd => "/tmp/"
   command "perl Makefile.PL", :cwd => "/tmp/ExtUtils-MakeMaker-6.31"
   if ohai['kernel']['machine'] == 'i686'
     command "curl -O http://cpansearch.perl.org/src/JHI/perl-5.8.0/thrdvar.h", :cwd => "/usr/lib/perl5/CORE/"
   end
   command "make", :cwd => "/tmp/ExtUtils-MakeMaker-6.31"
   command "make install", :cwd => "/tmp/ExtUtils-MakeMaker-6.31"
   command "curl -O http://oss.oetiker.ch/rrdtool/pub/rrdtool-#{version}.tar.gz", :cwd => "/opt/"
   command "tar -xzvf rrdtool-#{version}.tar.gz", :cwd => "/opt/"
   command "./configure", :cwd => "/opt/rrdtool-#{version}", :env => {"PKG_CONFIG_PATH" => "/usr/lib/pkgconfig/"}
   command "make", :cwd => "/opt/rrdtool-#{version}", :env => {"PKG_CONFIG_PATH" => "/usr/lib/pkgconfig/"}
   command "make install", :cwd => "/opt/rrdtool-#{version}", :env => {"PKG_CONFIG_PATH" => "/usr/lib/pkgconfig/"}
   command "#{install_dir}/embedded/bin/python setup.py install", :cwd => "/opt/rrdtool-#{version}/bindings/python/"
  end

end
