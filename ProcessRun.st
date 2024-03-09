REGION 预处理
    #"FP-run-bnt"(CLK:=#"Comm-run"."bnt-run");
    #"Motor-Runtimer"[0](IN := #"Comm-run".busy,PT := #"Screen-Time"."PT-pretime-m");
    #"Motor-Runtimer"[1](IN := #"Comm-run"."in-timer".%X1,PT := #"Screen-Time"."PT-runtime");
    #"Motor-Runtimer"[2](IN := #"Comm-run"."in-timer".%X2,PT := #"Screen-Time"."PT-runtime");
    IF "Debug".Unit_estop_state[2] AND "Debug".Screen_state = 1 THEN
        IF #"FP-run-bnt".Q AND NOT #"Comm-run".busy THEN
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
            IF NOT "P5010-DO" THEN
                "P5010-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 2;
                RETURN;
            END_IF;
            IF "P5010-DO" THEN
                #"Comm-run".step := 2;
            END_IF;
        END_IF;
        //step 2
        IF #"Comm-run".step = 2 THEN
            IF NOT "P5009-DO" AND #"Comm-run"."in-timer".%X1 AND #"Motor-Runtimer"[1].Q THEN
                "P5009-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 3;
                RETURN;
            END_IF;
            IF NOT "P5009-DO" AND NOT #"Comm-run"."in-timer".%X1 THEN
                "P5009-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 3;
                RETURN;
            END_IF;
            IF "P5009-DO" THEN
                #"Comm-run".step := 3;
            END_IF;
        END_IF;
        //step 3
        IF #"Comm-run".step = 3 THEN
            IF NOT "M5201-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "M5201-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 4;
                RETURN;
            END_IF;
            IF NOT "M5201-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5201-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 4;
                RETURN;
            END_IF;
            IF "M5201-DO" THEN
                #"Comm-run".step := 4;
            END_IF;
        END_IF;
        //step 4
        IF #"Comm-run".step = 4 THEN
            IF NOT "P5002-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "P5002-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 5;
                RETURN;
            END_IF;
            IF NOT "P5002-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5002-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 5;
                RETURN;
            END_IF;
            IF "P5002-DO" THEN
                #"Comm-run".step := 5;
            END_IF;
        END_IF;
        //step 5
        IF #"Comm-run".step = 5 THEN
            IF NOT "P5001-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "P5001-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 6;
                RETURN;
            END_IF;
            IF NOT "P5001-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5001-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 6;
                RETURN;
            END_IF;
            IF "P5001-DO" THEN
                #"Comm-run".step := 6;
            END_IF;
        END_IF;
        //step 6
        IF #"Comm-run".step = 6 THEN
            IF NOT "M5101-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "M5101-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 7;
                RETURN;
            END_IF;
            IF NOT "M5101-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5101-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 7;
                RETURN;
            END_IF;
            IF "M5101-DO" THEN
                #"Comm-run".step := 7;
            END_IF;
        END_IF;
        //step 7
        IF #"Comm-run".step = 7 THEN
            IF NOT "P5008-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "P5008-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 8;
                RETURN;
            END_IF;
            IF NOT "P5008-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5008-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 8;
                RETURN;
            END_IF;
            IF "P5008-DO" THEN
                #"Comm-run".step := 8;
            END_IF;
        END_IF;
        //step 8
        IF #"Comm-run".step = 8 THEN
            IF NOT "P5007-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "P5007-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 9;
                RETURN;
            END_IF;
            IF NOT "P5007-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5007-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 9;
                RETURN;
            END_IF;
            IF "P5007-DO" THEN
                #"Comm-run".step := 9;
            END_IF;
        END_IF;
        //step 9
        IF #"Comm-run".step = 9 THEN
            IF NOT "M5004-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "M5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 10;
                RETURN;
            END_IF;
            IF NOT "M5004-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 10;
                RETURN;
            END_IF;
            IF "M5004-DO" THEN
                #"Comm-run".step := 10;
            END_IF;
        END_IF;
        //step 10
        IF #"Comm-run".step = 10 THEN
            IF NOT "P5006-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "P5006-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 11;
                RETURN;
            END_IF;
            IF NOT "P5006-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5006-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 11;
                RETURN;
            END_IF;
            IF "P5006-DO" THEN
                #"Comm-run".step := 11;
            END_IF;
        END_IF;
        //step 11
        IF #"Comm-run".step = 11 THEN
            IF NOT "P5005-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "P5005-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 12;
                RETURN;
            END_IF;
            IF NOT "P5005-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5005-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 12;
                RETURN;
            END_IF;
            IF "P5005-DO" THEN
                #"Comm-run".step := 12;
            END_IF;
        END_IF;
        //step 12
        IF #"Comm-run".step = 12 THEN
            IF NOT "M5003-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "M5003-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 13;
                RETURN;
            END_IF;
            IF NOT "M5003-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5003-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 13;
                RETURN;
            END_IF;
            IF "M5003-DO" THEN
                #"Comm-run".step := 13;
            END_IF;
        END_IF;
        //step 13
        IF #"Comm-run".step = 13 THEN
            IF NOT "P5004-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "P5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".step := 14;
                RETURN;
            END_IF;
            IF NOT "P5004-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".step := 14;
                RETURN;
            END_IF;
            IF "P5004-DO" THEN
                #"Comm-run".step := 14;
            END_IF;
        END_IF;
        //step 14
        IF #"Comm-run".step = 14 THEN
            IF NOT "P5003-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "P5003-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 15;
                RETURN;
            END_IF;
            IF NOT "P5003-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5003-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".step := 15;
                RETURN;
            END_IF;
            IF "P5003-DO" THEN
                #"Comm-run".step := 15;
            END_IF;
        END_IF;
        //step 15
        IF #"Comm-run".step = 15 THEN
            IF NOT "M5002-DO" AND (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2)
                AND (#"Motor-Runtimer"[1].Q OR #"Motor-Runtimer"[2].Q) THEN
                "M5002-DO" := 1;
                #"Comm-run".step := 16;
                RETURN;
            END_IF;
            IF NOT "M5002-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5002-DO" := 1;
                #"Comm-run".step := 16;
                RETURN;
            END_IF;
            IF "M5002-DO" THEN
                #"Comm-run".step := 16;
            END_IF;
        END_IF;
        //step 16
        IF #"Comm-run".step = 16 THEN
            #"Comm-run"."in-timer" := 0;
            #"Comm-run".todo := 0;
            #"Comm-run".busy := 0;
            #"Comm-run".done := 1;
        END_IF;
        
    END_IF;
END_REGION