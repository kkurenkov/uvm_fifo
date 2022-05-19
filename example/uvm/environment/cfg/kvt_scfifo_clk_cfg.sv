// ----------------------------------------------------------------------------
// Author:   Konstantin Kurenkov
// Email:    krendkrend@gmail.com
// FileName: kvt_scfifo_clk_cfg.sv
// Create date: 19/11/2021
//
// Description: Clock configuration
//
// ----------------------------------------------------------------------------

`ifndef KVT_SCFIFO_CLK_CFG
`define KVT_SCFIFO_CLK_CFG

class kvt_scfifo_clk_cfg extends uvm_object;
    tvip_clock_vif      vif;
    /* PUBLIC ITEMS */
                   real clk_period_ns;
              rand bit  enable_freq_drift;
              rand bit  enable_equal_clock;

    /* PRIVATE ITEMS */
    protected      real clk_freq_mhz;

    protected rand int  clk_freq_int;

    protected rand int  clk_freq_drift;

    constraint basic_range_c {
        clk_freq_int inside {[100:300]};
    }

    constraint drift_range_c {
        if(enable_freq_drift) {
            clk_freq_drift inside {-1,1};
        } else {
            clk_freq_drift == 0;
        }
    }

    constraint equal_clock_c {
        if (enable_equal_clock) {
            soft clk_freq_drift == clk_freq_drift;
        }
    }

    constraint equal_clock_control_c {
        soft enable_equal_clock == 0;
    }

    constraint freq_drift_control_c {
        soft enable_freq_drift == 1;
    }

    function void post_randomize();
        clk_freq_mhz = real'(clk_freq_int) + (real'(clk_freq_int) * real'(clk_freq_drift))/100.0;
        clk_period_ns = 1000.0/clk_freq_mhz;
    endfunction : post_randomize

    function new(string name = "kvt_scfifo_clk_cfg");
        super.new(name);
    endfunction : new

    `uvm_object_utils(kvt_scfifo_clk_cfg)

    // ----------------------------------------------------------------------------
    // function void set_vif
    // ----------------------------------------------------------------------------

    function void set_vif(tvip_clock_vif _vif);
      vif_ref_is_not_null: assert(_vif != null)
      else
        `uvm_fatal(get_full_name(), $sformatf("arg ref passed to %s via 'set_vif' is null", get_full_name()))
      vif = _vif;
    endfunction

endclass : kvt_scfifo_clk_cfg

`endif // KVT_SCFIFO_CLK_CFG
