@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("bud").

// https://www.reddit.com/r/Kos/comments/3ivlz9/cooked_steering_flailing_your_craft_wildly_pids/
FUNCTION SMOOTH {
  PARAMETER tar.
  SET tar TO GETDIR(tar).

  LOCAL spd IS MAX(ANGULARMOMENTUM:MAG/10, 4).

  LOCAL curF IS FACING:VECTOR.
  LOCAL tarF IS tar:VECTOR.
  LOCAL curU IS FACING:UPVECTOR.
  LOCAL tarU IS tar:UPVECTOR.

  LOCAL axisF IS VCRS(curF, tarF).
  LOCAL rotAngF IS VANG(tarF, curF)/spd.
  LOCAL rotF IS ANGLEAXIS(MIN(2, rotAngF), axisF).

  LOCAL rotU IS R(0, 0, 0).
  IF VANG(tarF, curF) < 90 {
    LOCAL axisU IS VCRS(curU, tarU).
    LOCAL rotAngU IS VANG(tarU, curU)/spd.
    SET rotU TO ANGLEAXIS(MIN(.5, rotAngU), axisU).
  }

  RETURN LOOKDIRUP(rotF*curF, rotU*curU).
}