#
# Copyright:: Chef Software, Inc.
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
# expeditor/ignore: deprecated 2021-04
#

name "git-windows"
default_version "2.33.0"

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
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-#{version}-#{arch_suffix}-bit.7z.exe",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

if windows_arch_i386?
  # version_list: url=https://github.com/git-for-windows/git/releases filter=PortableGit-*-32-bit.7z.exe
  version("2.41.0") { source sha256: "e1360e94cb292862fb023018578a1029022a09278b160f7264c6dc444f65c9ca" }
  version("2.33.0") { source sha256: "c3b6f1a8f8c1b5be2175b7190d35926dce07a58294780291326a437ef0694676" }
  version("2.31.1") { source sha256: "d6d48e16e3f0ecbc0a45d410ad3ebae15e5618202855ebe72cd9757e4d35b880" }
  version("2.30.2") { source sha256: "8b203531c91d3f9075aa3ef1e89b0d6e5d18aa289c3bc485e093c9bfb860a116" }
  version("2.29.2") { source sha256: "5e4dc60d3ee143585da03843613bc4d9032b1b6f4d3a2473ef6d9adc8e4c71c0" }
  version("2.28.0") { source sha256: "11b854e9246057a22014dbf349adfc160ffa740dba7af0dbd42d642661b2cc7f" }
  version("2.27.0") { source sha256: "8cbe1e3b57eb9d02e92cff12089454f2cf090c02958080d62e199ef8764542d3" }
else
  # version_list: url=https://github.com/git-for-windows/git/releases filter=PortableGit-*-64-bit.7z.exe
  version("2.41.0") { source sha256: "fcbaeffd24fdf435a1f7844825253509136377915e6720aa66aa256ec1f83c30" }
  version("2.33.0") { source sha256: "12c10fad2c2db17d9867dbbacff1adc8be50868b793a73d451c2b878914bb32d" }
  version("2.31.1") { source sha256: "fce2161a8891c4deefdb8d215ab76498c245072f269843ef1a489c4312baef52" }
  version("2.30.2") { source sha256: "f719f248de3dd7ef234331f8da95762594a388f6aa62f4c0260df18068e5a447" }
  version("2.29.2") { source sha256: "7d114e81a541536b025313efcdf6feea1e973323f2b8f53995721bfd511139bd" }
  version("2.28.0") { source sha256: "0cd682188b76eeb3a5da3a466d4095d2ccd892e07aae5871c45bf8c43cdb3b13" }
  version("2.27.0") { source sha256: "0fd2218ba73e07e5a664d06e0ce514edcd241a2de0ba29ceca123e7d36aa8f58" }
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
