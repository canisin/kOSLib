@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("bud").

FUNCTION AdjustApoapsis {
  //todo check next apsis

  PARAMETER tApoapsis.
  PARAMETER useRadialThrust IS FALSE.
  RETURN AdjustApsis(TRUE, tApoapsis, useRadialThrust).
}

FUNCTION AdjustPeriapsis {
  //todo check next apsis

  PARAMETER tPeriapsis.
  PARAMETER useRadialThrust IS FALSE.
  RETURN AdjustApsis(FALSE, tPeriapsis, useRadialThrust).
}

LOCAL FUNCTION AdjustApsis {
  IF AVAILABLETHRUST = 0 {
    PRINT "No thrust available. Apsis adjustment aborted.".
    RETURN FALSE.
  }

  PARAMETER isApoOrPeri.
  LOCAL LOCK apsis TO TERNOP(isApoOrPeri, APOAPSIS, PERIAPSIS).
  PARAMETER tApsis.
  PARAMETER useRadialThrust IS FALSE.
  LOCAL isBoost IS tApsis > apsis.

  PARAMETER steeringMargin IS 1.
  PARAMETER steeringTimeout IS 20.

  PRINT TERNOP(isBoost, "Boosting", "Lowering") + " " + TERNOP(isApoOrPeri, "apoapsis", "periapsis") + "..".

  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

  PRINT "Turning..".
  LOCK STEERING TO TERNOP(useRadialThrust,
    TERNOP(isBoost, ANTIRADIAL(), RADIAL()),
    TERNOP(isBoost, PROGRADE, RETROGRADE)).

  LOCAL abortTime IS TIME + steeringTimeout.
  WAIT UNTIL VANG(FACING:VECTOR, STEERING:VECTOR) <= steeringMargin OR TIME > abortTime.

  IF TIME > abortTime {
    PRINT "Failed to maneuver to correct direction. Apsis adjustment aborted.".
    RETURN FALSE.
  }

  PRINT "Burning..".
  LOCAL LOCK burnNode TO NODE(0, TERNOP(useRadial, AVAILACC(), 0), 0, TERNOP(useRadial, 0, AVAILACC())).
  LOCAL LOCK apsisDiff TO TERNOP(isBoost, tApsis - apsis, apsis - tApsis).
  LOCAL LOCK apsisAcc TO ABS(TERNOP(isApoOrPeri, burnNode:ORBIT:APOAPSIS, burnNode:ORBIT:PERIAPSIS) - apsis).
  LOCK THROTTLE TO SIGMOID(apsisDiff, 2*apsisAcc).

  WAIT UNTIL 
    apsisDiff <= 0
    OR AVAILABLETHRUST = 0.

  UNLOCK THROTTLE.
  UNLOCK STEERING.

  IF AVAILABLETHRUST = 0 {
    PRINT "Ran out of thrust. Apsis adjustment aborted.".
    RETURN FALSE.
  }

  PRINT "Apsis adjustment complete.".
  RETURN TRUE.
}