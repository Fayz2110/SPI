`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2024 12:38:43 PM
// Design Name: 
// Module Name: spi_masterTB
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

module spi_masterTB;

    logic [7:0] data;
    logic tx_en;
    logic clk;
    logic rst;
    logic miso;
    logic mosi;
    logic cs;
    logic sclk;
    logic tx_valid,rx_valid,rx_en, rx_en_slave,data_in,clk_en;
    
    SPI_master dut (
        .data_in(data),
        .tx_en(tx_en),
        .clk(clk),
        .rst(rst),
        .m_miso(miso),
        .m_mosi(mosi),
        .cs(cs),
        .sclk(sclk),
        .tx_valid(tx_valid),
        .rx_valid(rx_valid),
        .rx_en(rx_en),
        .rx_en_slave(rx_en_slave),
        .slave_clk_en(clk_en)     
    );
    
    SPI_slave dut1(
    .mosi(mosi),
    .sclk(sclk),
    .cs(cs),
    .miso(miso),
    .rx_en(rx_en_slave),
    .tx_valid(tx_valid),
    .data_in(data_in),
    .rx_val(rx_valid),
    .clk(clk),
    .rst(rst),
    .sclk_en(clk_en)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        // Initialize signals
        rst = 1;
        data = 8'hAA;
        tx_en = 1;
      
        
        // Reset the design
        #10 rst = 0;
        #215 tx_en=0;
        #20 
        data = 8'hbc;
        tx_en=1;
        #105
        tx_en=0;
     
        #300;

        
        $stop;
    end
endmodule
