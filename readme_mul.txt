总接口
	input mul_clk, reset,//rst低电平有效
	input sign,
    	input [31:0] x, y, //x扩展至64位 y扩展至33位 区别有无符号
    	input start,//启动信号
    	output ready,//已经准备好
    	output [63:0] result
置顶模块mul.v
clk延迟：
需要三个周期完成
start，ready握手