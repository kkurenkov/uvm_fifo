// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_sequencer.sv
// Create date: 16/11/2021
// Description: scfifo sequencer
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_SEQUENCER
`define INC_KVT_SCFIFO_SEQUENCER

class kvt_scfifo_sequencer extends uvm_sequencer #(kvt_scfifo_seq_item); 
  
  `uvm_component_utils(kvt_scfifo_sequencer)

  // ----------------------------------------------------------------------------
  // function new
  // ----------------------------------------------------------------------------

  function new(string name="kvt_scfifo_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction 

endclass 

`endif