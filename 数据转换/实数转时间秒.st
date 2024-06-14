/* 变量声明 */
VAR_INPUT
    IN: REAL; 
END_VAR
VAR_OUTPUT
    OUT: TIME;
END_VAR
VAR_TEMP
    temp-time:DINT;
END_VAR
VAR CONSTANT
    uint:REAL:=1000.0;
END_VAR


/* 转换逻辑，STL汇编语言，例如:输入1.5,输出1500. */
PROGRAM SecondsConvert
    L     #IN
    L     #unit
    *R
    RND
    T     #"temp-time"
    CALL  T_CONV
        src_type:=DInt
        dest_type:=Time
        IN  :=#"temp-time"
        OUT :=#OUT
END_PROGRAM
