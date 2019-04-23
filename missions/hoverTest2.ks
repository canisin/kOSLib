@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("bud").
REQUIRE("rtControls").

LOCAL tVel IS 0.

SET _onControlR TO {SET tVel TO tVel -1. PRINT "Set velocity: " + tVel.}.
SET _onControlT TO {SET tVel TO tVel +1. PRINT "Set velocity: " + tVel.}.
_rtControlToggle ON.

LOCAL pid IS PIDLOOP().
SET pid:MINOUTPUT TO 0.
SET pid:MAXOUTPUT TO 1.

LOCK STEERING TO UP.
LOCK THROTTLE TO PID:UPDATE(TIME:SECONDS, VERTICALSPEED - tVel).

STAGE.
WAIT UNTIL FALSE.