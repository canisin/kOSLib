@LAZYGLOBAL OFF.

// Example usage:
// RUN ACQUIRE("libCaller").
// RUN libCaller("launch", "Launch(90, 100_000, 2).").

PARAMETER libName, funcCall.

DELETEPATH("libCaller.temp.ks").
LOCAL file IS CREATE("libCaller.temp.ks").

file:WRITELN("@LAZYGLOBAL OFF.").
file:WRITELN("RUN ONCE REQUIRE.").
file:WRITELN("").
file:WRITELN("REQUIRE(" + char(34) + libName + char(34) + ").").
file:WRITELN(funcCall).

RUNPATH("libCaller.temp.ks").
DELETEPATH("libCaller.temp.ks").