REGION 预处理
    #"Motor-Runtimer"[0]( IN := #"Comm-run".busy, PT := #"Screen-Time"."PT-pretime-m");
    #"Motor-Runtimer"[1]( IN := #"Comm-run"."in-timer".%X1, PT := #"Screen-Time"."PT-runtime");
    #"Motor-Runtimer"[2]( IN := #"Comm-run"."in-timer".%X2, PT := #"Screen-Time"."PT-runtime");
    
    IF "Debug".Unit_estop_state[2] AND #bnt_manual THEN
        "Debug".Screen_state := 2;
        "Manual".M5101.man_enable := TRUE;
        "Manual".M5201.man_enable := TRUE;
        "Manual".M5002.man_enable := TRUE;
        "Manual".M5003.man_enable := TRUE;
        "Manual".M5004.man_enable := TRUE;
        "Manual".P5101.man_enable := TRUE;
        "Manual".P5102.man_enable := TRUE;
        "Manual".P5201.man_enable := TRUE;
        "Manual".P5202.man_enable := TRUE;
        "Manual".P5003.man_enable := TRUE;
        "Manual".P5004.man_enable := TRUE;
        "Manual".P5005.man_enable := TRUE;
        "Manual".P5006.man_enable := TRUE;
        "Manual".P5007.man_enable := TRUE;
        "Manual".P5008.man_enable := TRUE;
        "Manual".P5009.man_enable := TRUE;
        "Manual".P5010.man_enable := TRUE;
    END_IF;

    IF "Debug".Unit_estop_state[2] AND #bnt_auto THEN
        "Debug".Screen_state := 1;
        "Manual".M5101.man_enable := FALSE;
        "Manual".M5201.man_enable := FALSE;
        "Manual".M5002.man_enable := FALSE;
        "Manual".M5003.man_enable := FALSE;
        "Manual".M5004.man_enable := FALSE;
        "Manual".P5101.man_enable := FALSE;
        "Manual".P5102.man_enable := FALSE;
        "Manual".P5201.man_enable := FALSE;
        "Manual".P5202.man_enable := FALSE;
        "Manual".P5003.man_enable := FALSE;
        "Manual".P5004.man_enable := FALSE;
        "Manual".P5005.man_enable := FALSE;
        "Manual".P5006.man_enable := FALSE;
        "Manual".P5007.man_enable := FALSE;
        "Manual".P5008.man_enable := FALSE;
        "Manual".P5009.man_enable := FALSE;
        "Manual".P5010.man_enable := FALSE;
    END_IF;
    
    IF "Debug".Unit_estop_state[2] AND "Debug".Screen_state = 1 THEN
        IF #"Comm-run"."bnt-run" AND NOT #"Comm-run".busy THEN
            #"Comm-run".todo := 1;
            //复位工艺停止
            #"Comm-stop"."in-timer" := 0;
            #"Comm-stop".todo := 0;
            #"Comm-stop".busy := 0;
            #"Comm-stop".done := 0;
            #"Comm-stop".step := 0;
        END_IF;
        IF #"Comm-run".todo THEN
            #"Comm-run".busy := 1;
            #"Comm-run".step := 1;
            #"Comm-run".todo := 0;
        END_IF;
    ELSE
        #"Comm-run"."in-timer" := 0;
        #"Comm-run".todo := 0;
        #"Comm-run".busy := 0;
        #"Comm-run".done := 0;
        #"Comm-run".step := 0;
    END_IF; 
END_REGION

REGION 工艺启动
    IF #"Comm-run".busy AND #"Motor-Runtimer"[0].Q THEN
        //step 1
        IF #"Comm-run".step = 1 THEN
            IF NOT "M5004-DO" THEN
                "M5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 2;
                RETURN;
            END_IF;
            IF "M5004-DO" THEN
                #"Comm-run".step := 2;
            END_IF;
        END_IF;
        //step 2
        IF #"Comm-run".step = 2 THEN
            IF NOT "M5003-DO" AND #"Comm-run"."in-timer".%X1 AND #"Motor-Runtimer"[1].Q THEN
                "M5003-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 3;
                RETURN;
            END_IF;
            IF NOT "M5003-DO" AND NOT #"Comm-run"."in-timer".%X1 THEN
                "M5003-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 3;
                RETURN;
            END_IF;
            IF "M5003-DO" THEN
                #"Comm-run".step := 3;
            END_IF;
        END_IF;
        //step 3
        IF #"Comm-run".step = 3 THEN
            IF NOT "M5002-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "M5002-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 4;
                RETURN;
            END_IF;
            IF NOT "M5002-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "M5002-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 4;
                RETURN;
            END_IF;
            IF NOT "M5002-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5002-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 4;
                RETURN;
            END_IF;
            IF "M5002-DO" THEN
                #"Comm-run".step := 4;
            END_IF;
        END_IF;
        //step 4
        IF #"Comm-run".step = 4 THEN
            IF NOT "M5201-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "M5201-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 5;
                RETURN;
            END_IF;
            IF NOT "M5201-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "M5201-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 5;
                RETURN;
            END_IF;
            IF NOT "M5201-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5201-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 5;
                RETURN;
            END_IF;
            IF "M5201-DO" THEN
                #"Comm-run".step := 5;
            END_IF;
        END_IF;
        //step 5
        IF #"Comm-run".step = 5 THEN
            IF NOT "M5101-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "M5101-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 6;
                RETURN;
            END_IF;
            IF NOT "M5101-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "M5101-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 6;
                RETURN;
            END_IF;
            IF NOT "M5101-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5101-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 6;
                RETURN;
            END_IF;
            IF "M5101-DO" THEN
                #"Comm-run".step := 6;
            END_IF;
        END_IF;
        //step 6
        IF #"Comm-run".step = 6 THEN
            IF NOT "P5010-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5010-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 7;
                RETURN;
            END_IF;
            IF NOT "P5010-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "P5010-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 7;
                RETURN;
            END_IF;
            IF NOT "P5010-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5010-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 7;
                RETURN;
            END_IF;
            IF "P5010-DO" THEN
                #"Comm-run".step := 7;
            END_IF;
        END_IF;
        //step 7
        IF #"Comm-run".step = 7 THEN
            IF NOT "P5007-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5007-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 8;
                RETURN;
            END_IF;
            IF NOT "P5007-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "P5007-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 8;
                RETURN;
            END_IF;
            IF NOT "P5007-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5007-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 8;
                RETURN;
            END_IF;
            IF "P5007-DO" THEN
                #"Comm-run".step := 8;
            END_IF;
        END_IF;
        //step 8
        IF #"Comm-run".step = 8 THEN
            IF NOT "P5005-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5005-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 9;
                RETURN;
            END_IF;
            IF NOT "P5005-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "P5005-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 9;
                RETURN;
            END_IF;
            IF NOT "P5005-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5005-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 9;
                RETURN;
            END_IF;
            IF "P5005-DO" THEN
                #"Comm-run".step := 9;
            END_IF;
        END_IF;
        //step 9
        IF #"Comm-run".step = 9 THEN
            IF NOT "P5003-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5003-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 10;
                RETURN;
            END_IF;
            IF NOT "P5003-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "P5003-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 10;
                RETURN;
            END_IF;
            IF NOT "P5003-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5003-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 10;
                RETURN;
            END_IF;
            IF "P5003-DO" THEN
                #"Comm-run".step := 10;
            END_IF;
        END_IF;
        //step 10
        IF #"Comm-run".step = 10 THEN
            IF NOT "P5201-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5201-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 11;
                RETURN;
            END_IF;
            IF NOT "P5201-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5201-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 11;
                RETURN;
            END_IF;
            IF NOT "P5201-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5201-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 11;
                RETURN;
            END_IF;
            IF "P5201-DO" THEN
                #"Comm-run".step := 11;
            END_IF;
        END_IF;
        //step 11
        IF #"Comm-run".step = 11 THEN
            IF NOT "P5101-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5101-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 12;
                RETURN;
            END_IF;
            IF NOT "P5101-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5101-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 12;
                RETURN;
            END_IF;
            IF NOT "P5101-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5101-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 12;
                RETURN;
            END_IF;
            IF "P5101-DO" THEN
                #"Comm-run".step := 12;
            END_IF;
        END_IF;
        //step 12
        IF #"Comm-run".step = 12 THEN
            IF NOT "P5009-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5009-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 13;
                RETURN;
            END_IF;
            IF NOT "P5009-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5009-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 13;
                RETURN;
            END_IF;
            IF NOT "P5009-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5009-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 13;
                RETURN;
            END_IF;
            IF "P5009-DO" THEN
                #"Comm-run".step := 13;
            END_IF;
        END_IF;
        //step 13
        IF #"Comm-run".step = 13 THEN
            IF NOT "P5008-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5008-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 14;
                RETURN;
            END_IF;
            IF NOT "P5008-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5008-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 14;
                RETURN;
            END_IF;
            IF NOT "P5008-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5008-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 14;
                RETURN;
            END_IF;
            IF "P5008-DO" THEN
                #"Comm-run".step := 14;
            END_IF;
        END_IF;
        //step 14
        IF #"Comm-run".step = 14 THEN
            IF NOT "P5006-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5006-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 15;
                RETURN;
            END_IF;
            IF NOT "P5006-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5006-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 15;
                RETURN;
            END_IF;
            IF NOT "P5006-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5006-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 15;
                RETURN;
            END_IF;
            IF "P5006-DO" THEN
                #"Comm-run".step := 15;
            END_IF;
        END_IF;
        //step 15
        IF #"Comm-run".step = 15 THEN
            IF NOT "P5004-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 16;
                RETURN;
            END_IF;
            IF NOT "P5004-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 16;
                RETURN;
            END_IF;
            IF NOT "P5004-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5004-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 16;
                RETURN;
            END_IF;
            IF "P5004-DO" THEN
                #"Comm-run".step := 16;
            END_IF;
        END_IF;
        //step 16
        IF #"Comm-run".step = 16 THEN
            IF NOT "P5202-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5202-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 17;
                RETURN;
            END_IF;
            IF NOT "P5202-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5202-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 17;
                RETURN;
            END_IF;
            IF NOT "P5202-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5202-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 17;
                RETURN;
            END_IF;
            IF "P5202-DO" THEN
                #"Comm-run".step := 17;
            END_IF;
        END_IF;
        //step 17
        IF #"Comm-run".step = 17 THEN
            IF NOT "P5102-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5102-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run".step := 18;
                RETURN;
            END_IF;
            IF NOT "P5102-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5102-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 18;
                RETURN;
            END_IF;
            IF NOT "P5102-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5102-DO" := 1;
                #"Comm-run".step := 18;
                RETURN;
            END_IF;
            IF "P5102-DO" THEN
                #"Comm-run".step := 18;
            END_IF;
        END_IF;
        //step 18
        IF #"Comm-run".step = 18 THEN
            #"Comm-run"."in-timer" := 0;
            #"Comm-run".todo := 0;
            #"Comm-run".busy := 0;
            #"Comm-run".done := 1;
        END_IF;
        
    END_IF;

REGION 工艺停止
    IF #"Comm-stop".busy AND #"Motor-Stoptimer"[0].Q THEN
        //step 1
        IF #"Comm-stop".step = 1 THEN
            IF "P5102-DO" THEN
                "P5102-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop".step := 2;
                RETURN;
            END_IF;
            IF NOT "P5102-DO" THEN
                #"Comm-stop".step := 2;
            END_IF;
        END_IF;
        //step 2
        IF #"Comm-stop".step = 2 THEN
            IF "P5202-DO" AND #"Comm-stop"."in-timer".%X1 AND #"Motor-Stoptimer"[1].Q THEN
                "P5202-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 3;
                RETURN;
            END_IF;
            IF "P5202-DO" AND NOT #"Comm-stop"."in-timer".%X1 THEN
                "P5202-DO" := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 3;
                RETURN;
            END_IF;
            IF NOT "P5202-DO" THEN
                #"Comm-stop".step := 3;
            END_IF;
        END_IF;
        //step 3
        IF #"Comm-stop".step = 3 THEN
            IF "P5004-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "P5004-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop"."in-timer".%X2 := 0;
                #"Comm-stop".step := 4;
                RETURN;
            END_IF;
            IF "P5004-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "P5004-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop".step := 4;
                RETURN;
            END_IF;
            IF NOT "P5004-DO" THEN
                #"Comm-stop".step := 4;
            END_IF;
        END_IF;
        //step 4
        IF #"Comm-stop".step = 4 THEN
            IF "P5006-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "P5006-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 5;
                RETURN;
            END_IF;
            IF "P5006-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "P5006-DO" := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 5;
                RETURN;
            END_IF;
            IF NOT "P5006-DO" THEN
                #"Comm-stop".step := 5;
            END_IF;
        END_IF;
        //step 5
        IF #"Comm-stop".step = 5 THEN
            IF "P5008-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "P5008-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop"."in-timer".%X2 := 0;
                #"Comm-stop".step := 6;
                RETURN;
            END_IF;
            IF "P5008-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "P5008-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop".step := 6;
                RETURN;
            END_IF;
            IF NOT "P5008-DO" THEN
                #"Comm-stop".step := 6;
            END_IF;
        END_IF;
        //step 6
        IF #"Comm-stop".step = 6 THEN
            IF "P5009-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "P5009-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 7;
                RETURN;
            END_IF;
            IF "P5009-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "P5009-DO" := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 7;
                RETURN;
            END_IF;
            IF NOT "P5009-DO" THEN
                #"Comm-stop".step := 7;
            END_IF;
        END_IF;
        //step 7
        IF #"Comm-stop".step = 7 THEN
            IF "P5101-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "P5101-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop"."in-timer".%X2 := 0;
                #"Comm-stop".step := 8;
                RETURN;
            END_IF;
            IF "P5101-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "P5101-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop".step := 8;
                RETURN;
            END_IF;
            IF NOT "P5101-DO" THEN
                #"Comm-stop".step := 8;
            END_IF;
        END_IF;
        //step 8
        IF #"Comm-stop".step = 8 THEN
            IF "P5201-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "P5201-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 9;
                RETURN;
            END_IF;
            IF "P5201-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "P5201-DO" := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 9;
                RETURN;
            END_IF;
            IF NOT "P5201-DO" THEN
                #"Comm-stop".step := 9;
            END_IF;
        END_IF;
        //step 9
        IF #"Comm-stop".step = 9 THEN
            IF "P5003-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "P5003-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop"."in-timer".%X2 := 0;
                #"Comm-stop".step := 10;
                RETURN;
            END_IF;
            IF "P5003-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "P5003-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop".step := 10;
                RETURN;
            END_IF;
            IF NOT "P5003-DO" THEN
                #"Comm-stop".step := 10;
            END_IF;
        END_IF;
        //step 10
        IF #"Comm-stop".step = 10 THEN
            IF "P5005-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "P5005-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 11;
                RETURN;
            END_IF;
            IF "P5005-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "P5005-DO" := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 11;
                RETURN;
            END_IF;
            IF NOT "P5005-DO" THEN
                #"Comm-stop".step := 11;
            END_IF;
        END_IF;
        //step 11
        IF #"Comm-stop".step = 11 THEN
            IF "P5007-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "P5007-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop"."in-timer".%X2 := 0;
                #"Comm-stop".step := 12;
                RETURN;
            END_IF;
            IF "P5007-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "P5007-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop".step := 12;
                RETURN;
            END_IF;
            IF NOT "P5007-DO" THEN
                #"Comm-stop".step := 12;
            END_IF;
        END_IF;
        //step 12
        IF #"Comm-stop".step = 12 THEN
            IF "P5010-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "P5010-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 13;
                RETURN;
            END_IF;
            IF "P5010-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "P5010-DO" := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 13;
                RETURN;
            END_IF;
            IF NOT "P5010-DO" THEN
                #"Comm-stop".step := 13;
            END_IF;
        END_IF;
        //step 13
        IF #"Comm-stop".step = 13 THEN
            IF "M5101-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "M5101-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop"."in-timer".%X2 := 0;
                #"Comm-stop".step := 14;
                RETURN;
            END_IF;
            IF "M5101-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "M5101-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop".step := 14;
                RETURN;
            END_IF;
            IF NOT "M5101-DO" THEN
                #"Comm-stop".step := 14;
            END_IF;
        END_IF;
        //step 14
        IF #"Comm-stop".step = 14 THEN
            IF "M5201-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "M5201-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 15;
                RETURN;
            END_IF;
            IF "M5201-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "M5201-DO" := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 15;
                RETURN;
            END_IF;
            IF NOT "M5201-DO" THEN
                #"Comm-stop".step := 15;
            END_IF;
        END_IF;
        //step 15
        IF #"Comm-stop".step = 15 THEN
            IF "M5002-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "M5002-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop"."in-timer".%X2 := 0;
                #"Comm-stop".step := 16;
                RETURN;
            END_IF;
            IF "M5002-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "M5002-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 1;
                #"Comm-stop".step := 16;
                RETURN;
            END_IF;
            IF NOT "M5002-DO" THEN
                #"Comm-stop".step := 16;
            END_IF;
        END_IF;
        //step 16
        IF #"Comm-stop".step = 16 THEN
            IF "M5003-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "M5003-DO" := 0;
                #"Comm-stop"."in-timer".%X1 := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 17;
                RETURN;
            END_IF;
            IF "M5003-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "M5003-DO" := 0;
                #"Comm-stop"."in-timer".%X2 := 1;
                #"Comm-stop".step := 17;
                RETURN;
            END_IF;
            IF NOT "M5003-DO" THEN
                #"Comm-stop".step := 17;
            END_IF;
        END_IF;
        //step 17
        IF #"Comm-stop".step = 17 THEN
            IF "M5004-DO" AND (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2)
                AND (#"Motor-Stoptimer"[1].Q OR #"Motor-Stoptimer"[2].Q) THEN
                "M5004-DO" := 0;
                #"Comm-stop".step := 18;
                RETURN;
            END_IF;
            IF "M5004-DO" AND NOT (#"Comm-stop"."in-timer".%X1 OR #"Comm-stop"."in-timer".%X2) THEN
                "M5004-DO" := 0;
                #"Comm-stop".step := 18;
                RETURN;
            END_IF;
            IF NOT "M5004-DO" THEN
                #"Comm-stop".step := 18;
            END_IF;
        END_IF;
        //step 18
        IF #"Comm-stop".step = 18 THEN
            #"Comm-stop"."in-timer" := 0;
            #"Comm-stop".todo := 0;
            #"Comm-stop".busy := 0;
            #"Comm-stop".done := 1;
        END_IF;
        
    END_IF;
END_REGION