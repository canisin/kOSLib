@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("launch").

PARAMETER tHeading.
PARAMETER tApoapsis.

SET _launchParameters["heading"] TO tHeading.
SET _launchParameters["apoapsis"] TO tApoapsis.
Launch().