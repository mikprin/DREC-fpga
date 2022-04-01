// By Mikhail Solovyanov for trial test
// AXI4 simplistic shift IP block

// USER and ID signals are avoided to save some sode space and ease reading.

module AXI4_SHIFT #(
    // Module parameters

    // BUS width in this case 512 or 256 bits TDATA[(8n-1):0]
    parameter BUS_WIDTH = 512,
    // Amounts of bits to shift hardcoded for now
    parameter SHIFT_BYTES = 2,
    // TKEEP is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as part of the data  stream. Associated bytes that have the TKEEP byte qualifier deasserted are null bytes and can be removed from the data stream. TKEEP[(n-1):0]
    parameter KEEP_WIDTH = ((DATA_WIDTH+7)/8),

    //TSTRB[(n-1):0]
    parameter  = 
)
(

    // Utiity signals
    
    input wire                       aclk,
    input wire                       ARESETn,

    // AXI4 BUS standard input stream



    input wire [KEEP_WIDTH-1:0]      in_tkeep,
    input wire                       in_tsrtb,
    input wire [BUS_WIDTH-1:0]       in_tdata,
    input wire                       in_tvalid,
    input wire                       in_tlast,



    output wire                      in_tready,


    // AXI4 BUS standard output signals
    


    // Non standard signals



);

// Parameters in module

    





endmodule