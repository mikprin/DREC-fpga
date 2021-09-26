`timescale 1ns/10ps

realtime period = 10;


initial begin
    $dumpvars;
    clk = 1'b0;
    rstn = 1'b1;
    #(200);
    rstn = 1'b0;
    #(100);
    rstn = 1'b1;
    
    for( sel_int = 4'h0; sel_int < 4'h8; sel_int = sel_int + 4'h1)
    begin
        #(20);
        exp_factor = 2**(16-sel_int);
        exp = period*exp_factor;
        clkdiv_verif(  .sel_i(sel_int), .exp_i(exp), .is_error_o(is_error));
        if( is_error)
            $finish;
    end
    
    $display("SUCCESS!");
    $finish;
end

module sr_top (); 
nor (Q, R, Qbar); 
nor (Qbar, S, Q); 
endmodule 


