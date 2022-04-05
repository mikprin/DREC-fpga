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
    parameter KEEP_WIDTH = ((BUS_WIDTH + 7) / 8),

    //TSTRB[(n-1):0]
    parameter TSTRB_WIDTH = ((BUS_WIDTH + 7) / 8)
)
(

    // Utiity signals
    
    input wire                       aclk,
    input wire                       ARESETn,

    // AXI4 BUS standard input stream



    input wire [KEEP_WIDTH-1:0]      in_tkeep,
    input wire [KEEP_WIDTH-1:0]      in_tsrtb,
    input wire [BUS_WIDTH-1:0]       in_tdata,
    input wire                       in_tvalid,
    input wire                       in_tlast,  



    output wire                      in_tready,


    // AXI4 BUS standard output signals
    

    output wire [KEEP_WIDTH-1:0]      out_tkeep,
    output wire [KEEP_WIDTH-1:0]      out_tsrtb,
    output wire [BUS_WIDTH-1:0]       out_tdata,
    output wire                       out_tvalid,
    output wire                       out_tlast,  



    input wire                       out_tready

    // Non standard signals



);

// Variables inside the module

reg [BUS_WIDTH-1:0]                  tdata;
reg [KEEP_WIDTH-1:0]                 tkeep;   
reg [KEEP_WIDTH-1:0]                 tsrtb;


reg[SHIFT_BYTES*8-1:0]               saved_bits;
wire[SHIFT_BYTES*8-1:0]              bits_to_save;


assign in_tready = 1; // For not stream always ready


always @( posedge aclk) begin
    

    if (ARESETn && tvalid && out_tready) begin
        pass
    end

    if (in_tvalid  && ARESETn ) begin
        // recive

        tdata <= in_tdata;
        tkeep <= in_tkeep;
    end
end


endmodule