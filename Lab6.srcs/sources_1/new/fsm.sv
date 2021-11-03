//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// 9/24/2021
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module fsm(
    input wire clk,
    //input wire RESET,                   // Comment this line out if no RESET input
    input wire up, center, down,           // List of inputs to FSM
    output logic countup, paused          // List of outputs of FSM
                                          // The outputs will actually be synthesized as combinational logic!
    );


    // =========================================================================

    // The first part is our state encoding.  There are two options.
    // (1) You enumerate states, and the compiler decides state encoding.

    enum { COUNTING_UP, PAUSING_UP, PAUSED_UP, RESUMING_UP, COUNTING_DOWN, 
           RESUMING_DOWN, PAUSED_DOWN, PAUSING_DOWN  } state, next_state;

    // -- OR --   
    // (2) You can specify state encoding explicitly.

    // enum { STATE0=2'b00, STATE1=2'b01, STATE2=2'b10, ... etc. } state, next_state;

    // Be sure that the initial (i.e. startup) state has the encoding of 0 or,
    // if you are leaving the encoding to the compiler, then the initial state
    // should be the first one listed.


    // =========================================================================

    // The next part is instantiation of the storage elements.

    // Instantiate the state storage elements (flip-flops)
    
    always_ff @(posedge clk)
      //if (RESET == 1) state <= STATE_??;    // Remove the "if" part if no RESET input
      state <= next_state;


    // =========================================================================

    // The next part is definition of the next stage logic.

    // Define next_state logic => combinational
    // Every case must either be a conditional expression
    //   or an "if" with a matching "else"

    always_comb     
      case (state)
            COUNTING_UP: next_state <= down == 1 ? COUNTING_DOWN 
                                     : center == 1 ? PAUSING_UP
                                     : COUNTING_UP;
            PAUSING_UP: next_state <= center == 0 ? PAUSED_UP 
                                              : PAUSING_UP;
            PAUSED_UP: next_state <= down == 1 ? PAUSED_DOWN
                                   : center == 1 ? RESUMING_UP
                                   : PAUSED_UP;
            RESUMING_UP: next_state <= center == 0 ? COUNTING_UP 
                                               : RESUMING_UP;
            COUNTING_DOWN: next_state <= up == 1 ? COUNTING_UP
                                       : center == 1 ? PAUSING_DOWN
                                       : COUNTING_DOWN;
            RESUMING_DOWN: next_state <= center == 0 ? COUNTING_DOWN 
                                                 : RESUMING_DOWN;
            PAUSED_DOWN: next_state <= up == 1 ? PAUSED_UP
                                     : center == 1 ? RESUMING_DOWN
                                     : PAUSED_DOWN;
            PAUSING_DOWN: next_state <= center == 0 ? PAUSED_DOWN
                                                : PAUSING_DOWN;                            
            default: next_state <= COUNTING_UP;   // must have default
      endcase



    // =========================================================================

    // The final part is definition of the output logic.

    // Define output logic => combinational
    // Every case must either be a conditional expression
    //   or an "if" with a matching "else"

    always_comb     
      case (state)
            COUNTING_UP: {countup, paused} <= {1'b1,1'b0};
            PAUSING_UP: {countup, paused} <= {1'b1,1'b1};
            PAUSED_UP: {countup, paused} <= {1'b1,1'b1};
            RESUMING_UP: {countup, paused} <= {1'b1,1'b0};
            COUNTING_DOWN: {countup, paused} <= {1'b0,1'b0};
            RESUMING_DOWN: {countup, paused} <= {1'b0,1'b0};
            PAUSED_DOWN: {countup, paused} <= {1'b0,1'b1};
            PAUSING_DOWN: {countup, paused} <= {1'b0,1'b1};
            default: {countup, paused} <= {1'b1,1'b0};  // must have default
      endcase

endmodule
