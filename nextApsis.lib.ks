@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

FUNCTION NEXT_APSIS {
  //Apoapsis
  //Periapsis
  //SOI Change: Encounter
  //SOI Change: Ejection
  //Maneuver
  IF OBT:TRANSITION = "FINAL"
    IF ETA:APOAPSIS < ETA:PERIAPSIS
      RETURN "APOAPSIS".
    ELSE RETURN "PERIAPSIS".
  ELSE IF OBT:TRANSITION = "ENCOUNTER"
    IF ETA:
}