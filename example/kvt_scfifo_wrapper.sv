// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_wrapper.sv
// Create date: 16/11/2021
//
// Description: Wrapper scfifo
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_WRAPPER
`define INC_KVT_SCFIFO_WRAPPER

module kvt_scfifo_wrapper(kvt_scfifo_env_if scfifo_env_if);

fifo#(
    .DEPTH_WIDTH(`AW),  //| FIFO Depth (power of 2)
    .DATA_WIDTH(`DW)    //| Data Width
) 
scfifo_inst
(
    .clk(scfifo_env_if.clk_if.clk),
    .rst(scfifo_env_if.rst_if.reset),

    .wr_data_i(scfifo_env_if.scfifo_if.wr_data_i),
    .wr_en_i(scfifo_env_if.scfifo_if.wr_en_i),

    .rd_data_o(scfifo_env_if.scfifo_if.rd_data_o),
    .rd_en_i(scfifo_env_if.scfifo_if.rd_en_i),

    .full_o(scfifo_env_if.scfifo_if.full_o),
    .empty_o(scfifo_env_if.scfifo_if.empty_o)
);

        // Check when project compile
        generate
                if(`DW < 1) $error("FATAL - DW must be > 0. DW = %0h \n", `DW);
                if(`AW < 1) $error("FATAL - AW must be > 0. DW = %0h \n", `AW);
        endgenerate
endmodule
`endif // INC_KVT_SCFIFO_WRAPPER