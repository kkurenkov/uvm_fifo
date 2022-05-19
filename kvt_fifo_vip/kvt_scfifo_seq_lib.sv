// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_seq_lib.sv
// Create date: 16/11/2021
// Description: scfifo sequence lib
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_BASE_SEQ
`define INC_KVT_SCFIFO_BASE_SEQ

class kvt_scfifo_base_seq   extends  uvm_sequence  #(kvt_scfifo_seq_item);
  `uvm_object_utils(kvt_scfifo_base_seq) 
  // Inputs 
    rand logic [`DW-1:0]                         data_in;
    rand logic                                   rd_en;
    rand logic                                   wr_en;

  constraint rd_en_c { soft rd_en == 1;}
  constraint wr_en_c { soft wr_en == 1;}

  // ----------------------------------------------------------------------------
  // function new
  // ----------------------------------------------------------------------------

  function new(string name="kvt_scfifo_base_seq");
    super.new(name);
  endfunction 

  // ----------------------------------------------------------------------------
  // virtual task body
  // ----------------------------------------------------------------------------

  virtual task body();
    kvt_scfifo_seq_item   req;

    `uvm_create(req)
     assert(req.randomize() with {
                  wr_data_i == data_in;
                  rd_en_i   == rd_en;
                  wr_en_i   == wr_en;  
      				   })
    
    `uvm_send(req)
  endtask 

endclass 

class kvt_scfifo_random extends kvt_scfifo_base_seq;
  `uvm_object_utils(kvt_scfifo_random)

  constraint rd_en_c { rd_en dist {1:=75, 0:=25};}
  constraint wr_en_c { wr_en dist {1:=45, 0:=55};}

  // ----------------------------------------------------------------------------
  // function new
  // ----------------------------------------------------------------------------

  function new(string name="kvt_scfifo_random");
    super.new(name);
  endfunction 

  // ----------------------------------------------------------------------------
  //    virtual task body
  // ----------------------------------------------------------------------------

   virtual task body();
    kvt_scfifo_seq_item   req;

    `uvm_create(req)
     assert(req.randomize() with {
                  wr_data_i == data_in;
                  rd_en_i   == rd_en;
                  wr_en_i   == wr_en;  
      				   })
    
    `uvm_send(req)
  endtask 

endclass

`endif