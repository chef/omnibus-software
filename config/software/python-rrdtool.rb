name "python-rrdtool"
default_version "s3"
dependency "python"

build do
  if ENV['PKG_TYPE'] == 'deb'
    command "wget http://dd-agent.s3.amazonaws.com/python-rrdtool/deb/#{ENV['ARCH']}/rrdtool.so", :cwd => "#{install_dir}/embedded/lib/python2.7/"
  elsif ENV['PKG_TYPE'] == 'rpm'
    command "wget http://dd-agent.s3.amazonaws.com/python-rrdtool/rpm/#{ENV['ARCH']}/rrdtoolmodule.so", :cwd => "#{install_dir}/embedded/lib/python2.7/"
  end
  
end
