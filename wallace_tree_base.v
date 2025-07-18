module wallace_tree_base(
    input [16:0] data_in,
    input [13:0] cin,
    output [13:0] cout,
    output out_c,out_s
    );

//first stage
wire [4:0] FirSig;
addr first1(.A(data_in[4]), .B(data_in[3]), .C(data_in[2]), .out2(cout[0]), .out1(FirSig[0]));
addr first2(.A(data_in[7]), .B(data_in[6]), .C(data_in[5]), .out2(cout[1]), .out1(FirSig[1]));
addr first3(.A(data_in[10]), .B(data_in[9]), .C(data_in[8]), .out2(cout[2]), .out1(FirSig[2]));
addr first4(.A(data_in[13]), .B(data_in[12]), .C(data_in[11]), .out2(cout[3]), .out1(FirSig[3]));
addr first5(.A(data_in[16]), .B(data_in[15]), .C(data_in[14]), .out2(cout[4]), .out1(FirSig[4]));

//second stage
wire [3:0] SecSig;
addr second1(.A(cin[2]), .B(cin[1]), .C(cin[0]), .out2(cout[5]), .out1(SecSig[0]));
addr second2(.A(data_in[0]), .B(cin[4]), .C(cin[3]), .out2(cout[6]), .out1(SecSig[1]));
addr second3(.A(FirSig[1]), .B(FirSig[0]), .C(data_in[1]), .out2(cout[7]), .out1(SecSig[2]));
addr second4(.A(FirSig[4]), .B(FirSig[3]), .C(FirSig[2]), .out2(cout[8]), .out1(SecSig[3]));

//third stage
wire [1:0] ThiSig;
addr third1(.A(SecSig[0]), .B(cin[6]), .C(cin[5]), .out2(cout[9]), .out1(ThiSig[0]));
addr third2(.A(SecSig[3]), .B(SecSig[2]), .C(SecSig[1]), .out2(cout[10]), .out1(ThiSig[1]));

//fourth stage
wire [1:0] ForSig;
addr fourth1(.A(cin[9]), .B(cin[8]), .C(cin[7]), .out2(cout[11]), .out1(ForSig[0]));
addr fourth2(.A(ThiSig[1]), .B(ThiSig[0]), .C(cin[10]), .out2(cout[12]), .out1(ForSig[1]));

//fifth stage
wire FifSig;
addr fifth1(.A(ForSig[1]), .B(ForSig[0]), .C(cin[11]), .out2(cout[13]), .out1(FifSig));

//sixth stage
addr sixth1(.A(FifSig), .B(cin[13]), .C(cin[12]), .out2(out_c), .out1(out_s));

endmodule
