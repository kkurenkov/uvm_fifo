// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_base_test.sv
//
// Description: Base test for block environment
//
// ----------------------------------------------------------------------------

`ifndef KVT_SCFIFO_BASE_TEST_SV
`define KVT_SCFIFO_BASE_TEST_SV

class kvt_scfifo_base_test extends uvm_test;

    /**
     * Instance of NVMe Device system environment
     */
    kvt_scfifo_env env;
    /**
     * Instance of clock configuration
     */
    kvt_scfifo_env_cfg cfg;
    

    int num_rst;
    int watchdog_timeout_val;
    int unsigned num_pre_wait_rst_cycles;
    int unsigned offs_rst_ns;
    int num_iterations;

    `uvm_component_utils(kvt_scfifo_base_test)

    // ----------------------------------------------------------------------------
    // function new
    // ----------------------------------------------------------------------------

    function new(string name = "kvt_scfifo_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

  	// ----------------------------------------------------------------------------
    // function void build_phase
    // ----------------------------------------------------------------------------

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!$value$plusargs("num_iterations=%d", num_iterations))
            num_iterations = 1;
        // if(!$value$plusargs("num_rst=%d", num_rst))
        //     num_rst = 50;
        if(!$value$plusargs("watchdog_timeout_val=%d", watchdog_timeout_val))
            watchdog_timeout_val = 1000000;
        
        env = kvt_scfifo_env::type_id::create("env", this);
        cfg = kvt_scfifo_env_cfg::type_id::create("cfg");
        cfg_is_not_null: assert(uvm_config_db#(virtual kvt_scfifo_env_if)::get(this, "", "vif", cfg.vif))
        else `uvm_fatal(get_full_name(), $sformatf("cfg is null: %s.cfg", get_full_name()))

        cfg.enable_all_agent();
        cfg.build();
        uvm_config_db#(kvt_scfifo_env_cfg)::set(this, "env", "cfg", cfg);

        /* Set basic timeout, keep overridable */
        uvm_top.set_timeout(500000us);
    endfunction : build_phase

    // ----------------------------------------------------------------------------
    // function void end_of_elaboration_phase
    // ----------------------------------------------------------------------------
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);

        if ($test$plusargs("print_env_hier"))
            `uvm_info(get_type_name(), $sformatf("Hierarchy of the test environment: \n%s", this.sprint()), UVM_MEDIUM)
    endfunction : end_of_elaboration_phase

    // ----------------------------------------------------------------------------
    // function void start_of_simulation_phase
    // ----------------------------------------------------------------------------

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        // Generate configurations
        void'(env.cfg.clk_cfg.randomize());
    endfunction : start_of_simulation_phase

    // ----------------------------------------------------------------------------
    // task pre_reset_phase
    // ----------------------------------------------------------------------------

    virtual task pre_reset_phase(uvm_phase phase);
        super.pre_reset_phase(phase);
        // Setup clocks
      `uvm_info(get_name(), "pre_reset_phase is started!", UVM_MEDIUM)

        env.cfg.vif.clk_if.start(env.cfg.clk_cfg.clk_period_ns);
    endtask : pre_reset_phase

    // ----------------------------------------------------------------------------
    // task reset_phase
    // ----------------------------------------------------------------------------

    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this, "Starting sequences");

        rand_offs: assert(this.randomize(offs_rst_ns) with {offs_rst_ns inside {[1:7]};})
        else `uvm_fatal(get_full_name(), "Randomization is failed!")

        #offs_rst_ns;
        env.cfg.vif.rst_if.initiate(5*env.cfg.clk_cfg.clk_period_ns);
        
        phase.drop_objection(this, "Ending sequences");
    endtask : reset_phase

    // ----------------------------------------------------------------------------
    // task run_rst_on_the_fly
    // ----------------------------------------------------------------------------

    task run_rst_on_the_fly();
      if(!$value$plusargs("rst_on_the_fly_pre_wait_cycles=%d", num_pre_wait_rst_cycles)) begin
        randomization_is_successfull: assert(this.randomize(num_pre_wait_rst_cycles) with {num_pre_wait_rst_cycles inside {[20:400]};})
        else `uvm_fatal(get_full_name(), "Randomization is failed!")
      end

      if(num_rst == 0)
        num_pre_wait_rst_cycles = 100000000;

      repeat(num_pre_wait_rst_cycles)
        @env.cfg.vif.clk_if.clk;

      `uvm_info(get_name(), "Reset on the fly is started!", UVM_MEDIUM)
    endtask


    // ----------------------------------------------------------------------------
    // task watchdog_timer_process
    // ----------------------------------------------------------------------------

    task watchdog_timer_process(int unsigned num_clk_cycles);
        repeat(num_clk_cycles)
          @env.cfg.vif.clk_if.clk;
        `uvm_fatal(get_name(), "watchdog timer is counted to zero")
    endtask

    // ----------------------------------------------------------------------------
    // task void wait_for_end
    // ----------------------------------------------------------------------------

    task wait_for_end();
      fork: wait_for_end
        watchdog_timer_process(watchdog_timeout_val);
      join_any
      disable wait_for_end;
    endtask

    // ----------------------------------------------------------------------------
    // function phase_ready_to_end
    // ----------------------------------------------------------------------------

    function void phase_ready_to_end(uvm_phase phase);
      if(phase.get_imp() == uvm_shutdown_phase::get() && num_rst > 0) begin
        num_rst--;
        
        `uvm_info(get_name(), "phase_ready_to_end is started!", UVM_MEDIUM)

        phase.jump(uvm_pre_reset_phase::get());
      end
    endfunction

endclass : kvt_scfifo_base_test
`endif // KVT_SCFIFO_BASE_TEST_SV