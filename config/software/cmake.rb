name "cmake"

default_version "3.13.4"

source :url => "https://github.com/Kitware/CMake/releases/download/v#{version}/cmake-#{version}.tar.gz",
       :sha256 => "fdd928fee35f472920071d1c7f1a6a2b72c9b25e04f7a37b409349aef3f20e9b",
       :extract => :seven_zip

relative_path "cmake-#{version}"

build do
  command "./configure --prefix=#{install_dir}/embedded"
  command "make -j #{workers}"
  command "make install"
end
