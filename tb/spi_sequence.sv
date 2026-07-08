`ifndef SPI_SEQUENCE_SV
`define SPI_SEQUENCE_SV

`include  "uvm_macros.svh"
import uvm_pkg::*;
`include "spi_seq_item.sv"
    
class spi_rand_seq extends uvm_sequence #(spi_seq_item);
    `uvm_object_utils(spi_rand_seq)
    int num_trans = 10;

    function new(string name = "spi_rand_seq");
        super.new(name);
    endfunction

    task body();
        spi_seq_item item;
        repeat (num_trans) begin
            item = spi_seq_item::type_id::create("item");
            start_item(item);
            if (!item.randomize()) begin
                `uvm_fatal(get_type_name(), "spi_seq_item randomize() fail!")
            end
            `uvm_info(get_type_name(), item.convert2string(), UVM_MEDIUM)
            finish_item(item);
        end
    endtask
endclass

`endif
