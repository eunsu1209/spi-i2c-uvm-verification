`ifndef COVERAGE_SV
`define COVERAGE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "i2c_seq_item.sv"

    class i2c_coverage extends uvm_subscriber#(i2c_seq_item);
        `uvm_component_utils(i2c_coverage)
        i2c_seq_item tx;

        covergroup i2c_cg;
            cp_op: coverpoint tx.op {
                bins op_start = {I2C_START};
                bins op_write = {I2C_WRITE};
                bins op_read = {I2C_READ};
                bins op_stop = {I2C_STOP};
            }
            cp_m_tx_data: coverpoint tx.m_tx_data {
                bins addr_base = {8'h12};
                bins addr_write = {8'h24};
                bins addr_read = {8'h25};

                bins zero = {8'h00};
                bins alt_01 = {8'h55};
                bins alt_10 = {8'haa};
                bins lsb_only = {8'h01};
                bins msb_only = {8'h80};
                bins low = {[8'h00:8'h3f]};
                bins mid = {[8'h40:8'hbf]};
                bins high = {[8'hc0:8'hff]};
            }
            cp_s_tx_data: coverpoint tx.s_tx_data {
                bins zero = {8'h00};
                bins alt_01 = {8'h55};
                bins alt_10 = {8'haa};
                bins lsb_only = {8'h01};
                bins msb_only = {8'h80};
                bins low = {[8'h00:8'h3f]};
                bins mid = {[8'h40:8'hbf]};
                bins high = {[8'hc0:8'hff]};
            }
            //cp_ack_in: coverpoint tx.m_ack_in {
            //    bins ack = {1'b0};
            //    bins nack = {1'b1};
            //}
            //cp_ack_out: coverpoint tx.m_ack_out {
            //    bins ack = {1'b0};
            //    bins nack = {1'b1};
            //}
        endgroup

        function new(string name, uvm_component parent);
            super.new(name, parent);
            i2c_cg = new();
        endfunction

        function void write(i2c_seq_item t);
            tx = t;
            i2c_cg.sample();
        endfunction

        virtual function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "==== Coverage Summary ====", UVM_LOW);
            `uvm_info(get_type_name(), $sformatf(" Overall: %.1f%%",
                i2c_cg.get_coverage()), UVM_LOW);
            `uvm_info(get_type_name(), $sformatf(" Operation  : %.1f%%",
                i2c_cg.cp_op.get_coverage()), UVM_LOW);
            `uvm_info(get_type_name(), $sformatf(" m_tx_data  : %.1f%%",
                i2c_cg.cp_m_tx_data.get_coverage()), UVM_LOW);
            `uvm_info(get_type_name(), $sformatf(" s_tx_data : %.1f%%",
                i2c_cg.cp_s_tx_data.get_coverage()), UVM_LOW);
            //`uvm_info(get_type_name(), $sformatf(" m_ack_in  : %.1f%%",
            //    i2c_cg.cp_ack_in.get_coverage()), UVM_LOW);
            //`uvm_info(get_type_name(), $sformatf(" m_ack_out  : %.1f%%",
            //    i2c_cg.cp_ack_out.get_coverage()), UVM_LOW);
            `uvm_info(get_type_name(), "==== Coverage Summary ====\n\n", UVM_LOW);
        endfunction

 
    endclass

`endif

