// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_pkg.sv
// Create date: 16/11/2021
// Description: scfifo package
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_PKG
`define INC_KVT_SCFIFO_PKG
`include "uvm_macros.svh"

`include "kvt_scfifo_if.sv"

package kvt_scfifo_pkg;
    /** Import UVM Base Package */

    import uvm_pkg::*;
    `include "kvt_scfifo_seq_item.sv"
    `include "kvt_scfifo_sequencer.sv"
    `include "kvt_scfifo_driver.sv"
    `include "kvt_scfifo_driver_with_constraints.sv"
    `include "kvt_scfifo_monitor.sv"
    `include "kvt_scfifo_agent.sv"
    `include "kvt_scfifo_seq_lib.sv"
endpackage :  kvt_scfifo_pkg

`endif // INC_KVT_SCFIFO_PKG
