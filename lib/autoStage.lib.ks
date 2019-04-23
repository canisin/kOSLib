@LAZYGLOBAL OFF.
RUN ONCE REQUIRE.

GLOBAL _autoStageDelay IS 3.
GLOBAL _maxDelayPressure IS .2.
GLOBAL _lastAutoStage IS TIME.
GLOBAL _autoStageTrigger IS {RETURN FALSE.}.

WHEN _autoStageTrigger() THEN {
  IF NOT STAGE:READY RETURN TRUE.
  IF SHIP:Q < _maxDelayPressure AND 
    TIME - _lastAutoStage < _autoStageDelay RETURN TRUE.
  STAGE.
  SET _lastAutoStage TO TIME.
  RETURN TRUE.
}

GLOBAL _lastAvailableThrust IS 0.
FUNCTION AUTOSTAGE_ON {
  SET _lastAutoStage TO TIME.
  SET _lastAvailableThrust TO AVAILABLETHRUST.
  SET _autoStageTrigger TO {
    LOCAL trigger IS AVAILABLETHRUST = 0
                 OR AVAILABLETHRUST < _lastAvailableThrust / 2.
    SET _lastAvailableThrust TO AVAILABLETHRUST.
    RETURN trigger.
  }.
  PRINT "AutoStage ON.".
}

FUNCTION AUTOSTAGE_OFF {
  SET _autoStageTrigger TO {RETURN FALSE.}.
  PRINT "AutoStage OFF.".
}

FUNCTION STAGE_TO {
  PARAMETER tStage.

  IF tStage > STAGE:NUMBER {
    PRINT "Target stage is already past.".
    RETURN.
  }

  IF tStage = STAGE:NUMBER RETURN.

  SET _autoStageTrigger TO {RETURN tStage < STAGE:NUMBER.}.
  WAIT UNTIL STAGE:NUMBER = tStage.
}