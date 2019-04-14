@LAZYGLOBAL OFF.

FUNCTION REQUIRE {
  PARAMETER lib.
  LOCAL path IS lib + ".lib.ks".

  IF NOT EXISTS(path)
    COPYPATH("0:/" + path, ".").
  RUNONCEPATH(path).
}
