@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

//start running the mission after manually plotting a mun encounter

REQUIRE("missionBuilder").
REQUIRE("nodeExecution").
REQUIRE("apsisAdjustment").
REQUIRE("autoStage").
REQUIRE("bud").

PRINT "BODY = " + BODY.
PRINT "ENCOUNTER = " + ENCOUNTER.
PRINT "STATUS = " + STATUS.

AddInitialMissionStage().
AddMissionStageTry({
  PRINT "Executing node..".
  RETURN ExecuteNode().
}).
AddMissionStageWait({
  PRINT "Awaiting mun encounter..".
  RETURN BODY = MUN.
}, 100).
AddMissionStageTry({
  PRINT "Adjusting munar periapsis..".
  RETURN AdjustPeriapsis(100_000, TRUE).
}).
AddMissionStageWait({
  PRINT "Awaiting munar periapsis..".
  RETURN ETA:PERIAPSIS <= 0.
}, 100).
AddMissionStage({
  PRINT "Conducting experiments..".
  DoScience().
}).
AddMissionStageWait({
  PRINT "Awaiting munar escape..".
  RETURN BODY <> MUN.
}, 100).
AddMissionStageTry({
  PRINT "Adjusting reentry depth..".
  RETURN AdjustPeriapsis(30_000).
}).
AddMissionStageWait({
  PRINT "Awaiting reentry..".
  RETURN ALTITUDE <= 250_000.
}, 100).
AddMissionStageWait({
  RETURN ALTITUDE <= 90_000.
}, 5).
AddMissionStage({
  PRINT "Preparing for reentry..".
  PrepReentry().
}).
AddMissionStageWait({
  PRINT "Awaiting landing..".
  RETURN STATUS = "LANDED" OR STATUS = "SPLASHED".
}, 0).
AddMissionStage({
  UNLOCK STEERING.
}).
AddFinalMissionStage().
RunMission().

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
