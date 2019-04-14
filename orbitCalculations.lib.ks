@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

FUNCTION CalculateECC {
  LOCAL position IS -BODY:POSITION.
  LOCAL velocity IS VELOCITY:ORBIT.
  RETURN (VCRS(velocity, VCRS(position, velocity))/BODY:MU - position:NORMALIZED):MAG.
}

FUNCTION CalculateSMA {
  LOCAL position IS BODY:POSITION:MAG.
  LOCAL velocity IS VELOCITY:ORBIT:MAG.
  RETURN 1/(2/position - velocity*velocity/BODY:MU).
}

FUNCTION CalculatePeriapsis {
  RETURN CalculateSMA()*(1 - CalculateECC()).
}

FUNCTION CalculateApoapsis {
  RETURN CalculateSMA()*(1 + CalculateECC()).
}