# Npgsql.nsi
NSIS script for Npgsql-2.2.5.0-net45 has been removed command prompt popup windows during installation

# Based on Seput_Npgsql.nsi
* Refer to https://gist.github.com/kenjiuno/7985982
* Replace ExecWait to nsExec::Exec
* Comment .Net framework 2.0 related

# Prepare install files
* Download Setup_Npgsql-2.2.5.0-net45.exe from https://github.com/npgsql/npgsql/releases
* Unzip excludes $PLUGINDIR
* Place nsi file in unziped folder
* After compile, run installer with /S options
