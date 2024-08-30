`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2024 07:47:26 PM
// Design Name: 
// Module Name: SPI_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SPI_master(
input logic [7:0] data_in,
output logic tx_valid, //to slave from master for reciving mosi
input logic rx_valid, // to master from slave for reciving miso
input logic tx_en,  //transmitter/mosi en
input logic rx_en, // reciver/miso en
output logic rx_en_slave,
input logic slave_clk_en,

input logic clk,
input logic rst,

input logic m_miso,
output logic m_mosi,
output logic sclk=0,
output logic cs

);
   
   logic tx_ready;
   reg [2:0]index =7;
   
   reg [7:0] data_saved_miso;
   reg  [3:0] count=0;
    
    typedef enum logic[1:0]{
    tx_idle=2'b00,
    transmit=2'b01,
    reset=2'b10
    }tx_state;
    
    tx_state current_state,next_state;
    
    always @(posedge clk)begin
    if (current_state==transmit ||slave_clk_en)begin
        
        sclk=~sclk;  
        end
        end
        
           
     //=============================from miso=================================================          
       always_ff@(posedge clk)begin
                     if(sclk && !cs &&rx_valid &&count<=8)begin
                     data_saved_miso[count]<=m_miso;
                     count<=count+1;end
                     if(count==8)begin
                     count<=0;
                     end
                     end  
    //=================================mosi======================================================
    always_ff@(posedge clk)begin
    if(rst)begin
    current_state<=reset;
    end
    else begin
    current_state<=next_state;
    end
    end
    
   
  always @(posedge clk)begin
              if(current_state==tx_idle &&rx_en)begin
                 cs<=0;
              end
              else if(current_state==tx_idle)begin
              cs<=1;
              end
                
    
   //======================================FSM=============================================== 
 
 case(current_state)
 tx_idle:begin
 tx_valid<=1'b0;
    tx_ready<=1;
    
    m_mosi<=1'b0;
    if(tx_en && tx_ready)begin
    next_state<=transmit; end
    end
    
 transmit:begin
    tx_ready<=0;
    cs<=1'b0;
 if(sclk==1'b1 && cs==1'b0)begin
    m_mosi<=data_in[index];
    tx_valid<=1'b1;
   // else if(clk_gen==1'b1 && cs==1'b0)begin
    index<=index-1; end
   // end
 if(index==1'b0)begin
    next_state<=tx_idle;
    end
    
    end
 reset:begin
 m_mosi<=0;
 sclk<=0;
 
 if(!rst)begin
 next_state<=tx_idle;
 end
 end
 default:begin
 next_state<=tx_idle;
 end
 endcase
 end
 
assign rx_en_slave=rx_en;
endmodule
