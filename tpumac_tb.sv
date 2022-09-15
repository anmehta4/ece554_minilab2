// Spec v1.1
module tpumac_tb();

  //Declaring paramters
  localparam BITS_AB = 8;
  localparam BITS_C = 16;

  // Declare stimulus 
  logic clk,rst_n, WrEn, en;
  logic signed [BITS_AB-1:0] Ain, Aprev;
  logic signed [BITS_AB-1:0] Bin, Bprev;
  logic signed [BITS_C-1:0] Cin, Cprev, Cexp;
  
  // Declare signals to monitor DUT output 
  logic signed [BITS_AB-1:0] Aout;
  logic signed [BITS_AB-1:0] Bout;
  logic signed [BITS_C-1:0] Cout;
  integer err = 0;

  // Instantiate DUT 

  tpumac #(.BITS_AB(BITS_AB), .BITS_C(BITS_C)) iDUT(.clk(clk), .rst_n(rst_n), .en(en), .WrEn(WrEn), 
           .Ain(Ain), .Bin(Bin), .Cin(Cin), .Aout(Aout), .Bout(Bout), .Cout(Cout));

  initial begin
     // Initial setup
     clk = 0;
     rst_n = 0;
     @(negedge clk);
     rst_n = 1;
     @(posedge clk);

     if(Aout !== 0 || Bout !== 0 || Cout !== 0) begin
	 $display("ERROR! Values not reset correctly!");
         err += 1;
     end

     @(negedge clk);
     Aprev = 0;
     Bprev = 0;
     Cprev = 0;

     for (integer i=0; i<256; i++) begin

        Ain = $random;
        Bin = $random;
	Cin = $random;
        en = $random;
        WrEn = $random;
        @(negedge clk);

        if (en == 1'b0) begin
	    if(Aout !== Aprev || Bout !== Bprev || Cout !== Cprev) begin
	        $display("ERROR! Values modified although en = 0");
                $stop;
                err += 1;
            end
        end else begin
             if(Aout != Ain && Bout !== Bin) begin
		$display("ERROR! Values of Ain and Bin not updated when en = 1");
		err += 1;
             end
             if (WrEn == 1'b0) begin
                Cexp = (Ain * Bin) + Cprev;
		if (Cout !== Cexp) begin
		    $display("ERROR! Cout should be Ain * Bin + Cout since WrEn is not enabled!");
		    err += 1;
                end
             end else begin
                 Cexp = Cin;
		 if (Cout !== Cexp) begin
		    $display("ERROR! Cout should be Ain * Bin + Cin since WrEn is enabled!");
		    err += 1;
                 end
             end
        end

        $display("En %x, WrEn: %x, Ain: %x, Bin: %x, Cin: %x, Aout: %x, Bout: %x, Cout: %x", en, WrEn, Ain, Bin, Cin, Aout, Bout, Cout);

        Aprev = Aout;
        Bprev = Bout;
        Cprev = Cout;
     end

     if (err == 0) begin
        $display("SUCCESS! All Tests Passed!");
        $stop;
     end else begin
	$display("FAILURE! There were %x failures", err);
        $stop;
     end   
  end  

always
  #5 clk = ~clk;

endmodule
