@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

REQUIRE("bud").
REQUIRE("steering").

FUNCTION ExecuteNode {
  IF NOT HASNODE {
    PRINT "No node. Node execution aborted.".
    RETURN FALSE.
  }

  IF AVAILABLETHRUST = 0 {
    PRINT "No thrust available. Node execution aborted.".
    RETURN FALSE.
  }

  PARAMETER turnTime IS 10.
  PARAMETER deltaVMargin IS 0.1.
  PARAMETER facingDeviation IS 10.

  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
  PRINT "Begin node execution..".

  LOCAL _burnTime IS BurnTime(NEXTNODE:DELTAV:MAG).
  PRINT "Calculated burn time = " + _burnTime.

  PRINT "Awaiting node..".
  WAIT UNTIL NEXTNODE:ETA <= _burnTime/2 + turnTime.

  PRINT "Maneuvering to node direction..".
  LOCK STEERING TO NOROT(NEXTNODE:DELTAV).
  IF NOT WAITSTEERING() {
    PRINT "Failed to maneuver to node direction. Node execution aborted.".
    UNLOCK STEERING.
    RETURN FALSE.
  }

  PRINT "Awaiting burn..".
  WAIT UNTIL NEXTNODE:ETA <= _burnTime/2.

  PRINT "Burning..".
  LOCK THROTTLE TO SIGMOID(NEXTNODE:DELTAV:MAG, 2*AVAILACC()).
  WAIT UNTIL 
    NEXTNODE:DELTAV:MAG <= deltaVMargin 
    OR VANG(FACING:VECTOR, NEXTNODE:DELTAV) >= facingDeviation
    OR AVAILABLETHRUST = 0.
  UNLOCK THROTTLE.
  UNLOCK STEERING.

  IF AVAILABLETHRUST = 0 {
    PRINT "Failed to complete node. Node execution aborted.".
    RETURN FALSE.
  }

  PRINT "Node execution complete.".
  REMOVE NEXTNODE.
  RETURN TRUE.
}

LOCAL FUNCTION BurnTime {
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