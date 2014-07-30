#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
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

require 'pathname'

module OmnibusSoftware
  VERSION = '3.0.0'

  class << self
    #
    # The root where Omnibus Software lives.
    #
    # @return [Pathname]
    #
    def root
      @root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end

    #
    # Verify the given software definitions, iterating over each software and
    # loading it. This is probably the most primitive test ever - just load the
    # DSL files - but it is the best thing we have for CI in omnibus-software.
    #
    # @return [void]
    #
    def verify!
      require 'omnibus'
      Omnibus::Config.local_software_dirs(OmnibusSoftware.root)

      project = Omnibus::Project.new.evaluate do
        name 'project.sample'
        install_dir 'tmp/project.sample'
      end

      root = OmnibusSoftware.root.join('config/software')
      Dir.glob("#{root}/*.rb").each do |filepath|
        Omnibus::Software.load(project, filepath)
        $stdout.print '.'
      end
    end
  end
end
