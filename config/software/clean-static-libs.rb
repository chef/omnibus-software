#
# Copyright 2012-2016 Chef Software, Inc.
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

name "clean-static-libs"
description "cleanup un-needed static libraries from the build"
default_version "1.0.0"

license :project_license
skip_transitive_dependency_licensing true

build do
  # Remove static object files for all platforms
  # except AIX which uses them at runtime.
  unless aix?
    block "Remove static libraries" do
      # find the embedded ruby gems dir and clean it up for globbing
      target_dir = "#{install_dir}/embedded/lib/ruby/gems".tr('\\', "/")

      # find all the static *.a files and delete them
      Dir.glob("#{target_dir}/**/*.a").each do |f|
        puts "Deleting #{f}"
        File.delete(f)
      end
    end
  end
end
