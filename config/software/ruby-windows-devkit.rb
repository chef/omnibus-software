#
# Copyright 2012-2014 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "ruby-windows-devkit"
default_version "4.7.2-20130224"

license "BSD-3-Clause"
license_file "https://raw.githubusercontent.com/oneclick/rubyinstaller/master/LICENSE.txt"
skip_transitive_dependency_licensing true

if windows_arch_i386?
  version "4.5.2-20111229-1559" do
    source url: "https://github.com/oneclick/rubyinstaller/releases/download/DevKit-tdm-32-4.5.2/DevKit-tdm-32-#{version}-sfx.exe",
           sha256: "6c3af5487dafda56808baf76edd262b2020b1b25ab86aabf972629f4a6a54491"
  end

  version "4.7.2-20130224" do
    source url: "https://github.com/oneclick/rubyinstaller/releases/download/devkit-4.7.2/DevKit-mingw64-32-#{version}-1151-sfx.exe",
           sha256: "61a06b5da06dd94343e591163ac0d43c544e9cd4df770f01275645b268b44dc7"
  end
else
  version "4.7.2-20130224" do
    source url: "https://github.com/oneclick/rubyinstaller/releases/download/devkit-4.7.2/DevKit-mingw64-64-#{version}-1432-sfx.exe",
           sha256: "2ada04c7234199126c0f34f6ea7163a8f8dccb1e15814af175a189f6ac48b8ac"
  end
end
build do
  env = with_standard_compiler_flags(with_embedded_path)

  embedded_dir = "#{install_dir}/embedded"

  command "#{project_file} -y -o#{windows_safe_path(embedded_dir)}", env: env

  command "echo - #{install_dir}/embedded > config.yml", cwd: embedded_dir
  ruby "dk.rb install", env: env, cwd: embedded_dir

  # Normally we would symlink the required unix tools.
  # However with the introduction of git-cache to speed up omnibus builds,
  # we can't do that anymore since git on windows doesn't support symlinks.
  # https://groups.google.com/forum/#!topic/msysgit/arTTH5GmHRk
  # Therefore we copy the tools to the necessary places.
  # We need tar for 'knife cookbook site install' to function correctly and
  # many gems that ship with native extensions assume tar will be available
  # in the PATH.
  {
    "tar.exe" => "bsdtar.exe",
    "libarchive-2.dll" => "libarchive-2.dll",
    "libexpat-1.dll" => "libexpat-1.dll",
    "liblzma-1.dll" => "liblzma-1.dll",
    "libbz2-2.dll" => "libbz2-2.dll",
    "libz-1.dll" => "libz-1.dll",
    "libssp-0.dll" => "libssp-0.dll",
  }.each do |target, to|
    copy "#{install_dir}/embedded/mingw/bin/#{to}", "#{install_dir}/bin/#{target}"

    copy "#{install_dir}/embedded/bin/x64-msvcrt-ruby300.dll", "#{install_dir}/bin/x64-msvcrt-ruby300.dll"
    copy "#{install_dir}/embedded/mingw/include/ansidecl.h", "#{install_dir}/embedded/mingw/x86_64-w64-mingw32/include/ansidecl.h"
  end

  # IIS 8.5 Server STIG finding V-76717 warns on this file because it ends with
  # `.java`. From the file name it presumes it contains Java source code which
  # should not be stored on a web server.
  #
  # https://www.stigviewer.com/stig/iis_8.5_server/2019-01-08/finding/V-76717
  #
  # Searching GitHub for software that may use this functionality with the
  # the following keywords presented no interesting results
  # - %language java extension:.y
  # - bison "-L java"
  # - bison "--language java"
  #
  # It is highly unlikely that a user would try to use our compiler stack on a
  # Windows system to compile a Java program that used bison.
  delete "#{install_dir}/embedded/share/bison/lalr1.java"
end
