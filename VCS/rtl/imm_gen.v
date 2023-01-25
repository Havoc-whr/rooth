// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : imm_gen.v
// Author        : whr
// Created On    : 2022-07-01 21:56
// Last Modified : 2022-07-02 17:53
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
//`include "/home/ICer/ic_prjs/rooth/VCS/rtl/rooth_defines.v"

module imm_gen(
    input       [`CPU_WIDTH-1:0]            inst_i,
    input       [`IMM_GEN_OP_WIDTH-1:0]     imm_gen_op_i,

    output reg  [`CPU_WIDTH-1:0]            imm_o            
);

always  @(*) begin
    imm_o = `CPU_WIDTH'b0;
    case(imm_gen_op_i)
        `IMM_GEN_I:
            imm_o = {{20{inst_i[31]}},inst_i[31:20]};
        `IMM_GEN_S:
            imm_o = {{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]};
        `IMM_GEN_B:
            imm_o = {{20{inst_i[31]}},inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
        `IMM_GEN_U:
            imm_o = {inst_i[31:12],{12{1'b0}}};
        `IMM_GEN_J:
            imm_o = {{12{inst_i[31]}},inst_i[19:12],inst_i[20],inst_i[30:21],1'b0};
        `IMM_GEN_CSRRWI:
            imm_o = {{27{1'b0}},{inst_i[19:15]}};
        `IMM_GEN_CSRRSI:
            imm_o = {{27{1'b0}},{inst_i[19:15]}};
        `IMM_GEN_CSRRCI:
            imm_o = ~{{27{1'b0}},{inst_i[19:15]}};
    endcase
end

endmodule
