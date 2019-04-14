@LAZYGLOBAL OFF.

WAIT 5.
IF HOMECONNECTION:ISCONNECTED {
  IF NOT EXISTS("require.ks")
    COPYPATH("0:/require.ks", ".").
  IF NOT EXISTS("acquire.ks")
    COPYPATH("0:/acquire.ks", ".").
}

CORE:DOEVENT("Open Terminal").