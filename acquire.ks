@LAZYGLOBAL OFF.

PARAMETER script.
LOCAL path IS script + ".ks".

IF NOT EXISTS(path)
  COPYPATH("0:/" + path, ".").