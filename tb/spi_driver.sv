`ifndef DRIVER_SV
`define DRIVER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

    class spi_driver extends uvm_driver #(spi_seq_item);
        `uvm_component_utils(spi_driver)
        virtual spi_if sif;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(virtual spi_if)::get(this,"", "sif", sif)) begin
                `uvm_fatal(get_type_name(), "error uvm_config_db in driver.");
            end
        endfunction

        virtual task run_phase(uvm_phase phase);
            spi_seq_item item;

            sif.drv_cb.m_start <= 1'b0;
            sif.drv_cb.clk_div <= 8'h00;
            sif.drv_cb.m_tx_data <= 8'h00;
            sif.drv_cb.s_tx_data <= 8'h00;
            
            wait(sif.reset == 1'b0);
            @(sif.drv_cb);

            forever begin
                seq_item_port.get_next_item(item);
                drive_item(item);
                seq_item_port.item_done();
            end
        endtask

        virtual task drive_item(spi_seq_item item);
            @(sif.drv_cb);
            sif.drv_cb.clk_div <= item.clk_div;
            sif.drv_cb.m_tx_data <= item.m_tx_data;
            sif.drv_cb.s_tx_data <= item.s_tx_data;

            sif.drv_cb.m_start <= 1'b1;
            @(sif.drv_cb);
            sif.drv_cb.m_start <= 1'b0;
            
            while (sif.drv_cb.m_done !== 1'b1) begin
                @(sif.drv_cb);
            end

            @(sif.drv_cb);
        endtask
    endclass

`endif
