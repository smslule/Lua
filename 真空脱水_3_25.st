FUNCTION_BLOCK Dewater
    VAR_STAT
        // 1#真空脱水控制流--结构体
        TYPE Dewater_1: STRUCT
                bnt_run: BOOL; (* 启动按钮 *)
                bnt_stop: BOOL; (* 停止按钮 *)
                bnt_manual: BOOL; (* 手动按钮 *)
                state: INT; (* 状态 *)
                error_id: INT; (* 错误 *)
                TYPE run: STRUCT
                        todo: BOOL; (* 初始化 *)
                        busy: BOOL; (* 执行中 *)
                        STEP: INT; (* 步数 *)
                        in_time: WORD; (* 计时器输入IN *)
                        skip: BOOL; (* 跳过 *)
                    END_STRUCT
                END_TYPE
                TYPE stop: STRUCT
                        todo: BOOL; (* 初始化 *)
                        busy: BOOL; (* 执行中 *)
                        STEP: INT; (* 步数 *)
                        in_time: WORD; (* 计时器输入IN *)
                        skip: BOOL; (* 跳过 *)
                    END_STRUCT
                END_TYPE
            END_STRUCT
        END_TYPE
        // 1#真空脱水设置时间--结构体
        TYPE Retain_time_D_1 : STRUCT
                preTime : DINT; (* 预处理时间 *)
                openTime_1 : DINT; (* 真空脱水时间 *)
                openTime_2 : DINT; (* 真空脱水时间 *)
                delayTime : DINT; (* 延迟时间 *)
                loopTime : DINT; (* 循环时间 *)
            END_STRUCT
        END_TYPE
        // 1#真空脱水计时器--数组
        Timer_D_1 : ARRAY [0..3] OF TON_TIME;
    END_VAR
    
    // 计时器
    Timer_D_1[0] (IN := #Dewater_1.run.in_time.%X0, PT := #Retain_time_D_1.preTime);
    Timer_D_1[1] (IN := #Dewater_1.run.in_time.%X1, PT := #Retain_time_D_1.openTime_1);

    // 预处理
    IF "Global".Emergency.Dewater_1 THEN
        IF #Dewater_1.bnt_run AND NOT #Dewater_1.run.busy THEN
            "V8016-O" := FALSE;
            "V8021-O" := FALSE;
            "V8026-O" := TRUE;
            #Dewater_1.run.todo := TRUE;
        END_IF;
        IF #Dewater_1.run.todo THEN
            #Dewater_1.state := 1;
            #Dewater_1.run.step := 1;
            #Dewater_1.run.skip := FALSE;
            #Dewater_1.run.in_time := 0;
            #Dewater_1.run.in_time.%X0 := TRUE;
            "ALARM3-O" := TRUE;
            #Dewater_1.bnt_run := FALSE;
            #Dewater_1.run.todo := FALSE;
        END_IF;
        IF #Dewater_1.run.in_time.%X0 AND #Timer_D_1[0].Q THEN
            #Dewater_1.run.busy := TRUE;
            "ALARM3-O" := FALSE;
        ELSE
            #Dewater_1.run.busy := FALSE;
        END_IF;
    ELSE
        #Dewater_1.state := 0;
        #Dewater_1.run.step := 0;
        #Dewater_1.run.in_time := 0;
        #Dewater_1.stop.step := 0;
        #Dewater_1.stop.in_time := 0;
        "ALARM3-O" := FALSE;
    END_IF;

    // 手动时
    IF "Global".Emergency.Dewater_1 AND #Dewater_1.bnt_manual THEN
        #Dewater_1.state := 2;
        #Dewater_1.run.step := 0;
        #Dewater_1.run.in_time := 0;
        #Dewater_1.stop.step := 0;
        #Dewater_1.stop.in_time := 0;
    END_IF;

    // 停止时
    IF "Global".Emergency.Dewater_1 AND #Dewater_1.bnt_stop THEN
        #Dewater_1.state := 3;
        #Dewater_1.run.step := 0;
        #Dewater_1.run.in_time := 0;
    END_IF;

    // 启动中
    IF #Dewater_1.run.busy AND Dewater_1.state = 1 THEN
        // 第1步
        IF #Dewater_1.run.step = 1 THEN
            IF NOT "KV7001-O" THEN
                "KV7001-O" := TRUE;
                #Dewater_1.run.step := 2;
                RETURN;
            END_IF;
            IF "KV7001-O" THEN
                #Dewater_1.run.skip := TRUE;
                #Dewater_1.run.step := 2;
            END_IF;
        END_IF;
        // 第2步
        IF #Dewater_1.run.step = 2 THEN
            IF NOT "A7001-DO" THEN
                IF #Dewater_1.run.skip THEN
                    "A7001-DO" := TRUE;
                    #Dewater_1.run.skip := FALSE;
                    #Dewater_1.run.step := 3;
                    RETURN;
                END_IF;
                #Dewater_1.run.in_time.%X1 := TRUE;
                IF #Dewater_1.run.in_time.%X1 AND #Timer_D_1[1].Q THEN
                    "A7001-DO" := TRUE;
                    #Dewater_1.run.in_time.%X1 := FALSE;
                    #Dewater_1.run.step := 3;
                    RETURN;
                END_IF;
            END_IF;
            IF "A7001-DO" THEN
                #Dewater_1.run.step := 3;
            END_IF;
        END_IF;
        // 第3步
        IF #Dewater_1.run.step = 3 THEN
            IF NOT "F7001-DO" THEN
                IF #Dewater_1.run.skip THEN
                    "F7001-DO" := TRUE;
                    #Dewater_1.run.skip := FALSE;
                    #Dewater_1.run.step := 4;
                    RETURN;
                END_IF;
                #Dewater_1.run.in_time.%X1 := TRUE;
                IF #Dewater_1.run.in_time.%X1 AND #Timer_D_1[1].Q THEN
                    "F7001-DO" := TRUE;
                    #Dewater_1.run.in_time.%X1 := FALSE;
                    #Dewater_1.run.step := 4;
                    RETURN;
                END_IF;
            END_IF;
            IF "F7001-DO" THEN
                #Dewater_1.run.step := 4;
            END_IF;
        END_IF;
        // 第4步
        IF #Dewater_1.run.step = 4 THEN
            IF NOT ( "V8001-O" AND NOT "V8006-O" ) THEN
                IF #Dewater_1.run.skip THEN
                    "V8001-O" := TRUE;
                    "V8006-O" := FALSE;
                    #Dewater_1.run.skip := FALSE;
                    #Dewater_1.run.step := 5;
                    RETURN;
                END_IF;
                #Dewater_1.run.in_time.%X1 := TRUE;
                IF #Dewater_1.run.in_time.%X1 AND #Timer_D_1[1].Q THEN
                    "V8001-O" := TRUE;
                    "V8006-O" := FALSE;
                    #Dewater_1.run.in_time.%X1 := FALSE;
                    #Dewater_1.run.step := 5;
                    RETURN;
                END_IF;
            END_IF;
            IF "V8001-O" AND NOT "V8006-O" THEN
                #Dewater_1.run.step := 5;
            END_IF;
        END_IF;
        // 第5步
        IF #Dewater_1.run.step = 5 THEN
            IF NOT "P8001-DO" THEN
                IF #Dewater_1.run.skip THEN
                    "P8001-DO" := TRUE;
                    #Dewater_1.run.skip := FALSE;
                    #Dewater_1.run.step := 6;
                    RETURN;
                END_IF;
                #Dewater_1.run.in_time.%X1 := TRUE;
                IF #Dewater_1.run.in_time.%X1 AND #Timer_D_1[1].Q THEN
                    "P8001-DO" := TRUE;
                    #Dewater_1.run.in_time.%X1 := FALSE;
                    #Dewater_1.run.step := 6;
                    RETURN;
                END_IF;
            END_IF;
            IF "P8001-DO" THEN
                #Dewater_1.run.step := 6;
            END_IF;
        END_IF;
        // 第6步
        IF #Dewater_1.run.step = 6 THEN
            IF NOT "T7001-DO" THEN
                IF #Dewater_1.run.skip THEN
                    "T7001-DO" := TRUE;
                    #Dewater_1.run.skip := FALSE;
                    #Dewater_1.run.step := 7;
                    RETURN;
                END_IF;
                #Dewater_1.run.in_time.%X1 := TRUE;
                IF #Dewater_1.run.in_time.%X1 AND #Timer_D_1[1].Q THEN
                    "T7001-DO" := TRUE;
                    #Dewater_1.run.in_time.%X1 := FALSE;
                    #Dewater_1.run.step := 7;
                    RETURN;
                END_IF;
            END_IF;
            IF "T7001-DO" THEN
                #Dewater_1.run.step := 7;
            END_IF;
        END_IF;
        // 第7步
        IF #Dewater_1.run.step = 7 THEN
            IF NOT "P7006-DO" THEN
                IF #Dewater_1.run.skip THEN
                    IF "Global".Disp_LIT_7001 > "Global".set_LIT_7001 THEN
                        "P7006-DO" := TRUE;
                        #Dewater_1.run.skip := FALSE;
                        #Dewater_1.run.step := 8;
                        RETURN;
                    ELSE
                        RETURN;
                    END_IF;
                END_IF;
                IF "Global".Disp_LIT_7001 > "Global".set_LIT_7001 THEN
                    #Dewater_1.run.in_time.%X1 := TRUE;
                    IF #Dewater_1.run.in_time.%X1 AND #Timer_D_1[1].Q THEN
                        "P7006-DO" := TRUE;
                        #Dewater_1.run.in_time.%X1 := FALSE;
                        #Dewater_1.run.step := 8;
                        RETURN;
                    END_IF; 
                END_IF;
            END_IF;
            IF "P7006-DO" THEN
                #Dewater_1.run.step := 8;
            END_IF;
        END_IF
        // 第8步
        IF #Dewater_1.run.step = 8 THEN
            IF NOT "V7001-O" THEN
                IF #Dewater_1.run.skip THEN
                    "V7001-O" := TRUE;
                    #Dewater_1.run.skip := FALSE;
                    #Dewater_1.run.step := 9;
                    RETURN;
                END_IF;
                #Dewater_1.run.in_time.%X1 := TRUE;
                IF #Dewater_1.run.in_time.%X1 AND #Timer_D_1[1].Q THEN
                    "V7001-O" := TRUE;
                    #Dewater_1.run.in_time.%X1 := FALSE;
                    #Dewater_1.run.step := 9;
                    RETURN;
                END_IF;
            END_IF;
            IF "V7001-O" THEN
                #Dewater_1.run.step := 9;
            END_IF;
        END_IF;
        // 第9步
        IF #Dewater_1.run.step = 9 THEN
            IF NOT "P7001-DO" THEN
                #Dewater_1.run.in_time.%X1 := TRUE;
                IF #Dewater_1.run.in_time.%X1 AND #Timer_D_1[1].Q THEN
                    "P7001-DO" := TRUE;
                    #Dewater_1.run.in_time := 0;
                    #Dewater_1.run.step := 100;
                    RETURN;
                END_IF;
            END_IF;
            IF "P7001-DO" THEN
                #Dewater_1.run.in_time := 0;
                #Dewater_1.run.step := 100;
            END_IF;
        END_IF;
    END_IF;
END_FUNCTION_BLOCK