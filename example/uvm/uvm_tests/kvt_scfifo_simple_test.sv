// ----------------------------------------------------------------------------
// Author:   Kurenkov Konstantin
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_simple_test.sv
// Create date: 16/11/2021
//
// Description: Simple test SCFIFO
//
// ----------------------------------------------------------------------------

`ifndef KVT_SCFIFO_SIMPLE_TEST_SV
`define KVT_SCFIFO_SIMPLE_TEST_SV

class kvt_scfifo_simple_test extends kvt_scfifo_base_test;

    `uvm_component_utils(kvt_scfifo_simple_test)

	// ----------------------------------------------------------------------------
	// function new
	// ----------------------------------------------------------------------------

    function new(string name = "kvt_scfifo_simple_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

	// ----------------------------------------------------------------------------
	// virtual function build_phase
	// ----------------------------------------------------------------------------

	virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
		num_rst = 0;
		set_type_override_by_type(kvt_scfifo_driver::get_type(), kvt_scfifo_driver_with_constraints::get_type());
	endfunction

	// ----------------------------------------------------------------------------
	// task void main_phase
	// ----------------------------------------------------------------------------

    virtual task main_phase(uvm_phase phase);
		kvt_scfifo_base_seq scfifo_seq;
		scfifo_seq = kvt_scfifo_base_seq::type_id::create("scfifo_seq");

		phase.raise_objection(this, "Starting main_phase" );

		for (int i = 0; i < 10; i++) begin
			assert(scfifo_seq.randomize() with {
				rd_en == 0;
				wr_en == 1;
				});
			scfifo_seq.start(env.scfifo_agent.sequencer);
        end
		
		for (int i = 0; i < 10; i++) begin
			assert(scfifo_seq.randomize() with {
				rd_en == 1;
				wr_en == 0;
				});
			scfifo_seq.start(env.scfifo_agent.sequencer);
        end
        #1000;
		
		phase.drop_objection(this, "Ending main_phase");
	endtask : main_phase

endclass : kvt_scfifo_simple_test
`endif // KVT_SCFIFO_SIMPLE_TEST_SV