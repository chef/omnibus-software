name "python-rrdtool"
default_version "s3"
dependency "python"

build do
   command "wget http://dd-agent.s3.amazonaws.com/python-rrdtool/#{ENV['ARCH']}/rrdtool.so", :cwd => "#{install_dir}/embedded/lib/python2.7/"
end
