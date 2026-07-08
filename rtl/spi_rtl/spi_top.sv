`timescale 1ns / 1ps

module spi_top (
    input logic clk,
    input logic reset,
    // master
    input logic [7:0] clk_div,
    input logic [7:0] master_tx_data,
    input logic master_start,
    output logic [7:0] master_rx_data,
    output logic master_done,
    output logic master_busy,
    // slave
    input logic [7:0] slave_tx_data,
    output logic [7:0] slave_rx_data,
    output logic slave_done,
    output logic slave_busy
    );

    wire spi_sclk;
    wire spi_mosi;
    wire spi_miso;
    wire spi_cs_n;

    spi_master U_SPI_MASTER (
        .clk(clk), 
        .reset(reset), 
        .cpol(1'b0), 
        .cpha(1'b0), 
        .clk_div(clk_div), 
        .tx_data(master_tx_data), 
        .start(master_start), 
        .rx_data(master_rx_data), 
        .done(master_done), 
        .busy(master_busy), 
        .sclk(spi_sclk), 
        .mosi(spi_mosi), 
        .miso(spi_miso), 
        .cs_n(spi_cs_n)
    );

    spi_slave U_SPI_SLAVE (
        .clk(clk), 
        .reset(reset), 
        .tx_data(slave_tx_data), 
        .rx_data(slave_rx_data), 
        .done(slave_done), 
        .busy(slave_busy), 
        .sclk(spi_sclk), 
        .mosi(spi_mosi), 
        .miso(spi_miso), 
        .cs_n(spi_cs_n)
    );

endmodule
