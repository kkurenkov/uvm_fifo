// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_rst_cfg.sv
// Create date: 19/11/2021
//
// Description: Reset configuration
//
// ----------------------------------------------------------------------------

`ifndef KVT_SCFIFO_RST_CFG
`define KVT_SCFIFO_RST_CFG

class kvt_scfifo_rst_cfg extends uvm_object;
    virtual tvip_reset_if      vif;

    function new(string name = "kvt_scfifo_rst_cfg");
        super.new(name);
    endfunction : new

    `uvm_object_utils(kvt_scfifo_rst_cfg)

    // ----------------------------------------------------------------------------
    // function void set_vif
    // ----------------------------------------------------------------------------

    function void set_vif(tvip_reset_vif _vif);
      vif_ref_is_not_null: assert(_vif != null)
      else
        `uvm_fatal(get_full_name(), $sformatf("arg ref passed to %s via 'set_vif' is null", get_full_name()))
      vif = _vif;
    endfunction

endclass : kvt_scfifo_rst_cfg

`endif // KVT_SCFIFO_RST_CFG
