name 'pywin32'
default_version '219'


dependency "python"
dependency "pip"

build do
    relative_path "pywin32-#{version}"
    # Switch on the architecture
    pip "install pypiwin32==#{version} "\
        "--prefix=#{windows_safe_path(install_dir)}/embedded"
    # pywintypes is patched, it doesn't work on Python > 2.7 otherwise
    # Since we don't install it from source, we can't use the patch option of omnibus
    # Here is a manual patch, using the same options as omnibus
    patch_path = File.realpath(
      File.join(
        File.dirname(__FILE__), '..',
        'patches', 'pywin32', 'fix_pywintypes_dll_import.patch'
      )
    )
    win32_path = File.join(install_dir, 'embedded', 'Lib', 'site-packages', 'win32')
    command "patch -d \"#{win32_path}\" -p1 -i \"#{patch_path}\""
end
