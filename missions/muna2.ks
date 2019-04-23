@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("missionBuilder").
REQUIRE("launch").
REQUIRE("nodeExecution").
REQUIRE("verticalSuicideLanding").
REQUIRE("apsisNodes").

AddInitialMissionStage(SCRIPTPATH()).
AddMissionStage({
  PRINT("Launching..").
  Launch(90, 100_000, 1, 
        4000, 500, 5, 70).
}).
AddMissionStage({
  PRINT "Deploying antennas..".
  TOGGLE BRAKES.
}).
AddMissionStage({
  PRINT "Plotting maneuver..".
  //choose for min mun peri
  MAPVIEW ON.
  ADD NODE((TIME + 5*60):SECONDS, 0, 0, 850).
  LOCAL minPeri IS 2_500_000.
  LOCAL minTime IS TIME.
  FOR i IN RANGE(0, 360) {
    SET NEXTNODE:ETA TO NEXTNODE:ETA + ORBIT:PERIOD/360.
    IF NEXTNODE:ORBIT:HASNEXTPATCH AND NEXTNODE:ORBIT:NEXTPATCH:BODY = MUN 
      AND NEXTNODE:ORBIT:NEXTPATCH:PERIAPSIS > MUN:RADIUS {
      IF NEXTNODE:ORBIT:NEXTPATCH:PERIAPSIS < minPeri {
        SET minPeri TO NEXTNODE:ORBIT:NEXTPATCH:PERIAPSIS.
        SET minTime TO TIME + NEXTNODE:ETA.
      }
    }
    WAIT .1.
  }
  SET NEXTNODE:ETA TO minTime:SECONDS - TIME:SECONDS.
  WAIT 5.
  MAPVIEW OFF.
  ExecuteNode().
}).
AddMissionStageWait({
  PRINT "Awaiting mun encounter..".
  RETURN BODY = MUN.
}, 100).
AddMissionStage({
  PRINT "Adjusting munar periapsis..".
  AdjustPeriapsis(10_000).
}).
AddMissionStageWait({
  PRINT "Awaiting munar periapsis..".
  RETURN ETA:PERIAPSIS <= 30.
}, 5).
AddMissionStage({
  LandVerticalSuicide().
}).
AddMissionStage({
  PRINT "Conducting experiments..".
  TOGGLE RCS.
  WAIT 2.
  TOGGLE LIGHTS.
  WAIT 20.
  TOGGLE RCS.
  WAIT 2.
}).
AddMissionStage({
  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

  LOCK STEERING TO HEADING(90, 90).
  LOCK THROTTLE TO 1.

  PRINT "Launch!".
  WAIT UNTIL ALTITUDE > 500.

  PRINT "Tipping over..".
  LOCK STEERING TO HEADING(90, VPITCH(SRFPROGRADE) - 10).
  WAIT UNTIL VPITCH(SRFPROGRADE) < 50.

  PRINT "Holding pitch..".
  LOCK STEERING TO HEADING(90, 45).
  WAIT UNTIL APOAPSIS > 10_000.

  PRINT "Apoapsis achieved.".
  UNLOCK THROTTLE.
  UNLOCK STEERING.

  ADD CircularizeAtApoNode().
  ExecuteNode().
}).
AddMissionStage({
  PRINT "Plotting maneuver..".
  MAPVIEW ON.
  ADD NODE((TIME + 5*60):SECONDS, 0, 0, 350).
  LOCAL minPeri IS 12_000_000.
  LOCAL minTime IS TIME.
  FOR i IN RANGE(0, 360) {
    SET NEXTNODE:ETA TO NEXTNODE:ETA + ORBIT:PERIOD/360.
    IF NEXTNODE:ORBIT:NEXTPATCH:PERIAPSIS < minPeri {
      SET minPeri TO NEXTNODE:ORBIT:NEXTPATCH:PERIAPSIS.
      SET minTime TO TIME + NEXTNODE:ETA.
    }
    WAIT .1.
  }
  SET NEXTNODE:ETA TO minTime:SECONDS - TIME:SECONDS.
  WAIT 5.
  MAPVIEW OFF.
  ExecuteNode().
}).
AddMissionStageWait({
  PRINT "Awaiting munar escape..".
  RETURN BODY <> MUN.
}, 100).
AddMissionStage({
  PRINT "Adjusting reentry depth..".
  AdjustPeriapsis(30_000).
}).
AddMissionStageWait({
  PRINT "Awaiting reentry..".
  RETURN ALTITUDE <= 250_000.
}, 100).
AddMissionStageWait({
  PRINT "Reentry imminent..".
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

LOCAL FUNCTION PrepReentry
{
  PRINT "Packing antennas.".
  TOGGLE BRAKES.

  PRINT "Locking to normal for staging..".
  LOCK STEERING TO NORMAL().
  WAIT 2.

  PRINT "Staging booster..".
  STAGE_TO(0).
  WAIT 3.

  PRINT "Locking to retrograde..".
  LOCK STEERING TO SRFRETROGRADE.
}