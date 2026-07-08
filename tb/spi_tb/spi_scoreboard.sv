`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "spi_seq_item.sv"

    class spi_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(spi_scoreboard)

        uvm_analysis_imp #(spi_seq_item, spi_scoreboard) ap_imp;

        int pass_cnt = 0;
        int fail_cnt = 0;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ap_imp = new("ap_imp", this);
        endfunction

        function void write(spi_seq_item item);
            if ((item.m_rx_data === item.s_tx_data) && (item.s_rx_data === item.m_tx_data)) begin
                pass_cnt++;
                `uvm_info(get_type_name(), $sformatf("Match!! Master RX: 0x%02h, Slave RX: 0x%02h", 
                    item.m_rx_data, item.s_rx_data), UVM_MEDIUM)
            end else begin
                fail_cnt++;
                `uvm_error(get_type_name(), $sformatf("Mismatch!! Master RX: 0x%02h (Expected: 0x%02h) | Slave RX: 0x%02h (Expected: 0x%02h)", 
                    item.m_rx_data, item.s_tx_data, item.s_rx_data, item.m_tx_data))
            end
        endfunction

        virtual function void report_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "\n\n", UVM_LOW)
            `uvm_info(get_type_name(), "==== Scoreboard Summary ====", UVM_LOW)
            `uvm_info(get_type_name(), $sformatf(" Total transaction: %0d",
                pass_cnt + fail_cnt), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf(" PASS: %0d", pass_cnt), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf(" FAIL: %0d", fail_cnt), UVM_LOW)

            if(fail_cnt > 0) begin
                `uvm_error(get_type_name(), $sformatf("TEST FAILED: %0d mismatches detected!",
                    fail_cnt))
            end else begin
                `uvm_info(get_type_name(), $sformatf("TEST PASSED: %0d all matches detected!",
                    pass_cnt), UVM_LOW)
            end
            `uvm_info(get_type_name(), "\n\n", UVM_LOW)
            endfunction

            task run_phase(uvm_phase phase);
            endtask

    endclass

`endif
