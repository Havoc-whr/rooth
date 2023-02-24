// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : if_as.v
// Author        : whr
// Created On    : 2022-08-12 22:31
// Last Modified : 2022-08-14 17:15
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------

//`include "/home/ICer/ic_prjs/rooth/VCS/rtl/core/rooth_defines.v"s

module if_as (
    input                               clk,
    input                               rst_n,
    input [`FLOW_WIDTH-1:0]             flow_as_i, 

    input [`CPU_WIDTH-1:0]              rs1_data_i,
    input [`CPU_WIDTH-1:0]              rs2_data_i,
    input [`CPU_WIDTH-1:0]              imm_i,
    input [`CPU_WIDTH-1:0]              inst_i,
    input [`CPU_WIDTH-1:0]              pc_adder_i,
    input [`WIDTH_RESCTRL-1:0]          alu_res_op_i,
    input [`CPU_WIDTH-1:0]              alu_res_i,

    input                               reg_wr_en_i,
    input [`REG_ADDR_WIDTH-1:0]         reg_wr_adder_i,
    input                               csr_wr_en_i,
    input [`CSR_ADDR_WIDTH-1:0]         csr_wr_adder_i,
    input [`CPU_WIDTH-1:0]              csr_rd_data_i,

    output reg [`CPU_WIDTH-1:0]          rs1_data_o,
    output reg [`CPU_WIDTH-1:0]          rs2_data_o,
    output reg [`CPU_WIDTH-1:0]          imm_o,
    output reg [`CPU_WIDTH-1:0]          inst_o,
    output reg [`CPU_WIDTH-1:0]          pc_adder_o,
    output reg [`WIDTH_RESCTRL-1:0]      alu_res_op_o,
    output reg [`CPU_WIDTH-1:0]          alu_res_o,

    output reg                           reg_wr_en_o,
    output reg [`REG_ADDR_WIDTH-1:0]     reg_wr_adder_o,
    output reg                           csr_wr_en_o,
    output reg [`CSR_ADDR_WIDTH-1:0]     csr_wr_adder_o,
    output reg [`CPU_WIDTH-1:0]          csr_rd_data_o,
    output wire                          pr_acess_mem_flag_o,
    output reg                           acess_mem_flag_o
);

assign pr_acess_mem_flag_o = ((alu_res_op_i == `RESCTRL_MEM) || ((alu_res_op_i == `RESCTRL_REG) && (inst_i[6:0] == `INST_TYPE_IL))) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rs1_data_o <= `CPU_WIDTH'b0;
        rs2_data_o <= `CPU_WIDTH'b0;
        imm_o <= `CPU_WIDTH'b0;
        inst_o <= `CPU_WIDTH'b0;
        pc_adder_o <= `CPU_WIDTH'b0;
        alu_res_op_o <= `WIDTH_RESCTRL'b11;
        alu_res_o <= `CPU_WIDTH;
        reg_wr_en_o <= 1'b0;
        reg_wr_adder_o <= `REG_ADDR_WIDTH'b0;
        csr_wr_en_o <= 1'b0;
        csr_wr_adder_o <= `CSR_ADDR_WIDTH'b0;
        csr_rd_data_o <= `CPU_WIDTH'b0;
        acess_mem_flag_o <= 1'b0;
    end
    else begin
        case(flow_as_i)
            `FLOW_WORK: begin
                rs1_data_o <= rs1_data_i;
                rs2_data_o <= rs2_data_i;
                imm_o <= imm_i;
                inst_o <= inst_i;
                pc_adder_o <= pc_adder_i;
                alu_res_op_o <= alu_res_op_i;
                alu_res_o <= alu_res_i;
                reg_wr_en_o <= reg_wr_en_i;
                reg_wr_adder_o <= reg_wr_adder_i;
                csr_wr_en_o <= csr_wr_en_i;
                csr_wr_adder_o <= csr_wr_adder_i;
                csr_rd_data_o <= csr_rd_data_i;
                acess_mem_flag_o <= pr_acess_mem_flag_o;
            end
            `FLOW_STOP: begin
                rs1_data_o <= rs1_data_o;
                rs2_data_o <= rs2_data_o;
                imm_o <= imm_o;
                inst_o <= inst_o;
                pc_adder_o <= pc_adder_o;
                alu_res_op_o <= alu_res_op_o;
                alu_res_o <= alu_res_o;
                reg_wr_en_o <= reg_wr_en_o;
                reg_wr_adder_o <= reg_wr_adder_o;
                csr_wr_en_o <= csr_wr_en_o;
                csr_wr_adder_o <= csr_wr_adder_o;
                csr_rd_data_o <= csr_rd_data_o;
                acess_mem_flag_o <= acess_mem_flag_o;
            end
            `FLOW_REFRESH: begin
                rs1_data_o <= `CPU_WIDTH'b0;
                rs2_data_o <= `CPU_WIDTH'b0;
                imm_o <= `CPU_WIDTH'b0;
                inst_o <= `CPU_WIDTH'b0;
                pc_adder_o <= `CPU_WIDTH'b0;
                alu_res_op_o <= `WIDTH_RESCTRL'b11;
                reg_wr_en_o <= 1'b0;
                reg_wr_adder_o <= `REG_ADDR_WIDTH'b0;
                csr_wr_en_o <= 1'b0;
                csr_wr_adder_o <= `CSR_ADDR_WIDTH'b0;
                csr_rd_data_o <= `CPU_WIDTH'b0;
                acess_mem_flag_o <= 1'b0;
            end
            default: begin
                rs1_data_o <= `CPU_WIDTH'b0;
                rs2_data_o <= `CPU_WIDTH'b0;
                imm_o <= `CPU_WIDTH'b0;
                inst_o <= `CPU_WIDTH'b0;
                pc_adder_o <= `CPU_WIDTH'b0;
                alu_res_op_o <= `WIDTH_RESCTRL'b11;
                reg_wr_en_o <= 1'b0;
                reg_wr_adder_o <= `REG_ADDR_WIDTH'b0;
                csr_wr_en_o <= 1'b0;
                csr_wr_adder_o <= `CSR_ADDR_WIDTH'b0;
                csr_rd_data_o <= `CPU_WIDTH'b0;
                acess_mem_flag_o <= 1'b0;
            end
        endcase
    end
end

endmodule //if_as
