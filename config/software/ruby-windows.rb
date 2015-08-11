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

name "ruby-windows"
default_version "2.0.0-p451"

if i386?
  relative_path "ruby-#{version}-i386-mingw32"
  source url: "http://dl.bintray.com/oneclick/rubyinstaller/ruby-#{version}-i386-mingw32.7z?direct"

  version("2.0.0-p451") { source md5: "37feadb0230e7f475a8591d1807ecfec" }
  version("2.0.0-p645") { source md5: "1a59c016a3ea0714b06d7a5f6aa4157a" }
  version("2.1.3") { source md5: "60e39aaab140c3a22abdc04ec2017968" }
  version("2.1.5") { source md5: "fe6b596fc47f503b0c0c01ebed16cf65" }
  version("2.1.6") { source md5: "e3c345a73e5523677a1f301caa4142eb" }
  version("2.2.1") { source md5: "9f1beca535b2e60098d826eb7cb1b972" }
else
  relative_path "ruby-#{version}-x64-mingw32"
  source url: "http://dl.bintray.com/oneclick/rubyinstaller/ruby-#{version}-x64-mingw32.7z?direct"

  version("2.0.0-p451") { source md5: "d4f6741138a26a4be12e684a16a19b75" }
  version("2.0.0-p645") { source md5: "d57d539b90f5bbf26550a9d1a3c33c33" }
  version("2.1.3") { source md5: "d339f956db4d4b1e8a30ac3e33014844" }
  version("2.1.5") { source md5: "2ebc791db99858a0bd586968cddfcf0d" }
  version("2.1.6") { source md5: "a443794bc4c22091193eccf0b02f763e" }
  version("2.2.1") { source md5: "0e6fe9f27367123f738bf143f4bf04f6" }
end

build do

  sync "#{project_dir}/", "#{install_dir}/embedded"

  # Ruby 2.X dl.rb gives an annoying warning message on Windows:
  # DL is deprecated, please use Fiddle
  # Since we don't have patch on windows we are manually patching the file
  # to turn off the warning message
  # We are only removing dl.rb:8
  # => warn "DL is deprecated, please use Fiddle"
  block do
    require 'digest/md5'

    ABI_ver = version[/(^\d+\.\d+)/] + '.0'
    dl_path = File.join(install_dir, "embedded/lib/ruby", ABI_ver, "dl.rb")

    if Digest::MD5.hexdigest(File.read(dl_path)) == "78c185a3fcc7b5e2c3db697c85110d8f"
      File.open(dl_path, "w") do |f|
        f.print <<-E
  require 'dl.so'

  begin
    require 'fiddle' unless Object.const_defined?(:Fiddle)
  rescue LoadError
  end

  module DL
    # Returns true if DL is using Fiddle, the libffi wrapper.
    def self.fiddle?
      Object.const_defined?(:Fiddle)
    end
  end
  E
      end
    end
  end
end
