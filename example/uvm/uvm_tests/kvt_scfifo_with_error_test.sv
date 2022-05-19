//// ----------------------------------------------------------------------------
// Author:   Kurenkov Konstantin
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_with_error_test.sv
// Create date: 29/04/2022
//
// Description: Test without override by type.
//
// ----------------------------------------------------------------------------

`ifndef KVT_SCFIFO_WITH_ERROR_TEST_SV
`define KVT_SCFIFO_WITH_ERROR_TEST_SV

class kvt_scfifo_with_error_test extends kvt_scfifo_base_test;

    `uvm_component_utils(kvt_scfifo_with_error_test)

	// ----------------------------------------------------------------------------
	// function new
	// ----------------------------------------------------------------------------

    function new(string name = "kvt_scfifo_with_error_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

	// ----------------------------------------------------------------------------
	// function void build_phase
	// ----------------------------------------------------------------------------

	virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
		num_rst = 0;
		// set_type_override_by_type(kvt_scfifo_driver::get_type(), kvt_scfifo_driver_with_constraints::get_type());
	endfunction
	
	// ----------------------------------------------------------------------------
	// task void main_phase
	// ----------------------------------------------------------------------------

    virtual task main_phase(uvm_phase phase);
		phase.raise_objection(this, "Starting main_phase" );
		fork
			send_transaction();
			run_rst_on_the_fly();
		join_any
		disable fork;
		env.scfifo_agent.sequencer.stop_sequences();
		phase.drop_objection(this, "Ending main_phase");
	endtask : main_phase

	task send_transaction();
		kvt_scfifo_base_seq scfifo_seq;
		kvt_scfifo_random scfifo_random;
		scfifo_seq = kvt_scfifo_base_seq::type_id::create("scfifo_seq");
		scfifo_random = kvt_scfifo_random::type_id::create("scfifo_random");

		for (int i = 0; i < 40; i++) begin
			assert(scfifo_seq.randomize() with {
				rd_en == 0;
				wr_en == 1;
				});
			scfifo_seq.start(env.scfifo_agent.sequencer);
        end
		
		#7;
        for (int i = 0; i < 10; i++) begin
			assert(scfifo_seq.randomize() with {
				rd_en == 1;
				wr_en == 0;
				});
			scfifo_seq.start(env.scfifo_agent.sequencer);
        end
		#29;
		for (int i = 0; i < 1000; i++) begin
			assert(scfifo_random.randomize());
			scfifo_random.start(env.scfifo_agent.sequencer);
        end

        #1000;
	endtask

endclass : kvt_scfifo_with_error_test
`endif // KVT_SCFIFO_WITH_ERROR_TEST_SV