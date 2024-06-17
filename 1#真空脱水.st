FUNCTION_BLOCK Dewater
    VAR_STATIC
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

        CIP_1: "CIP"	
        bnt_run: BOOL			启动按钮
        bnt_stop: BOOL			停止按钮
        todo: BOOL			    初始化
        busy: BOOL			    执行中
        step: INT			    步数
        in_time: WORD			计时器输入IN
        error: INT			    错误
        state: INT			    状态

	    Timer_CIP_1	Array[0..10] of TON_TIME	

        Retain_time_CIP_1: "CIP_time"		
        preTime: DINT		
        stepTime_1: DINT		
        stepTime_2: DINT		
        T102: DINT	
        T103: DINT	
        T104: DINT	
        T105: DINT	
        T106: DINT	
        T110: DINT			
        T107: DINT	
        T108: DINT	
        T109: DINT	
    END_VAR

    /*
        真空脱水一键启动
    */
    // 计时器
    Timer_D_1[0] (IN := #Dewater_1.run.in_time.%X0, PT := #Retain_time_D_1.preTime);
    Timer_D_1[1] (IN := #Dewater_1.run.in_time.%X1, PT := #Retain_time_D_1.openTime_1);

    // 预处理
    IF "Global".Emergency.Dewater_1 THEN
        IF #Dewater_1.bnt_run AND NOT #Dewater_1.run.busy THEN
            "V8016-O" := FALSE;
            "V8021-O" := FALSE;
            "V8011-O" := FALSE;
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
        END_IF;
        IF #Dewater_1.run.in_time.%X0 AND #Timer_D_1[0].Q THEN
            #Dewater_1.run.busy := TRUE;
            #Dewater_1.run.todo := FALSE;
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

    /*
        CIP在线清洗
    */
    REGION 计时器
        #Timer_CIP_1[0](IN:=#CIP_1.in_time.%X0, PT:=#Retain_time_CIP_1.preTime);
        #Timer_CIP_1[1](IN := #CIP_1.in_time.%X1, PT := #Retain_time_CIP_1.stepTime_1);
        #Timer_CIP_1[2](IN := #CIP_1.in_time.%X2, PT := #Retain_time_CIP_1.T102);
        #Timer_CIP_1[3](IN := #CIP_1.in_time.%X3, PT := #Retain_time_CIP_1.T103);
        #Timer_CIP_1[4](IN := #CIP_1.in_time.%X4, PT := #Retain_time_CIP_1.T104);
        #Timer_CIP_1[5](IN := #CIP_1.in_time.%X5, PT := #Retain_time_CIP_1.T105);
        #Timer_CIP_1[6](IN := #CIP_1.in_time.%X6, PT := #Retain_time_CIP_1.T106);
        #Timer_CIP_1[7](IN := #CIP_1.in_time.%X7, PT := #Retain_time_CIP_1.T107);
        #Timer_CIP_1[8](IN := #CIP_1.in_time.%X8, PT := #Retain_time_CIP_1.T108);
        #Timer_CIP_1[9](IN := #CIP_1.in_time.%X9, PT := #Retain_time_CIP_1.T109);
        #Timer_CIP_1[10](IN := #CIP_1.in_time.%X10, PT := #Retain_time_CIP_1.T110);
    END_REGION

    REGION 预处理
        // 初始化
        IF "Global".Emergency.Dewater_1 THEN
            IF #Dewater_1.state = 1 AND #Dewater_1.run.step = 100 AND #CIP_1.bnt_run AND NOT #CIP_1.busy THEN
                #CIP_1.todo := TRUE;
            END_IF;
            IF #CIP_1.todo THEN
                #CIP_1.state := 1;
                #CIP_1.step := 1;
                #CIP_1.in_time := 0;
                #CIP_1.in_time.%X0 := TRUE;
                #CIP_1.bnt_run := FALSE;
                #CIP_1.todo := FALSE;
            END_IF;
            IF #CIP_1.in_time.%X0 AND #Timer_CIP_1[0].Q THEN
                #CIP_1.busy := TRUE;
            ELSE
                #CIP_1.busy := FALSE;
            END_IF;
        ELSE
            #CIP_1.state := 0;
            #CIP_1.step := 0;
            #CIP_1.in_time := 0;
        END_IF;
    END_REGION

    REGION CIP运行中
        IF #CIP_1.busy AND #CIP_1.state = 1 THEN
            // step 1
            IF #CIP_1.step = 1 THEN
                "V8006-O" := TRUE;
                #CIP_1.step := 2;
            END_IF;
            // step 2
            IF #CIP_1.step = 2 THEN
                #CIP_1.in_time.%X2 := TRUE;
                IF #CIP_1.in_time.%X2 AND #Timer_CIP_1[2].Q THEN
                    "V8001-O" := FALSE;
                    #CIP_1.in_time.%X2:= FALSE;
                    #CIP_1.step := 3;
                END_IF;
            END_IF;
            // step 3
            IF #CIP_1.step = 3 THEN
                #CIP_1.in_time.%X3 := TRUE;
                IF #CIP_1.in_time.%X3 AND #Timer_CIP_1[3].Q THEN
                    "P8001-DO" := FALSE;
                    "Global".PID_7101.Man_enable := TRUE;
                    "Global".PID_7101.Man_value := 0;
                    "V8006-O" := FALSE;
                    "V8011-O" := TRUE;
                    #CIP_1.in_time.%X3 := FALSE;
                    #CIP_1.step := 4;
                END_IF;
            END_IF;
            // step 4
            IF #CIP_1.step = 4 THEN
                #CIP_1.in_time.%X4 := TRUE;
                IF #CIP_1.in_time.%X4 AND #Timer_CIP_1[4].Q THEN
                    "V8011-O" := FALSE;
                    #CIP_1.in_time.%X4 := FALSE;
                    #CIP_1.step := 5;
                END_IF;
            END_IF;
            // step 5
            IF #CIP_1.step = 5 THEN
                #CIP_1.in_time.%X1 := TRUE;
                IF #CIP_1.in_time.%X1 AND #Timer_CIP_1[1].Q THEN
                    "KV7001-O" := FALSE;
                    #CIP_1.in_time.%X1 := FALSE;
                    #CIP_1.step := 6;
                    RETURN;
                END_IF;
            END_IF;
            // step 6
            IF #CIP_1.step = 6 THEN
                #CIP_1.in_time.%X1 := TRUE;
                IF #CIP_1.in_time.%X1 AND #Timer_CIP_1[1].Q THEN
                    "P7001-DO" := FALSE;
                    "V7001-O" := FALSE;
                    #CIP_1.in_time.%X1 := FALSE;
                    #CIP_1.step := 7;
                    RETURN;
                END_IF;
            END_IF;
            // step 7
            IF #CIP_1.step = 7 THEN
                #CIP_1.in_time.%X1 := TRUE;
                IF #CIP_1.in_time.%X1 AND #Timer_CIP_1[1].Q THEN
                    "P7006-DO" := FALSE;
                    #CIP_1.in_time.%X1 := FALSE;
                    #CIP_1.step := 8;
                    RETURN;
                END_IF;
            END_IF;
            // step 8
            IF #CIP_1.step = 8 THEN
                #CIP_1.in_time.%X1 := TRUE;
                IF #CIP_1.in_time.%X1 AND #Timer_CIP_1[1].Q THEN
                    "T7001-DO" := FALSE;
                    #CIP_1.in_time.%X1 := FALSE;
                    #CIP_1.step := 9;
                    RETURN;
                END_IF;
            END_IF;
            // step 9
            IF #CIP_1.step = 9 THEN
                #CIP_1.in_time.%X1 := TRUE;
                IF #CIP_1.in_time.%X1 AND #Timer_CIP_1[1].Q THEN
                    "V8016-O" := TRUE;
                    "V8017-O" := FALSE;
                    "V8018-O" := FALSE;
                    "V8019-O" := FALSE;
                    "V8020-O" := FALSE;
                    "V8021-O" := FALSE;
                    #CIP_1.in_time.%X1 := FALSE;
                    #CIP_1.step := 901;
                    RETURN;
                END_IF;
            END_IF;
            // step 901
            IF #CIP_1.step = 901 THEN
                #CIP_1.in_time.%X1 := TRUE;
                IF #CIP_1.in_time.%X1 AND #Timer_CIP_1[1].Q THEN
                    "P8007-DO" := TRUE;
                    #CIP_1.in_time.%X1 := FALSE;
                    #CIP_1.step := 10;
                    RETURN;
                END_IF;
            END_IF;
            // step 10
            IF #CIP_1.step = 10 THEN
                #CIP_1.in_time.%X5 := TRUE;
                IF #CIP_1.in_time.%X5 AND #Timer_CIP_1[5].Q THEN
                    "P8007-DO" := FALSE;
                    "V8016-O" := FALSE;
                    #CIP_1.in_time.%X5 := FALSE;
                    #CIP_1.step := 11;
                END_IF;
            END_IF;
            // step 11
            IF #CIP_1.step = 11 THEN
                #CIP_1.in_time.%X6 := TRUE;
                IF #CIP_1.in_time.%X6 AND #Timer_CIP_1[6].Q THEN
                    "V8026-O" := TRUE;
                    "V8032-O" := TRUE;
                    #CIP_1.in_time.%X6 := FALSE;
                    #CIP_1.step := 12;
                END_IF;
            END_IF;
            // step 12
            IF #CIP_1.step = 12 THEN
                #CIP_1.in_time.%X10 := TRUE;
                IF #CIP_1.in_time.%X10 AND #Timer_CIP_1[10].Q THEN
                    "V8032-O" := FALSE;
                    "Global".set_Hz_F7001 := 10.0;
                    #CIP_1.in_time.%X10 := FALSE;
                    #CIP_1.step := 13;
                END_IF;
            END_IF;
            // step 13
            IF #CIP_1.step = 13 THEN
                #CIP_1.in_time.%X1 := TRUE;
                IF #CIP_1.in_time.%X1 AND #Timer_CIP_1[1].Q THEN
                    "V8016-O" := TRUE;
                    "V8017-O" := FALSE;
                    "V8018-O" := FALSE;
                    "V8019-O" := FALSE;
                    "V8020-O" := FALSE;
                    "V8021-O" := FALSE;
                    #CIP_1.in_time.%X1 := FALSE;
                    #CIP_1.step := 1301;
                    RETURN;
                END_IF;
            END_IF;
            // step 1301
            IF #CIP_1.step = 1301 THEN
                #CIP_1.in_time.%X1 := TRUE;
                IF #CIP_1.in_time.%X1 AND #Timer_CIP_1[1].Q THEN
                    "P8007-DO" := TRUE;
                    #CIP_1.in_time.%X1 := FALSE;
                    #CIP_1.step := 14;
                    RETURN;
                END_IF;
            END_IF;
            // step 14
            IF #CIP_1.step = 14 THEN
                #CIP_1.in_time.%X7 := TRUE;
                IF #CIP_1.in_time.%X7 AND #Timer_CIP_1[7].Q THEN
                    "P8007-DO" := FALSE;
                    "V8016-O" := FALSE;
                    #CIP_1.in_time.%X7 := FALSE;
                    #CIP_1.step := 15;
                END_IF;
            END_IF;
            // step 15
            IF #CIP_1.step = 15 THEN
                #CIP_1.in_time.%X8 := TRUE;
                IF #CIP_1.in_time.%X8 AND #Timer_CIP_1[8].Q THEN
                    "V8026-O" := FALSE;
                    "V8031-O" := TRUE;
                    #CIP_1.in_time.%X8 := FALSE;
                    #CIP_1.step := 16;
                END_IF;
            END_IF;
            // step 16
            IF #CIP_1.step = 16 THEN
                #CIP_1.in_time.%X9 := TRUE;
                IF #CIP_1.in_time.%X9 AND #Timer_CIP_1[9].Q THEN
                    "V8031-O" := FALSE;
                    #CIP_1.in_time.%X9 := FALSE;
                    #CIP_1.step := 17;
                END_IF;
            END_IF;
            // step 17
            IF #CIP_1.step = 17 THEN
                #CIP_1.in_time.%X1 := TRUE;
                IF #CIP_1.in_time.%X1 AND #Timer_CIP_1[1].Q THEN
                    "A7001-DO" := FALSE;
                    #CIP_1.in_time.%X1 := FALSE;
                    #CIP_1.step := 18;
                    RETURN;
                END_IF;
            END_IF;
            // step 18
            IF #CIP_1.step = 18 THEN
                #CIP_1.in_time.%X1 := TRUE;
                IF #CIP_1.in_time.%X1 AND #Timer_CIP_1[1].Q THEN
                    "F7001-DO" := FALSE;
                    #CIP_1.in_time.%X1 := FALSE;
                    #CIP_1.step := 19;
                END_IF;
            END_IF; 
        END_IF;
    END_REGION
END_FUNCTION_BLOCK

	
