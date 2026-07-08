`ifndef SEQ_ITEM_SV
`define SEQ_ITEM_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum {
    I2C_START, 
    I2C_WRITE, 
    I2C_READ, 
    I2C_STOP
} i2c_op_type;

class i2c_seq_item extends uvm_sequence_item;

    i2c_op_type op;
    rand bit [7:0] m_tx_data;
    rand bit [7:0] s_tx_data;
    rand bit       m_ack_in;
    logic [7:0] m_rx_data;
    logic [7:0] s_rx_data;
    logic       m_ack_out;

    constraint c_m_tx_data_corner {
        m_tx_data dist {
            8'h00 := 1,
            8'hFF := 1,
            8'haa := 1,
            8'h55 := 1,
            8'h12 := 2,
            8'h24 := 2,
            8'h25 := 2,
            [8'h01:8'hFE] :/ 5
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
    `uvm_object_utils_begin(i2c_seq_item)
        `uvm_field_enum(i2c_op_type, op, UVM_ALL_ON)
        `uvm_field_int(m_tx_data, UVM_ALL_ON)
        `uvm_field_int(s_tx_data, UVM_ALL_ON)
        `uvm_field_int(m_ack_in, UVM_ALL_ON)
        `uvm_field_int(m_rx_data, UVM_ALL_ON)
        `uvm_field_int(s_rx_data, UVM_ALL_ON)
        `uvm_field_int(m_ack_out, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "i2c_seq_item");
        super.new(name);
    endfunction


    function string convert2string();
        return $sformatf("OP: %10s, MASTER -> tx:0x%02h rx:0x%02h (ACK_OUT: %b), SLAVE -> tx:0x%02h rx:0x%02h",
            op.name(), m_tx_data, m_rx_data, m_ack_out, s_tx_data, s_rx_data);
    endfunction
endclass
`endif

