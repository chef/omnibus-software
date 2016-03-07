name "validate"

package_name    "validate"
install_dir     "/opt/validate"
build_version   "0.0.1dev"
build_iteration 1

dependency 'preparation'

Dir.glob('config/software/**').each do |filepath|
  dep_name = ''
  File.readlines(filepath).each do |line|
    if line =~ /name [\"\'](?<name>.*?)[\"\']/
      # require 'pry'; binding.pry
      dep_name = $~[:name]
      next
    end
  end
  dependency "#{dep_name}"
end
