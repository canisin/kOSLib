CLEARSCREEN.
PRINT "COUNTING DOWN...".
WAIT 5.
LOCK THROTTLE TO 1.0.
LOCK STEERING TO HEADING(90, 90).
STAGE.

WAIT UNTIL MAXTHRUST = 0.
STAGE.
WAIT 1.
STAGE.

PRINT "PITCHING DOWN".
LOCK PITCH TO 90 - VANG(UP:VECTOR, FACING:VECTOR).
LOCK STEERING TO HEADING(90, 90 - VANG(UP:VECTOR, SRFPROGRADE:VECTOR) - 5).
UNTIL PITCH < 80
{
  PRINT "PITCH = " + PITCH AT(0,0).
  WAIT .1.
}

PRINT "LOCKING TO SRF-PRG".
LOCK STEERING TO HEADING(90, 90 - VANG(UP:VECTOR, SRFPROGRADE:VECTOR)).
UNTIL ALTITUDE > 30000
{
  PRINT "ALTITUDE = " + ALTITUDE AT(0,0).
  WAIT .1.
}

PRINT "LOCKING TO PRG".
LOCK STEERING TO HEADING(90, 90 - VANG(UP:VECTOR, PROGRADE:VECTOR)).
UNTIL APOAPSIS > 80000
{
  PRINT "ALTITUDE = " + ALTITUDE AT(0,0).
  WAIT .1.
}

PRINT "COASTING TO APOAPSIS".
LOCK THRUST TO 0.

