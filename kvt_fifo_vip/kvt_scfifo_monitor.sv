// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_monitor.sv
// Create date: 16/11/2021
// Description: scfifo monitor
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_MONITOR
`define INC_KVT_SCFIFO_MONITOR

class kvt_scfifo_monitor extends uvm_monitor;
	virtual kvt_scfifo_if scfifo_vif;

	`uvm_component_utils(kvt_scfifo_monitor)

	uvm_analysis_port #(kvt_scfifo_seq_item)  item_wr_port;
	uvm_analysis_port #(kvt_scfifo_seq_item)  item_rd_port;

	kvt_scfifo_seq_item                       collect_wr_item;
	kvt_scfifo_seq_item                       collect_rd_item;

	// ----------------------------------------------------------------------------
	// function new
	// ----------------------------------------------------------------------------

	function new( string name, uvm_component parent);
		super.new(name, parent);
		item_wr_port = new("item_wr_port", this);
		item_rd_port = new("item_rd_port", this);
	endfunction 

	// ----------------------------------------------------------------------------
	// function void build_phase
	// ----------------------------------------------------------------------------

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction 

	// ----------------------------------------------------------------------------
	// task run_phase
	// ----------------------------------------------------------------------------

	task run_phase(uvm_phase phase);
		collect_wr_item = kvt_scfifo_seq_item::type_id::create("collect_wr_item", this);
		collect_rd_item = kvt_scfifo_seq_item::type_id::create("collect_rd_item", this);

		forever begin 
			collect_data();
		end 
	endtask

	// ----------------------------------------------------------------------------
	// task collect_data
	// ----------------------------------------------------------------------------

	task collect_data(); 
		wait(!scfifo_vif.rst);
		// Inputs 
		fork
			write_req_task(); 
			read_req_task(); 
			wait_reset();
		join_any
		disable fork;
	endtask 

	// ----------------------------------------------------------------------------
	// task wait_reset
	// ----------------------------------------------------------------------------

	task wait_reset();
		wait(scfifo_vif.rst);
	endtask

	// ----------------------------------------------------------------------------
	// task write_req_task
	// ----------------------------------------------------------------------------

	task write_req_task(); 
		forever begin
			@(negedge scfifo_vif.clk);
			
			if((scfifo_vif.wr_en_i)&& (!scfifo_vif.full_o)) begin
				collect_wr_item.wr_data_i = scfifo_vif.wr_data_i;
				`uvm_info("WRITE", $sformatf("write_req_task wr_en_i = %0h full_o %0h, wr_data_i %0h",scfifo_vif.wr_en_i, scfifo_vif.full_o, scfifo_vif.wr_data_i), UVM_MEDIUM)
				item_wr_port.write(collect_wr_item);
			end
		end
	endtask

	// ----------------------------------------------------------------------------
	// task read_req_task
	// ----------------------------------------------------------------------------

	task read_req_task(); 
		forever begin

			if((scfifo_vif.rd_en_i)&&(!scfifo_vif.empty_o)) begin
				@(negedge scfifo_vif.clk);
				collect_rd_item.rd_data_o = scfifo_vif.rd_data_o;    
				`uvm_info("READ", $sformatf("read_req_task rd_en_i = %0h empty_o %0h, rd_data_o %0h",scfifo_vif.rd_en_i, scfifo_vif.empty_o, scfifo_vif.rd_data_o), UVM_MEDIUM)
				item_rd_port.write(collect_rd_item);
			end
			else
				@(negedge scfifo_vif.clk);

		end
	endtask

endclass 


`endif // INC_KVT_SCFIFO_MONITOR