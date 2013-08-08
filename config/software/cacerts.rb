#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
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

name "cacerts"
version "2012.12.19-1"  # date of the file is in a comment at the start

source :url => "http://curl.haxx.se/ca/cacert.pem",
       :md5 => '349ba2d6964db9ca558c9e1daf38e428'

relative_path "cacerts-#{version}"

build do
  block do
    FileUtils.mkdir_p(File.expand_path("embedded/ssl/certs", install_dir))

    # There is a bug in omnibus-ruby that may or may not have been fixed. Since the source url
    # does not point to an archive, omnibus-ruby tries to copy cacert.pem into the project working
    # directory. However, it fails and copies to '/var/cache/omnibus/src/cacerts-2012.12.19\' instead
    # There is supposed to be a fix in omnibus-ruby, but under further testing, it was unsure if the
    # fix worked. Rather than trying to fix this now, we're filing a bug and copying the cacert.pem
    # directly from the cache instead.

    FileUtils.cp(File.expand_path("cacert.pem", Omnibus.config.cache_dir),
                 File.expand_path("embedded/ssl/certs/cacert.pem", install_dir))
  end

  unless platform == 'windows'
    command "ln -sf #{install_dir}/embedded/ssl/certs/cacert.pem #{install_dir}/embedded/ssl/cert.pem"
  end
end
