
//自动放料回料控制
IF ("Databas".Xuanliu_V50XX_Tab = 1) THEN
    //放料控制
    IF ("Databas".自动模式放料) THEN                   
        "V5007-O" := 0;
        IF "Databas".放料通道选择 = 1 THEN
            "V5001-O" := TRUE;
            "V5002-O" := FALSE;
            //去4#反应罐
            IF "Databas".反应罐通道选择 = 1 THEN
                "V5004-O" := TRUE;
                "V5006-O" := TRUE;
                "V5003-O" := FALSE;
                "V5005-O" := FALSE;
            END_IF;
            //去5#反应罐
            IF "Databas".反应罐通道选择 = 2 THEN
                "V5004-O" := TRUE;
                "V5005-O" := TRUE;
                "V5003-O" := FALSE;
                "V5006-O" := FALSE; 
            END_IF;
            //去6#反应罐
            IF "Databas".反应罐通道选择 = 3 THEN
                "V5003-O" := TRUE;
                "V5004-O" := FALSE;
                "V5005-O" := FALSE;
                "V5006-O" := FALSE;   
            END_IF;     
        END_IF;
        IF "Databas".放料通道选择 = 2 THEN
            "V5001-O" := FALSE;
            "V5002-O" := TRUE;
        END_IF;
    END_IF;
    //回料控制
    IF ("Databas".自动模式回料) THEN                  
        "V5007-O" := 1;
        "V5001-O" := FALSE;
        "V5002-O" := FALSE;
    END_IF;  
END_IF;


//......2023-10-19 @smslule现场修改
IF "Databas".Xuanliu_V50XX_Tab = 0 THEN
    
    IF ("Databas".手动放料按钮) THEN
     //手动放料控制
        "V5007-O" := 0;
        IF "Databas".放料通道选择 = 1 THEN
            "V5001-O" := TRUE;
            "V5002-O" := FALSE;
            //去4#反应罐
            IF "Databas".反应罐通道选择 = 1 THEN
                "V5004-O" := TRUE;
                "V5006-O" := TRUE;
                "V5003-O" := FALSE;
                "V5005-O" := FALSE; 
            END_IF;
            //去5#反应罐
            IF "Databas".反应罐通道选择 = 2 THEN
                "V5004-O" := TRUE;
                "V5005-O" := TRUE;
                "V5003-O" := FALSE;
                "V5006-O" := FALSE;   
            END_IF;
            //去6#反应罐
            IF "Databas".反应罐通道选择 = 3 THEN
                "V5003-O" := TRUE;
                "V5004-O" := FALSE;
                "V5005-O" := FALSE;
                "V5006-O" := FALSE;     
            END_IF;   
        END_IF;
        IF "Databas".放料通道选择 = 2 THEN
            "V5001-O" := FALSE;
            "V5002-O" := TRUE;    
        END_IF;
        "Databas".手动放料按钮 := FALSE;   
    END_IF;
    IF ("Databas".手动回料按钮) THEN
    //手动回料控制
        "V5007-O" := 1;
        "V5001-O" := FALSE;
        "V5002-O" := FALSE;
        "Databas".手动回料按钮 := FALSE;   
    END_IF;
    IF "Databas".手动淀粉乳阀 THEN
        "V5007-O" := 0;
        "V5001-O" := 0;
        "V5003-O" := 0;
        "V5004-O" := 0;
        "V5005-O" := 0;
        "V5006-O" := 0;
        "V5002-O" := 1;
        "Databas".手动淀粉乳阀 := FALSE;
    END_IF;
    IF "Databas".手动反应罐阀 THEN
        "V5007-O" := 0;
        "V5002-O" := 0;
        "V5001-O" := 1;
        "Databas".手动反应罐阀 := FALSE;
    END_IF;
    IF "Databas"."手动4#罐阀" THEN  
        "V5007-O" := 0;
        "V5002-O" := 0;
        "V5003-O" := 0;
        "V5004-O" := 1;
        "V5005-O" := 0;
        "V5006-O" := 1;
        "V5001-O" := 1;
        "Databas"."手动4#罐阀" := FALSE;
    END_IF;
    IF "Databas"."手动5#罐阀" THEN
        "V5007-O" := 0;
        "V5002-O" := 0;
        "V5003-O" := 0;
        "V5004-O" := 1;
        "V5005-O" := 1;
        "V5006-O" := 0;
        "V5001-O" := 1;
        "Databas"."手动5#罐阀" := FALSE;
    END_IF;
    IF "Databas"."手动6#罐阀" THEN
        "V5007-O" := 0;
        "V5002-O" := 0;
        "V5003-O" := 1;
        "V5004-O" := 0;
        "V5005-O" := 0;
        "V5006-O" := 0;
        "V5001-O" := 1;
        "Databas"."手动6#罐阀" := FALSE;
    END_IF;   
END_IF;

IF "V5002-O" OR "V5001-O" THEN
    "Databas".放料状态显示 := 1;   
END_IF;

IF "V5002-O"=0 AND "V5001-O"=0 THEN
    "Databas".放料状态显示 := 2;   
END_IF;

IF "Databas".反应罐方向按钮 THEN
    "Databas".放料通道选择 := 1;
    "Databas".反应罐方向按钮 := FALSE;
END_IF;

IF "Databas".淀粉乳罐方向按钮 THEN
    "Databas".反应罐通道选择 := 0;
    "Databas".放料通道选择 := 2;
    "Databas".淀粉乳罐方向按钮 := FALSE;
END_IF;
//选择4#反应罐
IF "Databas".反应罐方向1按钮 THEN
    "Databas".放料通道选择 := 1;
    "Databas".反应罐通道选择 := 1;
    "Databas".反应罐方向1按钮 := FALSE;
END_IF;  
//选择5#反应罐
IF "Databas".反应罐方向2按钮 THEN
    "Databas".放料通道选择 := 1;
    "Databas".反应罐通道选择 := 2;
    "Databas".反应罐方向2按钮 := FALSE;
END_IF;   
//选择6#反应罐
IF "Databas".反应罐方向3按钮 THEN
    "Databas".放料通道选择 := 1;
    "Databas".反应罐通道选择 := 3;
    "Databas".反应罐方向3按钮 := FALSE;
END_IF;

IF (("Databas".Xuanliu_V50XX_Tab = 1) AND ("Databas".DIT5001_AI < "Databas".Xuanliu_DIT5001_L)) THEN
    "Databas".自动模式回料 := TRUE;
    "Databas".自动模式放料 := FALSE;
END_IF;

IF (("Databas".Xuanliu_V50XX_Tab = 1) AND ("Databas".DIT5001_AI > "Databas".Xuanliu_DIT5001_H)) THEN
    "Databas".自动模式放料 := TRUE;
    "Databas".自动模式回料 := FALSE;
END_IF;
