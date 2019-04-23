@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

GLOBAL _debugSteeringToggle IS FALSE.
GLOBAL _debugSteeringDraw IS VECDRAW().
SET _debugSteeringDraw:COLOR TO RED.
SET _debugSteeringDraw:SCALE TO 10.
SET _debugSteeringDraw:WIDTH TO .1.

WHEN TRUE THEN {
  IF _debugSteeringToggle AND STEERINGMANAGER:ENABLED {
    SET _debugSteeringDraw:VEC TO STEERINGMANAGER:TARGET:VECTOR.
    _debugSteeringDraw:SHOW ON.
  } ELSE
    _debugSteeringDraw:SHOW OFF.
  RETURN TRUE.
}