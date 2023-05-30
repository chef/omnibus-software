name "tar"
default_version "1.28"

### This is used because centos 5 bundles a too old version of tar that doesn't support xz archives
### It won't be bundled in the omnibus project

source  url: "http://ftp.gnu.org/gnu/tar/tar-#{version}.tar.gz",
        sha256: "6a6b65bac00a127a508533c604d5bf1a3d40f82707d56f20cefd38a05e8237de"

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
