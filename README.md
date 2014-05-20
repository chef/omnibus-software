# Omnibus Software

This repository contains shared software descriptions, for use by any [Omnibus](https://github.com/opscode/omnibus-ruby) project that needs them.

This project is managed by the CHEF Release Engineering team. For more information on the Release Engineering team's contribution, triage, and release process, please consult the [CHEF Release Engineering OSS Management Guide](https://docs.google.com/a/opscode.com/document/d/1oJB0vZb_3bl7_ZU2YMDBkMFdL-EWplW1BJv_FXTUOzg/edit).

# Using Your Own Software Definitions

These are Opscode's software definitions.  We like that others get utility out of them, but they
are not meant to be comprehensive of all software on the planet.  We won't, for example, support building
every version of ruby ever released.  You have at least three choices for writing your own
software definitions.

## Software Definitions in your Project

If you only have one project you can fork or add software definitions directly into the `config/software`
directory of your project.  The chef client build [uses this approach](https://github.com/opscode/omnibus-chef/tree/master/config/software).

## Fork omnibus-software

You can make a fork of omnibus-software (or use a repo named omnibus-software) and update the Gemfile in
your project to point at your git repo instead of opscode's.

## Use a gem other than omnibus-software

You can use the `software_gem` config option in omnibus.rb in the root of your project to point at a differently
named gem.  If you wanted to release 'your' omnibus-software gem to rubygems.org or something you could use this
feature to avoid a name collision there.

## Licensing

See the LICENSE file for details.

Copyright: Copyright (c) 2012-2014 Chef Software, Inc.
License: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


