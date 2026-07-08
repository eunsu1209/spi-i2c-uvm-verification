`ifndef I2C_SEQUENCE_SV
`define I2C_SEQUENCE_SV

`include  "uvm_macros.svh"
import uvm_pkg::*;
`include "i2c_seq_item.sv"
    
class i2c_rand_seq extends uvm_sequence #(i2c_seq_item);
    `uvm_object_utils(i2c_rand_seq)
    int num_trans = 10; 

    function new(string name = "i2c_rand_seq");
        super.new(name);
    endfunction

    virtual task body();
        i2c_seq_item req;
        bit is_read;
        logic [7:0] rand_slave_data;

        repeat (num_trans) begin

            is_read = $urandom_range(0, 1);
            rand_slave_data = $urandom();
            
            req = i2c_seq_item::type_id::create("req");
            start_item(req);
            req.op = I2C_START;
            req.s_tx_data = rand_slave_data;
            finish_item(req);

            req = i2c_seq_item::type_id::create("req");
            start_item(req);
            req.op = I2C_WRITE;
            if (is_read) begin
                req.m_tx_data = 8'h25;
            end else begin
                req.m_tx_data = 8'h24;
            end
            req.s_tx_data = rand_slave_data;
            finish_item(req);

            req = i2c_seq_item::type_id::create("req");
            start_item(req);
            if (is_read) begin
                req.op = I2C_READ;
                req.randomize();
                req.m_ack_in = 1'b1;
            end else begin
                req.op = I2C_WRITE;
                req.randomize();
            end
            req.s_tx_data = rand_slave_data;
            finish_item(req);

            req = i2c_seq_item::type_id::create("req");
            start_item(req);
            req.op = I2C_STOP;
            req.s_tx_data = rand_slave_data;
            finish_item(req);

            #500;
        end
    endtask
endclass

`endif

