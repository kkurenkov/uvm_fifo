// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_env_pkg.sv
// Create date: 16/09/2021
//
// Description: test environment package
//
// ----------------------------------------------------------------------------

`ifndef KVT_SCFIFO_ENV_PKG_SV
`define KVT_SCFIFO_ENV_PKG_SV

`include "uvm_macros.svh"
`include "kvt_scfifo_pkg.sv"

`include "kvt_scfifo_env_if.sv"

package kvt_scfifo_env_pkg;
    typedef virtual tvip_clock_if tvip_clock_vif;
    typedef virtual tvip_reset_if tvip_reset_vif;

    /** Import UVM Base Package */
    import uvm_pkg::*;
    import kvt_scfifo_pkg::*;

    `include "kvt_scfifo_define.sv"
    `include "kvt_scfifo_clk_cfg.sv"
    `include "kvt_scfifo_rst_cfg.sv"
    `include "kvt_scfifo_env_cfg.sv"

    `include "kvt_scfifo_scoreboard.sv"
    `include "kvt_scfifo_env.sv"
    
    `include "../uvm_tests/kvt_scfifo_base_test.sv"
    `include "../uvm_tests/kvt_scfifo_simple_test.sv"
    `include "../uvm_tests/kvt_scfifo_random_test.sv"
    `include "../uvm_tests/kvt_scfifo_with_error_test.sv"

endpackage :  kvt_scfifo_env_pkg

`endif // KVT_SCFIFO_ENV_PKG_SV
