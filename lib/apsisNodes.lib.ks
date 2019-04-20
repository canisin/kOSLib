@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("bud").

FUNCTION CircularizeAtPeriNode {
  RETURN ChangeApoNode(PERIAPSIS).
}

FUNCTION CircularizeAtApoNode {
  RETURN ChangePeriNode(APOAPSIS).
}

FUNCTION ChangeApoNode {
  PARAMETER tApsis.
  RETURN ChangeApsisNode(FALSE, tApsis).
}

FUNCTION ChangePeriNode {
  PARAMETER tApsis.
  RETURN ChangeApsisNode(TRUE, tApsis).
}

LOCAL FUNCTION ChangeApsisNode {
  PARAMETER periOrApo, targApsis.

  LOCAL rBurn IS TERNOP(periOrApo, APOAPSIS, PERIAPSIS) + BODY:RADIUS.
  LOCAL rCurr IS TERNOP(periOrApo, PERIAPSIS, APOAPSIS) + BODY:RADIUS.
  LOCAL rTarg IS targApsis + BODY:RADIUS.
  LOCAL tBurn IS TIME + TERNOP(periOrApo, ETA:APOAPSIS, ETA:PERIAPSIS).

  LOCAL deltaV IS SQRT(BODY:MU * (2/rBurn - 2/(rBurn + rTarg)))
                - SQRT(BODY:MU * (2/rBurn - 2/(rBurn + rCurr))).
  RETURN NODE(tBurn:SECONDS, 0, 0, deltaV).
}