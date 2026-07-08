`ifndef TEST_SV
`define TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "spi_env.sv"
`include "spi_seq_item.sv"
`include "spi_sequence.sv"


class spi_base_test extends uvm_test;
    `uvm_component_utils(spi_base_test)
    spi_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = spi_env::type_id::create("env", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "=== Hierachy Structure UVM ====", UVM_MEDIUM)
        uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        run_test_seq();
        phase.drop_objection(this);
        `uvm_info("TEST", "spi test completed", UVM_NONE)
    endtask

    virtual task run_test_seq();
    endtask 

endclass

class spi_rand_test extends spi_base_test;
    `uvm_component_utils(spi_rand_test)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "=== Hierachy Structure UVM ====", UVM_MEDIUM)
        uvm_top.print_topology();
    endfunction

    virtual task run_test_seq();
        spi_rand_seq seq;
        //phase.raise_objection(this);
        seq = spi_rand_seq::type_id::create("seq");
        seq.num_trans = 1000;
        seq.start(env.agt.sqr);
        //phase.drop_objection(this);
        #1000;
    endtask
endclass

`endif



