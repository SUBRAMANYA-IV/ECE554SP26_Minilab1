module mat_vec_mult_tb ();
  parameter DEPTH = 8;
  parameter DATA_WIDTH = 8;

  logic clk;
  logic rst_n;
  logic Clr;
  // logic a_rden[7:0];
  // logic b_rden;
  logic a_wren[7:0];
  logic b_wren;
  logic [DATA_WIDTH-1:0] a_fifo_in[7:0];
  logic [DATA_WIDTH-1:0] b_fifo_in;
  logic clr;
  logic [DATA_WIDTH*3-1:0] out[7:0];

  //generate unpacked versions of a_fifo_in, b_fifo_in, out

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin
      logic [DATA_WIDTH-1:0] a_fifo_in_upacked = a_fifo_in[i];
      logic [DATA_WIDTH-1:0] out_unpacked = out[i];
    end
  endgenerate

  mat_vec_mult iDUT (.*);

  task load_fifo(input [DATA_WIDTH-1:-0] a_mat[7:0], input [DATA_WIDTH-1:0] b_vec);
  endtask


  initial clk = 1'b0;
  always @(*) begin
    clk <= #5 ~clk;
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, mat_vec_mult_tb);
    #5;
    rst_n <= 1'b1;
    Clr   <= 1'b1;
    #5;
    @(posedge clk) rst_n <= 1'b0;
    Clr <= 1'b0;
    #20 @(posedge clk) rst_n <= 1'b1;
    Clr <= 1'b1;
    #1000;
  end






endmodule
