#
# Copyright 2022 Progress Software, Inc.
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

name "ruby-msys2-devkit"
default_version "3.0.3-1"

license "BSD-3-Clause"
license_file "https://raw.githubusercontent.com/oneclick/rubyinstaller2/master/LICENSE.txt"
skip_transitive_dependency_licensing true
arch = "x64"
msys_dir = "msys64"

if windows_arch_i386?
  arch = "x86"
  msys_dir = "msys32"
  version "3.0.3-1" do
    source url: "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-#{version}/rubyinstaller-devkit-#{version}-x86.exe",
           sha256: "4cf4d3522c33472354f3c1af998f1cff8371d4a9a5958067efaa04bb9147b2be"
  end
else
  version "3.0.3-1" do
    source url: "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-#{version}/rubyinstaller-devkit-#{version}-x64.exe",
           sha256: "be05e2de16d75088613cc998beb2938aa2946384884ed7f9142daec9a848d08c"
  end

  version "3.1.2-1" do
    source url: "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-#{version}/rubyinstaller-devkit-#{version}-x64.exe",
           sha256: "5f0fd4a206b164a627c46e619d2babbcafb0ed4bc3e409267b9a73b6c58bdec1"
  end
end
build do
  if windows?
    embedded_dir = "#{install_dir}/embedded"

    Dir.mktmpdir do |tmpdir|
      command "#{project_dir}/rubyinstaller-devkit-#{version}-#{arch}.exe /SP- /NORESTART /VERYSILENT /SUPPRESSMSGBOXES /NOPATH /DIR=#{tmpdir}"
      copy "#{tmpdir}/#{msys_dir}", embedded_dir
      copy "#{tmpdir}/lib/ruby/site_ruby/3.0.0/devkit.rb", "#{embedded_dir}/lib/ruby/site_ruby/3.0.0"
      copy "#{tmpdir}/lib/ruby/site_ruby/3.0.0/ruby_installer.rb", "#{embedded_dir}/lib/ruby/site_ruby/3.0.0"
      copy "#{tmpdir}/lib/ruby/site_ruby/3.0.0/ruby_installer", "#{embedded_dir}/lib/ruby/site_ruby/3.0.0"
      copy "#{tmpdir}/lib/ruby/3.0.0/rubygems/defaults", "#{embedded_dir}/lib/ruby/3.0.0/rubygems/defaults"

      # Normally we would symlink the required unix tools.
      # However with the introduction of git-cache to speed up omnibus builds,
      # we can't do that anymore since git on windows doesn't support symlinks.
      # https://groups.google.com/forum/#!topic/msysgit/arTTH5GmHRk
      # Therefore we copy the tools to the necessary places.
      # We need tar for 'knife cookbook site install' to function correctly and
      # many gems that ship with native extensions assume tar will be available
      # in the PATH.
      copy "#{tmpdir}/#{msys_dir}/usr/bin/bsdtar.exe", "#{install_dir}/bin/tar.exe"
    end

    command "#{embedded_dir}/#{msys_dir}/msys2_shell.cmd -defterm -no-start -c exit", env: { "CONFIG" => "" }
  end
end
