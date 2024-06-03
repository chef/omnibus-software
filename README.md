# Omnibus Software

[![Build Status](https://badge.buildkite.com/e07e55eb2f281ec50dbd0f2bdbf8da4a2f246b864bffd17dfb.svg)](https://buildkite.com/chef-oss/chef-omnibus-software-main-verify)

**Umbrella Project**: [Chef Foundation](https://github.com/chef/chef-oss-practices/blob/main/projects/chef-foundation.md)

**Project State**: [Active](https://github.com/chef/chef-oss-practices/blob/main/repo-management/repo-states.md#active)

**Issues [Response Time Maximum](https://github.com/chef/chef-oss-practices/blob/main/repo-management/repo-states.md)**: 14 days

**Pull Request [Response Time Maximum](https://github.com/chef/chef-oss-practices/blob/main/repo-management/repo-states.md)**: 14 days


This repository contains shared software descriptions, for use by any [Omnibus](https://github.com/chef/omnibus) project that needs them.

This project is managed by the CHEF Release Engineering team. For more information on the Release Engineering team's contribution, triage, and release process, please consult the [CHEF Release Engineering OSS Management Guide](https://docs.google.com/a/opscode.com/document/d/1oJB0vZb_3bl7_ZU2YMDBkMFdL-EWplW1BJv_FXTUOzg/edit).

**The main branch of this project corresponds to the main branch of omnibus!**

## Using Your Own Software Definitions

This repository is the collection of Chef Software's software definitions. We like that others get utility out of them, but they are not meant to be comprehensive collection of all software on the planet. For more information, please read [Omnibus, a look forward](https://blog.chef.io/omnibus-a-look-forward) on the Chef blog.

For more information on writing your own software definitions, please see [the Omnibus README](https://github.com/chef/omnibus#sharing-software-definitions).

## Versioning

This repository is versioned and tagged using the `YY.MM.BUILD` to allow folks to be able to access the state of the software definition at a specific point in time. We do however encourage folks to pull in the latest whenever possible.

## Contributing

For information on contributing to this project please see our [Contributing Documentation](https://github.com/chef/chef/blob/main/CONTRIBUTING.md)

### Run Linux Tests in Docker

Run `.expeditor/run_linux_tests.sh rake` in the ruby image of your choice.

```
docker run -it --rm -v $PWD:/src -w /src ruby:2.7-buster .expeditor/run_linux_tests.sh rake
```

### Testing On Ubuntu 18.04 via Docker

#### Interactive Testing

If you want to enter an interactive shell in a dockerized omnibus build environment on Ubuntu 18.04 you can run the following command.

```
docker-compose run --rm -e SOFTWARE=<SOFTWARE> -e VERSION=<VERSION> builder

# Example
docker-compose run --rm -e SOFTWARE=go -e VERSION=1.17.6 builder
```

Now you should be in a shell in the container ready to explore, modify or build. The omnibus-software repository will be mounted inside the container which makes it easy to edit code with your editor and test it in the container.

You can start the build by running the following command in your shell.

```
bundle exec omnibus build test
```

Omnibus git caching is enabled for the build so you can rerun the build command and it will use the cache for any software that was already successfully built. This can save a lot of time when troubleshooting software that has dependencies on other software that builds fine.

The following command will clean the omnibus project and purge the packages and caches.

```
bundle exec omnibus clean test --purge
```

The container will automatically be destroyed when you exit it without requiring any further cleanup.

#### Non-Interactive Testing

If you only want to run a build without an interactive shell you can set the `CI` environment variable as you see in the following command.

```
docker-compose run --rm -e SOFTWARE=<SOFTWARE> -e VERSION=<VERSION> -e CI=true builder
```

The container will automatically be destroyed when you exit it without requiring any further cleanup.

## License & Copyright

- Copyright:: Copyright (c) 2012-2021 Chef Software, Inc.
- License:: Apache License, Version 2.0

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License..
```
