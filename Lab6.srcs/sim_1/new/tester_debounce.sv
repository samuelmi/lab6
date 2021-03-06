//////////////////////////////////////////////////////////////////////////////////
// Montek Singh 
// 9/24/2021
//
// NOTE:
//
//	For simulation purposes, N=20 is obviously too long.  Hence, the tester
//	instantiates a debouncer with N=4, so the debounce interval is only 16
//	clock ticks, not 2^20.  The debouncer's output should change on the 16th
//	clock tick once the raw input stops bouncing.
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module tester_debounce();

    // Inputs to uut
    logic clock=0;
    logic rawX=0;

    // Outputs of uut
    wire cleanX;

    // Instantiate the Unit Under Test (UUT)
    debouncer #(4) uut (
        .raw(rawX),
        .clk(clock), 
        .clean(cleanX)
    );

    initial begin       // generate the clock
        forever begin   // Each clock cycle is 1ns (0.5 ns high and 0.5 ns low)
          #0.5 clock = ~clock;
          #0.5 clock = ~clock;
        end
    end
    
    initial begin
        #100 $finish;   // terminate simulation after 100 ns
    end

    integer i;
    initial begin
        #10;
        for(i=0; i<30; i++) begin
            #0.33 rawX = $urandom_range(1,0); 	// unsigned random number from 0 to 1
        end
        #0.33 rawX = 1;
        
        #30;
        for(i=0; i<30; i++) begin
            #0.33 rawX = $urandom_range(1,0);
        end
        #0.33 rawX = 0;
    end    

endmodule
