#githubvisible=true

# Clear PYTHONPATH and PYTHONHOME
set env(PYTHONPATH) ""
set env(PYTHONHOME) ""

# Execute the Python script
# This TCL script runs from inside the Vivado impl_1 directory, so we point
# --config back up to the target folder's nihdlsettings.py.
exec nihdl gen-lvbitx --config=../../../nihdlsettings.py