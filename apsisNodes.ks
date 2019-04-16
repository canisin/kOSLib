@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

FUNCTION CircularizationNodeApo {
  RETURN ChangeApsisNodeApo(APOAPSIS).
}

FUNCTION CircularizationNodePeri {
  RETURN ChangeApsisNodePeri(PERIAPSIS).
}

FUNCTION ChangeApsisNodeApo {
  PARAMETER tApsis.
  RETURN ChangeApsisNode(PERIAPSIS, APOAPSIS, tApsis, ETA:PERIAPSIS).
}

FUNCTION ChangeApsisNodePeri {
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
