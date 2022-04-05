`timescale 1ns/1ps

module shift_test();


wire rst = 1;

wire[31:0] out_data;
reg clk = 0;
reg[31:0]data = 'hFFFF;
reg tlast = 0;

reg tvalid = 1;

always begin
    #4 clk = !clk;
end 

initial begin
    $dumpvars;
    $display("Started!");
    // #20 data <= 16'h0F0F;
    // #20 data <= 16'h1234;
    // #20 data <= 16'hFFFF;
    // #20 data <= 16'h1FFF;
    // #20 data <= 16'h0001;
    data <= 32'h00000001;
    #7 data <= 32'hFFFFFFFF;
    #7 data <= 32'h12345678;
    #8 data <= 32'h87654321;
    #7 data <= 32'h00000000;
    #5 data <= 32'h11111111;
    #5 data <= 32'h22222222;
    #1 tlast <= 1'b1;
    #11 data <= 32'h0F0F0F0F;
    #5 data <= 32'h1F1F1F1F;

    #50 $finish;
end

AXI4_SHIFT U0 (
    .aclk (clk),
    .in_tdata (data),
    .ARESETn (rst),
    .out_tdata (out_data),
    .tlast_input (tlast),
    .tvalid (tvalid)
);

endmodule


module AXI4_SHIFT #(
    // Module parameters

    // BUS width in this case 512 or 256 bits TDATA[(8n-1):0]
    parameter BUS_WIDTH = 32,
    // Amounts of bits to shift hardcoded for now
    parameter SHIFT_BYTES = 1
)
(

    // Utiity signals
    
    input wire                       aclk,
    input wire                       ARESETn,

    // AXI4 BUS standard input stream

    input wire [BUS_WIDTH-1:0]       in_tdata,

    output reg [BUS_WIDTH-1:0]       out_tdata,

    input  wire                     tvalid,  
    input  wire                     tlast_input

);

wire[BUS_WIDTH-1:0]  data;
wire[BUS_WIDTH-1 - SHIFT_BYTES*8 :0]  shifted_data;
reg[BUS_WIDTH-1 - SHIFT_BYTES*8 :0]  shifted_preprocessed_data;
wire[BUS_WIDTH-1:0]  preprocessed_data;
wire[BUS_WIDTH-1:0]  preprocessed_tlast_input_data;
reg [BUS_WIDTH-1:0]  processed_data;
wire[BUS_WIDTH-1:0]  also_processed_data;
reg[SHIFT_BYTES*8-1:0] saved_bits;
wire[SHIFT_BYTES*8-1:0] bits_to_save;

reg output_ready;
// Reg to detect if packet has leftover from the next packet
reg carry;
reg tfirst;
reg last_input_in_process;

wire[SHIFT_BYTES*8-1:0] right_bits_of_bus;

assign data = in_tdata;

assign shifted_data[BUS_WIDTH-1 - SHIFT_BYTES*8 :0] = data[BUS_WIDTH-1 : SHIFT_BYTES*8];

assign bits_to_save[SHIFT_BYTES*8-1:0] = right_bits_of_bus[SHIFT_BYTES*8 - 1 : 0];

assign preprocessed_data = {bits_to_save,shifted_preprocessed_data};
assign preprocessed_tlast_data = {{SHIFT_BYTES*8{1'b0}},shifted_preprocessed_data};
// assign also_processed_data = right_bits_of_bus[SHIFT_BYTES*8-1:0] | saved_bits[SHIFT_BYTES*8-1:0];
// assign preprocessed_data = (data >> SHIFT_BYTES*8);
// assign processed_data = preprocessed_data[BUS_WIDTH-1 :  BUS_WIDTH - ( SHIFT_BYTES * 8 ) - 1] | saved_bits[SHIFT_BYTES*8-1:0];
// assign processed_data = preprocessed_data[BUS_WIDTH - 1 : BUS_WIDTH-1-SHIFT_BYTES*8] | saved_bits[SHIFT_BYTES*8-1:0];

// assign processed_data = (data >> SHIFT_BYTES*8) | 16'hFF00 ;Pppp
//assign saved_bits[SHIFT_BYTES*8-1:0] = data[SHIFT_BYTES*8-1:0];


assign right_bits_of_bus[SHIFT_BYTES*8-1:0] = data[BUS_WIDTH - 1  : BUS_WIDTH - SHIFT_BYTES * 8];


always @( posedge aclk) begin

    if ( ARESETn) begin
        // recive only if source are ready
        if (tvalid ) begin


            // If output packet is ready we can give it on a T+1 clock if not waiting for T+2 clock
            if (output_ready) begin
            
            end

            //data <= in_tdata;
            // out_tdata <= processed_data;
            last_input_in_process <= 1'b1;
            shifted_preprocessed_data <= shifted_data;
            if (tlast_input) begin
                carry <= 1'b0;
                saved_bits <= {SHIFT_BYTES*8{1'b0}};    
                last_input_in_process <= 1'b0;
            end
            else begin
                carry <= 1;
                saved_bits <= bits_to_save;
                last_input_in_process <= 1'b1;
                // processed_data <= preprocessed_data;
            end
        end
        else begin
            // RESET HERE
            last_input_in_process <= 1'b0;
            tfirst <= 1;
            carry <= 0;
            output_ready <= 0;
        end
    end
end

always @( negedge aclk) begin
    if ( ARESETn) begin
        // negative edge support logic
        if (last_input_in_process) begin 
            // If there is no data I can insintiate transfer
            out_tdata <= preprocessed_tlast_data;
            // If data has next packet I should wait for it to get carry
            if ( !carry ) begin
                output_ready <= 1;
            end
        end
        else begin
            // Reset on neg edge
            output_ready <= 0;
        end
    end
end
endmodule