`ifndef TEST_SV
`define TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "i2c_env.sv"
`include "i2c_seq_item.sv"
`include "i2c_sequence.sv"


class i2c_base_test extends uvm_test;
    `uvm_component_utils(i2c_base_test)
    i2c_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = i2c_env::type_id::create("env", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "=== Hierachy Structure UVM ====", UVM_MEDIUM)
        uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        run_test_seq();
        phase.drop_objection(this);
        `uvm_info("TEST", "i2c test completed", UVM_NONE)
    endtask

    virtual task run_test_seq();
    endtask 

endclass

class i2c_rand_test extends i2c_base_test;
    `uvm_component_utils(i2c_rand_test)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

   virtual function void end_of_elaboration_phase(uvm_phase phase);
       `uvm_info(get_type_name(), "=== Hierachy Structure UVM ====", UVM_MEDIUM)
       uvm_top.print_topology();
   endfunction

    virtual task run_test_seq();
        i2c_rand_seq seq;
        //phase.raise_objection(this);
        seq = i2c_rand_seq::type_id::create("seq");
        seq.num_trans = 10; 
        seq.start(env.agt.sqr);
        //phase.drop_objection(this);
        #1000;
    endtask
endclass

`endif

