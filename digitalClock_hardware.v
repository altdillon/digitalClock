module digitalClock_hardware(
	output [9:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	input [9:0] SW,
	input [3:0] KEY,
	input CLOCK_50
);

	//clock system
	wire hz_clock;
	wire [6:0] clockOut;
	clock_divider clock_div(CLOCK_50,1'b1,1'b1,clockOut);
	assign hz_clock=clockOut[0];
	assign LEDR[9]=hz_clock;
	
	wire seconds1sPlaceCarry,seconds10sPlaceCarry,minutes1sPlaceCarry,minutes10sPlaceCarry,hoursCarry;
	wire [3:0] seconds1sPlace,seconds10sPlace,minutes1sPlace,minutes10sPlace,hoursOut;
	
	// counters for seconds 
	tenCounter secondsOnesPlace(.clockIn(hz_clock),.en(SW[0]),.out(seconds1sPlace),.z(seconds1sPlaceCarry),.reset(KEY[0]));
	sixCounter secondsTensPlace(.clockIn(seconds1sPlaceCarry),.en(SW[1]),.out(seconds10sPlace),.z(seconds10sPlaceCarry),.reset(KEY[0]));
	
	//counter for minute's onces place  
	tenCounter minutesOnesPlace(.clockIn(seconds10sPlaceCarry),.en(SW[2]),.out(minutes1sPlace),.z(minutes1sPlaceCarry),.reset(KEY[1]));
	sixCounter minutesTensPlace(.clockIn(minutes1sPlaceCarry),.en(SW[3]),.out(minutes10sPlace),.z(minutes10sPlaceCarry),.reset(KEY[1]));
	
	// counter for hours 
		twelveCounter hours(.out(hoursOut),.clockIn(minutes10sPlaceCarry),.reset(KEY[1]),.z(hoursCarry));
	
	// flip flop for am/pm
		lab_JKFF ampmFF(.clock(CLOCK_50),.J(hoursCarry),.K(hoursCarry),.preset(1'b1),.reset(KEY[0]),.Q(LEDR[8]));
	
	// bcd convter for values over 12 hours 
	wire [3:0] bcdOut,hours10sPlace;
	wire hours1Out;
	BCD_conveter bcdconv(.in(hoursOut),.out(bcdOut),.z(hours1Out));
	assign hours10sPlace={1'b0,1'b0,1'b0,hours1Out};
	
	//assign carrys to the outside world
	assign LEDR[0]=seconds1sPlaceCarry;
	assign LEDR[1]=seconds10sPlaceCarry;
	assign LEDR[2]=minutes1sPlaceCarry;
	assign LEDR[3]=minutes10sPlaceCarry;
	assign LEDR[4]=hoursCarry;
	
	hex_7seg dis0(SW[0],seconds1sPlace,HEX0);
	hex_7seg dis1(SW[1],seconds10sPlace,HEX1);
	hex_7seg dis2(SW[2],minutes1sPlace,HEX2);
	hex_7seg dis3(SW[3],minutes10sPlace,HEX3);
	hex_7seg dis4(SW[4],bcdOut,HEX4);
	hex_7seg dis5(SW[5],hours10sPlace,HEX5);
	
endmodule