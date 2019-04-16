@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

FUNCTION CircularizationNode {
  PARAMETER t.

  LOCAL pred IS ORBITAT(SHIP, t).
  LOCAL vel IS pred:VELOCITY:ORBIT. 
  LOCAL pos IS pred:POSITION - BODY:POSITION.

//  LOCAL bodyShift IS POSITIONAT(pred:BODY, t) - BODY:POSITION.
//  SET vel TO vel - bodyShift.
//  SET pos TO pos - bodyShift.

  LOCAL circVel IS VXCL(pos, vel):NORMALIZED
    * SQRT(pred:BODY:MU / pos:MAG).
  LOCAL deltaV IS circVel - vel.

//  LOCAL prograde IS VDOT(deltaV, vel:NORMALIZED)*vel:NORMALIZED.
//  LOCAL radial IS deltaV - prograde.
//  RETURN NODE(t, radial:MAG, 0, prograde:MAG).

  RETURN NodeFromDeltaV(deltaV, t).
}

FUNCTION NodeFromDeltaV {
  PARAMETER deltaV, t.

  LOCAL pred IS ORBITAT(SHIP, t).
  LOCAL vel IS pred:VELOCITY:ORBIT. 
  LOCAL pos IS pred:POSITION - BODY:POSITION.

//  LOCAL bodyShift IS POSITIONAT(pred:BODY, t) - BODY:POSITION.
//  SET vel TO vel - bodyShift.
//  SET pos TO pos - bodyShift.

  LOCAL prograde IS vel:NORMALIZED.
  LOCAL normal IS VCRS(vel, pos):NORMALIZED.
  LOCAL radial IS VCRS(prograde, normal).

  RETURN NODE(t:SECONDS, -VDOT(deltaV, radial),
                         VDOT(deltaV, normal),
                         VDOT(deltaV, prograde)).
}

FUNCTION NodeFromTargetVel {
  PARAMETER vel, t.
  RETURN NodeFromDeltaV(vel - VELOCITYAT(SHIP, t):ORBIT, t).
}
