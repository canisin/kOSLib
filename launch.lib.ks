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

  LOCAL _gui IS GUI(200).
  _gui:SHOW().

//  LOCAL qGui IS GUI(400).
//  qGui:SHOW().
//  LOCAL curQGui IS qGui:ADDLABEL("").
//  LOCAL maxQGui IS qGui:ADDLABEL("").
//  LOCK megaQ TO SHIP:Q * 1000_000.
//  LOCAL maxQ IS megaQ.
//  WHEN TRUE THEN {
//    SET curQGui:TEXT TO "Current dynamic pressure = " + ROUND(megaQ) + "(" + SHIP:Q + ")".
//    IF megaQ > maxQ SET maxQ TO megaQ.
//    SET maxQGui:TEXT TO "Max dynamic pressure = " + ROUND(maxQ).
//    PRESERVE.
//  }

  LOCK THROTTLE TO 1.0.
  LOCK STEERING TO HEADING(tHeading, 90).

  AUTOSTAGE_ON().

  _gui:ADDLABEL("Burning solid fuel stages and ascending to at least " + minPitchAltitude + " meters..").
  LOCAL _solidFuelGui IS _gui:ADDLABEL("").
  LOCAL _altGui IS _gui:ADDLABEL("").
  UNTIL SHIP:SOLIDFUEL <= solidfuelIgnore AND ALTITUDE >= minPitchAltitude {
    SET _solidFuelGui:TEXT TO "Remaining solid fuel = " + ROUND(SHIP:SOLIDFUEL).
    SET _altGui:TEXT TO "Current altitude = " + ROUND(ALTITUDE).
    WAIT 0.
  }

  _gui:ADDLABEL("Initiating pitch over to " + pitchOverTarget + " degrees with " + pitchOverLead + " degrees lead..").
  LOCAL _pitchGui IS _gui:ADDLABEL("").
  LOCK STEERING TO HEADING(tHeading, PITCH(SRFPROGRADE) - pitchOverLead).
  UNTIL PITCH(SRFPROGRADE) <= pitchOverTarget {
    SET _pitchGui:TEXT TO "Current pitch = " + ROUND(PITCH(SRFPROGRADE), 1).
    WAIT 0.
  }

  _gui:ADDLABEL("Following surface prograde until " + orbProgradeThreshold + " meters..").
  LOCAL _altGui2 IS _gui:ADDLABEL("").
  LOCK STEERING TO HEADING(tHeading, PITCH(SRFPROGRADE)).
  UNTIL ALTITUDE >= orbProgradeThreshold {
    SET _altGui2:TEXT TO "Current altitude = " + ROUND(ALTITUDE).
    WAIT 0.
  }

  _gui:ADDLABEL("Switching to orbital prograde and burnining for apoapsis..").
  LOCAL _apoGui IS _gui:ADDLABEL("").
  LOCK STEERING TO HEADING(tHeading, PITCH(PROGRADE)).
  UNTIL APOAPSIS > tApoapsis {
    SET _apoGui:TEXT TO "Current apoapsis = " + ROUND(APOAPSIS).
    WAIT 0.
  }

  _gui:ADDLABEL("Coasting to the edge of space..").
  LOCAL _altGui3 IS _gui:ADDLABEL("").
  UNLOCK THROTTLE.
  UNTIL ALTITUDE > BODY:ATM:HEIGHT {
    SET _altGui3:TEXT TO "Current altitude = " + ROUND(ALTITUDE).
    WAIT 0.
  }

  _gui:ADDLABEL("Reboosting apoapsis..").
  LOCAL _apoGui2 IS _gui:ADDLABEL("").
  LOCK THROTTLE TO SIGMOID(tApoapsis - APOAPSIS).
  UNTIL APOAPSIS >= tApoapsis {
    SET _apoGui2:TEXT TO "Current apoapsis = " + ROUND(APOAPSIS).
    WAIT 0.
  }

  WAIT 1.
  UNLOCK THROTTLE.
  UNLOCK STEERING.
  AUTOSTAGE_OFF().
  //_gui:ADDBUTTON("CLOSE"):ONCLICK({_gui:HIDE().}).

  IF circularizationStage <> -1
    STAGE_TO(circularizationStage).

  CreateCircularizationNodeAtApo().
  ExecuteNode().
}