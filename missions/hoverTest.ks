@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("bud").
REQUIRE("rtControls").

LOCAL tVel IS 0.

SET _onControlR TO {SET tVel TO tVel -1. PRINT "Set velocity: " + tVel.}.
SET _onControlT TO {SET tVel TO tVel +1. PRINT "Set velocity: " + tVel.}.
_rtControlToggle ON.

LOCK STEERING TO UP.
LOCK THROTTLE TO SIGMOID(tVel - VERTICALSPEED, 20*AVAILACC()).

STAGE.
WAIT UNTIL FALSE.