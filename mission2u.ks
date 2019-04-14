@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

//start running the mission after manually plotting a mun encounter

//stage0: execute maneuver
//stage1: await mun encunter
//stage2: adjust munar periapsis
//stage3: await munar periapsis
//stage4: do science
//stage5: await munar escape
//stage6: adjust kerbin periapsis
//stage7: await kerbin atmosphere
//stage8: prep reentry

REQUIRE("missions").
//REQUIRE("nodeExecution").
REQUIRE("maneuvering2").
REQUIRE("autoStage").
REQUIRE("bud").

PRINT "BODY = " + BODY.
PRINT "ENCOUNTER = " + ENCOUNTER.
PRINT "STATUS = " + STATUS.

LOCAL stage IS GetMissionStage().
PRINT "Mission stage " + stage.

IF stage = 0 {
  OverwriteBootFile(SCRIPTPATH()).
  CompleteStage().
} ELSE IF stage = 1 {
  PRINT "Executing node..".
//  IF ExecuteNode()
    CompleteStage().
} ELSE IF stage = 2 {
  PRINT "Awaiting mun encounter..".
  IF BODY = MUN
    CompleteStage().
  ELSE WAIT 100.
} ELSE IF stage = 3 {
  PRINT "Adjusting munar periapsis..".
  IF AdjustPeriapsis(15000, TRUE)
    CompleteStage().
} ELSE IF stage = 4 {
  PRINT "Awaiting munar periapsis..".
  IF ETA:PERIAPSIS <= 0
    CompleteStage().
  ELSE WAIT 100.
} ELSE IF stage = 5 {
  PRINT "Conducting experiments..".
  DoScience().
  CompleteStage().
} ELSE IF stage = 6 {
  PRINT "Awaiting munar escape..".
  IF BODY <> MUN
    CompleteStage().
  ELSE WAIT 100.
} ELSE IF stage = 7 {
  PRINT "Adjusting reentry depth..".
  IF AdjustPeriapsis(30000, TRUE)
    CompleteStage().
} ELSE IF stage = 8 {
  PRINT "Awaiting reentry..".
  IF ALTITUDE <= 250000
    CompleteStage().
  ELSE WAIT 100.
} ELSE IF stage = 9 {
  IF ALTITUDE <= 90000
    CompleteStage().
  ELSE WAIT 5.
} ELSE IF stage = 10 {
  PRINT "Preparing for reentry..".
  PrepReentry().
  CompleteStage().
} ELSE IF stage = 11 {
  PRINT "Awaiting landing..".
  IF STATUS = "LANDED" OR STATUS = "SPLASHED"
    CompleteStage().
  ELSE WAIT 0.
} ELSE IF stage = 12 {
  PRINT "Terminating mission..".
  UNLOCK STEERING.
  RestoreBootFile().
  CompleteStage().
} ELSE {
  PRINT "Undefined mission stage. " + stage.
  WAIT 5.
  ClearMissionStage().
}

REBOOT.

LOCAL FUNCTION CompleteStage {
  PRINT "Stage complete.".
  IncrementMissionStage().
  WAIT 5.
}

LOCAL FUNCTION DoScience
{
  LOCAL bay IS SHIP:PARTSTAGGED("bay1")[0]:GETMODULE("USAnimateGeneric").
  LOCAL mag IS SHIP:PARTSTAGGED("magneto")[0]:GETMODULE("DMModuleScienceAnimate").

  PRINT "Deploying magnetometer..".
  bay:DoEvent("deploy primary bays").
  WAIT 5.
  mag:DEPLOY().
  WAIT 5.

  PRINT "Running experiments..".
  FOR experiment IN SHIP:PARTSTAGGED("science")
    experiment:GetModule("ModuleScienceExperiment"):DEPLOY().
  WAIT 5.

  PRINT "Packing magnetometer..".  
  mag:TOGGLE().
  WAIT 5.
  bay:DoEvent("retract primary bays").
  WAIT 5.

  PRINT "Experiments complete.".
}

LOCAL FUNCTION PrepReentry
{
  PRINT "Packing antennas.".
  FOR antenna in SHIP:PARTSTAGGED("antenna")
    antenna:GETMODULE("ModuleDeployableAntenna"):DoEvent("retract antenna").

  PRINT "Locking to normal for staging..".
  LOCK STEERING TO NORMAL().
  WAIT 2.

  PRINT "Staging booster..".
  STAGE_TO(0).
  WAIT 3.

  PRINT "Locking to retrograde..".
  LOCK STEERING TO SRFRETROGRADE.
}
