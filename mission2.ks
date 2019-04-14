@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

//plot a maneuver for a free return trajectory

//kerbin, has maneuver
//burn maneuver
//kerbin with mun encounter
//await soi change
//mun, periapsis not between 14-16km
//plot and burn a maneuver to set periapsis to 15km
//mun, periapsis between 14-16km and before periapsis
//await periapsis and activate experiments
//mun, after periapsis
//await soi change
//kerbin, no maneuver, no encounter
//plot and burn a maneuver to set periapsis to 25km, stage all, end program

REQUIRE("nodeExecution").
REQUIRE("maneuvering2").
REQUIRE("autoStage").

UNTIL FALSE {
  PRINT "BODY = " + BODY.
  IF BODY = MUN {
    PRINT "PERIAPSIS = " + PERIAPSIS.
    IF PERIAPSIS < 14000 OR PERIAPSIS > 16000
      AdjustPeriapsis(15000, TRUE).
    IF ETA:PERIAPSIS < 0
      DoScience().
  } ELSE {
    PRINT "HASNODE = " + HASNODE.
    PRINT "ENCOUNTER = " + ENCOUNTER.
    PRINT "PERIAPSIS = " + PERIAPSIS.
    PRINT "SHIP:Q = " + SHIP:Q.
    PRINT "SHIP:STATUS = " + SHIP:STATUS.
    IF HASNODE
      ExecuteNode().
    IF ENCOUNTER = "NONE" AND (PERIAPSIS < 27500 OR PERIAPSIS > 32500)
       AdjustPeriapsis(30000, TRUE).
    IF SHIP:Q > 0
      PrepReentry().
    IF SHIP:STATUS = "LANDED" OR SHIP:STATUS = "SPLASHED"
      BREAK.
  }

  WAIT 100.
}

LOCAL FUNCTION DoScience
{
  IF SHIP:PARTSTAGGED("science")[0]:GETMODULE(ScienceExperimentModule):HASDATA
    RETURN.

  PRINT "Runing science...".

  SHIP:PARTSTAGGED("bay1"):GETMODULE("USAnimateGeneric"):DoEvent("deploy primary bays").
  WAIT 5.
  SHIP:PARTSTAGGED("magneto"):GETMODULE("DMModuleScienceAnimate"):DEPLOY().
  WAIT 5.

  FOR experiment IN SHIP:PARTSTAGGED("science")
    experiment:GetModule("ScienceExperimentModule"):DEPLOY().
  WAIT 5.
  
  SHIP:PARTSTAGGED("magneto"):GETMODULE("DMModuleScienceAnimate"):TOGGLE().
  WAIT 5.
  SHIP:PARTSTAGGED("bay1"):GETMODULE("USAnimateGeneric"):DoEvent("retract primary bays").
  WAIT 5.

  PRINT "Science run complete.".
}

LOCAL FUNCTION PrepReentry
{
  PRINT "Preparing for reentry..".

  FOR antenna in SHIP:PARTSTAGGED("antenna")
    antenna:GETMODULE("ModuleDeployableAntenna").DoEvent("retract antenna").

  PRINT "Locking to normal for staging..".
  LOCK STEERING TO NORMAL.
  WAIT 2.
  STAGE_TO(0).
  WAIT 3.

  PRINT "Locking to retrograde..".
  LOCK STEERING TO SRFRETROGRADE.
}