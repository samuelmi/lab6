`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2021 04:55:47 PM
// Design Name: 
// Module Name: updowncounter
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


module updowncounter(
    input wire clk,
    input wire countup,
    input wire paused,
    output wire [31:0] value
    );
    logic [64:0] count = 64'h00000000;
    
    always_ff @(posedge clk) begin
        count <= paused == 1 ? count
               : countup == 1 ? count + 1
               : count - 1;
    end
    
    assign value = count[50:19];
    
endmodule
