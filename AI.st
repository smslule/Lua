PROGRAM MainProgram;
VAR
    Motor1: BOOL; // 电机1的输出变量
    Motor2: BOOL; // 电机2的输出变量
    Motor3: BOOL; // 电机3的输出变量
END_VAR

// 电机启动顺序程序块
PROGRAM MotorStartupSequence;
VAR
    seqStep: INT; // 顺序步骤变量
END_VAR

// 顺序功能块，用于控制电机启动顺序
SEQ seqMotorStartup;

// 程序块主体
BEGIN
    seqMotorStartup(
        IN:= NOT seqMotorStartup.Q, // 当顺序功能块完成时，输入信号变为0
        Q0:= seqStep = 0, // 当顺序步骤为0时，输出Q0为1
        Q1:= seqStep = 1, // 当顺序步骤为1时，输出Q1为1
        Q2:= seqStep = 2  // 当顺序步骤为2时，输出Q2为1
    );

    // 根据顺序功能块的输出，控制电机的启动
    Motor1 := seqMotorStartup.Q0;
    Motor2 := seqMotorStartup.Q1;
    Motor3 := seqMotorStartup.Q2;

    // 如果所有电机都启动，增加顺序步骤
    IF seqMotorStartup.Q2 THEN
        seqStep := seqStep + 1;
    END_IF;
END_PROGRAM

// 主程序调用电机启动顺序程序块
BEGIN
    MotorStartupSequence();
END_PROGRAM
