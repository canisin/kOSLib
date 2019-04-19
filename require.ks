@LAZYGLOBAL OFF.

FUNCTION REQUIRE {
  PARAMETER lib.
  LOCAL path IS "lib/" + lib + ".lib.ks".

  IF NOT EXISTS(path)
    COPYPATH("0:/" + path, path).
  RUNONCEPATH(path).
}
