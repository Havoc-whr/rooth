// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : mux_alu.v
// Author        : whr
// Created On    : 2022-07-02 20:57
// Last Modified : 2022-08-11 22:59
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
//`include "../soc/rooth_defines.v"

module mux_alu(
    input       [`ALU_SRC_WIDTH-1:0]    alu_src_sel_i,

    input       [`CPU_WIDTH-1:0]        reg1_rd_data_i,
    input       [`CPU_WIDTH-1:0]        reg2_rd_data_i,
    input       [`CPU_WIDTH-1:0]        csr_rd_data_i,
    input       [`CPU_WIDTH-1:0]        imm_i,

    input       [`CPU_WIDTH-1:0]        curr_pc_i,

    output reg  [`CPU_WIDTH-1:0]        alu_src1_o,
    output reg  [`CPU_WIDTH-1:0]        alu_src2_o
);

always @(*) begin
    alu_src1_o = reg1_rd_data_i;
    alu_src2_o = reg2_rd_data_i;
    case(alu_src_sel_i)
        `ALU_SRC_REG:       //type-R
            alu_src2_o = reg2_rd_data_i;
        `ALU_SRC_IMM:       //type-I or type-U
            alu_src2_o = imm_i;
        `ALU_SRC_FOUR_PC: begin //jal or jalr
            alu_src1_o = `CPU_WIDTH'h4;
            alu_src2_o = curr_pc_i;
        end
        `ALU_SRC_IMM_PC: begin
            alu_src1_o = curr_pc_i;
            alu_src2_o = imm_i;
        end
        `ALU_SRC_CSR_REG: begin
            alu_src2_o = csr_rd_data_i;
        end
        `ALU_SRC_CSRIN_REG: begin
            alu_src1_o = ~reg1_rd_data_i;
            alu_src2_o = csr_rd_data_i;
        end
        `ALU_SRC_CSR_IMM: begin
            alu_src1_o = csr_rd_data_i;
            alu_src2_o = imm_i;
        end
        default: begin
            alu_src1_o = reg1_rd_data_i;
            alu_src2_o = reg2_rd_data_i;
        end
    endcase
end

endmodule
