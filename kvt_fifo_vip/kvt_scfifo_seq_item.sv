// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_seq_item.sv
// Create date: 16/11/2021
// Description: scfifo sequence item
//
// ----------------------------------------------------------------------------

`ifndef INC_SCFIFO_SEQ_ITEM
`define INC_SCFIFO_SEQ_ITEM

class kvt_scfifo_seq_item extends uvm_sequence_item;
 
  // Inputs 
  rand logic [`DW-1:0]                         wr_data_i;
  rand logic                                   wr_en_i;
  rand logic                                   rd_en_i;
  // Outputs
       logic [`DW-1:0]                         rd_data_o;
       logic                                   empty_o;
       logic                                   full_o;
  `uvm_object_utils_begin(kvt_scfifo_seq_item)
	  `uvm_field_int(wr_data_i,  UVM_ALL_ON)
  `uvm_object_utils_end

  // ----------------------------------------------------------------------------
  // function new
  // ----------------------------------------------------------------------------

  function new(string name="kvt_scfifo_seq_item");
    super.new(name);
  endfunction 

endclass 

`endif // INC_SCFIFO_SEQ_ITEM