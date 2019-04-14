@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("bud").

FUNCTION AdjustApoapsis {
  //todo check next apsis

  PARAMETER tApoapsis.
  PARAMETER useRadialThrust IS FALSE.
  RETURN AdjustApsis({RETURN APOAPSIS.}, tApoapsis, useRadialThrust).
}

FUNCTION AdjustPeriapsis {
  //todo check next apsis

  PARAMETER tPeriapsis.
  PARAMETER useRadialThrust IS FALSE.
  RETURN AdjustApsis({RETURN PERIAPSIS.}, tPeriapsis, useRadialThrust).
}

LOCAL FUNCTION AdjustApsis {
  IF AVAILABLETHRUST = 0 {
    PRINT "No thrust available. Apsis adjustment aborted.".
    RETURN FALSE.
  }

  PARAMETER apsis.
  PARAMETER tApsis.
  PARAMETER useRadialThrust IS FALSE.

  PARAMETER steeringMargin IS 1.
  PARAMETER steeringTimeout IS 20.

  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

  IF tApsis >= apsis() {
    PRINT "Boosting apsis..".
    LOCK apsisDiff TO tApsis - apsis().
    IF useRadialThrust LOCK STEERING TO ANTIRADIAL().
    ELSE LOCK STEERING TO PROGRADE.
  } ELSE {
  PRINT "Lowering apsis..".
    LOCK apsisDiff TO apsis() - tApsis.
    IF useRadialThrust LOCK STEERING TO RADIAL().
    ELSE LOCK STEERING TO RETROGRADE.
  }

  PRINT "Turning..".
  LOCAL abortTime IS TIME + steeringTimeout.
  WAIT UNTIL VANG(FACING:VECTOR, STEERING:VECTOR) <= steeringMargin OR TIME > abortTime.

  IF TIME > abortTime {
    PRINT "Failed to maneuver to correct direction. Apsis adjustment aborted.".
    RETURN FALSE.
  }

  PRINT "Burning..".
  LOCAL apsisDiffK IS apsisDiff/10.
  LOCK THROTTLE TO SIGMOID(apsisDiff, apsisDiffK).
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