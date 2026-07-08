`ifndef SEQ_ITEM_SV
`define SEQ_ITEM_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class spi_seq_item extends uvm_sequence_item;
    rand logic [7:0] clk_div;
    rand logic [7:0] m_tx_data;
    rand logic [7:0] s_tx_data;
    logic [7:0] m_rx_data;
    logic [7:0] s_rx_data;

    constraint c_m_tx_data_corner {
        m_tx_data dist {
            8'h00 := 1,
            8'hFF := 1,
            8'haa := 1,
            8'h55 := 1,
            [8'h01:8'hFE] :/ 6
        };
    }

    constraint c_s_tx_data_corner {
        s_tx_data dist {
            8'h00 := 1,
            8'hFF := 1,
            8'haa := 1,
            8'h55 := 1,
            [8'h01:8'hFE] :/ 6
        };
    }
    //constraint c_clk_div {
    //    clk_div >= 8'h04;
    //}

    `uvm_object_utils_begin(spi_seq_item)
        `uvm_field_int(clk_div, UVM_ALL_ON)
        `uvm_field_int(m_tx_data, UVM_ALL_ON)
        `uvm_field_int(s_tx_data, UVM_ALL_ON)
        `uvm_field_int(m_rx_data, UVM_ALL_ON)
        `uvm_field_int(s_rx_data, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "spi_seq_item");
        super.new(name);
    endfunction


    function string convert2string();
        return $sformatf("clk_div: 0x%02h, MASTER -> tx:0x%02h rx:0x%02h, SLAVE -> tx:0x%02h rx:0x%02h",
            clk_div, m_tx_data, m_rx_data, s_tx_data, s_rx_data);
    endfunction
endclass
`endif
