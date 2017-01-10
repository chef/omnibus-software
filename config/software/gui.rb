# This is a fake software gathering all depencies needed for the agent GUI
name "gui"
default_version "5.3.0"

dependency "guidata"
dependency "spyderlib"
if ohai["platform_family"] == "mac_os_x"
  dependency "py2app"
end
