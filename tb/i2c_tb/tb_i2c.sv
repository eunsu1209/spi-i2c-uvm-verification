`timescale 1ps/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "i2c_interface.sv"
`include "i2c_seq_item.sv"
`include "i2c_sequence.sv"
`include "i2c_driver.sv"
`include "i2c_monitor.sv"
`include "i2c_agent.sv"
`include "i2c_scoreboard.sv"
`include "i2c_coverage.sv"
`include "i2c_env.sv"
`include "i2c_test.sv"

module tb_i2c (); 
    logic clk = 0;
    logic reset;

    always #5 clk = ~clk;

    i2c_if iif(clk, reset);

    pullup(iif.scl);
    pullup(iif.sda);

    i2c_top dut(
        .clk(clk), 
        .reset(reset), 
        .m_cmd_start(iif.m_cmd_start), 
        .m_cmd_write(iif.m_cmd_write), 
        .m_cmd_read(iif.m_cmd_read), 
        .m_cmd_stop(iif.m_cmd_stop), 
        .m_tx_data(iif.m_tx_data), 
        .m_ack_in(iif.m_ack_in), 
        .m_rx_data(iif.m_rx_data), 
        .m_done(iif.m_done), 
        .m_ack_out(iif.m_ack_out),
        .m_busy(iif.m_busy),
        .s_tx_data(iif.s_tx_data), 
        .s_rx_data(iif.s_rx_data),
        .s_done(iif.s_done), 
        .s_busy(iif.s_busy), 
        .scl(iif.scl), 
        .sda(iif.sda)
    );  

    initial begin
        clk = 0;
        reset = 1;
        repeat (5) @(posedge clk);
        reset = 0;
    end 

    initial begin
        uvm_config_db #(virtual i2c_if)::set(null, "*", "iif", iif);
        run_test();
    end 
    
    initial begin
        $fsdbDumpfile("novas.fsdb");
        $fsdbDumpvars(0, tb_i2c, "+all");
    end 
endmodule

