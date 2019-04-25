@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("bud").
REQUIRE("autoStage").
REQUIRE("apsisAdjustment").
REQUIRE("apsisNodes").
REQUIRE("nodeExecution").

GLOBAL _launchParams IS LEXICON().

SET _launchParams["heading"] TO 90.
SET _launchParams["apoapsis"] TO 100_000.

SET _launchParams["circularizationStage"] IS -1.

SET _launchParams["firstPitchAlt"] TO 500.
SET _launchParams["firstPitchValue"] TO 85.
SET _launchParams["firstPitchLead"] TO 5.

SET _launchParams["secondPitchAlt"] TO 0.
SET _launchParams["secondPitchValue"] TO 0.
SET _launchParams["secondPitchLead"] TO 0.

SET _launchParams["orbitalProgradeAlt"] TO 30_000.
SET _launchParams["boosterDropMargin"] TO 100.
SET _launchParams["apoapsisPush"] TO 30.

LOCAL LOCK _heading TO _launchParams["heading"].

FUNCTION Launch {
  InitiateLaunch().
  PitchOverOne().
  PitchOverTwo().
  BoostApoapsis().
  CoastToSpace().
  ReboostApoapsis().
  AlmostCircularize().
  DropBoosters().
  Circularize().
}

LOCAL FUNCTION InitiateLaunch {
  PRINT "Counting down to launch..".
  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

  LOCK THROTTLE TO 1.0.
  LOCK STEERING TO HEADING(_heading, 90).

  AUTOSTAGE_ON().
}

LOCAL FUNCTION PitchOverOne {
  PitchOverImpl(_launchParams["firstPitchAlt"],
                _launchParams["firstPitchValue"],
                _launchParams["firstPitchLead"]).
}

LOCAL FUNCTION PitchOverTwo {
  PitchOverImpl(_launchParams["secondPitchAlt"],
                _launchParams["secondPitchValue"],
                _launchParams["secondPitchLead"]).
}

LOCAL FUNCTION PitchOverImpl {
  PARAMETER tAltitude, tPitch, lead.
  LOCAL LOCK cPitch TO VPITCH(TERNOP(
    ALTITUDE < _launchParams["orbitalProgradeAlt"],
    SRFPROGRADE, PROGRADE)).

  IF tAltitude = 0 RETURN.

  PRINT "Ascending to " + tAltitude + " meters..".
  WAIT UNTIL ALTITUDE >= tAltitude.

  PRINT "Initiating pitch over to " + tPitch + " degrees with " + lead + " degrees lead..".
  LOCK STEERING TO HEADING(_heading, cPitch - lead*SIGMOID(cPitch - tPitch, lead)).
  WAIT UNTIL cPitch <= tPitch.

  PRINT "Pitch over complete.".
  LOCK STEERING TO HEADING(_heading, cPitch).
}

LOCAL FUNCTION BoostApoapsis {
  LOCAL tApoapsis IS _launchParams["apoapsis"].
  LOCAL orbitalPrograde IS _launchParams["orbitalProgradeAlt"].

  PRINT "Ascending to orbital prograde switch altitude of " + orbitalPrograde + " meters..".
  WAIT UNTIL ALTITUDE >= orbitalPrograde.

  IF APOAPSIS >= tApoapsis RETURN.

  PRINT "Awaiting target apoapsis of " + tApoapsis + " meters..".
  AdjustApoapsis(tApoapsis).
  LOCK STEERING TO PROGRADE.
}

LOCAL FUNCTION CoastToSpace {
  PRINT "Coasting to the edge of space..".
  WAIT UNTIL ALTITUDE > BODY:ATM:HEIGHT.
  UNLOCK STEERING.
}

LOCAL FUNCTION ReboostApoapsis {
  LOCAL tApoapsis IS _launchParams["apoapsis"].
  IF APOAPSIS >= tApoapsis RETURN.

  PRINT "Reboosting apoapsis..".
  AdjustApoapsis(tApoapsis).
}

LOCAL FUNCTION AlmostCircularize {
  LOCAL boosterDropMargin IS _launchParams["boosterDropMargin"].

  ADD CircularizeAtApoNode().
  IF NEXTNODE:DELTAV:MAG <= boosterDropMargin {
    REMOVE NEXTNODE.
    RETURN.
  }

  PRINT "Executing circularization burn..".
  SET NEXTNODE:PROGRADE TO NEXTNODE:PROGRADE - boosterDropMargin.
  ExecuteNode().

  PushOutApo().
  ReboostApoapsis().
}

LOCAL FUNCTION PushOutApo {
  LOCAL apoapsisPush TO _launchParams["apoapsisPush"].

  PRINT "Pushing out apoapsis..".
  LOCK STEERING TO ANTIRADIAL().
  WAITSTEERING(5).
  LOCK THROTTLE TO 1.
  WAIT UNTIL ETAAPOAPSIS_CLAMPED() >= apoapsisPush.
  UNLOCK THROTTLE.
  UNLOCK STEERING.
}

LOCAL FUNCTION DropBoosters {
  LOCAL circularizationStage IS _launchParams["circularizationStage"].

  AUTOSTAGE_OFF().

  IF circularizationStage = -1 RETURN.

  PRINT "Dropping boosters..".
  STAGE_TO(circularizationStage).
}

LOCAL FUNCTION Circularize {
  PRINT "Finalizing orbit..".
  ADD CircularizeAtApoNode().
  ExecuteNode().
}