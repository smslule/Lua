REGION 预处理
    #"FP-valve-Product"(CLK := #"Comm-Valve"."bnt-run");
    #"FP-valve-Manual"(CLK := #"Comm-Valve"."bnt-stop");
    #"Valve-Timer"[0](IN := #"Comm-Valve".busy,PT := #"Screen-Time"."PT-pretime-v");
    #"Valve-Timer"[1](IN := #"Comm-Valve"."in-timer".%X1,PT := #"Screen-Time"."PT-opentime");
    #"Valve-Timer"[2](IN := #"Comm-Valve"."in-timer".%X2,PT := #"Screen-Time"."PT-delaytime");
    #"Valve-Timer"[3](IN := #"Comm-Valve"."in-timer".%X3,PT := #"Screen-Time"."PT-looptime");
    //阀组生产模式
    IF "Debug".Unit_estop_state[2] THEN
        IF (#"FP-valve-Product".Q OR #"Comm-run".todo) AND NOT #"Comm-Valve".busy THEN
            #"Comm-Valve".todo := 1;
        END_IF;
        IF #"Comm-Valve".todo THEN
            #"Comm-Valve".busy := 1;
            #"Comm-Valve".step := 1;
            #"Comm-Valve".todo := 0;
        END_IF;
    ELSE
        #"Comm-Valve"."in-timer" := 0;
        #"Comm-Valve".todo := 0;
        #"Comm-Valve".busy := 0;
        #"Comm-Valve".step := 0;
    END_IF;
    //阀组手动模式
    IF "Debug".Unit_estop_state[2] THEN
        IF (#"FP-valve-Manual".Q OR #"Comm-stop".todo) THEN
            #"Comm-Valve"."in-timer" := 0;
            #"Comm-Valve".todo := 0;
            #"Comm-Valve".busy := 0;
            #"Comm-Valve".step := 0;
            "V5002-O" := 0;
            "V5003-O" := 0;
            "V5004-O" := 0;
            "V5101-O" := 0;
            "V5201-O" := 0;
        END_IF;
    END_IF;
END_REGION
REGION 冲洗阀组生产模式
    IF #"Comm-Valve".busy AND #"Valve-Timer"[0].Q THEN
        //step 1
        IF #"Comm-Valve".step = 1 THEN
            "V5201-O" := 1;
            #"Comm-Valve"."in-timer".%X1 := 1;
            IF #"Comm-Valve"."in-timer".%X1 AND #"Valve-Timer"[1].Q THEN
                "V5201-O" := 0;
                #"Comm-Valve"."in-timer".%X1 := 0;
                #"Comm-Valve"."in-timer".%X2 := 1;
                #"Comm-Valve".step := 2;
            END_IF;
        END_IF;
        //step 2
        IF #"Comm-Valve".step = 2 THEN
            IF #"Comm-Valve"."in-timer".%X2 AND #"Valve-Timer"[2].Q THEN
                "V5004-O" := 1;
                #"Comm-Valve"."in-timer".%X1 := 1;
                #"Comm-Valve"."in-timer".%X2 := 0;
            END_IF;
            IF #"Comm-Valve"."in-timer".%X1 AND #"Valve-Timer"[1].Q THEN
                "V5004-O" := 0;
                #"Comm-Valve"."in-timer".%X1 := 0;
                #"Comm-Valve"."in-timer".%X2 := 1;
                #"Comm-Valve".step := 3;
            END_IF;
        END_IF;
        //step 3
        IF #"Comm-Valve".step = 3 THEN
            IF #"Comm-Valve"."in-timer".%X2 AND #"Valve-Timer"[2].Q THEN
                "V5003-O" := 1;
                #"Comm-Valve"."in-timer".%X1 := 1;
                #"Comm-Valve"."in-timer".%X2 := 0;
            END_IF;
            IF #"Comm-Valve"."in-timer".%X1 AND #"Valve-Timer"[1].Q THEN
                "V5003-O" := 0;
                #"Comm-Valve"."in-timer".%X1 := 0;
                #"Comm-Valve"."in-timer".%X2 := 1;
                #"Comm-Valve".step := 4;
            END_IF;
        END_IF;
        //step 4
        IF #"Comm-Valve".step = 4 THEN
            IF #"Comm-Valve"."in-timer".%X2 AND #"Valve-Timer"[2].Q THEN
                "V5002-O" := 1;
                #"Comm-Valve"."in-timer".%X1 := 1;
                #"Comm-Valve"."in-timer".%X2 := 0;
            END_IF;
            IF #"Comm-Valve"."in-timer".%X1 AND #"Valve-Timer"[1].Q THEN
                "V5002-O" := 0;
                #"Comm-Valve"."in-timer".%X1 := 0;
                #"Comm-Valve"."in-timer".%X2 := 1;
                #"Comm-Valve".step := 5;
            END_IF;
        END_IF;
        //step 5
        IF #"Comm-Valve".step = 5 THEN
            IF #"Comm-Valve"."in-timer".%X2 AND #"Valve-Timer"[2].Q THEN
                "V5101-O" := 1;
                #"Comm-Valve"."in-timer".%X1 := 1;
                #"Comm-Valve"."in-timer".%X2 := 0;
            END_IF;
            IF #"Comm-Valve"."in-timer".%X1 AND #"Valve-Timer"[1].Q THEN
                "V5101-O" := 0;
                #"Comm-Valve"."in-timer".%X1 := 0;
                #"Comm-Valve"."in-timer".%X3 := 1;
            END_IF;
            IF #"Comm-Valve"."in-timer".%X3 AND #"Valve-Timer"[3].Q THEN
                #"Comm-Valve"."in-timer".%X3 := 0;
                #"Comm-Valve".step := 1;
            END_IF;
        END_IF;  
    END_IF;
END_REGION

REGION V4001预处理
    #"Desand-Timer-1"[0](IN := #"Comm-desand-1".busy, PT := #"Desand-Time"."PT-pretime");
    #"Desand-Timer-1"[1](IN := #"Comm-desand-1"."in-timer".%X1,PT := #"Desand-Time"."PT-opentime");
    #"Desand-Timer-1"[2](IN := #"Comm-desand-1"."in-timer".%X2,PT := #"Desand-Time"."PT-looptime");
    //生产模式
    IF "Debug".Unit_estop_state[2] THEN
        IF #"Comm-desand-1"."bnt-run" AND NOT #"Comm-desand-1".busy THEN
            #"Comm-desand-1".todo := 1;
        END_IF;
        IF #"Comm-desand-1".todo THEN
            #"Comm-desand-1".busy := 1;
            #"Comm-desand-1".step := 1;
            #"Comm-desand-1".todo := 0;
        END_IF;
    ELSE
        #"Comm-desand-1"."in-timer" := 0;
        #"Comm-desand-1".todo := 0;
        #"Comm-desand-1".busy := 0;
        #"Comm-desand-1".step := 0;
    END_IF;
    //手动模式
    IF "Debug".Unit_estop_state[2] THEN
        IF #"Comm-desand-1"."bnt-stop" THEN
            #"Comm-desand-1"."in-timer" := 0;
            #"Comm-desand-1".todo := 0;
            #"Comm-desand-1".busy := 0;
            #"Comm-desand-1".step := 0;
            "V4001-O" := 0;
        END_IF;
    END_IF;
END_REGION
REGION V4001生产模式
    IF #"Comm-desand-1".busy AND #"Desand-Timer-1"[0].Q THEN
        //step 1
        IF #"Comm-desand-1".step = 1 THEN
            "V4001-O" := 1;
            #"Comm-desand-1"."in-timer".%X1 := 1;
            IF #"Comm-desand-1"."in-timer".%X1 AND #"Desand-Timer-1"[1].Q THEN
                "V4001-O" := 0;
                #"Comm-desand-1"."in-timer".%X1 := 0;
                #"Comm-desand-1"."in-timer".%X2 := 1;
                #"Comm-desand-1".step := 2;
            END_IF;
        END_IF;
        //step 2
        IF #"Comm-desand-1".step = 2 THEN
            IF #"Comm-desand-1"."in-timer".%X2 AND #"Desand-Timer-1"[2].Q THEN
                #"Comm-desand-1"."in-timer".%X2 := 0;
                #"Comm-desand-1".step := 1;
            END_IF;
        END_IF;
    END_IF;
END_REGION
REGION V6005预处理
    #"Desand-Timer-2"[0](IN := #"Comm-desand-2".busy,PT := #"Desand-Time"."PT-pretime");
    #"Desand-Timer-2"[1](IN := #"Comm-desand-2"."in-timer".%X1,PT := #"Desand-Time"."PT-opentime");
    #"Desand-Timer-2"[2](IN := #"Comm-desand-2"."in-timer".%X2,PT := #"Desand-Time"."PT-looptime");
    //生产模式
    IF "Debug".Unit_estop_state[2] THEN
        IF #"Comm-desand-2"."bnt-run" AND NOT #"Comm-desand-2".busy THEN
            #"Comm-desand-2".todo := 1;
        END_IF;
        IF #"Comm-desand-2".todo THEN
            #"Comm-desand-2".busy := 1;
            #"Comm-desand-2".step := 1;
            #"Comm-desand-2".todo := 0;
        END_IF;
    ELSE
        #"Comm-desand-2"."in-timer" := 0;
        #"Comm-desand-2".todo := 0;
        #"Comm-desand-2".busy := 0;
        #"Comm-desand-2".step := 0;
    END_IF;
    //手动模式
    IF "Debug".Unit_estop_state[2] THEN
        IF #"Comm-desand-2"."bnt-stop" THEN
            #"Comm-desand-2"."in-timer" := 0;
            #"Comm-desand-2".todo := 0;
            #"Comm-desand-2".busy := 0;
            #"Comm-desand-2".step := 0;
            "V6005-O" := 0;
        END_IF;
    END_IF;
END_REGION
REGION V6005生产模式
    IF #"Comm-desand-2".busy AND #"Desand-Timer-2"[0].Q THEN
        //step 1
        IF #"Comm-desand-2".step = 1 THEN
            "V6005-O" := 1;
            #"Comm-desand-2"."in-timer".%X1 := 1;
            IF #"Comm-desand-2"."in-timer".%X1 AND #"Desand-Timer-2"[1].Q THEN
                "V6005-O" := 0;
                #"Comm-desand-2"."in-timer".%X1 := 0;
                #"Comm-desand-2"."in-timer".%X2 := 1;
                #"Comm-desand-2".step := 2;
            END_IF;
        END_IF;
        //step 2
        IF #"Comm-desand-2".step = 2 THEN
            IF #"Comm-desand-2"."in-timer".%X2 AND #"Desand-Timer-2"[2].Q THEN
                #"Comm-desand-2"."in-timer".%X2 := 0;
                #"Comm-desand-2".step := 1;
            END_IF;
        END_IF;
    END_IF;
END_REGION