// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : rooth.v
// Author        : whr
// Created On    : 2022-07-01 23:14
// Last Modified : 2023-01-14 18:32
// ---------------------------------------------------------------------------------
// Description   : 
// RISC-V32I指令处理器核顶层文件
// 语法规范：i后缀表示组合逻辑模块输入，o后缀表示组合逻辑模块输出。对于时序逻辑if模块，其
//          输入信号为组合逻辑输出，输出为组合逻辑模块输入,t表示时序逻辑之间直接传递前缀
//          表示信号作用所处于的指令周期阶段
// -FHDR----------------------------------------------------------------------------
`include "./hdl_file/rooth_defines.v"

module rooth(
    input                   clk,
    input                   rst_n,
    
    input                   bus_hold_flag,
    input  [`INT_BUS]       int_flag_i,

    input  [`CPU_WIDTH-1:0] data_mem_data_out_i,
    output [`CPU_WIDTH-1:0] data_mem_addr_o,
    output                  data_mem_req_o,
    output                  data_mem_wr_en_o,
    output [`CPU_WIDTH-1:0] data_mem_data_in_o,

    input  [`CPU_WIDTH-1:0] pc_inst_i,
    output [`CPU_WIDTH-1:0] pc_curr_pc_o
);

// pc_reg
wire [`CPU_WIDTH-1:0]    pc_curr_pc_t;
wire [`CPU_WIDTH-1:0]    de_pc_adder_t;

//decode
wire [`CPU_WIDTH-1:0]        de_inst_o;
wire [`WIDTH_BRANCH-1:0]     de_branch_o;
wire [`WIDTH_JUMP-1:0]       de_jump_o;

wire                         de_reg_wr_en_o;
wire [`REG_ADDR_WIDTH-1:0]   de_reg_wr_adder_o;
wire [`REG_ADDR_WIDTH-1:0]   de_reg1_rd_adder_o;
wire [`REG_ADDR_WIDTH-1:0]   de_reg2_rd_adder_o;

wire [`IMM_GEN_OP_WIDTH-1:0] de_imm_gen_op;

wire                         de_csr_wr_en_o;
wire [`CSR_ADDR_WIDTH-1:0]   de_csr_wr_adder_o;
wire [`CSR_ADDR_WIDTH-1:0]   de_csr_rd_adder_o;

wire [`ALU_OP_WIDTH-1:0]     de_alu_op_o;
wire [`ALU_SRC_WIDTH-1:0]    de_alu_src_sel_o;

wire [`WIDTH_RESCTRL-1:0]    de_alu_res_op_o;

//if_ex
wire [`CPU_WIDTH-1:0]       ex_inst_o;
wire                        ex_reg_wr_en_t;
wire [`REG_ADDR_WIDTH-1:0]  ex_reg_wr_adder_t;
wire                        ex_csr_wr_en_t;
wire [`CSR_ADDR_WIDTH-1:0]  ex_csr_wr_adder_t;
wire [`WIDTH_RESCTRL-1:0]   ex_alu_res_op_t;

//imm_gen
wire [`CPU_WIDTH-1:0]        de_imm_o;

//regs_file
wire [`CPU_WIDTH-1:0]        ex_reg1_rd_data;
wire [`CPU_WIDTH-1:0]        ex_reg2_rd_data;
wire [`REG_ADDR_WIDTH-1:0]   ex_reg1_rd_adder_i;
wire [`REG_ADDR_WIDTH-1:0]   ex_reg2_rd_adder_i;

//csr_reg
wire [`CPU_WIDTH-1:0]        ex_csr_rd_data;
wire [`CSR_ADDR_WIDTH-1:0]   ex_csr_rd_adder_i;
wire [`CPU_WIDTH-1:0]        csr_mtvec_o;
wire [`CPU_WIDTH-1:0]        csr_mepc_o;
wire [`CPU_WIDTH-1:0]        csr_mstatus_o;
//wire [`CPU_WIDTH-1:0]        client_csr_rd_data_o; //未使用

//mux_alu
wire [`ALU_SRC_WIDTH-1:0]   ex_alu_src_sel_i;
wire [`CPU_WIDTH-1:0]       ex_imm_i;
wire [`CPU_WIDTH-1:0]       ex_pc_adder_i;
wire [`CPU_WIDTH-1:0]       ex_alu_src1;
wire [`CPU_WIDTH-1:0]       ex_alu_src2;

//alu_core
wire [`ALU_OP_WIDTH-1:0]  ex_alu_op_i;
wire                      ex_zero;
wire                      ex_more_zero;
wire                      ex_less;
wire [`CPU_WIDTH-1:0]     ex_alu_res_o;
wire [`CPU_WIDTH-1:0]     dividend_o;
wire [`CPU_WIDTH-1:0]     divisor_o;
wire                      div_start_o;
wire                      alu_busy_o;

//div
wire [`CPU_WIDTH-1:0]     div_result_o;
wire                      div_res_ready_o;
wire                      div_busy_o;

//alu_res_ctrl
wire  [`CPU_WIDTH-1:0]      as_rs1_data_i;
wire  [`CPU_WIDTH-1:0]      as_rs2_data_i;
wire  [`CPU_WIDTH-1:0]      as_csr_rd_data_i;
wire  [`CPU_WIDTH-1:0]      as_imm_i;
wire  [`FUNCT3_WIDTH-1:0]   as_funct3_i;
wire  [`OPCODE_WIDTH-1:0]   as_opcode_i;
wire  [`WIDTH_RESCTRL-1:0]  as_alu_res_op_i;
wire  [`CPU_WIDTH-1:0]      as_alu_res_i;

wire  [`CPU_WIDTH-1:0]  as_data_mem_addr;
wire                    as_data_mem_req_o;
wire                    as_data_mem_wr_en;
wire  [`CPU_WIDTH-1:0]  as_data_mem_data_in;
wire  [`CPU_WIDTH-1:0]  as_reg_wr_data_o;
wire  [`CPU_WIDTH-1:0]  as_csr_wr_data_o;

wire [`CPU_WIDTH-1:0]   ex_reg1_rd_data_o;
wire [`CPU_WIDTH-1:0]   ex_reg2_rd_data_o;
wire [`CPU_WIDTH-1:0]   ex_csr_rd_data_o;
wire [`CPU_WIDTH-1:0]   ex_imm_t;

//if_as
wire [`CPU_WIDTH-1:0]   as_inst_o;
wire [`CPU_WIDTH-1:0]   as_pc_adder_o;

//data_mem
wire  [`CPU_WIDTH-1:0]  as_data_mem_data_out;

//if_wb
wire                        as_reg_wr_en_i;
wire [`REG_ADDR_WIDTH-1:0]  as_reg_wr_adder_i;
wire                        as_csr_wr_en_i;
wire [`CSR_ADDR_WIDTH-1:0]  as_csr_wr_adder_i;
wire                        wb_reg_wr_en;
wire [`REG_ADDR_WIDTH-1:0]  wb_reg_wr_adder;
wire [`CPU_WIDTH-1:0]       wb_reg_wr_data;
wire                        wb_csr_wr_en;
wire [`CSR_ADDR_WIDTH-1:0]  wb_csr_wr_adder;
wire [`CPU_WIDTH-1:0]       wb_csr_wr_data;
wire [`CPU_WIDTH-1:0]       wb_inst_o;
wire [`CPU_WIDTH-1:0]       wb_pc_adder_o;

//flow_ctrl
wire [`WIDTH_JUMP-1:0]    ex_jump;
wire [`CPU_WIDTH-1:0]     ex_imm;
wire [`WIDTH_BRANCH-1:0]  ex_branch;
wire [`CPU_WIDTH-1:0]     ex_pc_adder;
wire [`CPU_WIDTH-1:0]     next_pc;
wire                      next_pc_four;
wire [`FLOW_WIDTH-1:0]    flow_pc;
wire [`FLOW_WIDTH-1:0]    flow_de;
wire [`FLOW_WIDTH-1:0]    flow_ex;
wire [`FLOW_WIDTH-1:0]    flow_as;
wire [`FLOW_WIDTH-1:0]    flow_wb;

//reg_clash_fb
wire [`REG_ADDR_WIDTH-1:0]  ctrl_reg1_rd_adder;
wire [`REG_ADDR_WIDTH-1:0]  ctrl_reg2_rd_adder;
wire [`CSR_ADDR_WIDTH-1:0]  ctrl_csr_rd_adder;
wire [`CPU_WIDTH-1:0]       ctrl_reg1_rd_data;
wire [`CPU_WIDTH-1:0]       ctrl_reg2_rd_data;
wire [`CPU_WIDTH-1:0]       ctrl_csr_rd_data;

// clinet
wire                         client_csr_wr_en_o;
wire [`CSR_ADDR_WIDTH-1:0]        client_csr_wr_adder_o;
wire [`CPU_WIDTH-1:0]        client_csr_wr_data_o;
//wire [`CSR_ADDR_WIDTH-1:0]        client_csr_rd_adder_o;
wire                         client_hold_flag_o;
wire [`CPU_WIDTH-1:0]        client_int_addr_o;
wire                         client_int_assert_o;

// 例化
assign ex_pc_adder = ex_pc_adder_i;
assign ex_imm = ex_imm_i;

flow_ctrl u_flow_ctrl_0(
    .branch_i                       ( ex_branch                   ),
    .pc_adder_i                     ( ex_pc_adder                 ),
    .zero_i                         ( ex_zero                     ),
    .more_zero_i                    ( ex_more_zero                ),
    .less_i                         ( ex_less                     ),
    .jump_i                         ( ex_jump                     ),
    .imm_i                          ( ex_imm                      ),
    .reg1_rd_data_i                 ( ex_reg1_rd_data             ),
    .bus_wait_i                     ( bus_hold_flag               ),
    .alu_busy_i                     ( alu_busy_o                  ),
    .client_hold_flag_i             ( client_hold_flag_o          ),
    .client_int_addr_i              ( client_int_addr_o           ),
    .client_int_assert_i            ( client_int_assert_o         ),
    .next_pc_o                      ( next_pc                     ),
    .next_pc_four_o                 ( next_pc_four                ),
    .flow_pc_o                      ( flow_pc                     ),
    .flow_de_o                      ( flow_de                     ),
    .flow_ex_o                      ( flow_ex                     ),
    .flow_as_o                      ( flow_as                     ),
    .flow_wb_o                      ( flow_wb                     )
);


pc_reg u_pc_reg_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .flow_pc_i                      ( flow_pc                     ),
    .next_pc_four_i                 ( next_pc_four                ),
    .next_pc_i                      ( next_pc                     ),
    .curr_pc_o                      ( pc_curr_pc_o                )
);

assign pc_curr_pc_t = pc_curr_pc_o;

if_de u_if_de_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .flow_de_i                      ( flow_de                     ),
    .pc_adder_i                     ( pc_curr_pc_t                ),
    .inst_i                         ( pc_inst_i                   ),
    .pc_adder_o                     ( de_pc_adder_t               ),
    .inst_o                         ( de_inst_o                   )
);

decode u_decode_0(
    .inst_i                         ( de_inst_o                   ),
    .branch_o                       ( de_branch_o                 ),
    .jump_o                         ( de_jump_o                   ),
    .reg_wr_en_o                    ( de_reg_wr_en_o              ),
    .reg_wr_adder_o                 ( de_reg_wr_adder_o           ),
    .reg1_rd_adder_o                ( de_reg1_rd_adder_o          ),
    .reg2_rd_adder_o                ( de_reg2_rd_adder_o          ),
    .imm_gen_op_o                   ( de_imm_gen_op               ),
    .csr_wr_en_o                    ( de_csr_wr_en_o              ),
    .csr_wr_adder_o                 ( de_csr_wr_adder_o           ),
    .csr_rd_adder_o                 ( de_csr_rd_adder_o           ),
    .alu_op_o                       ( de_alu_op_o                 ),
    .alu_src_sel_o                  ( de_alu_src_sel_o            ),
    .alu_res_op_o                   ( de_alu_res_op_o             )
);

imm_gen u_imm_gen_0(
    .inst_i                         ( de_inst_o                   ),
    .imm_gen_op_i                   ( de_imm_gen_op               ),
    .imm_o                          ( de_imm_o                    )
);

if_ex u_if_ex_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .flow_ex_i                      ( flow_ex                     ),
    .inst_i                         ( de_inst_o                   ),
    .pc_adder_i                     ( de_pc_adder_t               ),
    .branch_i                       ( de_branch_o                 ),
    .jump_i                         ( de_jump_o                   ),
    .reg_wr_en_i                    ( de_reg_wr_en_o              ),
    .reg_wr_adder_i                 ( de_reg_wr_adder_o           ),
    .reg1_rd_adder_i                ( de_reg1_rd_adder_o          ),
    .reg2_rd_adder_i                ( de_reg2_rd_adder_o          ),
    .imm_i                          ( de_imm_o                    ),
    .csr_wr_en_i                    ( de_csr_wr_en_o              ),
    .csr_wr_adder_i                 ( de_csr_wr_adder_o           ),
    .csr_rd_adder_i                 ( de_csr_rd_adder_o           ),
    .alu_op_i                       ( de_alu_op_o                 ),
    .alu_src_sel_i                  ( de_alu_src_sel_o            ),
    .alu_res_op_i                   ( de_alu_res_op_o             ),
    .inst_o                         ( ex_inst_o                   ),
    .pc_adder_o                     ( ex_pc_adder_i               ),
    .branch_o                       ( ex_branch                   ),
    .jump_o                         ( ex_jump                     ),
    .reg_wr_en_o                    ( ex_reg_wr_en_t              ),
    .reg_wr_adder_o                 ( ex_reg_wr_adder_t           ),
    .reg1_rd_adder_o                ( ex_reg1_rd_adder_i          ),
    .reg2_rd_adder_o                ( ex_reg2_rd_adder_i          ),
    .imm_o                          ( ex_imm_i                    ),
    .csr_wr_en_o                    ( ex_csr_wr_en_t              ),
    .csr_wr_adder_o                 ( ex_csr_wr_adder_t           ),
    .csr_rd_adder_o                 ( ex_csr_rd_adder_i            ), 
    .alu_op_o                       ( ex_alu_op_i                 ),
    .alu_src_sel_o                  ( ex_alu_src_sel_i            ),
    .alu_res_op_o                   ( ex_alu_res_op_t             )
);

mux_alu u_mux_alu_0(
    .alu_src_sel_i                  ( ex_alu_src_sel_i            ),
    .reg1_rd_data_i                 ( ex_reg1_rd_data             ),
    .reg2_rd_data_i                 ( ex_reg2_rd_data             ),
    .csr_rd_data_i                  ( ex_csr_rd_data              ),
    .imm_i                          ( ex_imm_i                    ),
    .curr_pc_i                      ( ex_pc_adder_i               ),
    .alu_src1_o                     ( ex_alu_src1                 ),
    .alu_src2_o                     ( ex_alu_src2                 )
);

alu_core u_alu_core_0(
    .alu_op_i                       ( ex_alu_op_i                 ),
    .alu_src1_i                     ( ex_alu_src1                 ),
    .alu_src2_i                     ( ex_alu_src2                 ),
    .zero_o                         ( ex_zero                     ),
    .less_o                         ( ex_less                     ),
    .more_zero_o                    ( ex_more_zero                ),
    .div_res_ready_i                ( div_res_ready_o             ),
    .div_result_i                   ( div_result_o                ),
    .dividend_o                     ( dividend_o                  ),
    .divisor_o                      ( divisor_o                   ),
    .div_start_o                    ( div_start_o                 ),
    .alu_busy_o                     ( alu_busy_o                  ),
    .alu_res_o                      ( ex_alu_res_o                )
);

div u_div_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .dividend_i                     ( dividend_o                  ),
    .divisor_i                      ( divisor_o                   ),
    .start_i                        ( div_start_o                 ),
    .op_i                           ( ex_inst_o[14:12]            ),
    .result_o                       ( div_result_o                ),
    .ready_o                        ( div_res_ready_o             ),
    .busy_o                         ( div_busy_o                  )
);


assign ex_reg1_rd_data_o = ex_reg1_rd_data;
assign ex_reg2_rd_data_o = ex_reg2_rd_data;
assign ex_csr_rd_data_o = ex_csr_rd_data;
assign ex_imm_t = ex_imm_i;

if_as u_if_as_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .flow_as_i                      ( flow_as                     ),
    .rs1_data_i                     ( ex_reg1_rd_data_o           ),
    .rs2_data_i                     ( ex_reg2_rd_data_o           ),
    .imm_i                          ( ex_imm_t                    ),
    .inst_i                         ( ex_inst_o                   ),
    .pc_adder_i                     ( ex_pc_adder_i               ),                    
    .alu_res_op_i                   ( ex_alu_res_op_t             ),
    .alu_res_i                      ( ex_alu_res_o                ),
    .reg_wr_en_i                    ( ex_reg_wr_en_t              ),
    .reg_wr_adder_i                 ( ex_reg_wr_adder_t           ),
    .csr_wr_en_i                    ( ex_csr_wr_en_t              ),
    .csr_wr_adder_i                 ( ex_csr_wr_adder_t           ),
    .csr_rd_data_i                  ( ex_csr_rd_data_o            ),
    .rs1_data_o                     ( as_rs1_data_i               ),
    .rs2_data_o                     ( as_rs2_data_i               ),
    .imm_o                          ( as_imm_i                    ),
    .inst_o                         ( as_inst_o                   ),
    .pc_adder_o                     ( as_pc_adder_o               ),
    .alu_res_op_o                   ( as_alu_res_op_i             ),
    .alu_res_o                      ( as_alu_res_i                ),
    .reg_wr_en_o                    ( as_reg_wr_en_i              ),
    .reg_wr_adder_o                 ( as_reg_wr_adder_i           ),
    .csr_wr_en_o                    ( as_csr_wr_en_i              ),
    .csr_wr_adder_o                 ( as_csr_wr_adder_i           ),
    .csr_rd_data_o                  ( as_csr_rd_data_i            )
);

assign data_mem_addr_o = as_data_mem_addr;
assign data_mem_wr_en_o = as_data_mem_wr_en;
assign data_mem_data_in_o = as_data_mem_data_in;
assign as_data_mem_data_out = data_mem_data_out_i;
assign data_mem_req_o = as_data_mem_req_o;

alu_res_ctrl u_alu_res_ctrl_0(
    .rs1_data_i                     ( as_rs1_data_i               ),
    .rs2_data_i                     ( as_rs2_data_i               ),
    .csr_rd_data_i                  ( as_csr_rd_data_i            ),
    .imm_i                          ( as_imm_i                    ),
    .funct3_i                       ( as_inst_o[14:12]            ),
    .opcode_i                       ( as_inst_o[6:0]              ),
    .alu_res_op_i                   ( as_alu_res_op_i             ),
    .alu_res_i                      ( as_alu_res_i                ),
    .data_mem_addr_o                ( as_data_mem_addr            ),
    .data_mem_wr_en_o               ( as_data_mem_wr_en           ),
    .data_mem_req_o                 ( as_data_mem_req_o           ),
    .data_mem_data_i                ( as_data_mem_data_out        ),
    .data_mem_data_o                ( as_data_mem_data_in         ),
    .reg_wr_data_o                  ( as_reg_wr_data_o            ),
    .csr_wr_data_o                  ( as_csr_wr_data_o            )
);

if_wb u_if_wb_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .inst_i                         ( as_inst_o                   ),
    .pc_adder_i                     ( as_pc_adder_o               ),
    .flow_wb_i                      ( flow_wb                     ),
    .reg_wr_en_i                    ( as_reg_wr_en_i              ),
    .reg_wr_adder_i                 ( as_reg_wr_adder_i           ),
    .reg_wr_data_i                  ( as_reg_wr_data_o            ),
    .csr_wr_en_i                    ( as_csr_wr_en_i              ),
    .csr_wr_adder_i                 ( as_csr_wr_adder_i           ),
    .csr_wr_data_i                  ( as_csr_wr_data_o            ),
    .reg_wr_en_o                    ( wb_reg_wr_en                ),
    .reg_wr_adder_o                 ( wb_reg_wr_adder             ),
    .reg_wr_data_o                  ( wb_reg_wr_data              ),
    .csr_wr_en_o                    ( wb_csr_wr_en                ),
    .csr_wr_adder_o                 ( wb_csr_wr_adder             ),
    .csr_wr_data_o                  ( wb_csr_wr_data              ),
    .inst_o                         ( wb_inst_o                   ),
    .pc_adder_o                     ( wb_pc_adder_o               )
);

reg_clash_fb u_reg_clash_fb_0(
    .as_reg_wr_en_i                 ( as_reg_wr_en_i              ),
    .as_reg_wr_adder_i              ( as_reg_wr_adder_i           ),
    .as_reg_wr_data_i               ( as_reg_wr_data_o            ),
    .as_csr_wr_en_i                 ( as_csr_wr_en_i              ),
    .as_csr_wr_adder_i              ( as_csr_wr_adder_i           ),
    .as_csr_wr_data_i               ( as_csr_wr_data_o            ),
    .wb_reg_wr_en_i                 ( wb_reg_wr_en                ),
    .wb_reg_wr_adder_i              ( wb_reg_wr_adder             ),
    .wb_reg_wr_data_i               ( wb_reg_wr_data              ),
    .wb_csr_wr_en_i                 ( wb_csr_wr_en                ),
    .wb_csr_wr_adder_i              ( wb_csr_wr_adder             ),
    .wb_csr_wr_data_i               ( wb_csr_wr_data              ),
    .csr_rd_adder_i                 ( ex_csr_rd_adder_i           ),
    .reg1_rd_adder_i                ( ex_reg1_rd_adder_i          ),
    .reg2_rd_adder_i                ( ex_reg2_rd_adder_i          ),
    .reg1_rd_data_i                 ( ctrl_reg1_rd_data           ),
    .reg2_rd_data_i                 ( ctrl_reg2_rd_data           ),
    .csr_rd_data_i                  ( ctrl_csr_rd_data            ),
    .reg1_rd_data_o                 ( ex_reg1_rd_data             ),
    .reg2_rd_data_o                 ( ex_reg2_rd_data             ),
    .csr_rd_data_o                  ( ex_csr_rd_data              ),
    .reg1_rd_adder_o                ( ctrl_reg1_rd_adder          ),
    .reg2_rd_adder_o                ( ctrl_reg2_rd_adder          ),
    .csr_rd_adder_o                 ( ctrl_csr_rd_adder           )
);

regs_file u_regs_file_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .reg_wr_en_i                    ( wb_reg_wr_en                ),
    .reg_wr_adder_i                 ( wb_reg_wr_adder             ),
    .reg_wr_data_i                  ( wb_reg_wr_data              ),
    .reg1_rd_adder_i                ( ctrl_reg1_rd_adder          ),
    .reg1_rd_data_o                 ( ctrl_reg1_rd_data           ),
    .reg2_rd_adder_i                ( ctrl_reg2_rd_adder          ),
    .reg2_rd_data_o                 ( ctrl_reg2_rd_data           )
);

csr_reg u_csr_reg_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .csr_wr_en_i                    ( wb_csr_wr_en                ),
    .csr_wr_adder_i                 ( wb_csr_wr_adder             ),
    .csr_wr_data_i                  ( wb_csr_wr_data              ),
    .csr_rd_adder_i                 ( ctrl_csr_rd_adder           ),
    .csr_rd_data_o                  ( ctrl_csr_rd_data            ),
    .client_csr_wr_en_i             ( client_csr_wr_en_o          ),
    .client_csr_wr_adder_i          ( client_csr_wr_adder_o       ),
    .client_csr_wr_data_i           ( client_csr_wr_data_o        ),
//    .client_csr_rd_adder_i          ( client_csr_rd_adder_o       ),
//    .client_csr_rd_data_o           ( client_csr_rd_data_o        ),
    .clint_csr_mtvec_o              ( csr_mtvec_o                 ),
    .clint_csr_mepc_o               ( csr_mepc_o                  ),
    .clint_csr_mstatus_o            ( csr_mstatus_o               )
);

clinet u_clinet_0(
    .clk                            ( clk                         ),
    .rst_n                          ( rst_n                       ),
    .int_flag_i                     ( int_flag_i                  ),
    .pc_inst_addr_i                 ( pc_curr_pc_o                ),
    .de_inst_addr_i                 ( de_pc_adder_t               ),
    .ex_inst_addr_i                 ( ex_pc_adder_i               ),
    .as_inst_addr_i                 ( as_pc_adder_o               ),
    .wb_inst_i                      ( wb_inst_o                   ),
    .wb_inst_addr_i                 ( wb_pc_adder_o               ),
    .csr_mtvec                      ( csr_mtvec_o                 ),
    .csr_mepc                       ( csr_mepc_o                  ),
    .csr_mstatus                    ( csr_mstatus_o               ),
    .we_o                           ( client_csr_wr_en_o          ),
    .waddr_o                        ( client_csr_wr_adder_o       ),
//    .raddr_o                        ( client_csr_rd_adder_o       ),
    .data_o                         ( client_csr_wr_data_o        ),
    .hold_flag_o                    ( client_hold_flag_o          ),
    .int_addr_o                     ( client_int_addr_o           ),
    .int_assert_o                   ( client_int_assert_o         )
);


endmodule
