`timescale 1ps/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "spi_interface.sv"
`include "spi_seq_item.sv"
`include "spi_sequence.sv"
`include "spi_driver.sv"
`include "spi_monitor.sv"
`include "spi_agent.sv"
`include "spi_scoreboard.sv"
`include "spi_coverage.sv"
`include "spi_env.sv"
`include "spi_test.sv"

module tb_spi ();
    logic clk = 0;
    logic reset;

    always #5 clk = ~clk;

    spi_if sif(clk, reset);

    spi_top dut(
        .clk(clk), 
        .reset(reset), 
        .clk_div(sif.clk_div), 
        .m_tx_data(sif.m_tx_data), 
        .m_start(sif.m_start), 
        .m_rx_data(sif.m_rx_data), 
        .m_done(sif.m_done), 
        .m_busy(sif.m_busy), 
        .s_tx_data(sif.s_tx_data), 
        .s_rx_data(sif.s_rx_data), 
        .s_done(sif.s_done), 
        .s_busy(sif.s_busy)
    );

    initial begin
        clk = 0;
        reset = 1;
        repeat (5) @(posedge clk);
        reset = 0;
    end

    initial begin
        uvm_config_db #(virtual spi_if)::set(null, "*", "sif", sif);
        run_test();
    end
    
    initial begin
        $fsdbDumpfile("novas.fsdb");
        $fsdbDumpvars(0, tb_spi, "+all");
    end
endmodule
