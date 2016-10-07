
module twelveCounter(
	output [3:0] out,
	output z,
	input clockIn,
	input reset
);

	// internal wires 
	wire a,b,c,d;
	wire ja,ka,jb,kb,jc,kc,jd,kd;
	
	// tie the internal wires to the outside world 
	assign out={a,b,c,d};
	
	// next state logic 
	
	assign ja=b&c&d;
	assign ka=b;
	
	assign jb=c&d;
	assign kb=a|c&d;
	
	assign jc=~a&d|~b&d;
	assign kc=d|a&b;
	
	assign jd=~a|~b;
	assign kd=1'b1;
	
	assign z=~a&~b&~c&~d;
	
	// flip flops 
	lab_JKFF Qa(.clock(clockIn),.J(ja),.K(ka),.reset(reset),.preset(1'b1),.Q(a));
	lab_JKFF Qb(.clock(clockIn),.J(jb),.K(kb),.reset(reset),.preset(1'b1),.Q(b));
	lab_JKFF Qc(.clock(clockIn),.J(jc),.K(kc),.reset(reset),.preset(1'b1),.Q(c));
	lab_JKFF qd(.clock(clockIn),.J(jd),.K(kd),.reset(reset),.preset(1'b1),.Q(d));

endmodule 