


`timescale 1ns / 1ns
package pack1;


`include "uvm_macros.svh"
 import uvm_pkg ::*;

class ALU_Sequence_Item extends uvm_sequence_item;
  
   // Factory Registration
  `uvm_object_utils(ALU_Sequence_Item)
  
  //Factory Construction
  function new (string name = "ALU_Sequence_Item");
       super.new(name);
    endfunction
  
	randc bit        srcCy, srcAc, bit_in;
	randc bit  [3:0] op_code;
	randc bit  [7:0] src1, src2, src3;
	bit       desCy, desAc, desOv;
	bit [7:0] des1, des2, des_acc, sub_result;
	bit clk, rst ;
	bit [15:0] inc, dec;
	bit da_tmp ;
	bit [1:0] cycle;
	
		 constraint c1 {
				src2 != 0 ;}
  
endclass

class ALU_Sequence extends uvm_sequence #(ALU_Sequence_Item);

  ALU_Sequence_Item First_seq ;
  bit STATUS ;
  
  // Factory Registration
  `uvm_object_utils(ALU_Sequence)
  
  //Factory Construction
  function new (string name = "ALU_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    First_seq = ALU_Sequence_Item :: type_id:: create("First_seq");
  endtask


  //Body Task
  task body;

     //First Sequence
	 start_item(First_seq);
	 First_seq.rst = 0;
	 finish_item(First_seq);
    
    //Second Sequence
	 start_item(First_seq);
	 First_seq.rst = 1;
	 finish_item(First_seq);
	

    //Third Sequence Randomized
    for(int i=0;i<20;i++)
	 begin
	 start_item(First_seq);
	 First_seq.rst = 1;
     STATUS = First_seq.randomize();
	 finish_item(First_seq);
	 end 
	 
	 //Fourth Sequence Direct case to hit cases not reached by randomization
	 start_item(First_seq);
	 First_seq.rst = 1;
	 First_seq.op_code = 4'b1111 ;
	 First_seq.srcCy = 1 ;
	 finish_item(First_seq);
	 
	 //Fifth Sequence Direct case to hit cases not reached by randomization
	 start_item(First_seq);
	 First_seq.rst = 1;
	 First_seq.op_code = 4'b1110 ;
	 First_seq.srcCy = 1 ;
	 finish_item(First_seq);
	 
	 //Sixth Sequence Direct case to test for negative inputs
	 start_item(First_seq);
	 First_seq.rst = 1;
	  First_seq.op_code = 4'b0001 ;
	 First_seq.src1 = -38 ;
	 finish_item(First_seq);
	 
	 
	 start_item(First_seq);
	 First_seq.rst = 1;
	 finish_item(First_seq);
	 
	 start_item(First_seq);
	 First_seq.rst = 1;
	 finish_item(First_seq);
	 
	 start_item(First_seq);
	 First_seq.rst = 1;
	 finish_item(First_seq);
	 

	 
  endtask
endclass

class ALU_Driver extends uvm_driver #(ALU_Sequence_Item);
  
  ALU_Sequence_Item First_Seq;
  virtual ALU_if intf1 ;

  
  // Factory Registration
  `uvm_component_utils(ALU_Driver)
  
  //Factory Construction
  function new (string name = "ALU_Driver" , uvm_component parent = null);
       super.new(name,parent);
  endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Driver" ,"We_Are_Now_In_Driver_Build_Phase",UVM_NONE)
      // Factory Creation
      First_Seq = ALU_Sequence_Item::type_id::create("First_Seq");
    
    //DataBase configurations
    if(!(uvm_config_db#(virtual ALU_if)::get(this,"","alu_VIF",intf1)))
      `uvm_fatal(get_full_name(),"Error")
      
    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Driver" ,"We_Are_Now_In_Driver_Connect_Phase",UVM_NONE)
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Driver" ,"We_Are_Now_In_Driver_Run_Phase",UVM_NONE)
    forever 
      begin
        seq_item_port.get_next_item(First_Seq);

        @ (negedge intf1.clk)
        	  begin
              intf1.srcCy 			  <= First_Seq.srcCy;
              intf1.srcAc 			  <= First_Seq.srcAc;
              intf1.bit_in 	  		  <= First_Seq.bit_in;
              intf1.rst 			  <= First_Seq.rst;
			  intf1.op_code 		  <= First_Seq.op_code;
			  intf1.src1 			  <= First_Seq.src1;
			  intf1.src2 			  <= First_Seq.src2;
			  intf1.src3 			  <= First_Seq.src3;

               /* $display("We are in Driver");
                $display (intf1.src1);
                $display(intf1.src2);
				$display(intf1.src3);*/
              end
              #1;
          seq_item_port.item_done();
      end

  endtask
    endclass 
	
	class ALU_Monitor extends uvm_monitor;
  
  ALU_Sequence_Item First_Seq;
  virtual ALU_if intf1 ;
  uvm_analysis_port #(ALU_Sequence_Item) M_write_port;
  
  // Factory Registration
  `uvm_component_utils(ALU_Monitor)
  
  //Factory Construction
  function new (string name = "ALU_Monitor" , uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Monitor" ,"We_Are_Now_In_Monitor_Build_Phase",UVM_NONE)
      // Factory Creation
      First_Seq = ALU_Sequence_Item::type_id::create("First_Seq");
    
    //DataBase configurations
    if(!(uvm_config_db#(virtual ALU_if)::get(this,"","alu_VIF",intf1)))
      `uvm_fatal(get_full_name(),"Error")
     M_write_port = new("M_write_port",this); 
    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Monitor" ,"We_Are_Now_In_Monitor_Connect_Phase",UVM_NONE)
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Monitor" ,"We_Are_Now_In_Monitor_Run_Phase",UVM_NONE)
    forever
      begin
        @ (negedge intf1.clk);
         begin
         First_Seq.srcCy 		    	<= intf1.srcCy;
		 First_Seq.srcAc	 	    	<= intf1.srcAc;
         First_Seq.bit_in 	    		<= intf1.bit_in;
         First_Seq.op_code 			    <= intf1.op_code;
         First_Seq.src1 		  		<= intf1.src1;
		 First_Seq.src2 	    		<= intf1.src2;
		 First_Seq.src3 			    <= intf1.src3;
		 First_Seq.desCy 			    <= intf1.desCy;
		 First_Seq.desAc 			    <= intf1.desAc;
		 First_Seq.desOv 			    <= intf1.desOv;
		 First_Seq.des1 			    <= intf1.des1;
		 First_Seq.des2 			    <= intf1.des2;
		 First_Seq.des_acc 			    <= intf1.des_acc;
		 First_Seq.sub_result 			<= intf1.sub_result;
		 First_Seq.rst                  <= intf1.rst;
		 First_Seq.cycle                <= intf1.cycle;
		 First_Seq.inc               	<= intf1.inc;
		 First_Seq.dec                	<= intf1.dec;
		 First_Seq.da_tmp               <= intf1.da_tmp;
		 
		 
         /*$display("We are in Monitor");
         $display (First_Seq.src1);
         $display(First_Seq.src2);
         $display(First_Seq.src3);   */
		 

		 
		 
         M_write_port.write(First_Seq);         
         end
      end
    endtask
   endclass 
   
   class ALU_Sequencer extends uvm_sequencer #(ALU_Sequence_Item);
  
  
  // Factory Registration
  `uvm_component_utils(ALU_Sequencer)
  
  //Factory Construction
  function new (string name = "ALU_Sequencer" , uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Sequencer" ,"We_Are_Now_In_Sequencer_Build_Phase",UVM_NONE)
    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Sequencer" ,"We_Are_Now_In_Sequencer_Connect_Phase",UVM_NONE)
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Sequencer" ,"We_Are_Now_In_Sequencer_Run_Phase",UVM_NONE)
	
    endtask
   endclass 
   
   class ALU_Agent extends uvm_agent;
  
  ALU_Driver 	alu_driver;
  ALU_Monitor 	alu_monitor;
  ALU_Sequencer	alu_sequencer;
  virtual ALU_if intf1 ;
  uvm_analysis_port #(ALU_Sequence_Item) M_write_port;
  
  // Factory Registration
  `uvm_component_utils(ALU_Agent)
  
  //Factory Construction
  function new (string name = "ALU_Agent" , uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Agent" ,"We_Are_Now_In_Agent_Build_Phase",UVM_NONE)
    // Factory Creation
      alu_driver = ALU_Driver::type_id::create("alu_driver", this);
      alu_monitor = ALU_Monitor::type_id::create("alu_monitor", this);
      alu_sequencer = ALU_Sequencer::type_id::create("alu_sequencer", this);
    
    
    //DataBase configurations
    if(!(uvm_config_db#(virtual ALU_if)::get(this,"","alu_VIF",intf1)))
      `uvm_fatal(get_full_name(),"Error")
       
      uvm_config_db #(virtual ALU_if)::set(this,"ALU_Driver","alu_VIF",intf1);
    uvm_config_db #(virtual ALU_if)::set(this,"ALU_Monitor","alu_VIF",intf1);

     M_write_port = new("M_write_port",this); 
    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Agent" ,"We_Are_Now_In_Agent_Connect_Phase",UVM_NONE)
    alu_driver.seq_item_port.connect(alu_sequencer.seq_item_export);
      alu_monitor.M_write_port.connect(M_write_port);
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Agent" ,"We_Are_Now_In_Agent_Run_Phase",UVM_NONE)
    endtask
  endclass  
  
  class ALU_Scoreboard extends uvm_scoreboard;
  
   ALU_Sequence_Item First_Seq;
  
   uvm_analysis_export #(ALU_Sequence_Item) S_write_exp; 
  
   uvm_tlm_analysis_fifo#(ALU_Sequence_Item) m_tlm_fifo;
   
   bit [7:0]add;
   bit [7:0]sub;
   bit [15:0]mul;
   bit [7:0]div;
   bit [7:0]logic_and;
   bit [7:0]op_dec;
   bit [7:0]op_pcs;
   bit [7:0]op_exc;
  // Factory Registration
  `uvm_component_utils(ALU_Scoreboard)
  
  //Factory Construction
  function new (string name = "ALU_Scoreboard" , uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Scoreboard" ,"We_Are_Now_In_Scoreboard_Build_Phase",UVM_NONE)
    // Factory Creation
      First_Seq = ALU_Sequence_Item::type_id::create("First_Seq");
    
    
      S_write_exp = new("S_write_exp",this); 
      m_tlm_fifo  = new ("m_tlm_fifo",this);
    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Scoreboard" ,"We_Are_Now_In_Scoreboard_Connect_Phase",UVM_NONE)
    
    
      S_write_exp.connect(m_tlm_fifo.analysis_export); 
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Scoreboard" ,"We_Are_Now_In_Scoreboard_Run_Phase",UVM_NONE)
    forever 
      begin
	  m_tlm_fifo.get_peek_export.get(First_Seq); 
	  add = (First_Seq.src1 + First_Seq.src2 + First_Seq.srcCy) ;
	  sub = {(First_Seq.src1[7:4] - First_Seq.src2[7:4] - First_Seq.srcCy), (First_Seq.src1[3:0] - First_Seq.src2[3:0] - First_Seq.srcCy)};
	  mul = First_Seq.src1 * (First_Seq.cycle == 2'h0 ? First_Seq.src2[7:6]
                           : First_Seq.cycle == 2'h1 ? First_Seq.src2[5:4]
                           : First_Seq.cycle == 2'h2 ? First_Seq.src2[3:2]
                           : First_Seq.src2[1:0]);
	  div = First_Seq.src1 / First_Seq.src2 ;
	  logic_and = First_Seq.src1 & First_Seq.src2 ;
	  op_dec[3:0] = (First_Seq.srcAc == 1'b1 | First_Seq.src1[3:0] > 4'b1001) ? {1'b0, First_Seq.src1[3:0]} + 5'b00110 : {1'b0, First_Seq.src1[3:0]};
	  op_dec[7:4] = (First_Seq.srcCy | First_Seq.da_tmp | First_Seq.src1[7:4] > 4'b1001) ? {First_Seq.srcCy, First_Seq.src1[7:4]} + 5'b00110 + {4'b0, First_Seq.da_tmp} : {First_Seq.srcCy, First_Seq.src1[7:4]} + {4'b0, First_Seq.da_tmp};
	  op_pcs = First_Seq.srcCy ? First_Seq.dec[7:0] : First_Seq.inc[7:0];
	  op_exc = First_Seq.srcCy ? First_Seq.src2 : {First_Seq.src1[7:4], First_Seq.src2[3:0]};

	  
	  
	  
	if (First_Seq.rst == 1) begin

    if (First_Seq.op_code == 4'b0001) begin
        if (First_Seq.des_acc == add ) begin
			$display("-------------------------------------------");
            $display(" [%0t] Addition Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, add );*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Addition Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, add );
        end
    end
	else if (First_Seq.op_code == 4'b0010)begin
			
		if (sub == First_Seq.des_acc) begin
			$display("-------------------------------------------");
            /*$display(" [%0t] Subtraction Pass", $time - 20);
			$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, sub );*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Subtraction Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, sub );
        end
	end
	else if (First_Seq.op_code == 4'b0011)begin
			
		if (mul == {First_Seq.des_acc,First_Seq.des2}) begin
			$display("-------------------------------------------");
            $display(" [%0t] Multiplication Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, {First_Seq.des_acc[7:0],First_Seq.des2[7:0]});
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, mul );*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Multiplication Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, {First_Seq.des_acc[7:0],First_Seq.des2[7:0]});
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, mul );
        end
	end
	else if (First_Seq.op_code == 4'b0100)begin
			
		if (div == First_Seq.des2) begin
			$display("-------------------------------------------");
            $display(" [%0t] Division Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des2);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, div );*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Division Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des2);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, div );
        end
	end
	else if (First_Seq.op_code == 4'b0101)begin
			
		if (op_dec == First_Seq.des_acc) begin
			$display("-------------------------------------------");
            $display(" [%0t] operation decimal adjustment Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, op_dec );*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] operation decimal adjustment Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, op_dec );
        end
	end
	else if (First_Seq.op_code == 4'b0110)begin
			
		if (~First_Seq.src1 == First_Seq.des_acc) begin
			$display("-------------------------------------------");
            $display(" [%0t] Not Logic Operation Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, ~First_Seq.src1 );*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Not Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, ~First_Seq.src1 );
        end
	end
	else if (First_Seq.op_code == 4'b0111)begin
			
		if (First_Seq.des1 == logic_and ) begin
			$display("-------------------------------------------");
            $display(" [%0t] AND Logic Operation Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, logic_and);*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] AND Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, logic_and );
        end
	end
		else if (First_Seq.op_code == 4'b1000)begin
			
		if (First_Seq.des_acc == First_Seq.src1 ^ First_Seq.src2 ) begin
			$display("-------------------------------------------");
            $display(" [%0t] XOR Logic Operation Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, First_Seq.src1 ^ First_Seq.src2);*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] XOR Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, First_Seq.src1 ^ First_Seq.src2 );
        end
	end
	else if (First_Seq.op_code == 4'b1001)begin
			
		if (First_Seq.des_acc == First_Seq.src1 | First_Seq.src2 ) begin
			$display("-------------------------------------------");
            $display(" [%0t] OR Logic Operation Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, First_Seq.src1 | First_Seq.src2);*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] OR Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, First_Seq.src1 | First_Seq.src2 );
        end
	end
	else if (First_Seq.op_code == 4'b1010)begin
			
		if (First_Seq.des_acc == {First_Seq.src1[6:0], First_Seq.src1[7]}) begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Left Logic Operation Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.src1[6:0], First_Seq.src1[7]});*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Left Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.src1[6:0], First_Seq.src1[7]} );
        end
	end
		else if (First_Seq.op_code == 4'b1011)begin
			
		if (First_Seq.des_acc == {First_Seq.src1[6:0], First_Seq.srcCy}) begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Left with carry Logic Operation Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.src1[6:0], First_Seq.srcCy});*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Left with carry Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.src1[6:0], First_Seq.srcCy} );
        end
	end
	else if (First_Seq.op_code == 4'b1100)begin
			
		if (First_Seq.des_acc == {First_Seq.src1[0], First_Seq.src1[7:1]}) begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Right Logic Operation Pass", $time - 20);
			/*$display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.src1[0], First_Seq.src1[7:1]});*/
        end else begin
			$display("-------------------------------------------");
            $display(" [%0t] Rotate Right Logic Operation Doesn't pass ", $time - 20);
            $display(" [%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display(" [%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display(" [%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display(" [%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display(" [%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.src1[0], First_Seq.src1[7:1]});
        end
	end
	else if (First_Seq.op_code == 4'b1101)begin
			
		if (First_Seq.des_acc == {First_Seq.srcCy, First_Seq.src1[7:1]}) begin
			$display("-------------------------------------------");
            $display("[%0t] Rotate Right with carry Logic Operation Pass", $time - 20);
			/*$display("[%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display("[%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display("[%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display("[%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display("[%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.srcCy, First_Seq.src1[7:1]});*/
        end else begin
			$display("-------------------------------------------");
            $display("[%0t] Rotate Right with carry Logic Operation Doesn't pass ", $time - 20);
            $display("[%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display("[%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display("[%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display("[%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display("[%0t] Value of supposed output [%0H]", $time - 20, {First_Seq.srcCy, First_Seq.src1[7:1]});
        end
	end
		else if (First_Seq.op_code == 4'b1110)begin
			
		if (First_Seq.des_acc == op_pcs) begin
			$display("-------------------------------------------");
            $display("[%0t] Operation pcs Add Pass", $time - 20);
			/*$display("[%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display("[%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display("[%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display("[%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display("[%0t] Value of supposed output [%0H]", $time - 20, op_pcs);*/
        end else begin
			$display("-------------------------------------------");
            $display("[%0t] Operation pcs Add Doesn't pass ", $time - 20);
            $display("[%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display("[%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display("[%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display("[%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display("[%0t] Value of supposed output [%0H]", $time - 20, op_pcs);
        end
	end
	else if (First_Seq.op_code == 4'b1111)begin
			
		if (First_Seq.des_acc == op_exc) begin
			$display("-------------------------------------------");
            $display("[%0t] operation exchange Pass", $time - 20);
			/*$display("[%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display("[%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display("[%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display("[%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display("[%0t] Value of supposed output [%0H]", $time - 20, op_exc);*/
        end else begin
			$display("-------------------------------------------");
            $display("[%0t] operation exchange Doesn't pass ", $time - 20);
            $display("[%0t] Value of first Operand [%0H]", $time - 20, First_Seq.src1);
            $display("[%0t] Value of second Operand [%0H]", $time - 20, First_Seq.src2);
            $display("[%0t] Value of Real output [%0H]", $time - 20, First_Seq.des_acc);
			$display("[%0t] Value of Carry in  [%0H]", $time - 20, First_Seq.srcCy);
            $display("[%0t] Value of supposed output [%0H]", $time - 20, op_exc);
        end
	end
end

	  end
    endtask
  
  
    endclass

class ALU_Subscriber extends uvm_subscriber #(ALU_Sequence_Item);
  
  ALU_Sequence_Item First_Seq;
  
  covergroup grp_1();
				Op_CODE: coverpoint First_Seq.op_code {bins bin_1[] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0};}
  endgroup
  
  covergroup grp_2();
				reset: coverpoint First_Seq.rst { bins bin_1 =(0=>1);}
												 
  endgroup
  
  covergroup grp_3();
				Carry_in: coverpoint First_Seq.srcCy { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_4();
				Auxillary_carry_input: coverpoint First_Seq.srcAc { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_5();
				Input_Bit: coverpoint First_Seq.bit_in { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_6();
				Overflow: coverpoint First_Seq.desOv { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_7();
				Carry_output: coverpoint First_Seq.desCy { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_8();
				Auxillary_Carry_output: coverpoint First_Seq.desAc { bins bin_1[] = {0,1};}										 
  endgroup
  
  covergroup grp_9();
				Operand1: coverpoint First_Seq.src1 { bins bin_1[] = {0};}	
				Operand3: coverpoint First_Seq.src3 { bins bin_3[] = {0};}
  endgroup

  
  
  
  // Factory Registration
  `uvm_component_utils(ALU_Subscriber)
  
  //Factory Construction
  function new (string name = "ALU_Subscriber" , uvm_component parent = null);
       super.new(name,parent);
	   grp_1 = new();
	   grp_2 = new();
	   grp_3 = new();
	   grp_4 = new();
	   grp_5 = new();
	   grp_6 = new();
	   grp_7 = new();
	   grp_8 = new();
	   grp_9 = new();

    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Subscriber" ,"We_Are_Now_In_Subscriber_Build_Phase",UVM_NONE)
    // Factory Creation
      First_Seq = ALU_Sequence_Item::type_id::create("First_Seq");
    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Subscriber" ,"We_Are_Now_In_Subscriber_Connect_Phase",UVM_NONE)
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Subscriber" ,"We_Are_Now_In_Subscriber_Run_Phase",UVM_NONE)
    endtask
  
  	
  
    function void write(ALU_Sequence_Item t);
      First_Seq = t ;
	  grp_1.sample();
	  grp_2.sample();
	  grp_3.sample();
	  grp_4.sample();
	  grp_5.sample();
	  grp_6.sample();
	  grp_7.sample();
	  grp_8.sample();
	  grp_9.sample();

	endfunction
	
    endclass
	
	class ALU_Enviroment extends uvm_env;
  
    ALU_Agent 		alu_agent;
  	ALU_Scoreboard	alu_scoreboard;
    ALU_Subscriber	alu_subscriber;
  	virtual ALU_if intf1 ;
  
  
  // Factory Registration
  `uvm_component_utils(ALU_Enviroment)
  
  //Factory Construction
  function new (string name = "ALU_Enviroment",uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Enviroment" ,"We_Are_Now_In_Enviroment_Build_Phase",UVM_NONE)
    // Factory Creation
    alu_agent = ALU_Agent::type_id::create("alu_agent",this);
    alu_scoreboard= ALU_Scoreboard::type_id::create("alu_scoreboard",this);
    alu_subscriber= ALU_Subscriber::type_id::create("alu_subscriber",this);
    
    //DataBase configurations
    if(!(uvm_config_db#(virtual ALU_if)::get(this,"","alu_VIF",intf1)))
      `uvm_fatal(get_full_name(),"Error")
       
      uvm_config_db #(virtual ALU_if)::set(this,"ALU_Agent","alu_VIF",intf1);

    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Enviroment" ,"We_Are_Now_In_Enviroment_Connect_Phase",UVM_NONE)
    alu_agent.M_write_port.connect(alu_scoreboard.S_write_exp);
    alu_agent.M_write_port.connect(alu_subscriber.analysis_export);
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Enviroment" ,"We_Are_Now_In_Enviroment_Run_Phase",UVM_NONE)
    endtask
    
    endclass
	
	class ALU_Test extends uvm_test;
  
  ALU_Enviroment alu_enviroment ;
  ALU_Sequence   alu_sequence ;
  virtual ALU_if intf1 ;
  
  // Factory Registration
  `uvm_component_utils(ALU_Test)
  
  //Factory Construction
  function new (string name = "ALU_Test" , uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Test" ,"We_Are_Now_In_Test_Build_Phase",UVM_NONE)
    // Factory Creation
    alu_enviroment= ALU_Enviroment::type_id::create("alu_enviroment",this);
    alu_sequence= ALU_Sequence::type_id::create("alu_sequence");
    
    //DataBase configurations
    if(!(uvm_config_db#(virtual ALU_if)::get(this,"","alu_VIF",intf1)))
      `uvm_fatal(get_full_name(),"Error")
       
    uvm_config_db #(virtual ALU_if)::set(this,"ALU_Enviroment","alu_VIF",intf1);

    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Test" ,"We_Are_Now_In_Test_Connect_Phase",UVM_NONE)
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Test" ,"We_Are_Now_In_Test_Run_Phase",UVM_NONE)
     phase.raise_objection(this,"Starting Sequence");
     alu_sequence.start(alu_enviroment.alu_agent.alu_sequencer);
     phase.drop_objection(this,"Finished Sequence");
    endtask
    
    endclass
	
	endpackage 