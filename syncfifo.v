//////////////////////////////////////////////////////////////////////////////////
//Designer: Shreyansh Promud Jain
// Design Name: Synchronous FIFO
// Module Name:
// Project Name: Synchronous FIFO
// Description: Designing a 4 bit buffer with a depth of 16 operating at 10MHz. 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module SyncFIFO(
	clk,rst,
	wdata,wen,werr,full,
	rdata,ren,rerr,empty

);
integer i;
parameter width=4,depth=16,ptr_width=$clog2(depth);
input clk,rst,wen,ren;

input [width-1:0] wdata;

output reg werr,rerr,full,empty;
output reg [width-1:0] rdata;

reg [ptr_width-1:0] rptr,wptr;
reg wtoggle_f,rtoggle_f;

reg [width-1:0] mem [depth-1:0];

//Code to check Full- Empty
always @(*) begin
	$display(ptr_width);
	full=0;
	empty=0;
	if(wptr==rptr) begin
		if(wtoggle_f != rtoggle_f) full=1;
		else empty=1;
	end
end

//Code for design work as FIFO 

always @(posedge clk) begin
	if(rst) begin
		werr=0;
		rerr=0;
		rptr=0;
		wptr=0;
		wtoggle_f=0;
		rtoggle_f=0;
		empty=0;
		full=0;
		for(i=0; i<depth;i=i+1) mem[i]=0;
	end
	else begin
		if(wen) begin
			if(full) werr=1;
			else begin
			mem[wptr]=wdata;
			werr=0;
			if(wptr==depth-1) wtoggle_f=~wtoggle_f;
			wptr=wptr+1;
			end
		end
		if(ren) begin
			if(empty) rerr=1;
			else begin
			rdata=mem[rptr];
			rerr=0;
			if(rptr==depth-1) rtoggle_f=~rtoggle_f;
			rptr=rptr+1;
			end
		end
	end
end
endmodule

