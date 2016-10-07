
module BCD_conveter(
	output [3:0] out,
	output z,
	input [3:0] in
);

	wire ai,bi,ci,di;

	assign ai=in[3];
	assign bi=in[2];
	assign ci=in[1];
	assign di=in[0];
	
	wire a,b,c,d;
	
	assign out={a,b,c,d};
	
	assign z=ai&bi|ci;
	
	assign a=ai&~bi&~ci;
	assign b=~ai&bi;
	assign c=~ai&ci|ai&bi;
	assign d=di;


endmodule 