REGION 预处理
    #open_timer_1(IN:=#i_open.%X1,
                  PT:=#open_time);
    #open_timer_2(IN := #i_open.%X2,
                  PT := #open_time);
    #open_timer_3(IN := #i_open.%X3,
                  PT := #open_time);
    #open_timer_4(IN := #i_open.%X4,
                  PT := #open_time);
    #open_timer_5(IN := #i_open.%X5,
                  PT := #open_time);
    #open_timer_6(IN := #i_open.%X6,
                  PT := #open_time);
    
    #close_timer_1(IN := #i_close.%X1,
                   PT := #close_time);
    #close_timer_2(IN := #i_close.%X2,
                   PT := #close_time);
    #close_timer_3(IN := #i_close.%X3,
                   PT := #close_time);
    #close_timer_4(IN := #i_close.%X4,
                   PT := #close_time);
    #close_timer_5(IN := #i_close.%X5,
                   PT := #close_time);
    #close_timer_6(IN := #i_close.%X6,
                   PT := #close_time);
    #loop_timer(IN := #b_loop,
                PT := #loop_time);
    #"pre-run-timer"(IN := #busy,
                     PT := #"pre-run-time");

    IF NOT(#Mode=5) AND #Mode=1 THEN

        #busy := TRUE;
    ELSE
        #busy := FALSE;
        #out_open := 0;
        #out_close := 0;
        #i_open := 0;
        #i_close := 0;
        #i_step := 0;
    END_IF;
    
END_REGION

REGION 球阀循环控制

    IF #"pre-run-timer".Q THEN
        
        //1 step
        IF #i_step = 0 THEN
            #out_close := 0;
            
            IF #b_loop AND #loop_timer.Q THEN
                #i_open.%X5 := FALSE;
                #out_open.%X1 := TRUE;
                #i_open.%X1 := TRUE;
                #i_close.%X1 := TRUE;
                
                IF #close_timer_1.Q THEN
                    #out_open.%X1 := FALSE;
                    #out_close.%X1 := TRUE;
                    #i_close.%X1 := FALSE;
                    #i_step := 1;  
                END_IF;    
            END_IF;
            IF NOT #b_loop THEN

                #out_open.%X1 := TRUE;
                #i_open.%X1 := TRUE;
                #i_close.%X1 := TRUE;
                
                IF #close_timer_1.Q THEN
                    #out_open.%X1 := FALSE;
                    #out_close.%X1 := TRUE;
                    #i_close.%X1 := FALSE;
                    #i_step := 1;
                    
                END_IF;
                
            END_IF;
        END_IF;
        
        //2 step
        IF #i_step=1 AND #i_open.%X1 AND #open_timer_1.Q THEN
                #i_open.%X6 := FALSE;
                #out_open.%X2 := TRUE;
                #i_open.%X2 := TRUE;
                #i_close.%X2 := TRUE;
               
                
                IF #close_timer_2.Q THEN
                    #out_open.%X2 := FALSE;
                    #out_close.%X2 := TRUE;
                    #i_close.%X2 := FALSE;
                    #i_step := 2;
                    
                    
                END_IF;
            
            END_IF;
            
            //3 step
            IF #i_step = 2 AND #i_open.%X2 AND #open_timer_2.Q THEN
                #i_open.%X1 := FALSE;
                #out_open.%X3 := TRUE;
                #i_open.%X3 := TRUE;
                #i_close.%X3 := TRUE;
                
                
                IF #close_timer_3.Q THEN
                    #out_open.%X3 := FALSE;
                    #out_close.%X3 := TRUE;
                    #i_close.%X3 := FALSE;
                    #i_step := 3;
                    
                    
                END_IF;
                
            END_IF;
            
            //4 step
            IF #i_step = 3 AND #i_open.%X3 AND #open_timer_3.Q THEN
                #i_open.%X2 := FALSE;
                #out_open.%X4 := TRUE;
                #i_open.%X4 := TRUE;
                #i_close.%X4 := TRUE;
                
                
                IF #close_timer_4.Q THEN
                    #out_open.%X4 := FALSE;
                    #out_close.%X4 := TRUE;
                    #i_close.%X4 := FALSE;
                    #i_step := 4;
                    
                    
                END_IF;
                
            END_IF;
            
            //5 step
            IF #i_step = 4 AND #i_open.%X4 AND #open_timer_4.Q THEN
                #i_open.%X3 := FALSE;
                #out_open.%X5 := TRUE;
                #i_open.%X5 := TRUE;
                #i_close.%X5 := TRUE;
               
                
                IF #close_timer_5.Q THEN
                    #out_open.%X5 := FALSE;
                    #out_close.%X5 := TRUE;
                    #i_close.%X5 := FALSE;
                    #i_step := 5;
                   
                    
                END_IF;
                
            END_IF;
            
            //6 step
            IF #i_step = 5 AND #i_open.%X5 AND #open_timer_5.Q THEN
                #b_loop := 0;
                #i_open.%X4 := FALSE;
                #out_open.%X6 := TRUE;

                #i_close.%X6 := TRUE;
                
                
                IF #close_timer_6.Q THEN
                    #out_open.%X6 := FALSE;
                    #out_close.%X6 := TRUE;
                    #b_loop := 1;
                    #i_close.%X6 := FALSE;
                    #i_step := 0;
                END_IF;

            END_IF;
            
            
    END_IF;
    
    
END_REGION

