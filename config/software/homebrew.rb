name "homebrew"

default_version "0"

install_url = 'https://raw.githubusercontent.com/Homebrew/install/master/install'

build do
  command "echo | "\
  		  "ruby -e \"$(curl -fsSL #{install_url})\" |"\
  		  " echo \"Brew already installed\""
  command "brew update"
end
