// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_driver_with_constraints.sv
// Create date: 28/03/2022
// Description: scfifo driver not read transactions when fifo empty and not write transactions when fifo full
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_DRIVER_WITH_CONSTRAINTS
`define INC_KVT_SCFIFO_DRIVER_WITH_CONSTRAINTS

class kvt_scfifo_driver_with_constraints extends kvt_scfifo_driver;

	// -----------------------------------------------------------------------------
    // function new
    // -----------------------------------------------------------------------------

	function new(string name="kvt_scfifo_driver_with_constraints", uvm_component parent);
		super.new(name, parent);
	endfunction 
	`uvm_component_utils(kvt_scfifo_driver_with_constraints)

	// -----------------------------------------------------------------------------
    // task drive
    // -----------------------------------------------------------------------------

	task drive();   
		@(scfifo_vif.drv_cb);
		scfifo_vif.wr_data_i = req.wr_data_i;

		if(!scfifo_vif.full_o)
			scfifo_vif.wr_en_i = req.wr_en_i;	
		else if(req.wr_en_i) begin // if we want to write data to full fifo. we can't do this
			scfifo_vif.wr_en_i = 0;
			`uvm_info("driver_constrains", "can't write. fifo full. wr_en = 0", UVM_MEDIUM);
		end			

		if(!scfifo_vif.empty_o)
			scfifo_vif.rd_en_i   = req.rd_en_i;
		else if(req.rd_en_i) begin // if we want to read data from empty fifo. we can't do this
			scfifo_vif.rd_en_i = 0;
			`uvm_info("driver_constrains", "can't read. fifo empty. rd_en = 1", UVM_MEDIUM);
		end			
		
		@(scfifo_vif.drv_cb);
		scfifo_vif.wr_en_i = 0;	
		scfifo_vif.rd_en_i = 0;
	endtask 

endclass 

`endif // INC_KVT_SCFIFO_DRIVER_WITH_CONSTRAINTS
