REGION 工艺启动
    IF #"Comm-run".busy AND #"Motor-Runtimer"[0].Q THEN
        // step 1
        IF #"Comm-run".STEP = 1 THEN
            IF NOT "P5010-DO" THEN
                "P5010-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".STEP := 2;
                RETURN;
            END_IF;
            IF "P5010-DO" THEN
                #"Comm-run".STEP := 2;
            END_IF;
        END_IF;
        // step 2
        IF #"Comm-run".STEP = 2 THEN
            IF NOT "P5009-DO" AND #"Comm-run"."in-timer".%X1 AND #"Motor-Runtimer"[1].Q THEN
                "P5009-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 3;
                RETURN;
            END_IF;
            IF NOT "P5009-DO" AND NOT #"Comm-run"."in-timer".%X1 THEN
                "P5009-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 3;
                RETURN;
            END_IF;
            IF "P5009-DO" THEN
                #"Comm-run".STEP := 3;
            END_IF;
        END_IF;
        // step 3
        IF #"Comm-run".STEP = 3 THEN
            IF NOT "M5201-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "M5201-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 4;
                RETURN;
            END_IF;
            IF NOT "M5201-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "M5201-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 4;
                RETURN;
            END_IF;
            IF NOT "M5201-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5201-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".STEP := 4;
                RETURN;
            END_IF;
            IF "M5201-DO" THEN
                #"Comm-run".STEP := 4;
            END_IF;
        END_IF;
        // step 4
        IF #"Comm-run".STEP = 4 THEN
            IF NOT "P5002-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5002-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 5;
                RETURN;
            END_IF;
            IF NOT "P5002-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "P5002-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 5;
                RETURN;
            END_IF;
            IF NOT "P5002-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5002-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 5;
                RETURN;
            END_IF;
            IF "P5002-DO" THEN
                #"Comm-run".STEP := 5;
            END_IF;
        END_IF;
        // step 5
        IF #"Comm-run".STEP = 5 THEN
            IF NOT "P5001-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5001-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 6;
                RETURN;
            END_IF;
            IF NOT "P5001-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "P5001-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 6;
                RETURN;
            END_IF;
            IF NOT "P5001-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5001-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".STEP := 6;
                RETURN;
            END_IF;
            IF "P5001-DO" THEN
                #"Comm-run".STEP := 6;
            END_IF;
        END_IF;
        // step 6
        IF #"Comm-run".STEP = 6 THEN
            IF NOT "M5101-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "M5101-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 7;
                RETURN;
            END_IF;
            IF NOT "M5101-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "M5101-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 7;
                RETURN;
            END_IF;
            IF NOT "M5101-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5101-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 7;
                RETURN;
            END_IF;
            IF "M5101-DO" THEN
                #"Comm-run".STEP := 7;
            END_IF;
        END_IF;
        // step 7
        IF #"Comm-run".STEP = 7 THEN
            IF NOT "P5008-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5008-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 8;
                RETURN;
            END_IF;
            IF NOT "P5008-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "P5008-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 8;
                RETURN;
            END_IF;
            IF NOT "P5008-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5008-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".STEP := 8;
                RETURN;
            END_IF;
            IF "P5008-DO" THEN
                #"Comm-run".STEP := 8;
            END_IF;
        END_IF;
        // step 8
        IF #"Comm-run".STEP = 8 THEN
            IF NOT "P5007-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5007-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 9;
                RETURN;
            END_IF;
            IF NOT "P5007-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "P5007-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 9;
                RETURN;
            END_IF;
            IF NOT "P5007-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5007-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 9;
                RETURN;
            END_IF;
            IF "P5007-DO" THEN
                #"Comm-run".STEP := 9;
            END_IF;
        END_IF;
        // step 9
        IF #"Comm-run".STEP = 9 THEN
            IF NOT "M5004-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "M5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 10;
                RETURN;
            END_IF;
            IF NOT "M5004-DO" AND (#"Comm-run"."in-timer".%X2)AND (#"Motor-Runtimer"[2].Q) THEN
                "M5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 10;
                RETURN;
            END_IF;
            IF NOT "M5004-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".STEP := 10;
                RETURN;
            END_IF;
            IF "M5004-DO" THEN
                #"Comm-run".STEP := 10;
            END_IF;
        END_IF;
        // step 10
        IF #"Comm-run".STEP = 10 THEN
            IF NOT "P5006-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5006-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 11;
                RETURN;
            END_IF;
            IF NOT "P5006-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5006-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 11;
                RETURN;
            END_IF;
            IF NOT "P5006-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5006-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 11;
                RETURN;
            END_IF;
            IF "P5006-DO" THEN
                #"Comm-run".STEP := 11;
            END_IF;
        END_IF;
        // step 11
        IF #"Comm-run".STEP = 11 THEN
            IF NOT "P5005-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5005-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 12;
                RETURN;
            END_IF;
            IF NOT "P5005-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5005-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 12;
                RETURN;
            END_IF;
            IF NOT "P5005-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5005-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".STEP := 12;
                RETURN;
            END_IF;
            IF "P5005-DO" THEN
                #"Comm-run".STEP := 12;
            END_IF;
        END_IF;
        // step 12
        IF #"Comm-run".STEP = 12 THEN
            IF NOT "M5003-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "M5003-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 13;
                RETURN;
            END_IF;
            IF NOT "M5003-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "M5003-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 13;
                RETURN;
            END_IF;
            IF NOT "M5003-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5003-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 13;
                RETURN;
            END_IF;
            IF "M5003-DO" THEN
                #"Comm-run".STEP := 13;
            END_IF;
        END_IF;
        // step 13
        IF #"Comm-run".STEP = 13 THEN
            IF NOT "P5004-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 14;
                RETURN;
            END_IF;
            IF NOT "P5004-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 14;
                RETURN;
            END_IF;
            IF NOT "P5004-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5004-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run".STEP := 14;
                RETURN;
            END_IF;
            IF "P5004-DO" THEN
                #"Comm-run".STEP := 14;
            END_IF;
        END_IF;
        // step 14
        IF #"Comm-run".STEP = 14 THEN
            IF NOT "P5003-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "P5003-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 15;
                RETURN;
            END_IF;
            IF NOT "P5003-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "P5003-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 15;
                RETURN;
            END_IF;
            IF NOT "P5003-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "P5003-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 1;
                #"Comm-run".STEP := 15;
                RETURN;
            END_IF;
            IF "P5003-DO" THEN
                #"Comm-run".STEP := 15;
            END_IF;
        END_IF;
        // step 15
        IF #"Comm-run".STEP = 15 THEN
            IF NOT "M5002-DO" AND (#"Comm-run"."in-timer".%X1 )AND (#"Motor-Runtimer"[1].Q ) THEN
                "M5002-DO" := 1;
                #"Comm-run"."in-timer".%X1 := 0;
                #"Comm-run".STEP := 16;
                RETURN;
            END_IF;
            IF NOT "M5002-DO" AND (#"Comm-run"."in-timer".%X2) AND (#"Motor-Runtimer"[2].Q) THEN
                "M5002-DO" := 1;
                #"Comm-run"."in-timer".%X2 := 0;
                #"Comm-run".STEP := 16;
                RETURN;
            END_IF;
            IF NOT "M5002-DO" AND NOT (#"Comm-run"."in-timer".%X1 OR #"Comm-run"."in-timer".%X2) THEN
                "M5002-DO" := 1;
                #"Comm-run".STEP := 16;
                RETURN;
            END_IF;
            IF "M5002-DO" THEN
                #"Comm-run".STEP := 16;
            END_IF;
        END_IF;
        // step 16
        IF #"Comm-run".STEP = 16 THEN
            #"Comm-run"."in-timer" := 0;
            #"Comm-run".todo := 0;
            #"Comm-run".busy := 0;
            #"Comm-run".done := 1;
        END_IF;

    END_IF;
END_REGION