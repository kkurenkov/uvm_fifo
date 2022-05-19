// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_tb_top.sv
// Create date: 16/11/2021
//
// Description: Top-level testbench for QSPI Controller
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SC_FIFO_TB_TOP_SV
`define INC_KVT_SC_FIFO_TB_TOP_SV

module tb_top;

// Environment main interface
kvt_scfifo_env_if  scfifo_env_if();
kvt_scfifo_wrapper  dut(scfifo_env_if);

    // -----------------------------------------------------------------------------
    // UVM test phase initiator
    // -----------------------------------------------------------------------------

    initial begin
        uvm_config_db#(virtual kvt_scfifo_env_if)::set(null, "uvm_test_top", "vif", scfifo_env_if);
        /**
        * Invoke run_test after set_config_db calls in other/peer initial blocks have been executed
        */
        repeat (100) #0;
        /** Start the UVM tests */
        run_test();
    end

endmodule : tb_top

`endif // INC_KVT_SC_FIFO_TB_TOP_SV
