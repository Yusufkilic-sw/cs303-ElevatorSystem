`timescale 1ns / 1ps

module elevator(

input clk_50hz, rst,

floor_0_p, //outside
floor_1_p,
floor_2_p,
floor_3_p,
floor_4_p,

direction_1,
direction_2,
direction_3,//for outside

floor_0_d,//inside
floor_1_d,
floor_2_d,
floor_3_d,
floor_4_d,

output reg led_inside_0,
led_inside_1,
led_inside_2,
led_inside_3,
led_inside_4,

led_outside_0,
led_outside_1,
led_outside_2,
led_outside_3,
led_outside_4,

continue,

reg [7:0] a,b,c,d,e,f,g,p
);

reg [3:0]floor; 
reg direction;//1 up 0 down
integer current_floor =0;
integer destination =0; // 0 denotes no current destination
reg led_busy = 0;
parameter IDLE = 3'b000,FLOOR0 =3'b001,FLOOR1 = 3'b010,FLOOR2 = 4'b011,FLOOR3 = 4'b100,FLOOR4 = 4'b101;
 parameter MOVE_SPEED = 120;
 parameter WAIT_TIME = 120;
     reg [24:0] cnt =0;
     reg [24:0] wit =0;
    // rst is used as clock posedge clk_50hz
   always@( posedge clk_50hz or posedge rst)
   begin
        
        if(rst ==1) 
        begin
            continue <=0;
            floor <= IDLE;
            current_floor = 0;
            led_inside_0 = 0;
            led_inside_1 = 0;
            led_inside_2 = 0;
            led_inside_3 = 0;
            led_inside_4 = 0;
            led_outside_0 = 0;
            led_outside_1 = 0;
            led_outside_2 = 0;
            led_outside_3 = 0;
            led_outside_4 = 0;
            led_busy = 0;
            wit <= 0;
            cnt <= 0;
            destination = 0;
        end 
        else
        begin
        case(floor)
                  IDLE:
                  begin 
                      if(led_busy ==1)
                      begin
                          if(current_floor ==0)floor <= FLOOR0;
                          else if(current_floor ==1)floor<= FLOOR1;
                          else if(current_floor ==2)floor<= FLOOR2;
                          else if(current_floor ==3)floor<= FLOOR3;
                          else floor <= FLOOR4;
                           
                      end
                  end 
                  FLOOR0:
                  begin
                            
                          current_floor = 0;  
                          if(led_outside_0 ==1 || led_inside_0 ==1 || continue ==1)
                          begin
                              led_outside_0 = 0;
                              led_inside_0 = 0;
                              continue <= 1;
                              if (destination == 0 ) // destination reached
                              begin
                                    led_busy = 0;    
                              end                            
                              else begin end
                              if (wit==WAIT_TIME)
                              begin
                                    continue <= 0;
                                    wit <= 0;
                                    if (destination == 0 ) floor <=IDLE; // destination reached
                                    else  floor <= FLOOR0;
                              end
                              else 
                              begin
                                    wit <= wit +1;
                                    floor = FLOOR0;  
                              end
                          end 
                          else // destination is somewhere else move up
                            begin
                             /////////////////////////////////////////////////////////////////////////      
                                 if (cnt==MOVE_SPEED)
                                begin
                                   cnt <= 0;
                                   floor <=FLOOR1;
                                   wit =0;
                               end
                               else begin
                                   cnt <= cnt +1;
                                   floor = FLOOR0;  
                               end 
                            end                                
                  end
                  FLOOR1:
                  begin
                        current_floor = 1;
                        if(led_outside_1 ==1 || led_inside_1 ==1 || continue ==1)
                          begin
                              led_outside_1 = 0;
                              led_inside_1 = 0;
                              continue <= 1;
                              if (destination == 1 ) // destination reached
                              begin
                                    led_busy = 0;    
                              end 

                             if (wit==WAIT_TIME)
                                  begin
                                     wit <= 0;
                                     continue <= 0;
                                     if(destination ==1) floor <=IDLE;
                                     else floor = FLOOR1;
                                    
                                 end
                                 else begin
                                     wit <= wit +1;
                                     floor = FLOOR1;  
                                 end
                         end
                         else // move up or down
                         begin
                          /////////////////////////////////////////////////////////////////////////    
                             if (cnt==MOVE_SPEED)
                             begin
                                cnt <= 0;
                                wit <=0;
                                if(direction ==1) floor <=FLOOR2;
                                else floor<=FLOOR0;
                                
                               
                            end
                            else begin
                                cnt <= cnt +1;
                                floor <= FLOOR1;  
                            end 
                         end 
                  end 
                  FLOOR2:         
                  begin
                  current_floor = 2;
                    if(led_outside_2 ==1 || led_inside_2 ==1 || continue ==1)
                    begin
                        led_outside_2 = 0;
                        led_inside_2 = 0;
                        continue <= 1;
                        if (destination == 2 ) // destination reached
                        begin
                              led_busy = 0;    
                        end 
                          if (wit==WAIT_TIME)
                          begin
                              continue <= 0;
                              wit <= 0;
                              if (destination == 2 )floor <=IDLE;
                              else floor <= FLOOR2;
                              
                          end
                          else begin
                              wit <= wit +1;
                              floor = FLOOR2;  
                          end
                     end
                     else // move up or down
                      begin
                       /////////////////////////////////////////////////////////////////////////
                      
                       if (cnt==MOVE_SPEED)
                       begin
                             cnt <= 0;
                             wit <= 0;
                             if(direction ==1) floor <= FLOOR3;
                             else floor <= FLOOR1;
                             
                            
                         end
                         else begin
                             cnt <= cnt +1;
                             floor <= FLOOR2;  
                         end 
                       end     
    
                  end
                  FLOOR3:
                  begin
                  current_floor = 3;
                    if(led_outside_3 == 1 || led_inside_3 == 1 || continue ==1)
                    begin
                        led_outside_3 = 0;
                        led_inside_3 = 0;
                        continue <= 1;
                        if (destination == 3 ) // destination reached
                        begin
                              led_busy = 0;    
                        end 
                          if (wit==WAIT_TIME)
                          begin
                             continue <= 0;
                              wit <= 0;
                              if (destination == 3 )floor <=IDLE;
                              else floor = FLOOR3;
                          end
                          else begin
                              wit <= wit +1;
                              floor = FLOOR3;  
                          end
                    end
                      else // move up or down
                      begin
                       /////////////////////////////////////////////////////////////////////////
                       
                       if (cnt==MOVE_SPEED)
                       begin
                             
                             cnt <= 0;
                             wit <= 0;
                             if(direction ==1) floor <= FLOOR4;
                             else floor <= FLOOR2;
                             
                            
                         end
                         else begin
                             cnt <= cnt +1;
                             floor = FLOOR3;  
                         end 
                       end 

                  end
                  FLOOR4:
                  begin
                  current_floor = 4;
                     if(led_outside_4 ==1 || led_inside_4 ==1 || continue ==1)
                     begin
                        led_outside_4 = 0;
                        led_inside_4 = 0;
                        continue <= 1;
                        if (destination == 4 ) // destination reached
                        begin
                              led_busy = 0;    
                        end 

                          if (wit==WAIT_TIME)
                          begin
                              continue <= 0;
                              wit <= 0;
                              if (destination == 4 ) floor <=IDLE;
                              else  floor <= FLOOR4;
                             
                          end
                          else begin
                              wit <= wit +1;
                              floor = FLOOR4;
                                
                          end
                      end
                      else 
                      begin
                    
                       if (cnt==MOVE_SPEED)
                       begin
                             cnt <= 0;
                             wit <= 0;
                             floor <= FLOOR3;
                             
                         end
                         else begin
                             cnt <= cnt +1;
                             floor = FLOOR4;  
                         end 
                       end 

                  end           
              endcase
              end
      end
      
      
   
      
       // ssd
      always@(floor)
      begin
         if(floor == IDLE)
         begin
                    if(current_floor == 0)
                    begin
                        a[7:0]=8'b11110110; b[7:0]=8'b11001110; c[7:0]=8'b11001110; d[7:0]=8'b11101010; e[7:0]=8'b11100010; f[7:0]=8'b11110010; g[7:0]=8'b11100111; p[7:0]=8'b11111111;
                    end
                    else if(current_floor == 1)
                    begin
                        a[7:0]=8'b11110111; b[7:0]=8'b11001110; c[7:0]=8'b11001110; d[7:0]=8'b11101011; e[7:0]=8'b11100011; f[7:0]=8'b11110011; g[7:0]=8'b11100111; p[7:0]=8'b11111111;
                    end
                    else if(current_floor == 2)
                    begin
                        a[7:0]=8'b11110110; b[7:0]=8'b11001110; c[7:0]=8'b11001111; d[7:0]=8'b11101010; e[7:0]=8'b11100010; f[7:0]=8'b11110011; g[7:0]=8'b11100110; p[7:0]=8'b11111111;
                    end
                    else if(current_floor == 3)
                    begin
                        a[7:0]=8'b11110110; b[7:0]=8'b11001110; c[7:0]=8'b11001110; d[7:0]=8'b11101010; e[7:0]=8'b11100011; f[7:0]=8'b11110011; g[7:0]=8'b11100110; p[7:0]=8'b11111111;
                    end
                    else 
                    begin
                        a[7:0]=8'b11110111; b[7:0]=8'b11001110; c[7:0]=8'b11001110; d[7:0]=8'b11101011; e[7:0]=8'b11100011; f[7:0]=8'b11110010; g[7:0]=8'b11100110; p[7:0]=8'b11111111;
                    end
                    
         end
         else
         begin
            if(direction ==1)
            begin
                    if(current_floor == 0)
                    begin
                        a[7:0]=8'b11100110; b[7:0]=8'b11001110; c[7:0]=8'b11011110; d[7:0]=8'b11011010; e[7:0]=8'b11000010; f[7:0]=8'b11000010; g[7:0]=8'b11100111; p[7:0]=8'b11111111;
                    end
                    else if(current_floor == 1)
                    begin
                        a[7:0]=8'b11100111; b[7:0]=8'b11001110; c[7:0]=8'b11011110; d[7:0]=8'b11011011; e[7:0]=8'b11000011; f[7:0]=8'b11000011; g[7:0]=8'b11100111; p[7:0]=8'b11111111;
                    end
                    else if(current_floor == 2)
                    begin
                        a[7:0]=8'b11100110; b[7:0]=8'b11001110; c[7:0]=8'b11011111; d[7:0]=8'b11011010; e[7:0]=8'b11000010; f[7:0]=8'b11000011; g[7:0]=8'b11100110; p[7:0]=8'b11111111;
                    end
                    else if(current_floor == 3)
                    begin
                        a[7:0]=8'b11100110; b[7:0]=8'b11001110; c[7:0]=8'b11011110; d[7:0]=8'b11011010; e[7:0]=8'b11000011; f[7:0]=8'b11000011; g[7:0]=8'b11100110; p[7:0]=8'b11111111;
                    end
                    else 
                    begin
                        a[7:0]=8'b11100111; b[7:0]=8'b11001110; c[7:0]=8'b11011110; d[7:0]=8'b11011011; e[7:0]=8'b11000011; f[7:0]=8'b11000010; g[7:0]=8'b11100110; p[7:0]=8'b11111111;                      
                    end
            end
            else
            begin
                    if(current_floor == 0)
                    begin
                        a[7:0]=8'b11100110; b[7:0]=8'b11001110; c[7:0]=8'b11001110; d[7:0]=8'b11001010; e[7:0]=8'b11000010; f[7:0]=8'b11100010; g[7:0]=8'b11010111; p[7:0]=8'b11111111;
                    end
                    else if(current_floor == 1)
                    begin
                        a[7:0]=8'b11100111; b[7:0]=8'b11001110; c[7:0]=8'b11001110; d[7:0]=8'b11001011; e[7:0]=8'b11000011; f[7:0]=8'b11100011; g[7:0]=8'b11010111; p[7:0]=8'b11111111;
                    end
                    else if(current_floor == 2)
                    begin
                        a[7:0]=8'b11100110; b[7:0]=8'b11001110; c[7:0]=8'b11001111; d[7:0]=8'b11001010; e[7:0]=8'b11000010; f[7:0]=8'b11100011; g[7:0]=8'b11010110; p[7:0]=8'b11111111;
                    end
                    else if(current_floor == 3)
                    begin
                        a[7:0]=8'b11100110; b[7:0]=8'b11001110; c[7:0]=8'b11001110; d[7:0]=8'b11001010; e[7:0]=8'b11000011; f[7:0]=8'b11100011; g[7:0]=8'b11010110; p[7:0]=8'b11111111;
                    end
                    else 
                    begin
                        a[7:0]=8'b11100111; b[7:0]=8'b11001110; c[7:0]=8'b11001110; d[7:0]=8'b11001011; e[7:0]=8'b11000011; f[7:0]=8'b11100010; g[7:0]=8'b11010110; p[7:0]=8'b11111111;
                    end
            
            
            end
         end
      
      end
      
     always@( floor_4_d ==1, floor_3_d==1, floor_2_d==1, floor_1_d==1, floor_0_d==1, floor_0_p==1, 
            floor_1_p==1, floor_2_p==1, floor_3_p==1, floor_4_p==1)
     begin
     if (  floor_0_p == 1 && led_busy == 0)
     begin
         led_outside_0 =1;
         direction = 0;
         if(led_busy == 0) begin destination = 0;led_busy = 1;end
         else led_busy = 1;
         
         
     end 
     else begin end
     //
     if ((floor_1_p ==1 && direction == direction_1 && led_busy == 1&& current_floor < 1&& destination >  1 )
         ||(floor_1_p ==1 && led_busy ==0 && current_floor > 1 && direction_1 == 0 ) 
         ||(floor_1_p ==1 && led_busy ==0 && current_floor < 1 && direction_1 == 1 )
         ||(floor_1_p ==1 && direction == direction_1 && led_busy == 1&& current_floor > 1&& destination <  1 ))
     begin
         led_outside_1 =1;
          if(current_floor>1) direction =0;
                    else begin direction =1; end
         if(led_busy ==0) 
         begin destination = 1; led_busy =1;end
          else led_busy =1;
         
     end
     else begin end 
                 
     
     if ((floor_2_p ==1 && direction == direction_2 && led_busy == 1&& current_floor < 2&& destination >  2 )||  
     (floor_2_p ==1 && led_busy ==0 && current_floor > 2 && direction_2 == 0 ) || (floor_2_p ==1 && led_busy ==0 && current_floor < 2 && direction_2 == 1 )
     ||(floor_2_p ==1 && direction == direction_2 && led_busy == 1&& current_floor > 2&& destination <  2 ))
     
         begin
             led_outside_2 =1;
              if(current_floor>2) direction =0;
               else begin direction =1; end
             
              if(led_busy ==0) 
                begin destination =2; led_busy =1;end
               else led_busy =1;
             
         end 
     else begin end 
     
         if ((floor_3_p ==1 && direction == direction_3 && led_busy == 1&& current_floor < 3&& destination >  3 )||
         (floor_3_p ==1 && led_busy ==0 && current_floor > 3 && direction_3 == 0 ) || (floor_3_p ==1 && led_busy ==0 && current_floor < 3 && direction_3 == 1 )  
          ||(floor_3_p ==1 && direction == direction_3 && led_busy == 1&& current_floor > 3&& destination <  3 ))   
         begin
              led_outside_3 =1;
              if(current_floor>3) direction =0;
              else begin direction =1; end
              if(led_busy ==0) 
                begin destination = 3; led_busy =1;end
               else led_busy =1;
             
         end 
         else begin end

      if (floor_4_p ==1 && led_busy ==0)
        begin
            led_outside_4 =1;
            direction =1;
            destination =4;
            led_busy =1;
            
        end 
        else begin end 

     // inside conditions
     if( floor_0_d ==1 && led_busy ==0 )
     begin 
         led_inside_0 = 1;
        
         led_busy = 1;
         direction = 0;
         destination = 0;
         
     end
     else begin end
     
     if(floor_1_d ==1 && led_busy ==0 || floor_1_d ==1 && led_busy == 1 && destination<1 && current_floor >1 ||
            floor_1_d ==1 && led_busy == 1 && destination > 1 && current_floor < 1 )
     begin
            if(led_busy ==0) destination = 1;
            else begin end
              led_busy =1;
             led_inside_1 = 1;
     if(current_floor>1) direction =0;
     else begin direction =1; end
          
     end
     else begin end
     
     if(floor_2_d ==1 && led_busy ==0 || floor_2_d ==1 && led_busy == 1 && destination < 2 && current_floor > 2 ||
                 floor_2_d ==1 && led_busy == 1 && destination > 2 && current_floor < 2 )
     begin
          
          if(led_busy ==0) destination = 2;
                 else begin end
          led_busy = 1;
          led_inside_2 = 1;
          if(current_floor>2) direction =0;
          else begin direction =1;end
            
     end 
     else begin end
     
      if(floor_3_d ==1 && led_busy ==0 || floor_3_d ==1 && led_busy == 1 && destination < 3 && current_floor > 3 ||
                     floor_3_d ==1 && led_busy == 1 && destination > 3 && current_floor < 3 )
     begin 
             if(led_busy ==0) destination = 3;
                 else begin end
    
             led_busy =1;
             led_inside_3 = 1;
             if(current_floor>3)  direction = 0;
                           else direction = 1;
                         
           end 
                            
         else
         begin
         end
         
     if(floor_4_d && led_busy ==0) 
         begin 
             if(led_busy == 0) destination = 4;
                     else begin end
            
             led_busy = 1;
             led_inside_4 = 1;
             
             direction =1;
          end
                        
         else begin end
         
     end
endmodule
