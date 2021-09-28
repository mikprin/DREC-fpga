`timescale 1ns/10ps



module SR_top_lvl (

realtime T_half = 10;

wire clk;

always @(T_half) begin
clk <= !clk;    
end

initial begin
    $dumpvars;
    clk = 1'b0;
    #100
    $display("SUCCESS!");
    $finish;
end
    
endmodule






