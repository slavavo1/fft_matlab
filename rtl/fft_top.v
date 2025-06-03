`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 11:37:47
// Design Name: 
// Module Name: fft_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fft_top #(parameter DATA_WIDTH = 8) (
  input                     clk          ,
  input                     reset        ,
  input                     s_axis_tvalid,
  input                     s_axis_tready,
  input  [  DATA_WIDTH-1:0] s_axis_tdata ,
  output                    m_axis_tvalid,
  output                    m_axis_tready,
  output [DATA_WIDTH*4-1:0] m_axis_tdata
);

  wire [DATA_WIDTH*2-1:0] data_re_1,data_re_2;
  reg  [DATA_WIDTH*4-1:0] data_reg   ;
  reg                     valid_reg  ;
  reg                     ready_delay;
  wire                    dout_tvalid;

  fft_sub1 FFT(
    .clk(clk),
    .reset(reset),
    .enb(1),
    .enb_const_rate(1),
    .DATA_B_re(s_axis_tdata),
    .DATA_B_im('0),
    .rst(reset),
    .ENA(s_axis_tvalid & m_axis_tready),
    .Out1_re(data_re_1),
    .Out1_im(),
    .Out2_re(data_re_2),
    .Out2_im(),
    .valid(dout_tvalid)
  );

  /*------------------------------------------------------------------------------
  --  latency 1 to 0
  ------------------------------------------------------------------------------*/

  always_ff @ (posedge clk or posedge reset) begin : proc_reg
    if(reset) begin
      valid_reg <= 1'b0;
      data_reg  <= '0  ;
    end else if(ready_delay) begin
      valid_reg <= dout_tvalid;
      data_reg  <= {data_re_1,data_re_2} ;
    end
  end

  always_ff @(posedge clk or posedge reset) begin : proc_ready_delay
    if(reset)
      ready_delay <= 1'b1;
    else
      ready_delay <= m_axis_tready;
  end

  assign m_axis_tdata  = (ready_delay) ? {data_re_1,data_re_2} : data_reg ;
  assign m_axis_tvalid = (ready_delay) ? dout_tvalid : valid_reg;
  assign s_axis_tready = m_axis_tready;

endmodule
