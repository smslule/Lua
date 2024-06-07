FUNCTION_BLOCK Dewater
    VAR_STAT
        // 1#真空脱水控制流--结构体
        TYPE Dewater_1: STRUCT
                bnt_run: BOOL; (* 启动按钮 *)
                bnt_stop: BOOL; (* 停止按钮 *)
                bnt_manual: BOOL; (* 手动按钮 *)
                state: INT; (* 状态 *)
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
    Timer_D_1[0](IN := #Dewater_1.run.in_time.%X0, PT := #Retain_time_D_1.preTime);
    Timer_D_1[1](IN := #Dewater_1.run.in_time.%X0, PT := #Retain_time_D_1.openTime_1);

    // 预处理
    IF "Global".Emergency.Dewater_1 THEN
        IF #Dewater_1.bnt_run AND NOT #Dewater_1.run.busy THEN
            #Dewater_1.run.todo := TRUE;
        END_IF;
        IF #Dewater_1.run.todo THEN
            #Dewater_1.state := 1;
            #Dewater_1.run.step := 1;
            #Dewater_1.run.skip := FALSE;
            #Dewater_1.run.in_time := 0;
            #Dewater_1.run.in_time.%X0 := TRUE;
            "ALARM1-O" := TRUE;
            #Dewater_1.bnt_run := FALSE;
            #Dewater_1.run.todo := FALSE;
        END_IF;
        
    END_IF;


END_FUNCTION_BLOCK