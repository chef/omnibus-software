name "qt"

default_version "4.8"

dependency "homebrew"

build do
  command "cd $( brew --prefix ) && git checkout a5112b"
  command "brew install qt"
  command "brew linkapps qt"
end

