@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

FUNCTION PITCH {
  PARAMETER v.

  IF v:ISTYPE("DIRECTION")
    SET v TO v:VECTOR.

  RETURN 90 - VANG(UP:VECTOR, v).
}

FUNCTION ISP {
  LOCAL _isp IS 0.
  LOCAL _fuelFlow IS 0.

  LOCAL _engines IS LIST().
  LIST ENGINES IN _engines.
  FOR engine IN _engines {
    SET _isp TO _isp + engine:AVAILABLETHRUST / CONSTANT:G0.
    SET _fuelFlow TO _fuelFlow + engine:AVAILABLETHRUST / engine:ISP / CONSTANT:G0.
  }

  IF _fuelFlow = 0 RETURN 0.
  RETURN _isp / _fuelFlow.
}

FUNCTION SIGMOID {
  PARAMETER x.
  PARAMETER k IS 1.

  IF x <= -k RETURN -1.
  IF x >= k RETURN 1.
  RETURN x / k.
}

//the real sigmoid function is pushing infinity to stack..

//FUNCTION SIGMOID {
//  PARAMETER x.
//  PARAMETER k IS 1.
//
//  RETURN 2 * SIGMOID_POS(x, k) - 1.
//}
//
//FUNCTION SIGMOID_POS {
//  PARAMETER x.
//  PARAMETER k IS 1.
//
//  RETURN 1 / (1 + CONSTANT:E ^ (-k * x)).*
//}

//these ish functions are bad!!

FUNCTION ZEROISH {
  PARAMETER x.
  PARAMETER ishyness IS 0.1.

  RETURN ABS(x) <= ishyness.
}

FUNCTION ISH {
  PARAMETER x, y.
  PARAMETER ishyness IS 0.1.

  RETURN ABS(x - y) <= ishyness.
}

//FUNCTION NEXT_APSIS {
//  //Apoapsis
//  //Periapsis
//  //SOI Change: Encounter
//  //SOI Change: Ejection
//  //Maneuver
//  IF OBT:TRANSITION = "FINAL"
//    IF ETA:APOAPSIS < ETA:PERIAPSIS
//      RETURN "APOAPSIS".
//    ELSE RETURN "PERIAPSIS".
//  ELSE IF OBT:TRANSITION = "ENCOUNTER"
//    IF ETA:
//}
