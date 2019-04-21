@LAZYGLOBAL OFF.

PARAMETER script.
LOCAL path IS script + ".ks".

IF EXISTS("0:/" + path)
  COPYPATH("0:/" + path, ".").
ELSE IF EXISTS("0:/missions/" + path)
  COPYPATH("0:/missions/" + path, ".").
ELSE
  PRINT "Program not found.".