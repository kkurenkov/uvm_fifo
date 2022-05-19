// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_agent.sv
// Create date: 16/11/2021
// Description: scfifo agent 
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_AGENT
`define INC_KVT_SCFIFO_AGENT

class kvt_scfifo_agent extends uvm_agent;
  virtual kvt_scfifo_if vif;
  `uvm_component_utils_begin(kvt_scfifo_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end 

  kvt_scfifo_driver                         driver;
  kvt_scfifo_monitor                        monitor;
  kvt_scfifo_sequencer                      sequencer; 
  uvm_analysis_port #(kvt_scfifo_seq_item)  item_wr_port;
  uvm_analysis_port #(kvt_scfifo_seq_item)  item_rd_port;

  uvm_active_passive_enum  is_active; 

	// ----------------------------------------------------------------------------
	// function new
	// ----------------------------------------------------------------------------

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction 

	// ----------------------------------------------------------------------------
	// function void build_phase
	// ----------------------------------------------------------------------------

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    item_wr_port = new("item_wr_port", this);
    item_rd_port = new("item_rd_port", this);
	  is_active = UVM_ACTIVE;
	  monitor     = kvt_scfifo_monitor::type_id::create("monitor", this);
    monitor.scfifo_vif = vif;
    if (is_active == UVM_ACTIVE) begin 
      driver    = kvt_scfifo_driver::type_id::create("driver", this);
      driver.scfifo_vif = vif;
      sequencer    = kvt_scfifo_sequencer::type_id::create("sequencer", this);
    end 
  endfunction 

	// ----------------------------------------------------------------------------
	// function void connect_phase
	// ----------------------------------------------------------------------------

  function void connect_phase(uvm_phase phase);
    monitor.item_wr_port.connect(item_wr_port);
    monitor.item_rd_port.connect(item_rd_port);

    if (is_active == UVM_ACTIVE) 
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction 

endclass 

`endif // INC_KVT_SCFIFO_AGENT