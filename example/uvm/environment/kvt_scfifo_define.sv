// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_define.sv
// Create date: 16/11/2021
//
// Description: Define parameter
//
// ----------------------------------------------------------------------------

`ifndef INC_KVT_SCFIFO_DEFINE
`define INC_KVT_SCFIFO_DEFINE

    `ifndef DW
        `define DW 0
    `endif

    `ifndef AW
        `define AW 0
    `endif
	
	`ifndef OUTPUT_REG
        `define OUTPUT_REG 0
	`endif

    `ifndef DESTINATION
        `define DESTINATION "0"
    `endif

    `ifndef TECH
        `define TECH "GENERIC"
    `endif
`endif // INC_KVT_SCFIFO_DEFINE