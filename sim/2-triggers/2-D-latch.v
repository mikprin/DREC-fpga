`timescale 1ns/10ps
`include "1-SR-latch.v"

module D_flip_flop_gate (input d,   
              input clk,  
              output q,
              output q_bar);  
    
    not(d , not_d);
    and (not_d, clk, sr_r);
    and (d, clk, sr_s);
    SR_latch_gate sr_latch(sr_s, sr_r, q, q_bar);

endmodule 