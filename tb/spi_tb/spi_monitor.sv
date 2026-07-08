`ifndef MONITOR_SV
`define MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    uvm_analysis_port #(spi_seq_item) ap; // bangsongguk
    virtual spi_if sif; // spy

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db #(virtual spi_if)::get(this, "", "sif", sif)) begin
            `uvm_fatal(get_type_name(), "error uvm_config_db in monitor");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "start monitoring SPI Top ...", UVM_MEDIUM)
        forever begin
            collect_transaction();
        end
    endtask

    task collect_transaction();
        spi_seq_item tx;
        @(sif.mon_cb);
        if (sif.mon_cb.m_done === 1'b1) begin
            tx = spi_seq_item::type_id::create("mon_tx");
            tx.clk_div = sif.mon_cb.clk_div;
            tx.m_tx_data = sif.mon_cb.m_tx_data;
            tx.s_tx_data = sif.mon_cb.s_tx_data;
            repeat(5) @(sif.mon_cb);
            tx.m_rx_data = sif.mon_cb.m_rx_data;
            tx.s_rx_data = sif.mon_cb.s_rx_data;
            `uvm_info(get_type_name(), $sformatf("mon tx: %s", 
                tx.convert2string()), UVM_MEDIUM)
            ap.write(tx);
        end
    endtask
    
endclass
`endif
