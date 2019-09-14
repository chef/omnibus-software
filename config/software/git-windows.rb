#
# Copyright 2016-2019, Chef Software Inc.
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
default_version "2.23.0"

license "LGPL-2.1"
# the license file does not ship in the portable git package so pull from the source repo
license_file "https://raw.githubusercontent.com/git-for-windows/git/master/LGPL-2.1"

arch_suffix = windows_arch_i386? ? "32" : "64"
# The Git for Windows project includes a build number in their tagging
# scheme and therefore in the URLs for downloaded releases.
# Occasionally, something goes wrong with a build/release and the "real"
# release of a version has a build number other than 1. And so far, the
# release URLs have not followed a consistent pattern for whether and how
# the build number is included.
# This URL pattern has worked for most releases. If a version has multiple
# builds, set the `source url:` again explicitly to the one appropriate for
# that version's release.
source url: "https://github.com/git-for-windows/git/releases/download/v#{version}.windows.1/PortableGit-#{version}-#{arch_suffix}-bit.7z.exe"

if windows_arch_i386?
  version("2.23.0") { source sha256: "33388028d45c685201490b0c621d2dbfde89d902a7257771f18de9bb37ae1b9a" }
  version("2.20.0") { source sha256: "d00e31b9d5db9b434d9da10bafb1028de3ea388bab3721d02ad5edb6d46d6507" }
  version("2.18.0") { source sha256: "28e68a781a78009913fef3d6c1074a6c91b05e4010bfd9efaff7b8398c87e017" }
  version("2.14.1") { source sha256: "df3f9b6c2dd2b12e5cb7035b9ca48d13b973d054a35b0939953aa6e7a00a0659" }
  version("2.12.0") { source sha256: "0375ba0a05f9cd501cc8089b9af6f2adf8904a5efb1e5b9421e6561bd9f8c817" }
  version("2.8.1") { source sha256: "0b6efaaeb4b127edb3a534261b2c9175bd86ee8683dff6e12ccb194e6abb990e" }
  version("2.8.2") { source sha256: "da25bc12efa864cda53dc6485c84dd8b0d41883dd360db505c026c284ef58d8e" }
else
  version("2.23.0") { source sha256: "501d8be861ebb8694df3f47f1f673996b1d1672e12559d4a07fae7a2eca3afc7" }
  version("2.20.0") { source sha256: "4f0c60a1d0ac23637d600531da34b48700fcaee7ecd79d36e2f5369dc8fcaef6" }
  version("2.18.0") { source sha256: "cd84a13b6c7aac0e924cb4db2476e2f4379aab4b8e60246992a6c5eebeac360c" }
  version("2.14.1") { source sha256: "3c3270a9df5f3db1f7637d86b94fb54a96e9145ba43c98a3e993cdffb1a1842e" }
  version("2.12.0") { source sha256: "5bebd0ee21e5cf3976bc71826a28b2663c7a0c9b5c98f4ab46ff03c3c0d3556f" }
  version("2.8.1") { source sha256: "dc9d971156cf3b6853bc0c1ad0ca76f1d2c24478cca80036919f12fe46acd64e" }
  version("2.8.2") { source sha256: "553acbf46bacc67c73b954689ad3d9ac294bf9cbe249a5b78159a1f92f37105b" }
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
        f.print "START \"\" " if %w{gitk git-gui}.include?(base.downcase)
        f.puts "\"%~dp0..\\git\\cmd\\#{base}#{ext}\" %*"
      end
    end
  end
end
