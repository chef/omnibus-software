#
# Copyright 2012-2017 Chef Software, Inc.
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

default_version "9.2.21"

license "PostgreSQL"
license_file "COPYRIGHT"
skip_transitive_dependency_licensing true

dependency "zlib"
dependency "openssl"
dependency "libedit"
dependency "ncurses"
dependency "libossp-uuid"
dependency "config_guess"

source url: "https://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.bz2"

version("9.2.8") { source md5: "c5c65a9b45ee53ead0b659be21ca1b97" }
version("9.2.9") { source md5: "38b0937c86d537d5044c599273066cfc" }
version("9.2.10") { source md5: "7b81646e2eaf67598d719353bf6ee936" }
version("9.2.14") { source md5: "ce2e50565983a14995f5dbcd3c35b627" }
version("9.2.21") { source sha256: "0697e843523ee60c563f987f9c65bc4201294b18525d6e5e4b2c50c6d4058ef9" }

version("9.3.4") { source md5: "d0a41f54c377b2d2fab4a003b0dac762" }
version("9.3.5") { source md5: "5059857c7d7e6ad83b6d55893a121b59" }
version("9.3.6") { source md5: "0212b03f2835fdd33126a2e70996be8e" }
version("9.3.10") { source md5: "ec2365548d08f69c8023eddd4f2d1a28" }
version("9.3.14") { source sha256: "5c4322f1c42ba1ff4b28383069c56663b46160bb08e85d41fa2ab9a5009d039d" }

version("9.4.0") { source md5: "8cd6e33e1f8d4d2362c8c08bd0e8802b" }
version("9.4.1") { source md5: "2cf30f50099ff1109d0aa517408f8eff" }
version("9.4.5") { source md5: "8b2e3472a8dc786649b4d02d02e039a0" }
version("9.4.6") { source md5: "0371b9d4fb995062c040ea5c3c1c971e" }

version("9.5.0") { source md5: "2f3264612ac32e5abdfb643fec934036" }
version("9.5.1") { source md5: "11e037afaa4bd0c90bb3c3d955e2b401" }

version("9.6.3") { source sha256: "1645b3736901f6d854e695a937389e68ff2066ce0cde9d73919d6ab7c995b9c6" }

relative_path "postgresql-#{version}"
