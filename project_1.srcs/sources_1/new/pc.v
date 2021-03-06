module pc;
    reg clk;
    reg  rst;

	cpu CPU(
        .clk(clk),
		.rst(rst));

	always 
		#5 clk = ~clk;

	initial
	begin
		clk = 1'b0;
		#1 rst = 1'b1;
	end

	initial
	begin		
		repeat(5) @(posedge clk);
		rst = 1'b0;
		repeat(1000) @(posedge clk);
		$stop();
	end
endmodule
