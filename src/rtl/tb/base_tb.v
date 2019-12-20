// Simple directed test bench for the edge to level module
//
`timescale 1ns/1ps

module base_tb;

   localparam P_ADDR_WIDTH = 8;
   localparam P_DATA_WIDTH = 32;
   localparam P_NUM_LED    = 8;
   localparam P_NUM_SWITCH = 8;
   localparam P_NUM_BUTTON = 5;

   reg ACLK;
   reg ARESETN;

   /*AUTOREG*/
   reg s_awvalid;
   reg s_wvalid;
   reg s_bready;
   reg s_arvalid;
   reg s_rready;
   reg uart_rxd;
   reg [P_ADDR_WIDTH-1:0]         s_awaddr;
   reg [2:0]			  s_awprot;
   reg [P_DATA_WIDTH-1:0]	  s_wdata;
   reg [(P_DATA_WIDTH/8)-1:0]	  s_wstrb;
   reg [P_ADDR_WIDTH-1:0]	  s_araddr;
   reg [2:0]			  s_arprot;
   reg [P_NUM_SWITCH-1:0]	  switches;
   reg [P_NUM_BUTTON-1:0]	  buttons;
   //reg [P_NUM_LED-1:0]		  leds;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			aux_resetn;		// From DUT of base.v
   wire			irq;			// From DUT of base.v
   wire [P_NUM_LED-1:0]	leds;			// From DUT of base.v
   wire			s_arready;		// From DUT of base.v
   wire			s_awready;		// From DUT of base.v
   wire [1:0]		s_bresp;		// From DUT of base.v
   wire			s_bvalid;		// From DUT of base.v
   wire [P_DATA_WIDTH-1:0] s_rdata;		// From DUT of base.v
   wire [1:0]		s_rresp;		// From DUT of base.v
   wire			s_rvalid;		// From DUT of base.v
   wire			s_wready;		// From DUT of base.v
   wire			uart_txd;		// From DUT of base.v
   // End of automatics

   task axi4_lite_write_txn;
      input [P_ADDR_WIDTH-1:0] write_address;
      input [P_DATA_WIDTH-1:0] write_data;

      reg [1:0]		       resp;

      begin

	 // Set the address bus
	 s_awaddr = write_address;

	 // Set the data bus
	 s_wdata  = write_data;

	 // Set the address VALID
	 s_awvalid = 1'b1;

	 // Set data valid
	 s_wvalid  = 1'b1;

	 // Set response ready
	 s_bready  = 1'b1;

	 // Wait for READYs from slave
	 wait (s_awready == 1'b1 && s_wready == 1'b1);

	 // Wait a cycle, address transfer occurs here
	 @(posedge ACLK);

	 // De-assert Valids
	 s_awvalid = 1'b0;
	 s_wvalid  = 1'b0;

	 // Wait for response valid
	 wait (s_bvalid == 1'b1);
	 @(posedge ACLK);

	 // read the response
	 resp = s_bresp;

	 @(posedge ACLK);

	 // De-assert Ready
	 s_bready = 1'b0;

	 // Clear address and data buses
	 s_awaddr = 0;
	 s_wdata  = 0;

      end
   endtask // txn

   // Clock and Reset
   initial begin
      ACLK     = 1;
      ARESETN  = 0;

     repeat (5)
	begin
	   @(posedge ACLK);
	end

      ARESETN = 1;

   end

   always
     begin
	#10 ACLK = !ACLK;
     end

   // Test
   initial begin

      // Initializations
      s_awaddr  = {P_ADDR_WIDTH{1'b0}};
      s_awvalid = 1'b0;
      s_awprot  = 3'b0;
      s_wvalid  = 1'b0;
      s_wdata   = 1'b0;
      s_bready  = 1'b0;


      // Wait for Reset De-assert
      repeat (10)
	begin
	   @(posedge ACLK);
	end

      // Transactions
      axi4_lite_write_txn (8'hFF, 32'hDEAD_BEEF);
   end

   base
       #(
	 .P_ADDR_WIDTH (8),
	 .P_DATA_WIDTH (32),
	 .P_NUM_LED    (8),
	 .P_NUM_SWITCH (8),
	 .P_NUM_BUTTON (5)
	 )
   DUT
     (
       /*AUTOINST*/
      // Outputs
      .s_awready			(s_awready),
      .s_wready				(s_wready),
      .s_bvalid				(s_bvalid),
      .s_bresp				(s_bresp[1:0]),
      .s_arready			(s_arready),
      .s_rvalid				(s_rvalid),
      .s_rdata				(s_rdata[P_DATA_WIDTH-1:0]),
      .s_rresp				(s_rresp[1:0]),
      .irq				(irq),
      .leds				(leds[P_NUM_LED-1:0]),
      .uart_txd				(uart_txd),
      .aux_resetn			(aux_resetn),
      // Inputs
      .ACLK				(ACLK),
      .ARESETN				(ARESETN),
      .s_awvalid			(s_awvalid),
      .s_awaddr				(s_awaddr[P_ADDR_WIDTH-1:0]),
      .s_awprot				(s_awprot[2:0]),
      .s_wvalid				(s_wvalid),
      .s_wdata				(s_wdata[P_DATA_WIDTH-1:0]),
      .s_wstrb				(s_wstrb[(P_DATA_WIDTH/8)-1:0]),
      .s_bready				(s_bready),
      .s_arvalid			(s_arvalid),
      .s_araddr				(s_araddr[P_ADDR_WIDTH-1:0]),
      .s_arprot				(s_arprot[2:0]),
      .s_rready				(s_rready),
      .switches				(switches[P_NUM_SWITCH-1:0]),
      .buttons				(buttons[P_NUM_BUTTON-1:0]),
      .uart_rxd				(uart_rxd));

endmodule // level_to_edge_tb
// Local Variables:
// verilog-library-directories:("." "../")
// verilog-library-extensions:(".v" ".h")
// End:
