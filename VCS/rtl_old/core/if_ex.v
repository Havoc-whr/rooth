// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : if_ex.v
// Author        : whr
// Created On    : 2022-08-12 18:30
// Last Modified : 2022-08-14 23:21
// ---------------------------------------------------------------------------------
// Description   : 
// 
//
// -FHDR----------------------------------------------------------------------------

//`include "/home/ICer/ic_prjs/rooth/VCS/rtl/core/rooth_defines.v"

module if_ex (
    input                               clk,
    input                               rst_n,
    input       [`FLOW_WIDTH-1:0]       flow_ex_i,

    input       [`CPU_WIDTH-1:0]        inst_i,
    input       [`CPU_WIDTH-1:0]        pc_adder_i,

    input       [`WIDTH_BRANCH-1:0]     branch_i,
    input       [`WIDTH_JUMP-1:0]       jump_i,

    input                               reg_wr_en_i,
    input       [`REG_ADDR_WIDTH-1:0]   reg_wr_adder_i,
    
    input       [`REG_ADDR_WIDTH-1:0]   reg1_rd_adder_i,
    input       [`REG_ADDR_WIDTH-1:0]   reg2_rd_adder_i,
    
    input       [`CPU_WIDTH-1:0]        imm_i,

    input                               csr_wr_en_i,
    input       [`CSR_ADDR_WIDTH-1:0]   csr_wr_adder_i,
    input       [`CSR_ADDR_WIDTH-1:0]   csr_rd_adder_i,

    input       [`ALU_OP_WIDTH-1:0]     alu_op_i,
    input       [`ALU_SRC_WIDTH-1:0]    alu_src_sel_i,

    input       [`WIDTH_RESCTRL-1:0]    alu_res_op_i,

    output reg  [`CPU_WIDTH-1:0]        inst_o,
    output reg  [`CPU_WIDTH-1:0]        pc_adder_o,

    output reg  [`WIDTH_BRANCH-1:0]     branch_o,
    output reg  [`WIDTH_JUMP-1:0]       jump_o,

    output reg                          reg_wr_en_o,
    output reg  [`REG_ADDR_WIDTH-1:0]   reg_wr_adder_o,
    
    output reg  [`REG_ADDR_WIDTH-1:0]   reg1_rd_adder_o,
    output reg  [`REG_ADDR_WIDTH-1:0]   reg2_rd_adder_o,
    
    output reg  [`CPU_WIDTH-1:0]        imm_o,

    output reg                          csr_wr_en_o,
    output reg  [`CSR_ADDR_WIDTH-1:0]   csr_wr_adder_o,
    output reg  [`CSR_ADDR_WIDTH-1:0]   csr_rd_adder_o,

    output reg  [`ALU_OP_WIDTH-1:0]     alu_op_o,
    output reg  [`ALU_SRC_WIDTH-1:0]    alu_src_sel_o,

    output reg  [`WIDTH_RESCTRL-1:0]    alu_res_op_o
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pc_adder_o <= `CPU_WIDTH'b0;
        branch_o <= `WIDTH_BRANCH'b0;
        jump_o <= `WIDTH_JUMP'b0;
        reg_wr_en_o <= 1'b0;
        reg_wr_adder_o <= `REG_ADDR_WIDTH'b0;
        reg1_rd_adder_o <= `REG_ADDR_WIDTH'b0;
        reg2_rd_adder_o <= `REG_ADDR_WIDTH'b0;
        imm_o <= `CPU_WIDTH'b0;
        csr_wr_en_o <= 1'b0;
        csr_wr_adder_o <= `CSR_ADDR_WIDTH'b0;
        csr_rd_adder_o <= `CSR_ADDR_WIDTH'b0;
        alu_op_o <= `ALU_OP_WIDTH'b0;
        alu_src_sel_o <= `ALU_SRC_WIDTH'b0;
        alu_res_op_o <= `WIDTH_RESCTRL'b11;
        inst_o <= `CPU_WIDTH'b0;
    end
    else begin
        case(flow_ex_i)
            `FLOW_WORK: begin
                pc_adder_o <= pc_adder_i;
                branch_o <= branch_i;
                jump_o <= jump_i;
                reg_wr_en_o <= reg_wr_en_i;
                reg_wr_adder_o <= reg_wr_adder_i;
                reg1_rd_adder_o <= reg1_rd_adder_i;
                reg2_rd_adder_o <= reg2_rd_adder_i;
                imm_o <= imm_i;
                csr_wr_en_o <= csr_wr_en_i;
                csr_wr_adder_o <= csr_wr_adder_i;
                csr_rd_adder_o <= csr_rd_adder_i;
                alu_op_o <= alu_op_i;
                alu_src_sel_o <= alu_src_sel_i;
                alu_res_op_o <= alu_res_op_i;
                inst_o <= inst_i;
            end
            `FLOW_STOP: begin
                pc_adder_o <= pc_adder_o;
                branch_o <= branch_o;
                jump_o <= jump_o;
                reg_wr_en_o <= reg_wr_en_o;
                reg_wr_adder_o <= reg_wr_adder_o;
                reg1_rd_adder_o <= reg1_rd_adder_o;
                reg2_rd_adder_o <= reg2_rd_adder_o;
                imm_o <= imm_o;
                csr_wr_en_o <= csr_wr_en_o;
                csr_wr_adder_o <= csr_wr_adder_o;
                csr_rd_adder_o <= csr_rd_adder_o;
                alu_op_o <= alu_op_o;
                alu_src_sel_o <= alu_src_sel_o;
                alu_res_op_o <= alu_res_op_o;
                inst_o <= inst_o;
            end
            `FLOW_REFRESH: begin
                pc_adder_o <= `CPU_WIDTH'b0;
                branch_o <= `WIDTH_BRANCH'b0;
                jump_o <= `WIDTH_JUMP'b0;
                reg_wr_en_o <= 1'b0;
                reg_wr_adder_o <= `REG_ADDR_WIDTH'b0;
                reg1_rd_adder_o <= `REG_ADDR_WIDTH'b0;
                reg2_rd_adder_o <= `REG_ADDR_WIDTH'b0;
                imm_o <= `CPU_WIDTH'b0;
                csr_wr_en_o <= 1'b0;
                csr_wr_adder_o <= `CSR_ADDR_WIDTH'b0;
                csr_rd_adder_o <= `CSR_ADDR_WIDTH'b0;
                alu_op_o <= `ALU_OP_WIDTH'b0;
                alu_src_sel_o <= `ALU_SRC_WIDTH'b0;
                alu_res_op_o <= `WIDTH_RESCTRL'b11;
                inst_o <= `CPU_WIDTH'b0;
            end
            default: begin
                pc_adder_o <= `CPU_WIDTH'b0;
                branch_o <= `WIDTH_BRANCH'b0;
                jump_o <= `WIDTH_JUMP'b0;
                reg_wr_en_o <= 1'b0;
                reg_wr_adder_o <= `REG_ADDR_WIDTH'b0;
                reg1_rd_adder_o <= `REG_ADDR_WIDTH'b0;
                reg2_rd_adder_o <= `REG_ADDR_WIDTH'b0;
                imm_o <= `CPU_WIDTH'b0;
                csr_wr_en_o <= 1'b0;
                csr_wr_adder_o <= `CSR_ADDR_WIDTH'b0;
                csr_rd_adder_o <= `CSR_ADDR_WIDTH'b0;
                alu_op_o <= `ALU_OP_WIDTH'b0;
                alu_src_sel_o <= `ALU_SRC_WIDTH'b0;
                alu_res_op_o <= `WIDTH_RESCTRL'b11;
                inst_o <= `CPU_WIDTH'b0;
            end
        endcase
    end
end

endmodule
