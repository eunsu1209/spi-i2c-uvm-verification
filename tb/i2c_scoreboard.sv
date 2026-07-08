`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "i2c_seq_item.sv"

    class i2c_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(i2c_scoreboard)

        uvm_analysis_imp #(i2c_seq_item, i2c_scoreboard) ap_imp;

        int pass_cnt = 0;
        int fail_cnt = 0;

        bit is_addr_phase = 0;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ap_imp = new("ap_imp", this);
        endfunction

        function void write(i2c_seq_item item);
            
            if (item.op == I2C_START) begin
                is_addr_phase = 1'b1; 
            end
            else if (item.op == I2C_WRITE) begin
                if (is_addr_phase == 1'b1) begin
                    `uvm_info(get_type_name(), $sformatf("[ADDR PHASE] Master sent Addr: 0x%02h (Check skipped)",
                        item.m_tx_data), UVM_HIGH)
                    is_addr_phase = 1'b0;
                end 
                else begin
                    if (item.m_tx_data === item.s_rx_data) begin
                        pass_cnt++;
                        `uvm_info(get_type_name(), $sformatf("[WRITE PASS] Master TX: 0x%02h == Slave RX: 0x%02h", 
                            item.m_tx_data, item.s_rx_data), UVM_HIGH)
                    end else begin
                        fail_cnt++;
                        `uvm_error(get_type_name(), $sformatf("[WRITE FAIL] Master TX: 0x%02h != Slave RX: 0x%02h", 
                            item.m_tx_data, item.s_rx_data))
                    end
                end
            end
            else if (item.op == I2C_READ) begin
                is_addr_phase = 1'b0;
                if (item.s_tx_data === item.m_rx_data) begin
                    pass_cnt++;
                    `uvm_info(get_type_name(), $sformatf("[READ PASS] Slave TX: 0x%02h == Master RX: 0x%02h", 
                        item.s_tx_data, item.m_rx_data), UVM_HIGH)
                end else begin
                    fail_cnt++;
                    `uvm_error(get_type_name(), $sformatf("[READ FAIL] Slave TX: 0x%02h != Master RX: 0x%02h", 
                        item.s_tx_data, item.m_rx_data))
                end
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

    endclass

`endif

