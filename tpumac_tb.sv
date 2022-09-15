// Spec v1.1
module tpumac_tb();

  //Declaring paramters
  localparam BITS_AB = 8;
  localparam BITS_C = 16;

  // Declare stimulus 
  logic clk,rst_n, WrEn, en;
  logic signed [BITS_AB-1:0] Ain;
  logic signed [BITS_AB-1:0] Bin;
  logic signed [BITS_C-1:0] Cin;
  
  // Declare signals to monitor DUT output 
  logic signed [BITS_AB-1:0] Aout;
  logic signed [BITS_AB-1:0] Bout;
  logic signed [BITS_C-1:0] Cout;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  tpumac #(.BITS_AB(BITS_AB), .BITS_C(BITS_C)) iDUT(.clk(clk), .rst_n(rst_n), .en(en), .WrEn(WrEn), 
           .Ain(Ain), .Bin(Bin), .Cin(Cin), .Aout(Aout), .Bout(Bout), .Cout(Cout));

  initial begin
     // Initial setup
     clk = 0;
     rst_n = 0;
     @(negedge clk);
     rst_n = 1;
  end

endmodule
