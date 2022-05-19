// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_if.sv
// Create date: 16/11/2021
// Description: scfifo interface
//
// ----------------------------------------------------------------------------


`ifndef INC_KVT_SCFIFO_IF
`define INC_KVT_SCFIFO_IF

interface kvt_scfifo_if(input clk, input rst);
    logic           [`DW-1:0]               wr_data_i;
    logic                                   wr_en_i;

    logic           [`DW-1:0]               rd_data_o;
    logic                                   rd_en_i;

    logic                                   empty_o;
    logic                                   full_o;

    clocking drv_cb@(posedge clk);
                default input #1 output #0;

                // output
                output wr_data_i;
                output wr_en_i;
                output rd_en_i;
                
                //input                 
                input rd_data_o;
                input empty_o;
                input full_o;
    endclocking

endinterface : kvt_scfifo_if

`endif //  INC_KVT_SCFIFO_IF