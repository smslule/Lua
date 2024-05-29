//自动模式
IF "Debug".Unit_estop_state[3] AND #Valve.mode = 1 THEN
    IF "Global"."DIT6001-density" < #Retain."density-Low" THEN
        "V6003-O" := 1;
        "V6004-O" := 0;
    END_IF;
    IF "Global"."DIT6001-density" > #Retain."density-High" THEN
        "V6003-O" := 0;
        "V6004-O" := 1;
    END_IF;
END_IF;
//手动模式
IF "Debug".Unit_estop_state[3] AND #Valve.mode = 2 THEN
    IF #Valve."bnt-loop" THEN
        "V6003-O" := 1;
        "V6004-O" := 0;
    END_IF;
    IF #Valve."bnt-dump" THEN
        "V6003-O" := 0;
        "V6004-O" := 1;
    END_IF;
END_IF;
//急停模式下复位
IF NOT "Debug".Unit_estop_state[3] THEN
    "V6003-O" := 1;
    "V6004-O" := 0;
    #Valve.mode := 2;
END_IF;
//回料--放料状态判断
IF "V6003-O" AND NOT "V6004-O" THEN
    #Valve.state := 1;
END_IF;
IF NOT "V6003-O" AND "V6004-O" THEN
    #Valve.state := 2;
END_IF;
IF NOT "V6003-O" AND NOT "V6004-O" THEN
    #Valve.state := 0;
END_IF;
IF "V6003-O" AND "V6004-O" THEN
    #Valve.state := 3;
END_IF;