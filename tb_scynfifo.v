`include "syncfifo.v"
module tb;
parameter width=8, depth=16, ptr_width=4;
integer i;

reg clk,rst,w_en,r_en;
reg [width-1:0] wdata;

wire w_err,r_err,full, empty;
wire [width-1:0] rdata;

SyncFIFO dut(.clk(clk), .rst(rst),.wen(w_en),.full(full),.werr(w_err),.wdata(wdata),.ren(r_en),.empty(empty),.rerr(r_err),.rdata(rdata));

//clock tp=10 steps (ns)
initial begin
	forever begin
		#5;
		clk=0;
		#5;
		clk=1;
	end
end

initial begin
rst=1;
//rst_();
#20;
rst=0;
write(depth);
read(depth);
write(3);
read(2);
#150;
$finish;
end

task rst_(); begin
clk=0;
rst=0;
w_en=0;
r_en=0;
end
endtask

task write(input integer num); begin
//integer=i;
for(i=0;i<num;i=i+1) begin
@(posedge clk);
w_en=1;
wdata=$random;
@(posedge clk);
w_en=0;
			//	$monitor("time=%0t,w_err=%0d,w_ptr=%0d, wdata=%0d,,r_err=%0d,r_ptr=%0d, rdata=%0d",$time,w_err,w_ptr,wdata,r_err,r_ptr,rdata);
				$monitor("time=%0t,ptr=%0d,w_err=%0d,, wdata=%0d,,r_err=%0d,, rdata=%0d",$time,i,w_err,wdata,r_err,rdata);
end
end
endtask

task read(input integer num); begin
//integer=i;
for(i=0;i<num;i=i+1) begin
@(posedge clk);
r_en=1;
@(posedge clk);
r_en=0;
end
end
endtask

//always @(posedge clk) begin
//
//				$monitor("time=%0t,w_err=%0d,, wdata=%0d,,r_err=%0d,, rdata=%0d",$time,w_err,wdata,r_err,rdata);
//end
endmodule
