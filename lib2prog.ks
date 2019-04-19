@LAZYGLOBAL OFF.

// Example usage:
// RUN ACQUIRE("libMaker").
// RUN libMaker("launch", "launch", 3).
// RUN launch(90, 100_000, 2).

PARAMETER libName, funcName, paramCount.
PARAMETER path IS funcName + ".ks".

LOCAL paramList IS LIST().
FOR i IN RANGE(paramCount)
  paramList:ADD("param" + i).
SET paramList TO paramList:JOIN(", ").

DELETEPATH(path).
LOCAL file IS CREATE(path).

file:WRITELN("@LAZYGLOBAL OFF.").
file:WRITELN("RUN ONCE REQUIRE.").
file:WRITELN("").
file:WRITELN("REQUIRE(" + char(34) + libName + char(34) + ").").
IF paramCount > 0
  file:WRITELN("PARAMETER " + paramList + ".").
file:WRITELN(funcName + "(" + paramList + ").").