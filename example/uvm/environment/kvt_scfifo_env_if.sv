// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_env_if.sv
// Create date: 19/11/2021
//
// Description: Environment Interface
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_ENV_IF
`define INC_KVT_SCFIFO_ENV_IF

interface kvt_scfifo_env_if();
    //  Clock and the Reset
	tvip_clock_if clk_if();
    tvip_reset_if rst_if(clk_if.clk);
    
    // Fifo
    kvt_scfifo_if scfifo_if (clk_if.clk, rst_if.reset);
endinterface

`endif // INC_KVT_SCFIFO_ENV_IF