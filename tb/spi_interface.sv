
interface spi_if (input logic clk, input logic reset);
    logic [7:0] clk_div;
    logic [7:0] m_tx_data;
    logic m_start;
    logic [7:0] m_rx_data;
    logic m_done;
    logic m_busy;
    logic [7:0] s_tx_data;
    logic [7:0] s_rx_data;
    logic s_done;
    logic s_busy;

    clocking drv_cb @(posedge clk);
        default input #1step output #0;
        output clk_div;
        output m_tx_data;
        output m_start;
        output s_tx_data;
        input m_rx_data;
        input m_done;
        input m_busy;
        input s_rx_data;
        input s_done;
        input s_busy;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        input clk_div;
        input m_tx_data;
        input m_start;
        input m_rx_data;
        input m_done;
        input m_busy;
        input s_tx_data;
        input s_rx_data;
        input s_done;
        input s_busy;
    endclocking

    modport mp_drv(clocking drv_cb, input clk, input reset);
    modport mp_mon(clocking mon_cb, input clk, input reset);
    
endinterface


