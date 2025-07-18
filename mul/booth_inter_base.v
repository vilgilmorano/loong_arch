module booth_inter_base(
    input [2:0] y,
    input [63:0] x_in,
    output [63:0] x_out,
    output Carry
);

wire negx, x, neg2x, _2x;
wire [1:0] CarrySig [64:0];



assign negx = (y[2] & y[1] & ~y[0]) | (y[2] & ~y[1] & y[0]);
assign x = (~y[2] & ~y[1] & y[0]) | (~y[2] & y[1] & ~y[0]);
assign neg2x = (y[2] & ~y[1] & ~y[0]);
assign _2x = (~y[2] & y[1] & y[0]);


booth_base fir(.negx(negx), .x(x), .neg2x(neg2x), ._2x(_2x), .x_in(x_in[0]), .pos_last_x(1'b0), .neg_last_x(1'b1), .pos_next_x(CarrySig[1][0]), .neg_next_x(CarrySig[1][1]), .x_out(x_out[0]));

generate
    genvar i;
    for (i=1; i<64; i=i+1) begin: gfor
        booth_base ui(
            .negx(negx),
            .x(x),
            .neg2x(neg2x),
            ._2x(_2x),
            .x_in(x_in[i]),
            .pos_last_x(CarrySig[i][0]),
            .neg_last_x(CarrySig[i][1]),
            .pos_next_x(CarrySig[i+1][0]),
            .neg_next_x(CarrySig[i+1][1]),
            .x_out(x_out[i])
        );
    end
endgenerate

assign Carry = negx || neg2x;

endmodule