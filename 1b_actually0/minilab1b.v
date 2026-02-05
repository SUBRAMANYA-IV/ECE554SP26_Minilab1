module minilab1b(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SEG7 //////////
	output	reg	     [6:0]		HEX0,
	output	reg	     [6:0]		HEX1,
	output	reg	     [6:0]		HEX2,
	output	reg	     [6:0]		HEX3,
	output	reg	     [6:0]		HEX4,
	output	reg	     [6:0]		HEX5,
	
	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW
);

localparam DATA_WIDTH = 8;
localparam DEPTH = 8;


// SM States
//TODO: Change when SM logic done
localparam FILL = 2'd0;
localparam EXEC = 2'd1;
localparam DONE = 2'd2;

wire clk, rst_n;
wire Clr, a_wren, b_wren;
wire [DATA_WIDTH-1:0] a_fifo_in[DATA_WIDTH-1:0];
wire [DATA_WIDTH-1:0] b_fifo_in;
wire [DATA_WIDTH*3-1:0] out[DATA_WIDTH-1:0];

wire [31:0] address;
wire mem_rd_en;
reg [63:0] data_line;
reg readdatavalid, waitrequest;

parameter HEX_0 = 7'b1000000;		// zero
parameter HEX_1 = 7'b1111001;		// one
parameter HEX_2 = 7'b0100100;		// two
parameter HEX_3 = 7'b0110000;		// three
parameter HEX_4 = 7'b0011001;		// four
parameter HEX_5 = 7'b0010010;		// five
parameter HEX_6 = 7'b0000010;		// six
parameter HEX_7 = 7'b1111000;		// seven
parameter HEX_8 = 7'b0000000;		// eight
parameter HEX_9 = 7'b0011000;		// nine
parameter HEX_10 = 7'b0001000;	// ten
parameter HEX_11 = 7'b0000011;	// eleven
parameter HEX_12 = 7'b1000110;	// twelve
parameter HEX_13 = 7'b0100001;	// thirteen
parameter HEX_14 = 7'b0000110;	// fourteen
parameter HEX_15 = 7'b0001110;	// fifteen
parameter OFF   = 7'b1111111;		// all off


 

//=======================================================
//  Module instantiation
//=======================================================
mem_wrapper iRemember(
	.clk(CLOCK_50),
	.reset_n(rst_n),
	.address(address),
	.read(mem_rd_en),
	.readdata(data_line),
	.readdatavalid(readdatavalid),
	.waitrequest(waitrequest)
);	

mat_vec_mult #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) iMAC(
	.clk(CLOCK_50),
	.rst_n(rst_n),
	.Clr(Clr),
	.a_wren(a__wren),
	.b_wren(b_wren),
	.a_fifo_in(a_fifo_in),
	.b_fifo_in(b_fifo_in),
	.out(out)
);

//=======================================================
//  SM Time :)
//=======================================================
assign rst_n = KEY[0];
assign wren[0] = state == FILL;
assign wren[1] = wren[0];
assign rden[0] = state == EXEC;
assign rden[1] = rden[0];
