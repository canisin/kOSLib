@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("missions").

GLOBAL _missionStages IS LIST().

FUNCTION AddInitialMissionStage {
  PARAMETER missionScriptPath.
  AddMissionStage({
    PRINT "Initiating mission..".
    OverwriteBootFile(missionScriptPath).
  }).
}

FUNCTION AddMissionStage {
  PARAMETER stageAction.
  _missionStages:ADD({
    stageAction().
    CompleteStage().
  }).
}

FUNCTION AddMissionStageTry {
  PARAMETER stageFunc.
  _missionStages:ADD({
    IF stageFunc() CompleteStage().
  }).
}

FUNCTION AddMissionStageWait {
  PARAMETER stageCheck.
  PARAMETER waitTime.
  _missionStages:ADD({
    IF stageCheck() {
      KUNIVERSE:TIMEWARP:CANCELWARP().
      CompleteStage().
    }
    ELSE WAIT waitTime.
  }).
}

FUNCTION AddFinalMissionStage {
  AddMissionStage({
    PRINT "Terminating mission..".
    RestoreBootFile().
  }).
}

FUNCTION RunMission {
  LOCAL stage IS GetMissionStage().
  PRINT "Mission stage " + stage.

  IF stage > _missionStages:LENGTH {
    PRINT "Mission stage out of bounds.".
    ClearMissionStage().
  } ELSE
    _missionStages[stage]().
  WAIT 5.
  REBOOT.
}

FUNCTION ClearMission {
  _missionStages:CLEAR().
}

LOCAL FUNCTION CompleteStage {
  PRINT "Stage complete.".
  IncrementMissionStage().
}
