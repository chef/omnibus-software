name "mumrah-kafka-python"
default_version "kafka-0.8.0-release"
source :git => "https://github.com/mumrah/kafka-python.git"
relative_path "kafka-python"


build do
   command "#{install_dir}/embedded/bin/pip install -I --build #{project_dir} --install-option=\"--install-scripts=#{install_dir}/bin\" ./"
end