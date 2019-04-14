@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("bud").
REQUIRE("maneuvering").
REQUIRE("nodeExecution").
REQUIRE("autoStage").

FUNCTION Launch {
  PARAMETER tHeading.
  PARAMETER tApoapsis.

  PARAMETER circularizationStage IS -1.

  PARAMETER solidfuelIgnore IS 0.
  PARAMETER minPitchAltitude IS 500.
  PARAMETER pitchOverLead IS 5.
  PARAMETER pitchOverTarget IS 85.
  PARAMETER orbProgradeThreshold IS 30000.

  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

  LOCK THROTTLE TO 1.0.
  LOCK STEERING TO HEADING(tHeading, 90).

  AUTOSTAGE_ON().

  PRINT "Burning solid fuel stages and ascending to at least " + minPitchAltitude + " meters..".
  WAIT UNTIL SHIP:SOLIDFUEL <= solidfuelIgnore AND ALTITUDE >= minPitchAltitude.

  PRINT "Initiating pitch over to " + pitchOverTarget + " degrees with " + pitchOverLead + " degrees lead..".
  LOCK STEERING TO HEADING(tHeading, PITCH(SRFPROGRADE) - pitchOverLead).
  WAIT UNTIL PITCH(SRFPROGRADE) <= pitchOverTarget.

  PRINT "Following surface prograde until " + orbProgradeThreshold + " meters..".
  LOCK STEERING TO HEADING(tHeading, PITCH(SRFPROGRADE)).
  WAIT UNTIL ALTITUDE >= orbProgradeThreshold.

  PRINT "Switching to orbital prograde and burnining for apoapsis..".
  LOCK STEERING TO HEADING(tHeading, PITCH(PROGRADE)).
  WAIT UNTIL APOAPSIS > tApoapsis.

  PRINT "Coasting to the edge of space..".
  UNLOCK THROTTLE.
  WAIT UNTIL ALTITUDE > BODY:ATM:HEIGHT.

  PRINT "Reboosting apoapsis..".
  LOCK THROTTLE TO SIGMOID(tApoapsis - APOAPSIS).
  WAIT UNTIL APOAPSIS >= tApoapsis.

  WAIT 1.
  UNLOCK THROTTLE.
  UNLOCK STEERING.
  AUTOSTAGE_OFF().

  IF circularizationStage <> -1
    STAGE_TO(circularizationStage).

  CreateCircularizationNodeAtApo().
  ExecuteNode().
}