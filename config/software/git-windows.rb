#
# Copyright 2016 Chef Software, Inc.
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

name "git-windows"
default_version "2.10.2"

license "LGPL-2.1"
# the license file does not ship in the portable git package so pull from the source repo
license_file "https://raw.githubusercontent.com/git-for-windows/git/master/LGPL-2.1"

arch_suffix = windows_arch_i386? ? "32" : "64"
source url: "https://github.com/git-for-windows/git/releases/download/v#{version}.windows.1/PortableGit-#{version}-#{arch_suffix}-bit.7z.exe"

if windows_arch_i386?
  version("2.8.1") { source sha256: "0b6efaaeb4b127edb3a534261b2c9175bd86ee8683dff6e12ccb194e6abb990e" }
  version("2.8.2") { source sha256: "da25bc12efa864cda53dc6485c84dd8b0d41883dd360db505c026c284ef58d8e" }
  version("2.10.2") { source sha256: "edc616817e96a6f15246bb0dd93c97e53d38d3b2a0b7375f26bd0bd082c41a73" }
else
  version("2.8.1") { source sha256: "dc9d971156cf3b6853bc0c1ad0ca76f1d2c24478cca80036919f12fe46acd64e" }
  version("2.8.2") { source sha256: "553acbf46bacc67c73b954689ad3d9ac294bf9cbe249a5b78159a1f92f37105b" }
  version("2.10.2") { source sha256: "101314826892480043d5b11989726fc8ee448991eb7b0a1c61aca751161bc15b" }
end

# The git portable archives come with their own copy of posix related tools
# i.e. msys/basic posix/what-do-you-mean-you-dont-have-bash tools that git
# needs.  Surprising nobody who has ever dealt with this on windows, we ship
# our own set of posix libraries and ported tools - the highlights being
# tar.exe, sh.exe, bash.exe, perl.exe etc.  Since our tools reside in
# embedded/bin, we cannot simply extract git's bin/ cmd/ and lib directories
# into embedded.  So we we land them in embedded/git instead.  Git uses a
# strategy similar to ours when it comes to "appbundling" its binaries.  It has
# a /bin top level directory and a /cmd directory.  The unixy parts of it use
# /bin.  The windowsy parts of it use /cmd.  If you add /cmd to the path, there
# are tiny shim-executables in there that forward your call to the appropriate
# internal binaries with the path and environment reconfigured correctly.
# Unfortunately, they work based on relative directories...  so /cmd/git.exe
# looks for ../bin/git.  If we want delivery-cli or other applications to access
# git binaries without having to add yet another directory to the system path,
# we need to add our own shims (or shim-shims as I like to call them).  These
# are .bat files in embedded/bin - one for each binary in git's /cmd directory -
# that simply call out to git's shim binaries.

build do

  env = with_standard_compiler_flags(with_embedded_path)

  source_7z = "#{project_dir}/PortableGit-#{version}-#{arch_suffix}-bit.7z.exe"
  destination = "#{install_dir}/embedded/git"

  command "#{source_7z} -y"
  sync "PortableGit", "#{windows_safe_path(destination)}", env: env

  block "Create bat files to point to executables under embedded/git/cmd" do
    Dir.glob("#{destination}/cmd/*") do |git_bin|
      ext = File.extname(git_bin)
      base = File.basename(git_bin, ext)
      File.open("#{install_dir}/embedded/bin/#{base}.bat", "w") do |f|
        f.puts "@ECHO OFF"
        f.print "START \"\" " if ["gitk", "git-gui"].include?(base.downcase)
        f.puts "\"%~dp0..\\git\\cmd\\#{base}#{ext}\" %*"
      end
    end
  end
end
