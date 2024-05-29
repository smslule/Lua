FUNCTION_BLOCK Extraction
    VAR_GLOBAL
        //提取单元自动启动关键属性--结构体
        TYPE Common_M_1_run : STRUCT
                bnt_run : BOOL; (* 自动启动 *)
                bnt_stop : BOOL; (* 自动停止 *)
                todo : BOOL; (* 是否跳过步骤1 *)
                busy : BOOL; (* 自动正在执行 *)
                step : INT; (* 自动运行步骤 *)
                in_time : WORD; (* 控制计时器输入IN通断 *)
                manual_enable : BOOL; (* 手动模式按钮 *)
                state : INT; (* 提取单元状态都在此处显示 *)
            END_STRUCT
        END_TYPE

        //提取单元自动启动设定时间--结构体
        TYPE Retain_M5000_run : STRUCT
                preTime : DINT; (* 自动启动预处理时间 *)
                openTime_1 : DINT; (* 自动启动电机延时打开时间 *)
            END_STRUCT
        END_TYPE

        //提取单元启动--通电延时计时器
        Timer_M5000_run : ARRAY[0..2] of TON_TIME;
        (* 
            Timer_M5000_run[0]......预处理--计时器
            Timer_M5000_run[1]......电机打开延时--计时器
        *)  
    END_VAR

    /* *
    **计时器
    */
    #Timer_M5000_run[0](IN := #Common_M_1_run.in_time.%X0, PT := #Retain_M5000_run.preTime);
    #Timer_M5000_run[1](IN := #Common_M_1_run.in_time.%X1, PT := #Retain_M5000_run.openTime_1);

    /* *
    **预处理
    */
    IF "Global".Emergency.Extraction_1 AND #Common_M_1_run.bnt_run AND NOT #Common_M_1_run.busy THEN
    #Common_M_1_run.state := 1;
    #Common_M_1_run.step := 1;
    #Common_M_1_run.in_time := 0;
    #Common_M_1_run.todo := FALSE;
    #Common_M_1_run.in_time.%X0 := TRUE;
    END_IF;
    IF #Common_M_1_run.in_time.%X0 AND #Timer_M5000_run[0].Q THEN
    #Common_M_1_run.bnt_run := FALSE;
    #Common_M_1_run.busy := TRUE;
    ELSE
    #Common_M_1_run.busy := FALSE;
    END_IF;

    //急停时
    IF NOT "Global".Emergency.Extraction_1 THEN
    #Common_M_1_run.state := 0;
    #Common_M_1_run.step := 0;
    #Common_M_1_run.in_time := 0;
    #Common_M_1_run.bnt_run := FALSE;
    END_IF;

    //手动时
    IF "Global".Emergency.Extraction_1 AND #Common_M_1_run.manual_enable THEN
    #Common_M_1_run.state := 2;
    #Common_M_1_run.step := 0;
    #Common_M_1_run.in_time := 0;
    #Common_M_1_run.bnt_run := FALSE;
    END_IF;

    //停止时
    IF "Global".Emergency.Extraction_1 AND #Common_M_1_run.bnt_stop THEN
    #Common_M_1_run.step := 0;
    #Common_M_1_run.in_time := 0;
    #Common_M_1_run.bnt_run := FALSE;
    END_IF;

    /* *
    **运行时
    */
    IF #Common_M_1_run.busy AND #Common_M_1_run.state = 1 THEN
        //step1
        IF #Common_M_1_run.step = 1 THEN
            IF NOT "M5203-DO" THEN
                "M5203-DO" := TRUE;
                #Common_M_1_run.step := 2;
                RETURN;
            END_IF;
            IF "M5203-DO" THEN
                #Common_M_1_run.todo := TRUE;
                #Common_M_1_run.step := 2;
            END_IF;
        END_IF;
        //step2
        IF #Common_M_1_run.step = 2 THEN
            IF NOT "M5103-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "M5103-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 3;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "M5103-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 3;
                    RETURN;
                END_IF;
            END_IF;
            IF "M5103-DO" THEN
                #Common_M_1_run.step := 3;
            END_IF;
        END_IF;
        //step3
        IF #Common_M_1_run.step = 3 THEN
            IF NOT "M5202-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "M5202-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 4;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "M5202-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 4;
                    RETURN;
                END_IF;
            END_IF;
            IF "M5202-DO" THEN
                #Common_M_1_run.step := 4;
            END_IF;
        END_IF;
        //step4
        IF #Common_M_1_run.step = 4 THEN
            IF NOT "M5102-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "M5102-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 5;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "M5102-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 5;
                    RETURN;
                END_IF;
            END_IF;
            IF "M5102-DO" THEN
                #Common_M_1_run.step := 5;
            END_IF;
        END_IF;
        //step5
        IF #Common_M_1_run.step = 5 THEN
            IF NOT "M5401-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "M5401-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 6;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "M5401-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 6;
                    RETURN;
                END_IF;
            END_IF;
            IF "M5401-DO" THEN
                #Common_M_1_run.step := 6;
            END_IF;
        END_IF;
        //step6
        IF #Common_M_1_run.step = 6 THEN
            IF NOT "M5301-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "M5301-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 7;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "M5301-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 7;
                    RETURN;
                END_IF;
            END_IF;
            IF "M5301-DO" THEN
                #Common_M_1_run.step := 7;
            END_IF;
        END_IF;
        //step7
        IF #Common_M_1_run.step = 7 THEN
            IF NOT "M5201-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "M5201-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 8;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "M5201-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 8;
                    RETURN;
                END_IF;
            END_IF;
            IF "M5201-DO" THEN
                #Common_M_1_run.step := 8;
            END_IF;
        END_IF;
        //step8
        IF #Common_M_1_run.step = 8 THEN
            IF NOT "M5101-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "M5101-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 9;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "M5101-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 9;
                    RETURN;
                END_IF;
            END_IF;
            IF "M5101-DO" THEN
                #Common_M_1_run.step := 9;
            END_IF;
        END_IF;
        //step9
        IF #Common_M_1_run.step = 9 THEN
            IF NOT "P5005-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5005-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 10;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5005-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 10;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5005-DO" THEN
                #Common_M_1_run.step := 10;
            END_IF;
        END_IF;
        //step10
        IF #Common_M_1_run.step = 10 THEN
            IF NOT "P5003-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5003-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 11;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5003-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 11;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5003-DO" THEN
                #Common_M_1_run.step := 11;
            END_IF;
        END_IF;
        //step11
        IF #Common_M_1_run.step = 11 THEN
            IF NOT "P5201-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5201-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 12;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5201-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 12;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5201-DO" THEN
                #Common_M_1_run.step := 12;
            END_IF;
        END_IF;
        //step12
        IF #Common_M_1_run.step = 12 THEN
            IF NOT "P5101-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5101-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 13;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5101-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 13;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5101-DO" THEN
                #Common_M_1_run.step := 13;
            END_IF;
        END_IF;
        //step13
        IF #Common_M_1_run.step = 13 THEN
            IF NOT "P5206-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5206-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 14;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5206-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 14;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5206-DO" THEN
                #Common_M_1_run.step := 14;
            END_IF;
        END_IF;
        //step14
        IF #Common_M_1_run.step = 14 THEN
            IF NOT "P5106-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5106-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 15;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5106-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 15;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5106-DO" THEN
                #Common_M_1_run.step := 15;
            END_IF;
        END_IF;
        //step15
        IF #Common_M_1_run.step = 15 THEN
            IF NOT "P5204-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5204-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 16;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5204-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 16;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5204-DO" THEN
                #Common_M_1_run.step := 16;
            END_IF;
        END_IF;
        //step16
        IF #Common_M_1_run.step = 16 THEN
            IF NOT "P5104-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5104-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 17;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5104-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 17;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5104-DO" THEN
                #Common_M_1_run.step := 17;
            END_IF;
        END_IF;
        //step17
        IF #Common_M_1_run.step = 17 THEN
            IF NOT "P5402-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5402-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 18;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5402-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 18;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5402-DO" THEN
                #Common_M_1_run.step := 18;
            END_IF;
        END_IF;
        //step18
        IF #Common_M_1_run.step = 18 THEN
            IF NOT "P5302-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5302-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 19;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5302-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 19;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5302-DO" THEN
                #Common_M_1_run.step := 19;
            END_IF;
        END_IF;
        //step19
        IF #Common_M_1_run.step = 19 THEN
            IF NOT "P5202-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5202-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.step := 20;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5202-DO" := TRUE;
                    #Common_M_1_run.in_time.%X1 := FALSE;
                    #Common_M_1_run.step := 20;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5202-DO" THEN
                #Common_M_1_run.step := 20;
            END_IF;
        END_IF;
        //step20
        IF #Common_M_1_run.step = 20 THEN
            IF NOT "P5102-DO" THEN
                IF #Common_M_1_run.todo THEN
                    "P5102-DO" := TRUE;
                    #Common_M_1_run.todo := FALSE;
                    #Common_M_1_run.in_time := 0;
                    #Common_M_1_run.step := 100;
                    RETURN;
                END_IF;
                #Common_M_1_run.in_time.%X1 := TRUE;
                IF #Common_M_1_run.in_time.%X1 AND #Timer_M5000_run[1].Q THEN
                    "P5102-DO" := TRUE;
                    #Common_M_1_run.in_time := 0;
                    #Common_M_1_run.step := 100;
                    RETURN;
                END_IF;
            END_IF;
            IF "P5102-DO" THEN
                #Common_M_1_run.in_time := 0;
                #Common_M_1_run.step := 100;
            END_IF;
        END_IF;
    END_IF;    
END_FUNCTION_BLOCK

