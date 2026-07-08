`ifndef COVERAGE_SV
`define COVERAGE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "spi_seq_item.sv"

    class spi_coverage extends uvm_subscriber#(spi_seq_item);
        `uvm_component_utils(spi_coverage)
        spi_seq_item tx;

        covergroup spi_cg;
            cp_m_tx_data: coverpoint tx.m_tx_data {
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
        endgroup

        function new(string name, uvm_component parent);
            super.new(name, parent);
            spi_cg = new();
        endfunction

        function void write(spi_seq_item t);
            tx = t;
            spi_cg.sample();
        endfunction

        virtual function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "==== Coverage Summary ====", UVM_LOW);
            `uvm_info(get_type_name(), $sformatf(" Overall: %.1f%%",
                spi_cg.get_coverage()), UVM_LOW);
            `uvm_info(get_type_name(), $sformatf(" m_tx_data  : %.1f%%",
                spi_cg.cp_m_tx_data.get_coverage()), UVM_LOW);
            `uvm_info(get_type_name(), $sformatf(" s_tx_data : %.1f%%",
                spi_cg.cp_s_tx_data.get_coverage()), UVM_LOW);
            `uvm_info(get_type_name(), "==== Coverage Summary ====\n\n", UVM_LOW);
        endfunction

 
    endclass

`endif
