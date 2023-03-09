// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : decode.v
// Author        : whr
// Created On    : 2022-06-29 20:30
// Last Modified : 2022-08-12 11:51
// ---------------------------------------------------------------------------------
// Description   : 
// 对指令进行译码，并产生控制信号完成指令的执行
//
// -FHDR----------------------------------------------------------------------------
`include "rooth_defines.v"

module decode(
    input               [`CPU_WIDTH-1:0]        inst_i,

    output reg          [`WIDTH_BRANCH-1:0]     branch_o,
    output reg          [`WIDTH_JUMP-1:0]       jump_o,

    output reg                                  reg_wr_en_o,
    output reg          [`REG_ADDR_WIDTH-1:0]   reg_wr_adder_o,
    
    output reg          [`REG_ADDR_WIDTH-1:0]   reg1_rd_adder_o,
    output reg          [`REG_ADDR_WIDTH-1:0]   reg2_rd_adder_o,
    
    output reg          [`IMM_GEN_OP_WIDTH-1:0] imm_gen_op_o,

    output reg                                  csr_wr_en_o,
    output reg          [`CSR_ADDR_WIDTH-1:0]   csr_wr_adder_o,
    output reg          [`CSR_ADDR_WIDTH-1:0]   csr_rd_adder_o,

    output reg          [`ALU_OP_WIDTH-1:0]     alu_op_o,
    output reg          [`ALU_SRC_WIDTH-1:0]    alu_src_sel_o,

    output reg          [`WIDTH_RESCTRL-1:0]    alu_res_op_o // alu结果数据流向
);

wire    [`OPCODE_WIDTH-1:0]opcode = inst_i[6:0];
wire    [`FUNCT3_WIDTH-1:0]funct3 = inst_i[14:12];
wire    [`FUNCT7_WIDTH-1:0]funct7 = inst_i[31:25];
wire    [`REG_ADDR_WIDTH-1:0]rd = inst_i[11:7];
wire    [`REG_ADDR_WIDTH-1:0]rs1 = inst_i[19:15];
wire    [`REG_ADDR_WIDTH-1:0]rs2 = inst_i[24:20];
wire    [`CSR_ADDR_WIDTH-1:0]csr = inst_i[31:20];

always  @(*)begin
    branch_o = `WIDTH_BRANCH'b0;
    jump_o  =   `WIDTH_JUMP'b0;
    reg_wr_en_o = 1'b0;
    reg_wr_adder_o = `REG_ADDR_WIDTH'b0;
    reg1_rd_adder_o = `REG_ADDR_WIDTH'b0;
    reg2_rd_adder_o = `REG_ADDR_WIDTH'b0;
    imm_gen_op_o = `IMM_GEN_OP_WIDTH'b111;
    alu_op_o = `ALU_OP_WIDTH'b0;
    alu_src_sel_o = `ALU_SRC_WIDTH'b0;
    alu_res_op_o = `WIDTH_RESCTRL'b11; //null
    csr_wr_en_o = 1'b0;
    csr_wr_adder_o = `CSR_ADDR_WIDTH'b0;
    csr_rd_adder_o = `CSR_ADDR_WIDTH'b0;
    case(opcode)
        `INST_TYPE_R: begin
            reg_wr_en_o     = 1'b1;
            alu_res_op_o = `WIDTH_RESCTRL'b0;
            reg1_rd_adder_o  = rs1;
            reg2_rd_adder_o  = rs2;
            reg_wr_adder_o   = rd;
            alu_src_sel_o = `ALU_SRC_REG;
            if(funct7 != `FUNCT7_INST_M) begin
                case (funct3)
                    `INST_ADD_SUB: 
                        alu_op_o = (funct7 == `FUNCT7_INST_ADD) ? `ALU_ADD : `ALU_SUB;
                    `INST_XOR:
                        alu_op_o = `ALU_XOR;
                    `INST_OR:
                        alu_op_o = `ALU_OR;
                    `INST_AND:
                        alu_op_o = `ALU_AND;
                    `INST_SLL:
                        alu_op_o = `ALU_SLL;
                    `INST_SRL_SRA:
                        alu_op_o = (funct7 == `FUNCT7_INST_SRL) ? `ALU_SRL : `ALU_SRA;//sra:msb_extends
                    `INST_SLT:
                        alu_op_o = `ALU_SLT;
                    `INST_SLTU:
                        alu_op_o = `ALU_SLTU;//zero-extends
                    default: 
                        alu_op_o = `ALU_NULL;
                endcase
            end
            else begin
                case (funct3)
                    `INST_MUL: 
                        alu_op_o = `ALU_MUL;
                    `INST_MULH:
                        alu_op_o = `ALU_MULH;
                    `INST_MULHSU:
                        alu_op_o = `ALU_MULHSU;
                    `INST_MULHU:
                        alu_op_o = `ALU_MULHU;
                    `INST_DIV:
                        alu_op_o = `ALU_DIV;
                    `INST_DIVU:
                        alu_op_o = `ALU_DIVU;//sra:msb_extends
                    `INST_REM:
                        alu_op_o = `ALU_REM;
                    `INST_REMU:
                        alu_op_o = `ALU_REMU;//zero-extends
                    default:
                        alu_op_o = `ALU_NULL;
                endcase
            end
        end
        `INST_TYPE_I: begin
            reg_wr_en_o   = 1'b1;
            alu_res_op_o = `WIDTH_RESCTRL'b0;
            reg1_rd_adder_o  = rs1;
            reg_wr_adder_o   = rd;
            imm_gen_op_o = `IMM_GEN_I;
            alu_src_sel_o = `ALU_SRC_IMM;
            case (funct3)
                `INST_ADDI: 
                    alu_op_o = `ALU_ADD; 
                `INST_XORI:
                    alu_op_o = `ALU_XOR;
                `INST_ORI:
                    alu_op_o = `ALU_OR;
                `INST_ANDI:
                    alu_op_o = `ALU_AND;
                `INST_SLLI:
                    case(inst_i[31:25])//imm[11:5]
                        (7'h00):
                            alu_op_o = `ALU_SLL;
                        default:
                            alu_op_o = `ALU_SLL;//error
                    endcase
                `INST_SRLI_SRAI:
                    case(inst_i[31:25])//imm[11:5]
                        (7'h00):
                            alu_op_o = `ALU_SRL;
                        (7'h20):
                            alu_op_o = `ALU_SRA;
                        default:
                            alu_op_o = `ALU_SRA;//error
                    endcase
                `INST_SLT:
                    alu_op_o = `ALU_SLT;
                `INST_SLTU:
                    alu_op_o = `ALU_SLTU;
            endcase
        end
        `INST_TYPE_IL: begin //lb lh lw lbu lhu
            reg1_rd_adder_o = rs1;
            imm_gen_op_o = `IMM_GEN_I;
            alu_src_sel_o = `ALU_SRC_IMM;
            alu_op_o = `ALU_ADD;
            reg_wr_en_o = 1'b1;
            alu_res_op_o = `WIDTH_RESCTRL'b0;
            reg_wr_adder_o = rd;
        end
        `INST_TYPE_S: begin
            reg1_rd_adder_o = rs1;
            reg2_rd_adder_o = rs2;
            imm_gen_op_o = `IMM_GEN_S;
            alu_src_sel_o = `ALU_SRC_IMM;
            alu_op_o = `ALU_ADD;
            alu_res_op_o = `WIDTH_RESCTRL'b01;
        end
        `INST_TYPE_B: begin
            reg1_rd_adder_o  = rs1;
            reg2_rd_adder_o  = rs2;
            imm_gen_op_o  = `IMM_GEN_B;
            alu_src_sel_o = `ALU_SRC_REG;
            case (funct3)
                `INST_BNE: begin
                    branch_o = `BRANCH_BNE;
                    alu_op_o = `ALU_SUB;
                end
                `INST_BEQ: begin
                   branch_o = `BRANCH_BEQ;
                   alu_op_o = `ALU_SUB;
               end
               `INST_BLT: begin
                   branch_o = `BRANCH_BLT;
                   alu_op_o = `ALU_SLT;
               end
               `INST_BGE: begin
                   branch_o = `BRANCH_BGE;
                   alu_op_o = `ALU_SLT;
               end
               `INST_BLTU: begin
                   branch_o = `BRANCH_BLTU;
                   alu_op_o = `ALU_SLTU;
               end
               `INST_BGEU: begin
                   branch_o = `BRANCH_BGEU;
                   alu_op_o = `ALU_SLTU;
               end
            endcase
        end
        `INST_JAL: begin // only jal
            jump_o        = `JUMP_JAL;
            reg_wr_en_o     = 1'b1;
            alu_res_op_o = `WIDTH_RESCTRL'b0;
            reg_wr_adder_o   = rd;
            imm_gen_op_o  = `IMM_GEN_J;
            alu_op_o      = `ALU_ADD;
            alu_src_sel_o = `ALU_SRC_FOUR_PC; //pc + 4
        end
        `INST_JALR: begin
            case(funct3)
                `FUNCT3_WIDTH'h0: begin
                    jump_o = `JUMP_JALR;
                    reg_wr_en_o = 1'b1;
                    alu_res_op_o = `WIDTH_RESCTRL'b0;
                    reg_wr_adder_o = rd;
                    reg1_rd_adder_o = rs1;
                    imm_gen_op_o = `IMM_GEN_I;
                    alu_src_sel_o = `ALU_SRC_FOUR_PC;
                    alu_op_o = `ALU_ADD;
                end
                default: begin
                    jump_o = `JUMP_JALR;
                    reg_wr_en_o = 1'b1;
                    alu_res_op_o = `WIDTH_RESCTRL'b0;
                    reg_wr_adder_o = rd;
                    reg1_rd_adder_o = rs1;
                    imm_gen_op_o = `IMM_GEN_I;
                    alu_src_sel_o = `ALU_SRC_FOUR_PC;
                    alu_op_o = `ALU_ADD;
                end
            endcase
        end
        `INST_LUI: begin // only lui
                reg_wr_en_o     = 1'b1;
                alu_res_op_o = `WIDTH_RESCTRL'b0;
                reg1_rd_adder_o  = `REG_ADDR_WIDTH'b0; // x0 = 0
                reg_wr_adder_o   = rd;
                imm_gen_op_o  = `IMM_GEN_U;
                alu_op_o      = `ALU_ADD;
                alu_src_sel_o = `ALU_SRC_IMM; // x0 + imm
            end
        `INST_AUIPC: begin // only auipc
                reg_wr_en_o     = 1'b1;
                alu_res_op_o = `WIDTH_RESCTRL'b0;
                reg_wr_adder_o   = rd;
                imm_gen_op_o  = `IMM_GEN_U;
                alu_src_sel_o = `ALU_SRC_IMM_PC; //  imm + curr_pc
                alu_op_o      = `ALU_ADD;
            end
        `INST_CSR: begin
            reg_wr_en_o = 1'b1;
            reg_wr_adder_o = rd;
            csr_wr_en_o = 1'b1;
            csr_wr_adder_o = csr;
            alu_res_op_o = `RESCTRL_CSR;
            csr_rd_adder_o = csr;
            case(funct3)
                `INST_CSRRW: begin
                    reg1_rd_adder_o  = rs1;
                end
                `INST_CSRRS: begin
                    reg1_rd_adder_o  = rs1;
                    alu_src_sel_o = `ALU_SRC_CSR_REG;
                    alu_op_o = `ALU_OR;
                end
                `INST_CSRRC: begin
                    reg1_rd_adder_o  = rs1;
                    alu_src_sel_o = `ALU_SRC_CSRIN_REG;
                    alu_op_o = `ALU_AND;
                end
                `INST_CSRRWI: begin
                    imm_gen_op_o = `IMM_GEN_CSRRWI;
                end
                `INST_CSRRSI: begin
                    imm_gen_op_o = `IMM_GEN_CSRRSI;
                    alu_src_sel_o = `ALU_SRC_CSR_IMM;
                    alu_op_o = `ALU_OR;
                end
                `INST_CSRRCI: begin
                    imm_gen_op_o = `IMM_GEN_CSRRCI;
                    alu_src_sel_o = `ALU_SRC_CSR_IMM;
                    alu_op_o = `ALU_AND;
                end
                default: begin //CSRRW CSRRWI
                    reg_wr_en_o = 1'b1;
                    reg_wr_adder_o = rd;
                    csr_wr_en_o = 1'b1;
                    csr_wr_adder_o = csr;
                    alu_res_op_o = `RESCTRL_CSR;
                end
            endcase
        end
        `INST_FENCE: begin
            branch_o = `WIDTH_BRANCH'b0;
            jump_o  =   `JUMP_FENCE;
            reg_wr_en_o = 1'b0;
            reg_wr_adder_o = `REG_ADDR_WIDTH'b0;
            reg1_rd_adder_o = `REG_ADDR_WIDTH'b0;
            reg2_rd_adder_o = `REG_ADDR_WIDTH'b0;
            imm_gen_op_o = `IMM_GEN_OP_WIDTH'b111;
            alu_op_o = `ALU_OP_WIDTH'b0;
            alu_src_sel_o = `ALU_SRC_WIDTH'b0;
            alu_res_op_o = `WIDTH_RESCTRL'b11; //null
            csr_wr_en_o = 1'b0;
            csr_wr_adder_o = `CSR_ADDR_WIDTH'b0;
            csr_rd_adder_o = `CSR_ADDR_WIDTH'b0;
        end
        default: begin
            branch_o = `WIDTH_BRANCH'b0;
            jump_o  =   `WIDTH_JUMP'b0;
            reg_wr_en_o = 1'b0;
            reg_wr_adder_o = `REG_ADDR_WIDTH'b0;
            reg1_rd_adder_o = `REG_ADDR_WIDTH'b0;
            reg2_rd_adder_o = `REG_ADDR_WIDTH'b0;
            imm_gen_op_o = `IMM_GEN_OP_WIDTH'b111;
            alu_op_o = `ALU_OP_WIDTH'b0;
            alu_src_sel_o = `ALU_SRC_WIDTH'b0;
            alu_res_op_o = `WIDTH_RESCTRL'b11; //null
            csr_wr_en_o = 1'b0;
            csr_wr_adder_o = `CSR_ADDR_WIDTH'b0;
            csr_rd_adder_o = `CSR_ADDR_WIDTH'b0;
        end
    endcase
end
endmodule
