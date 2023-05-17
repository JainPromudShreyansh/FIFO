//////////////////////////////////////////////////////////////////////////////////
//Designer: Shreyansh Promud Jain
// Design Name: Asynchronous FIFO
// Module Name: FIFO
// Project Name: Asynchronous FIFO
// Description: Designing a 4 bit Asynchronous FIFO with a depth of 16 operating at 10MHz. 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns
module asyncFIFO(rst,wclk,wen,werr,wdata,full,rclk,ren,rerr,rdata,empty);
parameter depth =16,width=4,ptr_width=$clog2(depth);
integer i;

input rst,wclk,wen,rclk,ren;
input [width-1:0] wdata;

output reg full,empty,rerr,werr;
output reg [width-1:0] rdata;

reg [ptr_width-1:0] rptr,rptr_wclk,wptr,wptr_rclk;
reg wtoggle_f,wtoggle_f_rclk,rtoggle_f,rtoggle_f_wclk;

reg [width-1:0] mem [depth-1:0];

//Code for pointer and Toggle Flag synchronization
always @(posedge rclk) begin
	wptr_rclk<=wptr;
	wtoggle_f_rclk<=wtoggle_f;
end

always @(posedge wclk) begin
	rptr_wclk<=rptr;
	rtoggle_f_wclk<=rtoggle_f;
end

//full condition
always @(*) begin
	full=0;
	if(wptr==rptr_wclk) begin
		if(wtoggle_f!=rtoggle_f_wclk) full=1;
	end
end

//empty condition
always @(*) begin
	empty=0;
	if(rptr==wptr_rclk) begin
		if(rtoggle_f==wtoggle_f_rclk) empty=1;
	end
end

//Code for write operation
always @(posedge wclk) begin
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
		werr=0;
		if(wen) begin
			if(full) werr=1;
			else begin
			mem[wptr]=wdata;
			werr=0;
			if(wptr==depth-1) wtoggle_f=~wtoggle_f;
			wptr=wptr+1;
			end
		end
	end
end

//read operation
always @(posedge rclk) begin
	if(rst!=0) begin
		rerr=0;
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

