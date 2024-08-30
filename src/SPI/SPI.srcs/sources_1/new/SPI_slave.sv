`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2024 06:12:40 PM
// Design Name: 
// Module Name: SPI_slave
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


module SPI_slave(
 input logic mosi,
 input logic sclk,
 input logic cs,
 output logic miso,
 
 input logic rx_en,
 input logic tx_valid,
 input logic data_in, //from any device
 output logic rx_val,
 output logic sclk_en,
 input logic clk,
 input logic rst

    );
    reg [7:0]data_saved_mosi,buff;
    reg [2:0] index=7;
    logic rx_ready;
    reg [3:0] i=0,count=0;
    //====================================receive logic================================================================
    always_ff@(posedge clk)begin
    if(sclk &&!cs && tx_valid)begin
    data_saved_mosi[index]<=mosi;
    index<=index-1;
    end
    end
    //==============================================================================
     typedef enum logic[1:0]{
       tx_idle=2'b00,
       transmit=2'b01,
       reset=2'b10
       }tx_state_slave;
       
       tx_state_slave current_state_slave,next_state_slave;
       
       always_ff@(posedge clk)begin
       if(rst)begin
       current_state_slave<=reset;
       end
       else begin
       current_state_slave<=next_state_slave;
       end
       end
       
       always_ff@(posedge clk) begin
       if(rx_en&&i<=8)begin
       buff[i]<=data_in;
       i<=i+1;
       end
       else if(!rx_en)begin
       i<=0;
       end
     
       
       
       case(current_state_slave)
       tx_idle:begin
       rx_val<=1'b0;
       rx_ready<=1;
       
       miso<=0;
       if(rx_en && rx_ready)begin
       next_state_slave<=transmit;
       sclk_en<=1;
       end
       end
       transmit:begin
       rx_ready<=0;
       if(sclk && !cs)begin
       miso<=buff[count];
       count<=count+1;
       rx_val=1'b1;
       
       if(count==4'b1000)begin
       count<=0;
       next_state_slave<=tx_idle;
       sclk_en<=0;
       end
       end
       end 
       reset:begin
       miso<=0;
       
       if(!rst)begin
       next_state_slave<=tx_idle;
       end
       end
        default:begin
       next_state_slave<=tx_idle;
       end
       
       
       
       
       
       
       endcase
       end
endmodule
