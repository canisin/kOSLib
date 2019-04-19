@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

FUNCTION CircularizeAtPeriNode {
  RETURN ChangeApoAtPeriNode(APOAPSIS).
}

FUNCTION CircularizeAtApoNode {
  RETURN ChangePeriAtApoNode(PERIAPSIS).
}

FUNCTION ChangeApoAtPeriNode {
  PARAMETER tApsis.
  RETURN ChangeApsisNode(PERIAPSIS, APOAPSIS, tApsis, ETA:PERIAPSIS).
}

FUNCTION ChangePeriAtApoNode {
  PARAMETER tApsis.
  RETURN ChangeApsisNode(APOAPSIS, PERIAPSIS, tApsis, ETA:APOAPSIS).
}

FUNCTION ChangeApsisNode {
  PARAMETER apsisBurn, apsisCurr, apsisTarg, t.

  SET apsisBurn TO apsisBurn + BODY:RADIUS.
  SET apsisBurn TO apsisCurr + BODY:RADIUS.
  SET apsisBurn TO apsisTarg + BODY:RADIUS.
  SET t TO TIME + t.

  LOCAL deltaV IS SQRT(BODY:MU * (2/apsisBurn - 2/(apsisBurn + apsisTarg)))
                - SQRT(BODY:MU * (2/apsisBurn - 2/(apsisBurn + apsisCurr))).
  RETURN NODE(t:SECONDS, 0, 0, deltaV).
}
