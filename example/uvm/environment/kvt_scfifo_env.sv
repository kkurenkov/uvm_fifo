// ----------------------------------------------------------------------------
// Author:   Kurenkov Konstantin
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_env.sv
// Create date: 16/11/2021
//
// Description: environment for SCFIFO
//
// ----------------------------------------------------------------------------


`ifndef INC_KVT_SCFIFO_ENV
`define INC_KVT_SCFIFO_ENV

class kvt_scfifo_env extends uvm_env;

	kvt_scfifo_env_cfg 		cfg;
	kvt_scfifo_agent        scfifo_agent;
	string msg_tag = "ENV";
	//Scoreboard
	kvt_scfifo_scoreboard 	scoreboard;

	`uvm_component_utils(kvt_scfifo_env)

	function new(input string name, input uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(input uvm_phase phase);
		super.build_phase(phase);
		
		//------------------------------------------------------------------------------------------
		// Create AXI agents and configuration objects
		//------------------------------------------------------------------------------------------
		cfg_is_not_null: assert(uvm_config_db#(kvt_scfifo_env_cfg)::get(this, "", "cfg", cfg))
		else `uvm_fatal(get_full_name(), $sformatf("cfg is null: %s.cfg", get_full_name()))


	  	scfifo_agent   = kvt_scfifo_agent::type_id::create("scfifo_agent", this);
		scfifo_agent.vif = cfg.vif.scfifo_if;

		scoreboard = kvt_scfifo_scoreboard::type_id::create("scoreboard", this);

	endfunction


	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		scfifo_agent.item_wr_port.connect(scoreboard.write_fifo);
		scfifo_agent.item_rd_port.connect(scoreboard.read_fifo);
	endfunction 


	virtual function void handle_reset(uvm_phase phase);
		// scoreboard.handle_reset();
		scoreboard.reset();
		`uvm_info(msg_tag, "stop_sequencer", UVM_LOW)
		scfifo_agent.sequencer.stop_sequences();
		scfifo_agent.driver.handle_reset();
	endfunction

	//wait for reset to start
	virtual task wait_reset_start();
		@(negedge(cfg.vif.rst_if.reset));
	endtask

	//wait for reset to be finished
	virtual task wait_reset_end();
		@(posedge(cfg.vif.rst_if.reset));
	endtask


	//UVM run phase
	//@param phase - current phase
	virtual task run_phase(uvm_phase phase);
		forever begin
			wait_reset_start();

			`uvm_info(msg_tag, "Reset start detected", UVM_LOW)

			handle_reset(phase);

			wait_reset_end();

			`uvm_info(msg_tag, "Reset end detected", UVM_LOW)
		end
	endtask

endclass

`endif // INC_KVT_SCFIFO_ENV