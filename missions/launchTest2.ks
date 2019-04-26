@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("launch").

SET _launchParams["heading"] TO 90.
SET _launchParams["apoapsis"] TO 100_000.
SET _launchParams["circularizationStage"] TO 1.

SET _launchParams["firstPitchAlt"] TO 500.
SET _launchParams["firstPitchValue"] TO 70.

Launch().