// +FHDR------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// -----------------------------------------------------------------------
// Filename      : defines.v
// Author        : whr
// Created On    : 2022-06-29 20:03
// Last Modified : 2023-01-14 18:18
// -----------------------------------------------------------------------
// Description   : Parameter definitions. 
//
//
// -FHDR------------------------------------------------------------------
`timescale 1ns / 1ps
// simulation clock period
`define SIM_PERIOD 20 // 20ns -> 50MHz 

// processor 
`define CPU_WIDTH 32 // rv32
`define CPU_DOUBLE_WIDTH 64

//data memmory
`define DATA_MEM_ADDR_DEPTH 4096
`define DATA_MEM_ADDR_WIDHT 13 

// instruction memory
`define INST_MEM_ADDR_DEPTH 4096
`define INST_MEM_ADDR_WIDTH 12 // 2^11 = 2048

//register
`define REG_DATA_DEPTH 32
`define REG_NUM        32
`define REG_ADDR_WIDTH 5

//immediate generate
`define INST_I_IMM_WIDTH 12
`define INST_S_IMM_WIDTH 12
`define INST_B_IMM_WIDTH 13
`define INST_U_IMM_WIDTH 32
`define INST_J_IMM_WIDTH 21

//imm gen opcode
`define IMM_GEN_OP_WIDTH 3
`define IMM_GEN_I       `IMM_GEN_OP_WIDTH'b000 
`define IMM_GEN_S       `IMM_GEN_OP_WIDTH'b001
`define IMM_GEN_B       `IMM_GEN_OP_WIDTH'b010
`define IMM_GEN_J       `IMM_GEN_OP_WIDTH'b011
`define IMM_GEN_U       `IMM_GEN_OP_WIDTH'b100
`define IMM_GEN_CSRRWI  `IMM_GEN_OP_WIDTH'b101
`define IMM_GEN_CSRRSI  `IMM_GEN_OP_WIDTH'b110
`define IMM_GEN_CSRRCI  `IMM_GEN_OP_WIDTH'b111

// ALU opcode
`define ALU_OP_WIDTH 5
`define ALU_AND    `ALU_OP_WIDTH'b00000
`define ALU_OR     `ALU_OP_WIDTH'b00001
`define ALU_XOR    `ALU_OP_WIDTH'b00010
`define ALU_ADD    `ALU_OP_WIDTH'b00011
`define ALU_SUB    `ALU_OP_WIDTH'b00100
`define ALU_SLL    `ALU_OP_WIDTH'b00101 // shift left logical
`define ALU_SRL    `ALU_OP_WIDTH'b00110 // shift right logical
`define ALU_SRA    `ALU_OP_WIDTH'b00111 // shift right arith 
`define ALU_SLT    `ALU_OP_WIDTH'b01000 // set less than  
`define ALU_SLTU   `ALU_OP_WIDTH'b01001 // set less than (unsigned) 
`define ALU_BLT    `ALU_OP_WIDTH'b01010 // branch less than
`define ALU_BLTU   `ALU_OP_WIDTH'b01011 // branch less than (unsigned)
`define ALU_JAL    `ALU_OP_WIDTH'b01100 
`define ALU_JALR   `ALU_OP_WIDTH'b01101
`define ALU_MUL    `ALU_OP_WIDTH'b01110
`define ALU_MULH   `ALU_OP_WIDTH'b01111
`define ALU_MULHSU `ALU_OP_WIDTH'b10000
`define ALU_MULHU  `ALU_OP_WIDTH'b10001
`define ALU_DIV    `ALU_OP_WIDTH'b10010
`define ALU_DIVU   `ALU_OP_WIDTH'b10011
`define ALU_REM    `ALU_OP_WIDTH'b10100
`define ALU_REMU   `ALU_OP_WIDTH'b10101
`define ALU_NULL   `ALU_OP_WIDTH'b10110

// ALU select soure
`define ALU_SRC_WIDTH 3
`define ALU_SRC_REG     		`ALU_SRC_WIDTH'b000 // src1 = reg1, src2 = reg2
`define ALU_SRC_IMM     		`ALU_SRC_WIDTH'b001 // src1 = reg1, src2 = imm
`define ALU_SRC_FOUR_PC 		`ALU_SRC_WIDTH'b010 // src1 = 4,    src2 = pc
`define ALU_SRC_IMM_PC  		`ALU_SRC_WIDTH'b011 // src1 = imm,  src2 = pc
`define ALU_SRC_CSR_REG 		`ALU_SRC_WIDTH'b100 // src1 = reg1, src2 = csr
`define ALU_SRC_CSR_IMM 		`ALU_SRC_WIDTH'b101 // src1 = imm, src2 = csr
`define ALU_SRC_CSRIN_REG 	`ALU_SRC_WIDTH'b110 // src1 = ~reg1, src2 = csr

// opcode
`define OPCODE_WIDTH 7
`define INST_TYPE_R  `OPCODE_WIDTH'b0110011 // add/sub/xor/or/and/sll/srl/sra/slt/sltu
`define INST_TYPE_I  `OPCODE_WIDTH'b0010011 // addi/xori/ori/andi/slli/srli/srai/slti/sltiu
`define INST_TYPE_IL `OPCODE_WIDTH'b0000011 // lb/lh/lw/lbu/lhu
`define INST_TYPE_S  `OPCODE_WIDTH'b0100011 // sb/sh/sw
`define INST_TYPE_B  `OPCODE_WIDTH'b1100011 // beq/bne/blt/bge/bltu/bgeu
`define INST_JAL     `OPCODE_WIDTH'b1101111 // jal
`define INST_JALR    `OPCODE_WIDTH'b1100111 // jalr
`define INST_LUI     `OPCODE_WIDTH'b0110111 // lui
`define INST_AUIPC   `OPCODE_WIDTH'b0010111 // auipc
`define INST_TYPE_IE `OPCODE_WIDTH'b1110011 // ecall/ebreak
`define INST_FENCE   `OPCODE_WIDTH'b0001111 // fnece

// funct3
// R-type
`define FUNCT3_WIDTH 3
`define INST_ADD_SUB   `FUNCT3_WIDTH'h0 
`define INST_XOR       `FUNCT3_WIDTH'h4
`define INST_OR        `FUNCT3_WIDTH'h6
`define INST_AND       `FUNCT3_WIDTH'h7
`define INST_SLL       `FUNCT3_WIDTH'h1
`define INST_SRL_SRA   `FUNCT3_WIDTH'h5
`define INST_SLT       `FUNCT3_WIDTH'h2
`define INST_SLTU      `FUNCT3_WIDTH'h3
// R-type MULTIPLY EXTENSION
`define INST_MUL   	   `FUNCT3_WIDTH'h0 
`define INST_MULH      `FUNCT3_WIDTH'h1
`define INST_MULHSU    `FUNCT3_WIDTH'h2
`define INST_MULHU     `FUNCT3_WIDTH'h3
`define INST_DIV       `FUNCT3_WIDTH'h4
`define INST_DIVU      `FUNCT3_WIDTH'h5
`define INST_REM       `FUNCT3_WIDTH'h6
`define INST_REMU      `FUNCT3_WIDTH'h7
// I-type 
`define INST_ADDI      `FUNCT3_WIDTH'h0
`define INST_XORI      `FUNCT3_WIDTH'h4
`define INST_ORI       `FUNCT3_WIDTH'h6
`define INST_ANDI      `FUNCT3_WIDTH'h7
`define INST_SLLI      `FUNCT3_WIDTH'h1
`define INST_SRLI_SRAI `FUNCT3_WIDTH'h5 
`define INST_SLTI      `FUNCT3_WIDTH'h2
`define INST_SLTIU     `FUNCT3_WIDTH'h3
// I-type load
`define INST_LB        `FUNCT3_WIDTH'h0
`define INST_LH        `FUNCT3_WIDTH'h1
`define INST_LW        `FUNCT3_WIDTH'h2
`define INST_LBU       `FUNCT3_WIDTH'h4
`define INST_LHU       `FUNCT3_WIDTH'h5
// S-type
`define INST_SB        `FUNCT3_WIDTH'h0
`define INST_SH        `FUNCT3_WIDTH'h1
`define INST_SW        `FUNCT3_WIDTH'h2
// B-type
`define WIDTH_BRANCH 3
`define INST_BEQ       `FUNCT3_WIDTH'h0
`define INST_BNE       `FUNCT3_WIDTH'h1
`define INST_BLT       `FUNCT3_WIDTH'h4
`define INST_BGE       `FUNCT3_WIDTH'h5
`define INST_BLTU      `FUNCT3_WIDTH'h6
`define INST_BGEU      `FUNCT3_WIDTH'h7
// I-type environment
`define INST_ECALL      `CPU_WIDTH'h73
`define INST_EBREAK     `CPU_WIDTH'h00100073

// funct7 only with R-type
`define FUNCT7_WIDTH 7
`define FUNCT7_INST_ADD  `FUNCT7_WIDTH'h00
`define FUNCT7_INST_SUB  `FUNCT7_WIDTH'h20
`define FUNCT7_INST_SRL  `FUNCT7_WIDTH'h00
`define FUNCT7_INST_SRA  `FUNCT7_WIDTH'h20
`define FUNCT7_INST_M    `FUNCT7_WIDTH'h01

// branch-type
`define WIDTH_BRANCH 3
`define BRANCH_BEQ       `WIDTH_BRANCH'h1
`define BRANCH_BNE       `WIDTH_BRANCH'h2
`define BRANCH_BLT       `WIDTH_BRANCH'h3
`define BRANCH_BGE       `WIDTH_BRANCH'h4
`define BRANCH_BLTU      `WIDTH_BRANCH'h5
`define BRANCH_BGEU      `WIDTH_BRANCH'h6

// jump-type
`define WIDTH_JUMP 2
`define JUMP_JAL         `WIDTH_JUMP'b01
`define JUMP_JALR        `WIDTH_JUMP'b10
`define JUMP_FENCE       `WIDTH_JUMP'b11

// alu_res-control
`define WIDTH_RESCTRL   2
`define RESCTRL_REG     `WIDTH_RESCTRL'b00
`define RESCTRL_MEM     `WIDTH_RESCTRL'b01
`define RESCTRL_CSR     `WIDTH_RESCTRL'b10

// CSR inst
`define INST_CSR    7'b1110011
`define INST_CSRRW  3'b001
`define INST_CSRRS  3'b010
`define INST_CSRRC  3'b011
`define INST_CSRRWI 3'b101
`define INST_CSRRSI 3'b110
`define INST_CSRRCI 3'b111

`define INST_MRET   32'h30200073

// flow control
`define FLOW_WIDTH  2
`define FLOW_WORK       `FLOW_WIDTH'b00
`define FLOW_STOP       `FLOW_WIDTH'b01
`define FLOW_REFRESH    `FLOW_WIDTH'b10
 
// csr-adder
`define CSR_ADDR_WIDTH  12
`define CSR_CYCLE       12'hc00 //时钟周期计数器
`define CSR_CYCLEH      12'hc80 //时钟周期计数器
`define CSR_MTVEC       12'h305 //中断/异常矢量
`define CSR_MCAUSE      12'h342 //时钟周期计数器
`define CSR_MEPC        12'h341 //异常/中断原因
`define CSR_MIE         12'h304 //中断使能
`define CSR_MSTATUS     12'h300 //状态控制
`define CSR_MSCRATCH    12'h340 //提供一个上下文保存寄存器

//interrupt
`define INT_BUS 7:0
`define INT_NONE 8'h0
`define INT_RET 8'hff
`define INT_TIMER0 8'b00000001
`define INT_TIMER0_ENTRY_ADDR 32'h4
