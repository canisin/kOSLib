@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

GLOBAL _rtControlToggle IS FALSE.
GLOBAL _onControlR IS {RETURN.}.
GLOBAL _onControlT IS {RETURN.}.

ON RCS {
  IF NOT(_rtControlToggle AND RCS) RETURN TRUE.
  RCS OFF.
  _onControlR().
  RETURN TRUE.
}

ON SAS {
  IF NOT(_rtControlToggle AND SAS) RETURN TRUE.
  SAS OFF.
  _onControlT().
  RETURN TRUE.
}