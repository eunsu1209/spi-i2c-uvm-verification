`ifndef DRIVER_SV
`define DRIVER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

    class i2c_driver extends uvm_driver #(i2c_seq_item);
        `uvm_component_utils(i2c_driver)
        virtual i2c_if iif;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(virtual i2c_if)::get(this, "", "iif", iif)) begin
                `uvm_fatal(get_type_name(), "error uvm_config_db in driver.");
            end
        endfunction

        virtual task run_phase(uvm_phase phase);
            i2c_seq_item item;

            iif.drv_cb.m_cmd_start <= 1'b0;
            iif.drv_cb.m_cmd_write <= 1'b0;
            iif.drv_cb.m_cmd_read <= 1'b0;
            iif.drv_cb.m_cmd_stop <= 1'b0;
            iif.drv_cb.m_tx_data <= 8'h00;
            iif.drv_cb.m_ack_in <= 1'b1;
            iif.drv_cb.s_tx_data <= 8'h00;

            wait(iif.reset == 1'b0);
            @(iif.drv_cb);

            forever begin
                seq_item_port.get_next_item(item);
                drive_item(item);
                seq_item_port.item_done();
            end
        endtask

        virtual task drive_item(i2c_seq_item item);
            @(iif.drv_cb);
            iif.drv_cb.s_tx_data <= item.s_tx_data;

            case (item.op)
                I2C_START: begin
                    iif.drv_cb.m_cmd_start <= 1'b1;
                    @(iif.drv_cb);
                    iif.drv_cb.m_cmd_start <= 1'b0;
                end
                I2C_WRITE: begin
                    iif.drv_cb.m_tx_data <= item.m_tx_data;
                    iif.drv_cb.m_cmd_write <= 1'b1;
                    @(iif.drv_cb);
                    iif.drv_cb.m_cmd_write <= 1'b0;
                end
                I2C_READ: begin
                    iif.drv_cb.m_ack_in <= item.m_ack_in;
                    iif.drv_cb.m_cmd_read <= 1'b1;
                    @(iif.drv_cb);
                    iif.drv_cb.m_cmd_read <= 1'b0;
                end
                I2C_STOP: begin
                    iif.drv_cb.m_cmd_stop <= 1'b1;
                    @(iif.drv_cb);
                    iif.drv_cb.m_cmd_stop <= 1'b0;
                end
            endcase

            while (iif.drv_cb.m_done !== 1'b1) begin
                @(iif.drv_cb);
            end

            @(iif.drv_cb);
        endtask
    endclass

`endif
