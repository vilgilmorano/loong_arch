module mul(
    input mul_clk, reset,
    input sign,
    input [31:0] x, y, //x扩展至64位 y扩展至33位 区别有无符号
    input start,//启动信号
    output ready,//已经准备好
    output [63:0] result
    );

wire [63:0] CalX;
wire [32:0] CalY;

assign CalX = sign ? {{32{x[31]}}, x} : {32'b0, x};
assign CalY = sign ? {y[31], y} : {1'b0, y};

//booth
wire [16:0] Carry; //booth计算得到的进位
wire [63:0] BoothRes [16:0]; //booth的计算结果
booth_inter_base fir(.y({CalY[1], CalY[0], 1'b0}), .x_in(CalX), .x_out(BoothRes[0]), .Carry(Carry[0]));

generate
    genvar i;
    for (i=2; i<32; i=i+2) begin: boothfor
        booth_inter_base ai(
            .y(CalY[i+1:i-1]),
            .x_in(CalX<<i),
            .x_out(BoothRes[i>>1]),
            .Carry(Carry[i>>1])
        );
    end
endgenerate

booth_inter_base las(.y({CalY[32], CalY[32], CalY[31]}), .x_in(CalX<<32), .x_out(BoothRes[16]), .Carry(Carry[16]));

reg [16:0] SecStageCarry;
reg [63:0] SecStageBoothRes [16:0];
integer p;
 
always @(posedge mul_clk) begin
    if (~reset) begin
        SecStageCarry <= Carry;
        for(p=0; p<17; p=p+1) begin
            SecStageBoothRes[p] <= BoothRes[p];
        end 
    end
end

//wallace
wire [13:0] WallaceInter [64:0];
wire [63:0] cout, SOut;

wallace_tree_base firs(
            .data_in({SecStageBoothRes[0][0], SecStageBoothRes[1][0], SecStageBoothRes[2][0], SecStageBoothRes[3][0], SecStageBoothRes[4][0], SecStageBoothRes[5][0], SecStageBoothRes[6][0],
            SecStageBoothRes[7][0], SecStageBoothRes[8][0], SecStageBoothRes[9][0], SecStageBoothRes[10][0], SecStageBoothRes[11][0], SecStageBoothRes[12][0], SecStageBoothRes[13][0], SecStageBoothRes[14][0],
            SecStageBoothRes[15][0], SecStageBoothRes[16][0]}),
            .cin(SecStageCarry[13:0]),
            .cout(WallaceInter[1]),
            .out_c(cout[0]),
            .out_s(SOut[0])
        );

generate
    genvar n;
    for (n=1; n<64; n=n+1) begin: wallacefor
        wallace_tree_base bi(
            .data_in({SecStageBoothRes[0][n], SecStageBoothRes[1][n], SecStageBoothRes[2][n], SecStageBoothRes[3][n], SecStageBoothRes[4][n], SecStageBoothRes[5][n], SecStageBoothRes[6][n],
            SecStageBoothRes[7][n], SecStageBoothRes[8][n], SecStageBoothRes[9][n], SecStageBoothRes[10][n], SecStageBoothRes[11][n], SecStageBoothRes[12][n], SecStageBoothRes[13][n], SecStageBoothRes[14][n],
            SecStageBoothRes[15][n], SecStageBoothRes[16][n]}),
            .cin(WallaceInter[n]),
            .cout(WallaceInter[n+1]),
            .out_c(cout[n]),
            .out_s(SOut[n])
        );
    end
endgenerate

//64bit add
assign result = SOut + {cout[62:0], SecStageCarry[14]} + SecStageCarry[15];

endmodule








