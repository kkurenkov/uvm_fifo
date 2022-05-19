// ----------------------------------------------------------------------------
// Author:   Kurenkov Konstantin
// Email:    krendkrend@gmail.com
// FileName: kvt_sckvt_scfifo_scoreboard.sv
// Create date: 16/11/2021
//
// Description: environment for SCFIFO
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_SCOREBOARD
`define INC_KVT_SCFIFO_SCOREBOARD

`uvm_analysis_imp_decl(_write_fifo)
`uvm_analysis_imp_decl(_read_fifo)

class kvt_scfifo_scoreboard extends uvm_scoreboard;
 
    uvm_analysis_imp_read_fifo #(kvt_scfifo_seq_item, kvt_scfifo_scoreboard)  read_fifo; 
    uvm_analysis_imp_write_fifo #(kvt_scfifo_seq_item, kvt_scfifo_scoreboard) write_fifo;

    string msg_tag = "SCOREBOARD";
    logic   [`DW-1:0] data_in_q[$];
    logic   [`DW-1:0] data_out_q[$];
    int mismatch = 0;
    int match = 0;

  function  new(string name, uvm_component parent);
    super.new(name, parent);
    read_fifo  = new("read_fifo", this); 
    write_fifo  = new("write_fifo", this); 
  endfunction 

  `uvm_component_utils(kvt_scfifo_scoreboard)

  virtual function  void write_write_fifo(kvt_scfifo_seq_item transaction);
    data_in_q.push_back(transaction.wr_data_i);
  endfunction 


  virtual function  void write_read_fifo(kvt_scfifo_seq_item transaction);
    logic   [`DW-1:0] data_check;

    data_check = data_in_q.pop_front();

    if(data_check !== transaction.rd_data_o) begin
        `uvm_fatal(msg_tag, $sformatf("error data in %h != dat out %0h", data_check, transaction.rd_data_o))
        mismatch++;
    end
    else begin
        `uvm_info(msg_tag, $sformatf(" data in %h dat out %0h", data_check, transaction.rd_data_o), UVM_FULL)
         match++;
    end
  endfunction 

  function void reset();
    data_in_q.delete();
    data_out_q.delete();
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info(msg_tag, $sformatf("MATCH  %0d",match), UVM_LOW)
    `uvm_info(msg_tag, $sformatf("MISMATCH  %0d",mismatch), UVM_LOW)
  endfunction


endclass 


`endif // INC_KVT_SCkvt_scfifo_scoreboard