module rs_cu_v1(
						input 		clock,reset, 		//global pins
						input 		start,		 		//from master
						output reg 	done,					//to master
						input 		bsign,neq0,			//from DU
						output reg 	ldn,lda,ldt,ldp,
										ldb,ldq,selq,ldm,
										selm,decn,ldo,		//to DU
						output[3:0] state					//for tracing
);

reg [3:0] ps,ns;
parameter [3:0] 	s0=0,s1=1,s2=2,s3=3,s4=4,
						s5=5,s6=6,s7=7,s8=8;
assign state=ps;

//NSL
always@(*)
	case(ps)
		s0	:	if(start) 
				ns<=s1;
				else 
				ns<=s0;
		s1	:	ns<=s2;
		s2	:	ns<=s3;
		s3	:	ns<=s4;	//bsign decision only affects OPL
		s4	:	ns<=s5;
		s5	:	ns<=s6;
		s6	:	ns<=s7;	//bsign decision only affects OPL
		s7	:	ns<=s8;
		s8	:	if(neq0) 
				ns<=s0;
				else 
				ns<=s4;
	endcase

//SR
always@(posedge clock,posedge reset)
if(reset) ps<=s0;else ps<=ns;

//OPL
always@(*)
	begin
		{ldn,decn,lda,ldt,ldp,ldb,ldq,selq,ldm,selm,ldo}=0;
		done=0;
		case(ps)
			//s0	:no output//////////////////////////
			s1	:	begin ldn=1;lda=1;ldt=1;ldp=1;	end
			s2	:	begin ldb=1;							end
			s3	:	if(bsign)///////////////////////////
					begin ldq=1;selq=1;ldm=1;selm=1;	end
					else////////////////////////////////
					begin ldq=1;selq=0;ldm=1;selm=0;	end
			s4	:	begin decn=1;							end
			s5	:	begin ldt=1;ldp=1;					end
			s6	:	begin ldb=1;							end
			s7	:	if(bsign)///////////////////////////
					begin ldq=1;selq=1;ldm=1;selm=1;	end
					else////////////////////////////////
					begin ldq=1;selq=0;ldm=1;selm=0;	end
			s8	:	if(neq0)////////////////////////////
					begin done=1;ldo=1;					end
					//no else output component//////////
		endcase
	end
endmodule
