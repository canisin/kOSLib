@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

FUNCTION CreateCircularizationNodeAtApo {
  LOCAL targetVelocity IS SQRT(BODY:MU / (APOAPSIS + BODY:RADIUS)).
  LOCAL apoapsisVelocity IS VELOCITYAT(SHIP, TIME + ETA:APOAPSIS):ORBIT:MAG.
  ADD NODE(TIME:SECONDS + ETA:APOAPSIS, 0, 0, targetVelocity - apoapsisVelocity).
}

//FUNCTION CreateCircularizationNode {
//  PARAMETER radius.
//
//}