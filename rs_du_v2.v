module rs_du_v2(	
						input clock,reset,					//global pins
						input ldn,lda,ldt,ldp,
								ldb,ldq,selq,ldm,
								selm,decn,ldo,		 			//from CU
						output bsign,neq0,					//to CU
						
						input  [19:0] data_in,				//from Master
						output reg [9:0] data_out			//to Master
);	

						
//creating regs for the DU
reg [19:0] a,p,b,m;
reg [10:0] t;
reg [9:0] q,out;
reg [3:0] n;

//decisions to CU
assign bsign	=	(b[19]);
assign neq0		=	(n==0);

//a reg///////////////////////////////////////////////////////
always@(posedge clock,posedge reset)
	begin
		if(reset)a<=0;
		else if(lda)a<=data_in;
		else a<=a;
	end

//n reg////////////////////////////////////////////////////////
always@(posedge clock,posedge reset)
	if(reset)n<=9;
	else if(ldn)n<=9;
	else if(decn)n<=n-1;
	else	n<=n;

//t reg/////////////////////////////////////////////////////////
always@(posedge clock,posedge reset)
	if(reset)t<=0;
	else if(ldt)
			begin
				case(n)
					9	:	t[1 :0]			<={			2'b01};
					8	:	t[2 :0]			<={q[9:9],	2'b01};
					7	:	t[3 :0]			<={q[9:8],	2'b01};
					6	:	t[4 :0]			<={q[9:7],	2'b01};
					5	:	t[5 :0]			<={q[9:6],	2'b01};
					4	:	t[6 :0]			<={q[9:5],	2'b01};
					3	:	t[7 :0]			<={q[9:4],	2'b01};
					2	:	t[8 :0]			<={q[9:3],	2'b01};
					1	:	t[9 :0]			<={q[9:2],	2'b01};
					0	:	t[10:0]			<={q[9:1],	2'b01};
				endcase
			end
	else t<=t;

//p reg//////////////////////////////////////////////////////////
always@(posedge clock,posedge reset)
	if(reset)p<=0;
	else if(ldp)
			begin
				case(n)
					9	:	p[19:18]		<={			data_in[19:18]};
					8	:	p[19:16]		<={m[19:18],		a[17:16]};
					7	:	p[19:14]		<={m[19:16],		a[15:14]};
					6	:	p[19:12]		<={m[19:14],		a[13:12]};
					5	:	p[19:10]		<={m[19:12],		a[11:10]};
					4	:	p[19: 8]		<={m[19:10],		a[9 : 8]};
					3	:	p[19: 6]		<={m[19: 8],		a[7 : 6]};
					2	:	p[19: 4]		<={m[19: 6],		a[5 : 4]};
					1	:	p[19: 2]		<={m[19: 4],		a[3 : 2]};
					0	:	p[19: 0]		<={m[19: 2],		a[1 : 0]};
				endcase
			end
	else	p<=p;


//b reg////////////////////////////////////////////////////////////////////
always@(posedge clock,posedge reset)
	if(reset)b<=0;
	else if(ldb)
			begin
				case(n)
					9	:	b[19:18]		<=		{			data_in[19:18]}	-	{			2'b01};
					8	:	b[19:16]		<=		{m[19:18],		a[17:16]}	-	{q[9:9],	2'b01};
					7	:	b[19:14]		<=		{m[19:16],		a[15:14]}	-	{q[9:8],	2'b01};
					6	:	b[19:12]		<=		{m[19:14],		a[13:12]}	-	{q[9:7],	2'b01};
					5	:	b[19:10]		<=		{m[19:12],		a[11:10]}	-	{q[9:6],	2'b01};
					4	:	b[19: 8]		<=		{m[19:10],		a[9 : 8]}	-	{q[9:5],	2'b01};
					3	:	b[19: 6]		<=		{m[19: 8],		a[7 : 6]}	-	{q[9:4],	2'b01};
					2	:	b[19: 4]		<=		{m[19: 6],		a[5 : 4]}	-	{q[9:3],	2'b01};
					1	:	b[19: 2]		<=		{m[19: 4],		a[3 : 2]}	-	{q[9:2],	2'b01};
					0	:	b[19: 0]		<=		{m[19: 2],		a[1 : 0]}	-	{q[9:1],	2'b01};

				endcase
			end
	else	b<=b;

//m reg
always@(posedge clock,posedge reset)
	if(reset)m<=0;
	else if(ldm)
			begin
				case(selm)
					1	:	case(n)
								9	:	m[19:18]<=p[19:18];
								8	:	m[19:16]<=p[19:16];
								7	:	m[19:14]<=p[19:14];
								6	:	m[19:12]<=p[19:12];
								5	:	m[19:10]<=p[19:10];
								4	:	m[19: 8]<=p[19: 8];
								3	:	m[19: 6]<=p[19: 6];
								2	:	m[19: 4]<=p[19: 4];
								1	:	m[19: 2]<=p[19: 2];
								0	:	m[19: 0]<=p[19: 0];
							endcase
					0	:	case(n)
								9	:	m[19:18]<=b[19:18];
								8	:	m[19:16]<=b[19:16];
								7	:	m[19:14]<=b[19:14];
								6	:	m[19:12]<=b[19:12];
								5	:	m[19:10]<=b[19:10];
								4	:	m[19: 8]<=b[19: 8];
								3	:	m[19: 6]<=b[19: 6];
								2	:	m[19: 4]<=b[19: 4];
								1	:	m[19: 2]<=b[19: 2];
								0	:	m[19: 0]<=b[19: 0];
							endcase
				endcase
			end
//q reg///////////////////////////////////////////////
always@(posedge clock,posedge reset)
	begin
		if(reset)q<=0;
		else if(ldq)
			case(selq)
				1	:	q[n]<=0;
				0	:	q[n]<=1;
				endcase
		else q<=q;
	end

//out(o) reg//////////////////////////////////////////
always@(posedge clock,posedge reset)
	begin
		if(reset)data_out<=0;
		else if(ldo) data_out<=q;
	end

endmodule
