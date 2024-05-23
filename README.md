# 自动化生产线相关控制指南

为实现工业自动化生产线相关控制标准化。

## 原著

- 作者：Lei Liu
- 版本：Revision 0, 01 Mar 2024
- 版权：公共领域(Public Domain)

## 参与人员（排序不分先后）

@smslule

- [ ] **待办事项**
  - [ ] 1
  - [ ] 2

```iecst
VAR_STATIC
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
```
