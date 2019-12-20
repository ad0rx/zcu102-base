// UG1037 Table A-5
// AXI Spec Table B1-1
//  A3.2
//  All inputs are flopped
//  no resets - relying on global FPGA reset of Xilinx system as recommended by X
module base
  #(
    //parameter PROTOCOL     = "AXI4LITE",
    //parameter HAS_BURST    = 0,
    //parameter HAS_CACHE    = 0,
    //parameter HAS_LOCK     = 0,
    //parameter HAS_PROT     = 1,
    //parameter HAS_QOS      = 0,
    //parameter HAS_REGION   = 0,
    //parameter HAS_WSTRB    = 1,
    //parameter HAS_BRESP    = 1,
    //parameter HAS_RRESP    = 1,
    parameter P_ADDR_WIDTH = 8,
    parameter P_DATA_WIDTH = 32,
    parameter P_NUM_LED    = 8,
    parameter P_NUM_SWITCH = 8,
    parameter P_NUM_BUTTON = 5
    )
   (
    /*AUTOARG*/
    // Outputs
    s_awready, s_wready, s_bvalid, s_bresp, s_arready, s_rvalid,
    s_rdata, s_rresp, irq, leds, uart_txd, aux_resetn,
    // Inputs
    ACLK, ARESETN, s_awvalid, s_awaddr, s_awprot, s_wvalid, s_wdata,
    s_wstrb, s_bready, s_arvalid, s_araddr, s_arprot, s_rready,
    switches, buttons, uart_rxd
    );

   // Clock and Reset
   (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ACLK CLK" *)
   (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET ARESETN" *)
   input ACLK;

   (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ARESETN RST" *)
   (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
   input ARESETN;

   // Write Address Channel
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *)
   input s_awvalid;

   // Write address ready
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *)
   output s_awready;

   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *)
   input [P_ADDR_WIDTH-1:0] s_awaddr;

   // Protection type
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWPROT" *)
   input [2:0]		    s_awprot;

   // Write Data Channel
   // Write valid
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *)
   input		    s_wvalid;

   // Write ready
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *)
   output		    s_wready;

   // Write data
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *)
   input [P_DATA_WIDTH-1:0] s_wdata;

   // Write strobes
   // Byte lanes
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *)
   input [(P_DATA_WIDTH/8)-1:0] s_wstrb;

   // Write Response Channel
   // Write response valid
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *)
   output			s_bvalid;

   // Write response ready
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *)
   input			s_bready;

   // Write response
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *)
   output [1:0]			s_bresp;

   // Read Address Channel
   // Read address valid
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *)
   input			s_arvalid;

   // Read address ready
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *)
   output			s_arready;

   // Read address
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *)
   input [P_ADDR_WIDTH-1:0]	s_araddr;

   // Protection type
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARPROT" *)
   input [2:0]			s_arprot;

   // Read Data Channel
   // Read valid
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *)
   output			s_rvalid;

   // Read ready
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *)
   input			s_rready;

   // Read data
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *)
   output [P_DATA_WIDTH-1:0]	s_rdata;

   // Read response
   (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *)
   output [1:0]			s_rresp;

   // Interrupt Request
   output			irq;

   // General Purpose Output
   output [P_NUM_LED-1:0]	leds;

   // General Purpose Input
   input [P_NUM_SWITCH-1:0]	switches;

   input [P_NUM_BUTTON-1:0]	buttons;

   // UART
   (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART RxD" *)
   input			uart_rxd;

   (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 UART TxD" *)
   output			uart_txd;

   // Reset Output
   // Able to reset PL from PS
   // Needs another clock and input reset
   // don't connect to ARESETN, only global reset
   // implement as a counter so that it auto clears
   (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 AUX_RESET RST" *)
   (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
   output			aux_resetn;

   // Write Address Signals
   reg [P_ADDR_WIDTH-1:0]	write_addr;
   reg				s_awready_reg;
   reg				s_awvalid_q;
   reg [P_ADDR_WIDTH-1:0]	s_awaddr_q;

   // Write Data Signals
   reg [P_DATA_WIDTH-1:0]	write_data;
   reg				s_wvalid_q;
   reg				s_wready_reg;
   reg [P_DATA_WIDTH-1:0]	s_wdata_q;
   //reg [(P_DATA_WIDTH/8)-1:0]		s_wstrb_q;

   // Write Response
   reg				s_bvalid_reg;
   reg				s_bready_q;
   reg [1:0]			s_bresp_reg;


   //top_level_assignments
   assign s_awready = s_awready_reg;
   assign s_wready  = s_wready_reg;
   assign s_bvalid  = s_bvalid_reg;
   assign s_bresp   = s_bresp_reg;

   // Write Address
   always @ (posedge ACLK)
     begin

	s_awvalid_q   <= s_awvalid;
	s_awaddr_q    <= s_awaddr;
	s_awready_reg <= 1'b1;

	if (s_awvalid_q == 1'b1)
	  begin
	   write_addr <= s_awaddr_q;
	end

     end

   // Write Data
   // need to update for data to go into proper register
   always @ (posedge ACLK)
     begin

	s_wvalid_q   <= s_wvalid;
	s_wdata_q    <= s_wdata;
	s_wready_reg <= 1'b1;

	if (s_wvalid_q == 1'b1)
	  begin
	     write_data <= s_wdata_q;
	  end

     end

   // Write Response
   always @ (posedge ACLK)
     begin

	s_bready_q  <= s_bready;
	s_bresp_reg <= 2'b00;

	if (s_wvalid_q == 1'b1 && s_wready_reg == 1'b1)
	  begin
	     s_bvalid_reg <= 1'b1;
	  end else if (s_bready == 1'b1)
	    begin
	       s_bvalid_reg <= 1'b0;
	    end

     end

endmodule // base_ip
