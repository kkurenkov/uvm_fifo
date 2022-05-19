// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_env_cfg.sv
// Create date: 19/11/2021
//
// Description: Environment configuration
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_ENV_CFG
`define INC_KVT_SCFIFO_ENV_CFG

class kvt_scfifo_env_cfg extends uvm_object;
    virtual kvt_scfifo_env_if vif;
    bit has_clk = 0;
    bit has_rst = 0;
    bit has_fifo_agent = 0;

    kvt_scfifo_clk_cfg         clk_cfg;
    kvt_scfifo_rst_cfg         rst_cfg;
    
    `uvm_object_utils(kvt_scfifo_env_cfg)

    extern function new(string name = "kvt_scfifo_env_cfg");
    extern function void set_vif(virtual kvt_scfifo_env_if _vif);
    extern virtual function void build();
    extern function void create_scfifo_agent_cfg();
    extern function void create_clk();
    extern function void create_rstn();
    extern function void enable_all_agent();
    
endclass : kvt_scfifo_env_cfg

// ----------------------------------------------------------------------------
// function new
// ----------------------------------------------------------------------------

function kvt_scfifo_env_cfg::new(string name = "kvt_scfifo_env_cfg");
  super.new(name);
endfunction

// ----------------------------------------------------------------------------
// function set_vif
// ----------------------------------------------------------------------------

function void kvt_scfifo_env_cfg::set_vif(virtual kvt_scfifo_env_if _vif);
  if(_vif == null) `uvm_fatal(get_full_name(), $sformatf("arg ref passed to %s is null", get_full_name()))
  vif = _vif;
endfunction

// ----------------------------------------------------------------------------
// function enable_all_agent
// ----------------------------------------------------------------------------

function void kvt_scfifo_env_cfg::enable_all_agent();
  has_clk = 1;
  has_rst = 1;
  has_fifo_agent = 1;
endfunction

// ----------------------------------------------------------------------------
// function void build
// ----------------------------------------------------------------------------

function void kvt_scfifo_env_cfg::build();
        if(has_clk)
          create_clk();

        if(has_rst)
          create_rstn();

        if(has_fifo_agent)
          create_scfifo_agent_cfg();
endfunction

// ----------------------------------------------------------------------------
// function void create_clk
// ----------------------------------------------------------------------------

function void kvt_scfifo_env_cfg::create_clk();
  clk_cfg = kvt_scfifo_clk_cfg::type_id::create("clk_cfg");
  clk_cfg.set_vif(vif.clk_if);
endfunction

// ----------------------------------------------------------------------------
// function void create_rstn
// ----------------------------------------------------------------------------

function void kvt_scfifo_env_cfg::create_rstn();
    rst_cfg = kvt_scfifo_rst_cfg::type_id::create("rst_cfg");
    rst_cfg.set_vif(vif.rst_if);
    rst_cfg.vif.reset = 0;
endfunction

// ----------------------------------------------------------------------------
// function void create_scfifo_agent_cfg
// ----------------------------------------------------------------------------

function void kvt_scfifo_env_cfg::create_scfifo_agent_cfg();
 

endfunction

`endif // INC_KVT_SCFIFO_ENV_CFG