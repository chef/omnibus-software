name "qt"

default_version "4.8"

dependency "homebrew"

build do
  command "brew install qt"
  command "brew uninstall qt5 || true"
  command "brew unlink qt || true"
  command "brew link qt --force"
end
