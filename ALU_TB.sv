
`timescale 1ns / 1ns

interface ALU_if;	
  
	bit        srcCy, srcAc, bit_in, clk, rst;
	bit  [3:0] op_code;
	bit  [7:0] src1, src2, src3;
	bit       desCy, desAc, desOv;
	bit [7:0] des1, des2, des_acc, sub_result;
	bit [1:0] cycle ;
	bit [15:0] inc, dec;
	bit da_tmp;
	
	
	always  #5 clk = ~clk;  
	
	
	
	property pr0;
	   @(negedge clk) ( DUT.op_code == 4'b0001 |-> (DUT.des1 == DUT.src1 && DUT.des2 == DUT.src3 + {7'b0 , DUT.addc[1]} && DUT.desCy == DUT.addc[1] && DUT.desAc == DUT.add4[4] && DUT.desOv == DUT.addc[1] ^ DUT.add8[3] && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Addition: assert property (pr0) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and division enable don't operate right for Addition operation \n", $time ); 
	 cover property (pr0) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and division operate right for Addition operation \n" ,$time);
	 
	property pr1;
	   @(negedge clk) ( DUT.op_code == 4'b0010 |-> (DUT.des1 == 0 && DUT.des2 == 0 && DUT.desCy == ! DUT.subc[1] && DUT.desAc == ! DUT.sub4[4] && DUT.desOv == !DUT.subc[1] ^ !DUT.sub8[3] && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Subtraction: assert property (pr1) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and division enable don't operate right for Subtraction operation \n", $time ); 
	 cover property (pr1) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and division operate right for Subtraction operation \n" ,$time);
	 
	property pr2;
	   @(negedge clk) ( DUT.op_code == 4'b0011 |-> (DUT.des1 == DUT.src1 && DUT.des2 == DUT.mulsrc2 && DUT.desCy == 0 && DUT.desAc == 0 && DUT.desOv == DUT.mulOv && DUT.enable_mul == 1'b1 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Multiplication: assert property (pr2) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and division enable don't operate right for Multiplication operation \n", $time ); 
	 cover property (pr2) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and division operate right for Multiplication operation \n" ,$time);
	 
	 property pr3;
	   @(negedge clk) ( DUT.op_code == 4'b0100 |-> (DUT.des1 == DUT.src1 && DUT.des2 == DUT.divsrc2 && DUT.desCy == 0 && DUT.desAc == 0 && DUT.desOv == DUT.divOv && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b1)) ;  
	 endproperty
	
	
	  Division: assert property (pr3) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for Division operation \n", $time ); 
	 cover property (pr3) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for Division operation \n" ,$time);
	 
	  property pr4;
	   @(negedge clk) ( DUT.op_code == 4'b0101  |-> (DUT.des1 == DUT.src1 && DUT.des2 == 0 && DUT.desCy == DUT.da_tmp | DUT.da_tmp1 && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Operation_Decimal_Adjustment: assert property (pr4) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for Operation Decimal Adjustment operation \n", $time ); 
	 cover property (pr4) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for Operation Decimal Adjustment operation \n" ,$time);
	 
	property pr5;
	   @(negedge clk) ( DUT.op_code == 4'b0110  |-> (DUT.des1 == ~ DUT.src1 && DUT.des2 == 0 && DUT.desCy == ~ DUT.srcCy && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Not: assert property (pr5) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for Not logical operation \n", $time ); 
	 cover property (pr5) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for Not logica operation \n" ,$time);
	 
	 property pr6;
	   @(negedge clk) ( DUT.op_code == 4'b0111  |-> (DUT.des1 ==  (DUT.src1 & DUT.src2) && DUT.des2 == 0 && DUT.desCy == (DUT.srcCy & DUT.bit_in)  && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  And : assert property (pr6) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for AND logical operation \n", $time ); 
	 cover property (pr6) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for AND logical operation \n" ,$time);
	 
	  property pr7;
	   @(negedge clk) ( DUT.op_code == 4'b1000  |-> (DUT.des1 ==  DUT.src1 ^ DUT.src2 && DUT.des2 == 0 && DUT.desCy == DUT.srcCy ^ DUT.bit_in && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  XOR : assert property (pr7) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for XOR logical operation \n", $time ); 
	 cover property (pr7) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for XOR logical operation \n" ,$time);
	 
	 
	 property pr8;
	   @(negedge clk) ( DUT.op_code == 4'b1001  |-> (DUT.des1 ==  DUT.src1 | DUT.src2 && DUT.des2 == 0 && DUT.desCy == DUT.srcCy | DUT.bit_in && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  OR : assert property (pr8) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for OR logical operation \n", $time ); 
	 cover property (pr8) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for OR logical operation \n" ,$time);
	 
	 property pr9;
	   @(negedge clk) ( DUT.op_code == 4'b1010  |-> (DUT.des1 ==  DUT.src1  && DUT.des2 == 0 && DUT.desCy == DUT.srcCy | ! DUT.bit_in && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Rotate_Left : assert property (pr9) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for Rotate Left operation \n", $time ); 
	 cover property (pr9) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for Rotate Left operation \n" ,$time);
	 
	  property pr10;
	   @(negedge clk) ( DUT.op_code == 4'b1011  |-> (DUT.des1 ==  DUT.src1  && DUT.des2 == {DUT.src1[3:0], DUT.src1[7:4]} && DUT.desCy == DUT.src1[7] && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Rotate_Left_with_carry : assert property (pr10) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for Rotate Left with carry operation \n", $time ); 
	 cover property (pr10) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for Rotate Left with carry operation \n" ,$time);
	 
	  property pr11;
	   @(negedge clk) ( DUT.op_code == 4'b1100  |-> (DUT.des1 ==  DUT.src1  && DUT.des2 == 0 && DUT.desCy == DUT.srcCy | ! DUT.bit_in && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Rotate_Right : assert property (pr11) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for Rotate Right operation \n", $time ); 
	 cover property (pr11) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for Rotate Right operation \n" ,$time);
	 
	  property pr12;
	   @(negedge clk) ( DUT.op_code == 4'b1101  |-> (DUT.des1 ==  DUT.src1  && DUT.des2 == 0 && DUT.desCy == DUT.src1[0] && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Rotate_Right_with_carry : assert property (pr12) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for Rotate Right with carry operation \n", $time ); 
	 cover property (pr12) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for Rotate Left with carry operation \n" ,$time);
	 
	  property pr13;
	   @(negedge clk) ( DUT.op_code == 4'b1110 && DUT.srcCy |-> (DUT.des1 ==  DUT.dec[7:0]  && DUT.des2 == DUT.dec[15:8] && DUT.desCy == 0 && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Operation_PCS_Add_srcCy_1 : assert property (pr13) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for operation PCS add operation \n", $time ); 
	 cover property (pr13) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for operation PCS add operation \n" ,$time);
	 
	 property pr14;
	   @(negedge clk) ( DUT.op_code == 4'b1110 && ! DUT.srcCy |-> (DUT.des1 ==  DUT.inc[7:0]  && DUT.des2 == DUT.inc[15:8] && DUT.desCy == 0 && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Operation_PCS_Add_srcCy_0 : assert property (pr14) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for operation PCS add operation \n", $time ); 
	 cover property (pr14) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for operation PCS add operation \n" ,$time);
	 
	 property pr15;
	   @(negedge clk) ( DUT.op_code == 4'b1111 && DUT.srcCy |-> (DUT.des1 ==  DUT.src2  && DUT.des2 == DUT.src1 && DUT.desCy == 0 && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Operation_exchange_1 : assert property (pr15) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for operation exchange operation \n", $time ); 
	 cover property (pr15) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for operation exchange operation \n" ,$time);
	 
	 property pr16;
	   @(negedge clk) ( DUT.op_code == 4'b1111 && ! DUT.srcCy |-> (DUT.des1 == {DUT.src1[7:4],DUT.src2[3:0]}  && DUT.des2 == {DUT.src2[7:4],DUT.src1[3:0]} && DUT.desCy == 0 && DUT.desAc == 0 && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  Operation_exchange_0 : assert property (pr16) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for operation exchange operation \n", $time ); 
	 cover property (pr16) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for operation exchange operation \n" ,$time);
	 
	  property pr17;
	   @(negedge clk) ( DUT.op_code == 4'b0000 && ! DUT.srcCy |-> (DUT.des1 == DUT.src1  && DUT.des2 == DUT.src2 && DUT.desCy == DUT.srcCy && DUT.desAc == DUT.srcAc && DUT.desOv == 0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0)) ;  
	 endproperty
	
	
	  NOP : assert property (pr17) else $display("\n [%0t] Assertion failed : Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division enable don't operate right for no operation  \n", $time ); 
	 cover property (pr17) $display ("\n [%0t] Carry Out Flag , Auxillary Flag , Overflow Flag and Multiplication and Division operate right for no operation \n" ,$time);
	 
	
	 
endinterface 



module TestBench();
 `include "uvm_macros.svh"
  import uvm_pkg ::*; 
  import pack1 ::*;
  ALU_if intf1();

oc8051_alu DUT (
  .clk(intf1.clk),
  .rst(intf1.rst),
  .op_code(intf1.op_code),
  .src1(intf1.src1),
  .src2(intf1.src2),
  .src3(intf1.src3),
  .srcCy(intf1.srcCy),
  .srcAc(intf1.srcAc),
  .bit_in(intf1.bit_in),
  .des1(intf1.des1),
  .des2(intf1.des2),
  .des_acc(intf1.des_acc),
  .desCy(intf1.desCy),
  .desAc(intf1.desAc),
  .desOv(intf1.desOv),
  .sub_result(intf1.sub_result)
);

assign intf1.cycle = DUT.oc8051_mul1.cycle;
assign intf1.inc = DUT.inc;
assign intf1.dec = DUT.dec;
assign intf1.da_tmp = DUT.da_tmp;

  initial 
   begin
     uvm_config_db #(virtual ALU_if)::set(null,"*","alu_VIF",intf1);
     run_test("ALU_Test");
     

    end

endmodule