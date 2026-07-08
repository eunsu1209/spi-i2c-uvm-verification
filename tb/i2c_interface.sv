
interface i2c_if (input logic clk, input logic reset);

    logic       m_cmd_start;
    logic       m_cmd_write;
    logic       m_cmd_read;
    logic       m_cmd_stop;
    logic [7:0] m_tx_data;
    logic       m_ack_in;
    logic [7:0] m_rx_data;
    logic       m_done;
    logic       m_ack_out;
    logic       m_busy;
    logic [7:0] s_tx_data;
    logic [7:0] s_rx_data;
    logic       s_done;
    logic       s_busy;
    wire        scl;
    wire  sda;

    clocking drv_cb @(posedge clk);
        default input #1step output #0; 
        output m_cmd_start;
        output m_cmd_write;
        output m_cmd_read;
        output m_cmd_stop;
        output m_tx_data;
        output m_ack_in;
        output s_tx_data;
        input  m_rx_data;
        input  m_done;
        input  m_ack_out;
        input  m_busy;
        input  s_rx_data;
        input  s_done;
        input  s_busy;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        input m_cmd_start;
        input m_cmd_write;
        input m_cmd_read;
        input m_cmd_stop;
        input m_tx_data;
        input m_ack_in;
        input m_rx_data;
        input m_done;
        input m_ack_out;
        input m_busy;
        input s_tx_data;
        input s_rx_data;
        input s_done;
        input s_busy;
        input scl;
    endclocking

    modport mp_drv(clocking drv_cb, input clk, input reset);
    modport mp_mon(clocking mon_cb, input clk, input reset);
    
endinterface

