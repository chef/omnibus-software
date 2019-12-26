name "tar"
default_version "1.28"

### This is used because centos 5 bundles a too old version of tar that doesn't support xz archives
### It won't be bundled in the omnibus project

source  url: "http://ftp.gnu.org/gnu/tar/tar-#{version}.tar.gz",
        md5: "6ea3dbea1f2b0409b234048e021a9fd7"

relative_path "#{name}-#{version}"
build do
  if ohai["platform_family"] == "rhel"
    delete "/bin/gtar /bin/tar"
    command "FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/"
    command "make -j #{workers}"
    command "make install"
    # Omnibus 4 uses gtar instead of tar so let's make a proper symlink
    link "/bin/tar", "/bin/gtar"
  end
end
