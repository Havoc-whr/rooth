// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rooth.v
// Author        : whr
// Created On    : 2022-07-01 23:14
// Last Modified : 2023-01-14 17:01
// ---------------------------------------------------------------------------------
// Description   : 
//
// -FHDR----------------------------------------------------------------------------
`include "./hdl_file/rooth_defines.v"

module rooth_soc(
    input                   clk,
    input                   rst_n,
    input  [`INT_BUS]       int_flag_i
); 
// master 0 interface data_mem
wire[`CPU_WIDTH-1:0] m0_addr_i;
wire[`CPU_WIDTH-1:0] m0_data_i;
wire[`CPU_WIDTH-1:0] m0_data_o;
wire m0_req_i;
wire m0_we_i;

// master 1 interface
wire[`CPU_WIDTH-1:0] m1_addr_i;
wire[`CPU_WIDTH-1:0] m1_data_i;
wire[`CPU_WIDTH-1:0] m1_data_o;
wire m1_req_i;
wire m1_we_i;

// master 2 interface
wire[`CPU_WIDTH-1:0] m2_addr_i;
wire[`CPU_WIDTH-1:0] m2_data_i;
wire[`CPU_WIDTH-1:0] m2_data_o;
wire m2_req_i;
wire m2_we_i;

// master 3 interface
wire[`CPU_WIDTH-1:0] m3_addr_i;
wire[`CPU_WIDTH-1:0] m3_data_i;
wire[`CPU_WIDTH-1:0] m3_data_o;
wire m3_req_i;
wire m3_we_i;

// slave 0 interface
wire[`CPU_WIDTH-1:0] s0_addr_o;
wire[`CPU_WIDTH-1:0] s0_data_o;
wire[`CPU_WIDTH-1:0] s0_data_i;
wire s0_we_o;

// slave 1 interface
wire[`CPU_WIDTH-1:0] s1_addr_o;
wire[`CPU_WIDTH-1:0] s1_data_o;
wire[`CPU_WIDTH-1:0] s1_data_i;
wire s1_we_o;

// slave 2 interface
wire[`CPU_WIDTH-1:0] s2_addr_o;
wire[`CPU_WIDTH-1:0] s2_data_o;
wire[`CPU_WIDTH-1:0] s2_data_i;
wire s2_we_o;

// slave 3 interface
wire[`CPU_WIDTH-1:0] s3_addr_o;
wire[`CPU_WIDTH-1:0] s3_data_o;
wire[`CPU_WIDTH-1:0] s3_data_i;
wire s3_we_o;

// slave 4 interface
wire[`CPU_WIDTH-1:0] s4_addr_o;
wire[`CPU_WIDTH-1:0] s4_data_o;
wire[`CPU_WIDTH-1:0] s4_data_i;
wire s4_we_o;

// slave 5 interface
wire[`CPU_WIDTH-1:0] s5_addr_o;
wire[`CPU_WIDTH-1:0] s5_data_o;
wire[`CPU_WIDTH-1:0] s5_data_i;
wire s5_we_o;

wire                 bus_hold_flag;

rooth u_rooth_0(
    .clk                ( clk                   ),
    .rst_n              ( rst_n                 ),
    .bus_hold_flag      ( bus_hold_flag         ),
    .int_flag_i         ( int_flag_i            ),
    .data_mem_data_out_i( m0_data_o             ),
    .data_mem_addr_o    ( m0_addr_i             ),
    .data_mem_req_o     ( m0_req_i              ),
    .data_mem_wr_en_o   ( m0_we_i               ),
    .data_mem_data_in_o ( m0_data_i             ),
    .pc_inst_i          ( m1_data_o             ),
    .pc_curr_pc_o       ( m1_addr_i             )
);
rib u_rib_0(
    .clk                ( clk                   ),
    .rst                ( rst_n                 ),

    .m0_addr_i          ( m0_addr_i             ),
    .m0_data_i          ( m0_data_i             ),
    .m0_data_o          ( m0_data_o             ),
    .m0_req_i           ( m0_req_i              ),
    .m0_we_i            ( m0_we_i               ),

    .m1_addr_i          ( m1_addr_i             ),
    .m1_data_i          ( `CPU_WIDTH'b0         ),
    .m1_data_o          ( m1_data_o             ),
    .m1_req_i           ( 1'b1                  ),
    .m1_we_i            ( 1'b0                  ),

    .m2_addr_i          ( m2_addr_i             ),
    .m2_data_i          ( m2_data_i             ),
    .m2_data_o          ( m2_data_o             ),
    .m2_req_i           ( m2_req_i              ),
    .m2_we_i            ( m2_we_i               ),

    .m3_addr_i          ( m3_addr_i             ),
    .m3_data_i          ( m3_data_i             ),
    .m3_data_o          ( m3_data_o             ),
    .m3_req_i           ( m3_req_i              ),
    .m3_we_i            ( m3_we_i               ),

    .s0_addr_o          ( s0_addr_o             ),
    .s0_data_o          ( s0_data_o             ),
    .s0_data_i          ( s0_data_i             ),
    .s0_we_o            ( s0_we_o               ),

    .s1_addr_o          ( s1_addr_o             ),
    .s1_data_o          ( s1_data_o             ),
    .s1_data_i          ( s1_data_i             ),
    .s1_we_o            ( s1_we_o               ),

    .s2_addr_o          ( s2_addr_o             ),
    .s2_data_o          ( s2_data_o             ),
    .s2_data_i          ( s2_data_i             ),
    .s2_we_o            ( s2_we_o               ),

    .s3_addr_o          ( s3_addr_o             ),
    .s3_data_o          ( s3_data_o             ),
    .s3_data_i          ( s3_data_i             ),
    .s3_we_o            ( s3_we_o               ),

    .s4_addr_o          ( s4_addr_o             ),
    .s4_data_o          ( s4_data_o             ),
    .s4_data_i          ( s4_data_i             ),
    .s4_we_o            ( s4_we_o               ),

    .s5_addr_o          ( s5_addr_o             ),
    .s5_data_o          ( s5_data_o             ),
    .s5_data_i          ( s5_data_i             ),
    .s5_we_o            ( s5_we_o               ),

    .hold_flag_o        ( bus_hold_flag         )
);

inst_mem u_inst_mem_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .wr_en_i                        ( s0_we_o                     ),
    .data_i                         ( s0_data_o                   ),
    .curr_pc_i                      ( s0_addr_o                   ),
    .inst_o                         ( s0_data_i                   )
);

data_mem u_data_mem_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .adder_i                        ( s1_addr_o                   ),
    .wr_en_i                        ( s1_we_o                     ),
    .data_i                         ( s1_data_o                   ),
    .data_o                         ( s1_data_i                   )
);

endmodule
