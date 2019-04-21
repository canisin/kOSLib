@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("bud").

FUNCTION BurnTime {
  PARAMETER deltaV.
  RETURN AdvBurnTime(deltaV).
}

LOCAL FUNCTION SimpleBurnTime {
  PARAMETER deltaV.

  RETURN deltaV * MASS / AVAILABLETHRUST.
}

LOCAL FUNCTION AdvBurnTime {
  PARAMETER deltaV.

  LOCAL ispG0 IS ISP() * CONSTANT:G0.
  RETURN MASS * ispG0 * (1 - CONSTANT:E ^ (-deltaV / ispG0)) / AVAILABLETHRUST.
}