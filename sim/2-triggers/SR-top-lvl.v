`timescale 1ns/10ps



module SR_top_lvl;


reg clk;


initial begin
    forever begin
        clk = 0;
        #10 clk = ~clk;
    end 
    $dumpvars;
    clk = 1'b0;
    #100
    $display("SUCCESS!");
    $finish;
end
    
endmodule






