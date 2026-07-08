`timescale 1ns / 1ps

module i2c_top #(
    parameter logic [6:0] SLA_ADDR = 7'h12
)(
    input  logic clk,
    input  logic reset,

    input  logic       m_cmd_start,
    input  logic       m_cmd_write,
    input  logic       m_cmd_read,
    input  logic       m_cmd_stop,
    input  logic [7:0] m_tx_data,
    input  logic       m_ack_in,
    output logic [7:0] m_rx_data,
    output logic       m_done,
    output logic       m_ack_out,
    output logic       m_busy,

    input  logic [7:0] s_tx_data,
    output logic [7:0] s_rx_data,
    output logic       s_done,
    output logic       s_busy,

    output wire scl,
    inout  wire sda
);

    I2C_MASTER u_master (
        .clk        (clk),
        .reset      (reset),
        
        .cmd_start  (m_cmd_start),
        .cmd_write  (m_cmd_write),
        .cmd_read   (m_cmd_read),
        .cmd_stop   (m_cmd_stop),
        .tx_data    (m_tx_data),
        .ack_in     (m_ack_in),
        
        .rx_data    (m_rx_data),
        .done       (m_done),
        .ack_out    (m_ack_out),
        .busy       (m_busy),
        
        .scl        (scl),
        .sda        (sda)
    );

    I2C_SLAVE #(
        .SLA_ADDR   (SLA_ADDR)
    ) u_slave (
        .clk        (clk),
        .reset      (reset),
        
        .tx_data    (s_tx_data),
        .rx_data    (s_rx_data),
        .done       (s_done),
        .busy       (s_busy),
        
        .scl        (scl),
        .sda        (sda)
    );

endmodule