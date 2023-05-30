#
# Microsoft Visual C++ Compiler for Python
# Required by PyCrypto
#
# This one is actually stored in an S3 bucket of ours because downloading it
# from the microsoft website is extremely slow (around 45 minutes)
#
# Here"s the original download URL:
# http://www.microsoft.com/en-us/download/details.aspx?id=44266
#

name "vc_python"
default_version "2.7"

source url: "https://s3.amazonaws.com/dd-agent-omnibus/vc_for_python_27.msi",
       sha256: "070474db76a2e625513a5835df4595df9324d820f9cc97eab2a596dcbc2f5cbf"

build do
  command "start /wait msiexec /x vc_for_python_27.msi /qn"
  command "start /wait msiexec /i vc_for_python_27.msi /qn"
end
