`ifndef MONITOR_SV
`define MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class i2c_monitor extends uvm_monitor;
    `uvm_component_utils(i2c_monitor)

    uvm_analysis_port #(i2c_seq_item) ap; 
    virtual i2c_if iif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db #(virtual i2c_if)::get(this, "", "iif", iif)) begin
            `uvm_fatal(get_type_name(), "error uvm_config_db in monitor");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "start monitoring I2C Top ...", UVM_MEDIUM)

        wait(iif.reset == 1'b0);
        @(iif.mon_cb);

        forever begin
            collect_transaction();
        end
    endtask

    task collect_transaction();
        i2c_seq_item tx;
        tx = i2c_seq_item::type_id::create("mon_tx");

        forever begin
            @(iif.mon_cb);
            if (iif.mon_cb.m_cmd_start) begin
                tx.op = I2C_START;
                break;
            end else if (iif.mon_cb.m_cmd_write) begin
                tx.op = I2C_WRITE;
                tx.m_tx_data = iif.mon_cb.m_tx_data;
                tx.s_tx_data = iif.mon_cb.s_tx_data;
                break;
            end else if (iif.mon_cb.m_cmd_read) begin
                tx.op = I2C_READ;
                tx.m_ack_in = iif.mon_cb.m_ack_in;
                tx.s_tx_data = iif.mon_cb.s_tx_data;
                break;
            end else if (iif.mon_cb.m_cmd_stop) begin
                tx.op = I2C_STOP;
                break;
            end
        end

        while (iif.mon_cb.m_done !== 1'b1) begin
            @(iif.mon_cb);
        end

        tx.m_rx_data = iif.mon_cb.m_rx_data;
        tx.s_rx_data = iif.mon_cb.s_rx_data;
        tx.m_ack_out = iif.mon_cb.m_ack_out;

        `uvm_info(get_type_name(), $sformatf("mon tx: %s", tx.convert2string()), UVM_MEDIUM)
        ap.write(tx);
        
        @(iif.mon_cb);
    endtask
    
endclass
`endif

