module booth_base(
    input negx, x, neg2x, _2x,
    input x_in,
    input pos_last_x, neg_last_x,
    output pos_next_x, neg_next_x,
    output x_out
    );

assign x_out = (negx & ~x_in) | (x & x_in) | (neg2x & neg_last_x) | (_2x & pos_last_x);
assign pos_next_x = x_in;
assign neg_next_x= ~x_in;

endmodule