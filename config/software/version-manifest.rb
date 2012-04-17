name "version-manifest"
description "generates a version manifest file"
always_build true

project_name = project.name
build do
  block do
    File.open("#{install_dir}/version-manifest.txt", "w") do |f|
      f.puts "#{project_name} #{Omnibus::BuildVersion.full}"
      f.puts ""
      f.puts Omnibus::Reports.pretty_version_map(project)
    end
  end
end
