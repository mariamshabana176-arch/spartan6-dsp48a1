module DSP_PROJECT (A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,
RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
input [17:0] A , B , D;
input [47:0] C;
input CLK , CARRYIN;
input [7:0] OPMODE;
input [17:0] BCIN;
input RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
input CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
input [ 47:0 ] PCIN;
output [17:0] BCOUT ;
output [ 47:0] PCOUT;
output [ 47: 0] P;
output [35:0] M;
output CARRYOUT , CARRYOUTF;
wire [17:0] A_mux1 , A_mux2 , B_mux1 , B_mux2 , D_mux;
wire [7:0] OPMODE_mux;
wire [47:0] C_mux;
wire [17:0] adder_out1 , adder_out1_mux1 , adder_out1_mux2 ;
wire [35:0] mul_out , mul_out_mux;
wire [ 47:0 ] adder2_in0 , adder2_in1;  // X and Z 
wire carry_cascaded , carryin_mux;
wire [48:0] adder2_out;

reg_mux #(.width(8)) inst1 ( OPMODE ,CEOPMODE , CLK , RSTOPMODE , OPMODE_mux , OPMODEREG );

reg_mux #(.width(18)) inst2 ( D ,CED, CLK , RSTD , D_mux , DREG );
reg_mux #(.width(18)) inst3 ( A , CEA ,CLK , RSTA , A_mux1 , A0REG );
reg_mux #(.width(48)) inst4 ( C , CEC ,CLK , RSTC , C_mux , CREG );

assign B_mux1 = (B_INPUT == "DIRECT")?   B : (B_INPUT == "CASCADE")? BCIN : 0 ;

reg_mux #(.width(18)) inst5 ( B_mux1 , CEB ,CLK , RSTB , B_mux2 , B0REG );

assign adder_out1 = ( OPMODE_mux[6] ) ? (D_mux - B_mux2) : (D_mux + B_mux2);
assign adder_out1_mux1 = ( OPMODE_mux[4] )? adder_out1 : B_mux2;

reg_mux #(.width(18)) inst6 ( adder_out1_mux1 , CEB ,CLK , RSTB , adder_out1_mux2 , B1REG );
reg_mux #(.width(18)) inst7 ( A_mux1, CEA , CLK , RSTA , A_mux2 , A1REG );

assign mul_out = ( adder_out1_mux2 * A_mux2 );
assign BCOUT = adder_out1_mux2;
reg_mux #(.width(36)) inst8 ( mul_out , CEM , CLK , RSTM , mul_out_mux , MREG );
// output M
assign M = ~ (~ mul_out_mux);
assign adder2_in0 = ( OPMODE_mux[1:0] == 2'b00)? 0 : ( OPMODE_mux[1:0] == 2'b01)? mul_out_mux : ( OPMODE_mux[1:0] == 2'b10)? P : ({D[11:0] , A[17:0] , adder_out1_mux2[17:0]}) ;
assign adder2_in1 = ( OPMODE_mux[ 3: 2] ==2'b00)? 0 : ( OPMODE_mux[ 3: 2] ==2'b01)? PCIN :  ( OPMODE_mux[ 3: 2] ==2'b10)? P : C_mux;
assign carry_cascaded = ( CARRYINSEL== "OPMODE5")? OPMODE_mux[5] : ( CARRYINSEL== "CARRYIN")? CARRYIN : 0;
reg_mux #(.width(1)) inst9 ( carry_cascaded , CECARRYIN , CLK , RSTCARRYIN , carryin_mux , CARRYINREG );
assign adder2_out = ( OPMODE_mux[7])? ( adder2_in1 - (adder2_in0 + carryin_mux) ) : ( adder2_in1 + adder2_in0 + carryin_mux);
reg_mux #(.width(48)) inst10 ( adder2_out[47:0] , CEP, CLK , RSTP , P , PREG );
reg_mux #(.width(1)) inst11 ( adder2_out[48] , CECARRYIN , CLK , RSTCARRYIN , CARRYOUT , CARRYOUTREG );
assign CARRYOUTF = CARRYOUT;
assign PCOUT = P;
endmodule



















