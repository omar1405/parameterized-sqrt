module rs_cudu_v2(	
							input clock,reset,
							input sqrt_start,input  [19:0] data_in,
							output sqrt_done,output [9:0] data_out,
							output [3:0] SQRTstate
);
//interconnects
wire ldn,lda,ldt,ldp,ldb,ldq,selq,ldm,selm,decn,ldo;//cu-du
wire bsign,neq0;//du-cu
rs_cu_v1	u1	(
						.clock(clock),.reset(reset),.start(sqrt_start),.done(sqrt_done),.state(SQRTstate),
						.bsign(bsign),.neq0(neq0),.ldn(ldn),.lda(lda),.ldt(ldt),.ldp(ldp),
						.ldb(ldb),.ldq(ldq),.selq(selq),.ldm(ldm),.selm(selm),.decn(decn),.ldo(ldo)
);

rs_du_v2	u2	(
						.clock(clock),.reset(reset),
						.bsign(bsign),.neq0(neq0),.ldn(ldn),.lda(ldn),.ldt(ldt),.ldp(ldp),
						.ldb(ldb),.ldq(ldq),.selq(selq),.ldm(ldm),.selm(selm),.decn(decn),.ldo(ldo),
						.data_in(data_in),.data_out(data_out)						
);

endmodule
