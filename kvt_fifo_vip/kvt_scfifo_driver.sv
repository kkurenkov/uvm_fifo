// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_driver.sv
// Create date: 16/11/2021
// Description: scfifo driver 
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_DRIVER
`define INC_KVT_SCFIFO_DRIVER

class kvt_scfifo_driver extends uvm_driver #(kvt_scfifo_seq_item);

virtual kvt_scfifo_if scfifo_vif;
	protected process process_drive_transactions;
	int no_tr = 1'b0;
	`uvm_component_utils(kvt_scfifo_driver)

	// ----------------------------------------------------------------------------
	// function new
	// ----------------------------------------------------------------------------

	function new(string name="kvt_scfifo_driver", uvm_component parent);
		super.new(name, parent);
	endfunction 

	// ----------------------------------------------------------------------------
	// function void build_phase
	// ----------------------------------------------------------------------------

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("DRIVER", "In build phase", UVM_FULL)
	endfunction 

	// ----------------------------------------------------------------------------
	// function void handle_reset
	// ----------------------------------------------------------------------------

	function void handle_reset();
		if(process_drive_transactions != null) begin
			process_drive_transactions.kill();
			`uvm_info("DRIVER", "killing process for drive_transactions() task...", UVM_FULL);
		end
	endfunction

	// ----------------------------------------------------------------------------
	// task run_phase
	// ----------------------------------------------------------------------------

	task run_phase(uvm_phase phase);
		no_tr = 1'b0;
		reset_dut();

		forever begin
			fork
				begin: driver
					wait(!scfifo_vif.rst);
					seq_item_port.get(req);

					no_tr = 1'b0;
					drive();
					no_tr = 1'b1;

					disable rst;
				end

				begin: drive_null
					drive_nothing();
				end

				begin:rst
					wait(scfifo_vif.rst);
					`uvm_info(get_type_name(), "RESET Detected..", UVM_FULL)
					disable driver;
					disable drive_null;
					reset_dut();

					@(scfifo_vif.drv_cb);
					if(!scfifo_vif.rst)
						disable rst;
				end
			join
		end
	endtask 

	// ----------------------------------------------------------------------------
	// task drive_nothing
	// ----------------------------------------------------------------------------

	task drive_nothing();
		@(scfifo_vif.drv_cb);
		if (no_tr) begin 
			scfifo_vif.wr_en_i = 0;
			scfifo_vif.rd_en_i = 0; //no transaction -> drive zero.
		end
	endtask

	// ----------------------------------------------------------------------------
	// virtual task drive
	// ----------------------------------------------------------------------------

	virtual task drive();   
		@(scfifo_vif.drv_cb);
		scfifo_vif.wr_data_i = req.wr_data_i;
		if(!scfifo_vif.full_o)
			scfifo_vif.wr_en_i = req.wr_en_i;
		else
			scfifo_vif.wr_en_i = 0;

		if(!scfifo_vif.empty_o)
			scfifo_vif.rd_en_i = req.rd_en_i;
		else
			scfifo_vif.rd_en_i = 0;
	endtask 

	// ----------------------------------------------------------------------------
	// task reset_dut
	// ----------------------------------------------------------------------------

	task reset_dut();
		scfifo_vif.wr_data_i = 0;
		scfifo_vif.wr_en_i   = 0;
		scfifo_vif.rd_en_i   = 0;
	endtask 

endclass 

`endif // INC_KVT_SCFIFO_DRIVER
