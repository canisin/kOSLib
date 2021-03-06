@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

FUNCTION VPITCH {
  PARAMETER v.

  RETURN 90 - VANG(UP:VECTOR, GETVEC(v)).
}

FUNCTION VHEADING {
  PARAMETER v.

  SET v TO VXCL(UP:VECTOR, GETVEC(v)).
  LOCAL angleN IS VANG(NORTH:VECTOR, v).
  LOCAL angleE IS VANG(VCRS(UP:VECTOR, NORTH:VECTOR), v).
  RETURN MOD(TERNOP(angleE < 90, angleN, 360-angleN), 360).
}

FUNCTION ISP {
  LOCAL _isp IS 0.
  LOCAL _fuelFlow IS 0.

  LOCAL _engines IS LIST().
  LIST ENGINES IN _engines.

  FOR engine IN _engines {
    IF engine:AVAILABLETHRUST > 0 {
      SET _isp TO _isp + engine:AVAILABLETHRUST.
      SET _fuelFlow TO _fuelFlow + engine:AVAILABLETHRUST / engine:ISP.
    }
  }

  IF _fuelFlow = 0 RETURN 0.
  RETURN _isp / _fuelFlow.
}

FUNCTION SIGMOID {
  PARAMETER x.
  PARAMETER k IS 1.

  IF x <= -k RETURN -1.
  IF x >= k RETURN 1.
  IF x <= k/20 AND x > 0 RETURN .05.
  IF x >= -k/20 AND x < 0 RETURN -.05.
  RETURN x / k.
//  LOCAL eX IS CONSTANT:E^(4*x).
//  RETURN (eX - 1) / (eX + 1).
}

FUNCTION NORMAL {
  RETURN VCRS(PROGRADE:VECTOR, UP:VECTOR):DIRECTION.
}

FUNCTION ANTINORMAL {
  RETURN VCRS(UP:VECTOR, PROGRADE:VECTOR):DIRECTION.
}

FUNCTION RADIAL {
  RETURN VCRS(PROGRADE:VECTOR, NORMAL:VECTOR):DIRECTION.
}

FUNCTION ANTIRADIAL {
  RETURN VCRS(NORMAL:VECTOR, PROGRADE:VECTOR):DIRECTION.
}

FUNCTION TERNOP {
  PARAMETER b, t, f.
  IF b RETURN t.
  ELSE RETURN f.
}

FUNCTION AVAILACC {
  RETURN AVAILABLETHRUST / MASS.
}

FUNCTION GETVEC {
  PARAMETER p.
  IF p:ISTYPE("VECTOR") RETURN p.
  ELSE RETURN p:VECTOR.
}

FUNCTION GETDIR {
  PARAMETER p.
  IF p:ISTYPE("DIRECTION") RETURN p.
  ELSE p:DIRECTION.
}

FUNCTION ETAAPOAPSIS_CLAMPED {
// todo check behavior on escape
  RETURN TERNOP(
    ETA:APOAPSIS > ORBIT:PERIOD / 2, 
    ETA:APOAPSIS - ORBIT:PERIOD, 
    ETA:APOAPSIS).
}

FUNCTION ETAPERIAPSIS_CLAMPED {
// todo check behavior on escape
  RETURN TERNOP(
    ETA:PERIAPSIS > ORBIT:PERIOD / 2, 
    ETA:PERIAPSIS - ORBIT:PERIOD, 
    ETA:PERIAPSIS).
}