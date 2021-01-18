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

require "pathname" unless defined?(Pathname)
require "omnibus"
require "highline"

module OmnibusSoftware
  class << self
    #
    # The root where Omnibus Software lives.
    #
    # @return [Pathname]
    #
    def root
      @root ||= Pathname.new(File.expand_path("..", __dir__))
    end

    #
    # Verify the given software definitions, iterating over each software and
    # loading it. This is probably the most primitive test ever - just load the
    # DSL files - but it is the best thing we have for CI in omnibus-software.
    #
    # @return [void]
    #
    def verify!
      for_each_software do |_software|
        $stdout.print "."
      end
    end

    def fetch(name, path)
      fetch_software(load_software(name), path)
    end

    def fetch_all(path)
      for_each_software do |software|
        # only fetch net_fetcher sources for now
        next if software.source.nil? || software.source[:url].nil?

        fetch_software(software, path)
      end
    end

    def fetch_software(software, path)
      Omnibus::Config.cache_dir File.expand_path(path)
      Omnibus::Config.use_s3_caching false
      Omnibus.logger.level = :debug
      puts "Fetching #{software.name}"
      software.fetcher.fetch
    end

    def list
      Omnibus.logger.level = :fatal
      h = HighLine.new
      for_output = ["Name", "Default Version", "Source"]
      for_each_software do |software|
        for_output += [software.name, software.default_version, maybe_source(software.source)]
      end
      puts h.list(for_output, :uneven_columns_across, 3)
    end

    private

    def maybe_source(source)
      if source
        if source[:git]
          "GIT #{source[:git]}"
        elsif source[:url]
          "NET #{source[:url]}"
        else
          "OTHER"
        end
      else
        "NONE"
      end
    end

    def fake_project
      @fake_project ||= Omnibus::Project.new.evaluate do
        name "project.sample"
        install_dir "tmp/project.sample"
      end
    end

    def software_dir
      OmnibusSoftware.root.join("config/software")
    end

    def load_software(software_name)
      Omnibus::Config.local_software_dirs(OmnibusSoftware.root)
      Omnibus::Software.load(fake_project, software_name, nil)
    end

    def for_each_software
      Dir.glob("#{software_dir}/*.rb").each do |filepath|
        name = File.basename(filepath, ".rb")
        yield load_software(name)
      end
    end
  end
end
