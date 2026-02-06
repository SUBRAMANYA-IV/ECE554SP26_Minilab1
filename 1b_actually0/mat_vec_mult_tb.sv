module mat_vec_mult_tb ();
  parameter DEPTH = 8;
  parameter DATA_WIDTH = 8;

  logic clk;
  logic rst_n;
  logic Clr;
  // logic a_rden[7:0];
  // logic b_rden;
  logic a_wren;
  logic b_wren;
  logic [DATA_WIDTH-1:0] a_fifo_in[7:0];
  logic [DATA_WIDTH-1:0] b_fifo_in;
  logic [DATA_WIDTH*3-1:0] out[7:0];

  //generate unpacked versions of a_fifo_in, b_fifo_in, out
  logic [DATA_WIDTH*3-1:0] out_0;
  assign out_0 = out[0];

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin
      logic [DATA_WIDTH-1:0] a_fifo_in_upacked = a_fifo_in[i];
      logic [DATA_WIDTH-1:0] out_unpacked = out[i];
    end
  endgenerate

  logic done;
  mat_vec_mult iDUT (
      .done(done),
      .clk(clk),
      .rst_n(rst_n),
      .Clr(Clr),
      .a_wren(a_wren),
      .b_wren(b_wren),
      .a_fifo_in(a_fifo_in),
      .b_fifo_in(b_fifo_in),
      .out(out)
  );


  //enable all a and b fifos, and start loading in values into each one
  task load_fifo_a(input [DATA_WIDTH-1:0] a_mat[7:0]);
    a_wren = 1'b1;
    for (integer i = 0; i < 8; i = i + 1) begin
      for (integer j = 0; j < 8; j = j + 1) begin
        a_fifo_in[j] = a_mat[i];
      end
    end
    @(posedge clk) begin
    end
    a_wren = 1'b0;
  endtask

  task load_fifo_b(input [DATA_WIDTH-1:0] b_vec);
    b_wren = 1'b1;
    b_fifo_in = b_vec;
    @(posedge clk) begin
    end
    b_wren = 1'b0;
  endtask


  initial clk = 0;
  always #5 clk = ~clk;
  logic [DATA_WIDTH-1:0] mat_a[7:0][7:0];
  logic [DATA_WIDTH-1:0] val_a[7:0];
  logic [DATA_WIDTH-1:0] vec_b[7:0];
  logic [DATA_WIDTH-1:0] val_b;
  logic [DATA_WIDTH-1:0] exp_val[7:0];
  logic [DATA_WIDTH-1:0] flat[7:0];

  initial begin
    $dumpfile("dump2.vcd");
    $dumpvars(0, mat_vec_mult_tb);
    #5;
    rst_n <= 1'b1;
    Clr   <= 1'b1;
    #5;
    @(posedge clk) begin
      rst_n <= 1'b0;
      Clr   <= 1'b0;
    end
    #20
    @(posedge clk) begin
      rst_n <= 1'b1;
      Clr   <= 1'b0;
    end
    //generate 1000 test cases
    /*
    for (integer i = 0; i < 1000; i = i + 1) begin
      //create random stuff for mat_a and vec_b
      for (integer j = 0; j < 8; j = j + 1) begin
        for (integer k = 0; k < 8; k = k + 1) begin
          mat_a[j][k] = $urandom_range(0, (1 << DATA_WIDTH) - 1);
        end
        vec_b[j] = $urandom_range(0, (1 << DATA_WIDTH) - 1);
      end
    end

    //Finished instantiating arrays; calculate expected outcome?
    for (integer j = 0; j < 8; j = j + 1) begin
      for (integer k = 0; k < 8; k = k + 1) begin
        exp_val[j] = exp_val[j] + mat_a[j][k] * vec_b[k];
      end
    end

    for (integer j = 0; j < 8; j = j + 1) begin
      for (integer k = 0; k < 8; k = k + 1) begin
        flat[k] = mat_a[j][k];
      end
      load_fifo_a(flat);
      load_fifo_b(vec_b[j]);
      @(posedge clk) begin
      end
    end
    */

    //try driving the tasks (god please work)
    for (integer i = 0; i < 8; i = i + 1) begin
      val_a[i] = 8'd5;
    end
    val_b = 8'd1;
    load_fifo_a(val_a);
    load_fifo_b(val_b);

    for (integer i = 0; i < 8; i = i + 1) begin
      val_a[i] = 8'd2;
    end
    val_b = 8'd2;
    load_fifo_a(val_a);
    load_fifo_b(val_b);

    for (integer i = 0; i < 8; i = i + 1) begin
      val_a[i] = 8'd3;
    end
    val_b = 8'd3;
    load_fifo_a(val_a);
    load_fifo_b(val_b);

    for (integer i = 0; i < 8; i = i + 1) begin
      val_a[i] = 8'd1;
    end
    val_b = 8'd4;
    load_fifo_a(val_a);
    load_fifo_b(val_b);

    for (integer i = 0; i < 8; i = i + 1) begin
      val_a[i] = 8'd7;
    end
    val_b = 8'd5;
    load_fifo_a(val_a);
    load_fifo_b(val_b);

    for (integer i = 0; i < 8; i = i + 1) begin
      val_a[i] = 8'd4;
    end
    val_b = 8'd6;
    load_fifo_a(val_a);
    load_fifo_b(val_b);

    for (integer i = 0; i < 8; i = i + 1) begin
      val_a[i] = 8'd2;
    end
    val_b = 8'd7;
    load_fifo_a(val_a);
    load_fifo_b(val_b);

    for (integer i = 0; i < 8; i = i + 1) begin
      val_a[i] = 8'd2;
    end
    val_b = 8'd8;
    load_fifo_a(val_a);
    load_fifo_b(val_b);
    #100;
    $display("FUCK");

  end
endmodule

