@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

FUNCTION OverwriteBootFile {
  PARAMETER missionPath.

  IF EXISTS("boot/boot.ks")
    MOVEPATH("boot/boot.ks", "boot/boot.bak").

  LOCAL boot IS CREATE("boot/boot.ks").
  boot:WRITELN("@LAZYGLOBAL OFF.").
  boot:WRITELN("").
  boot:WRITELN("WAIT 5.").
  //boot:WRITELN("CORE:DOEVENT(" + CHAR(34) + "Open Terminal" + CHAR(34) + ").").
  boot:WRITELN("RUNPATH(" + CHAR(34) + missionPath + CHAR(34) + ").").
}

FUNCTION RestoreBootFile {
  DELETEPATH("boot/boot.ks").

  IF EXISTS("boot/boot.bak")
    MOVEPATH("boot/boot.bak", "boot/boot.ks").
}

FUNCTION SetMissionStage {
  PARAMETER stage.
  DELETEPATH("missionStage").
  CREATE("missionStage"):WRITE(stage:TOSTRING).
}

FUNCTION GetMissionStage {
  IF NOT EXISTS("missionStage") RETURN 0.
  RETURN OPEN("missionStage"):READALL():STRING:TOSCALAR.
}

FUNCTION IncrementMissionStage {
  SetMissionStage(GetMissionStage + 1).
}

FUNCTION ClearMissionStage {
  DELETEPATH("missionStage").
}