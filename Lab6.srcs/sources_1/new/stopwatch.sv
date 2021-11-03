`timescale 1ns / 1ps
`default_nettype none

module stopwatch(
    input wire clk,
    input wire BTNU,
    input wire BTNC,
    input wire BTND,
    output wire [7:0] segments,
    output wire [7:0] digitselect
    );
        
    wire up, center, down;
    wire countup, paused;
    wire [31:0] value;
    
    debouncer #(20) d1(BTNU, clk, up);
    debouncer #(20) d2(BTNC, clk, center);
    debouncer #(20) d3(BTND, clk, down);
    
    fsm f(clk, up, center, down, countup, paused);
    
    updowncounter c(clk, countup, paused, value);
    
    display8digit display(value, clk, segments, digitselect);
    
    
endmodule
