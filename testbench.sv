`include "uvm_macros.svh"
import uvm_pkg::*;

class reg_transaction extends uvm_sequence_item;
  rand bit [31:0] addr;
  rand bit [31:0] data;
  	
  `uvm_object_utils_begin(reg_transaction)
  `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "reg_transaction");
    super.new(name);
  endfunction
endclass

class reg_sequence extends uvm_sequence #(reg_transaction);
  `uvm_object_utils(reg_sequence)
  
  function new(string name = "reg_sequence");
    super.new(name);
  endfunction
 
  virtual task body();
    repeat (10) begin
    req = reg_transaction::type_id::create("id");
    start_item(req);
      req.randomize();
    `uvm_info("T1", $sformatf("Addr: %d | Data: %d", req.addr, req.data), UVM_LOW);
    finish_item(req);    
    end
  endtask
endclass

class reg_sequencer extends uvm_sequencer #(reg_transaction);
  `uvm_object_utils(reg_sequencer)  
  
  function new(string name = "reg_sequencer");
    super.new(name);
  endfunction
  
endclass

class reg_driver extends uvm_driver #(reg_transaction); 
  `uvm_component_utils(reg_driver)
  
  function new(string name = "reg_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      seq_item_port.item_done(req);
    end
  endtask  
endclass

class reg_monitor extends uvm_monitor;
  uvm_analysis_port #(reg_transaction) monitor_analysis_port;
  `uvm_component_utils(reg_monitor)
  
  function new(string name = "reg_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
    
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);    
    monitor_analysis_port = new("monitor_analysis_port", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    reg_transaction tr;
    super.run_phase(phase);
    
    forever begin
      #10;
      tr = reg_transaction::type_id::create("TR");
      assert(tr.randomize());
      
      `uvm_info("Monitor", $sformatf("Sampled ADDR: %d | DATA: %d", tr.addr, tr.data), UVM_LOW);
      
      monitor_analysis_port.write(tr);    
    end    
  endtask   
endclass

class reg_test extends uvm_test; 
  uvm_sequencer #(reg_transaction) m_sequencer;
  reg_driver					   m_driver;
  reg_monitor					   m_monitor;
  
  `uvm_component_utils(reg_test)
  
  function new(string name = "reg_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_sequencer = uvm_sequencer#(reg_transaction)::type_id::create("M_Sequencer", this);
    m_driver    = reg_driver::type_id::create("M_Driver", this);
    m_monitor   = reg_monitor::type_id::create("M_Monitor",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    reg_sequence seq;
    super.run_phase(phase);
  	
    phase.raise_objection(this);
    seq = reg_sequence::type_id::create("Seq");
    seq.start(m_sequencer);
    
    #100; 
    phase.drop_objection(this); 
  endtask
endclass

module tb;
  initial begin
    run_test("reg_test");
  end
endmodule
    
/*
UVM_INFO @ 0: reporter [RNTST] Running test reg_test...
UVM_INFO testbench.sv(30) @ 0: uvm_test_top.M_Sequencer@@Seq [T1] Addr: 2247349333 | Data: 3834907113
UVM_INFO testbench.sv(30) @ 0: uvm_test_top.M_Sequencer@@Seq [T1] Addr: 2526055137 | Data:  110413912
UVM_INFO testbench.sv(30) @ 0: uvm_test_top.M_Sequencer@@Seq [T1] Addr: 3368688260 | Data:  189293535
UVM_INFO testbench.sv(30) @ 0: uvm_test_top.M_Sequencer@@Seq [T1] Addr:  354336425 | Data: 3785299808
UVM_INFO testbench.sv(30) @ 0: uvm_test_top.M_Sequencer@@Seq [T1] Addr:  882789234 | Data: 1870615323
UVM_INFO testbench.sv(30) @ 0: uvm_test_top.M_Sequencer@@Seq [T1] Addr: 2495180869 | Data: 2742654391
UVM_INFO testbench.sv(30) @ 0: uvm_test_top.M_Sequencer@@Seq [T1] Addr: 2625300273 | Data: 2579864227
UVM_INFO testbench.sv(30) @ 0: uvm_test_top.M_Sequencer@@Seq [T1] Addr: 2887783292 | Data: 2893160336
UVM_INFO testbench.sv(30) @ 0: uvm_test_top.M_Sequencer@@Seq [T1] Addr: 2706401100 | Data: 2518635584
UVM_INFO testbench.sv(30) @ 0: uvm_test_top.M_Sequencer@@Seq [T1] Addr:  482277815 | Data: 2965613206
UVM_INFO testbench.sv(87) @ 10: uvm_test_top.M_Monitor [Monitor] Sampled ADDR: 2371022609 | DATA: 1450668908
UVM_INFO testbench.sv(87) @ 20: uvm_test_top.M_Monitor [Monitor] Sampled ADDR: 3229473526 | DATA: 2461034458
UVM_INFO testbench.sv(87) @ 30: uvm_test_top.M_Monitor [Monitor] Sampled ADDR: 1768415315 | DATA: 2391353246
UVM_INFO testbench.sv(87) @ 40: uvm_test_top.M_Monitor [Monitor] Sampled ADDR: 3803304098 | DATA: 3739280213
UVM_INFO testbench.sv(87) @ 50: uvm_test_top.M_Monitor [Monitor] Sampled ADDR: 1837187268 | DATA: 3934523622
UVM_INFO testbench.sv(87) @ 60: uvm_test_top.M_Monitor [Monitor] Sampled ADDR: 2040974046 | DATA:  372606808
UVM_INFO testbench.sv(87) @ 70: uvm_test_top.M_Monitor [Monitor] Sampled ADDR: 2346552010 | DATA:  970630955
UVM_INFO testbench.sv(87) @ 80: uvm_test_top.M_Monitor [Monitor] Sampled ADDR:  787232031 | DATA: 1323574995
UVM_INFO testbench.sv(87) @ 90: uvm_test_top.M_Monitor [Monitor] Sampled ADDR:  844769204 | DATA: 2672368925
UVM_INFO testbench.sv(87) @ 100: uvm_test_top.M_Monitor [Monitor] Sampled ADDR: 3102852076 | DATA: 3639692904
UVM_INFO /apps/vcsmx/vcs/X-2025.06-SP1//etc/uvm-ieee/src/base/uvm_report_server.svh(902) @ 100: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   22
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[Monitor]    10
[RNTST]     1
[T1]    10
[UVM/RELNOTES]     1
*/
