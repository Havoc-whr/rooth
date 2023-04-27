// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : flow_ctrl.v
// Author        : whr
// Created On    : 2022-08-11 16:20
// Last Modified : 2023-01-14 21:22
// ---------------------------------------------------------------------------------
// Description   :流水线控制模块，用于流水线暂停等
// 
//
//
// -FHDR----------------------------------------------------------------------------
`include "rooth_defines.v"

module flow_ctrl (
    input                           jtag_halt_flag_i,
    input      [`WIDTH_BRANCH-1:0]  branch_i,           // branch type
    input      [`CPU_WIDTH-1:0]     pc_adder_i,

    input                           zero_i,             // alu result is zero
    input                           more_zero_i,        // alu result is mroe
    input                           less_i,             // alu result is less

    input      [`WIDTH_JUMP-1:0]    jump_i,             // jump type
    input      [`CPU_WIDTH-1:0]     imm_i,              // immediate
    input      [`CPU_WIDTH-1:0]     reg1_rd_data_i,     // rs1 be used in jalr
    input                           bus_wait_i,         // current pc addr

    input                           alu_busy_i,         // div is busy
    input                           access_mem_hold_i,
    input                           pr_acess_mem_flag_i,
    
    // from clint 
    input                           clint_hold_flag_i, // 流水线暂停标志
    input    [`CPU_WIDTH-1:0]       clint_int_addr_i,  // 中断入口地址
    input                           clint_int_assert_i,// 中断标志

    output reg [`CPU_WIDTH-1:0]     next_pc_o,          // next pc addr
    output reg                      next_pc_four_o,       
    output reg [`FLOW_WIDTH-1:0]    flow_pc_o,
    output reg [`FLOW_WIDTH-1:0]    flow_de_o,
    output reg [`FLOW_WIDTH-1:0]    flow_ex_o,
    output reg [`FLOW_WIDTH-1:0]    flow_as_o,
    output reg [`FLOW_WIDTH-1:0]    flow_wb_o
);

always @( *) begin
    next_pc_four_o = 1'b0;
    next_pc_o = `CPU_WIDTH'b0;
    if(clint_int_assert_i) begin
        next_pc_four_o = 1'b0;
        next_pc_o = clint_int_addr_i;
        flow_pc_o = `FLOW_WORK;
        flow_de_o = `FLOW_REFRESH;
        flow_ex_o = `FLOW_REFRESH;
        flow_as_o = `FLOW_REFRESH;
        flow_wb_o = `FLOW_REFRESH;
    end
    else if(clint_hold_flag_i) begin
        flow_pc_o = `FLOW_STOP;
        flow_de_o = `FLOW_STOP;
        flow_ex_o = `FLOW_STOP;
        flow_as_o = `FLOW_STOP;
        flow_wb_o = `FLOW_STOP;
    end
    else if(access_mem_hold_i) begin
        flow_pc_o = `FLOW_STOP;
        flow_de_o = `FLOW_STOP;
        flow_ex_o = `FLOW_STOP;
        flow_as_o = `FLOW_STOP;
        flow_wb_o = `FLOW_REFRESH;
    end
    else if(pr_acess_mem_flag_i) begin
        flow_pc_o = `FLOW_STOP;
        flow_de_o = `FLOW_STOP;
        flow_ex_o = `FLOW_REFRESH;
        flow_as_o = `FLOW_WORK;
        flow_wb_o = `FLOW_WORK;
    end
    else if(alu_busy_i) begin
        flow_pc_o = `FLOW_STOP;
        flow_de_o = `FLOW_STOP;
        flow_ex_o = `FLOW_STOP;
        flow_as_o = `FLOW_REFRESH;
        flow_wb_o = `FLOW_WORK;
    end
    else if(bus_wait_i) begin
        flow_pc_o = `FLOW_STOP;
        flow_de_o = `FLOW_REFRESH;
        flow_ex_o = `FLOW_WORK;
        flow_as_o = `FLOW_WORK;
        flow_wb_o = `FLOW_WORK;
    end
    else if(branch_i != `WIDTH_BRANCH'h0) begin // B-TYPE enable
        flow_pc_o = `FLOW_WORK;
        flow_de_o = `FLOW_WORK;
        flow_ex_o = `FLOW_WORK;
        flow_as_o = `FLOW_WORK;
        flow_wb_o = `FLOW_WORK;
        next_pc_four_o = 1'b0;
        case(branch_i)
            `BRANCH_BNE:
                if(!zero_i) begin
                    flow_de_o = `FLOW_REFRESH;
                    flow_ex_o = `FLOW_REFRESH;
                    next_pc_o = pc_adder_i + imm_i;
                end
                else next_pc_four_o = 1'b1;
            `BRANCH_BEQ:
                if(zero_i) begin
                    flow_de_o = `FLOW_REFRESH;
                    flow_ex_o = `FLOW_REFRESH;
                    next_pc_o = pc_adder_i + imm_i;
                end
                else next_pc_four_o = 1'b1;
            `BRANCH_BLT:
                if(less_i) begin
                    flow_de_o = `FLOW_REFRESH;
                    flow_ex_o = `FLOW_REFRESH;
                    next_pc_o = pc_adder_i + imm_i;
                end
                else next_pc_four_o = 1'b1;
            `BRANCH_BGE:
                if(more_zero_i) begin
                    flow_de_o = `FLOW_REFRESH;
                    flow_ex_o = `FLOW_REFRESH;
                    next_pc_o = pc_adder_i + imm_i;
                end
                else next_pc_four_o = 1'b1;
            `BRANCH_BLTU:
                if(less_i) begin
                    flow_de_o = `FLOW_REFRESH;
                    flow_ex_o = `FLOW_REFRESH;
                    next_pc_o = pc_adder_i + imm_i;
                end
                else next_pc_four_o = 1'b1;
            `BRANCH_BGEU:
                if(more_zero_i) begin
                    flow_de_o = `FLOW_REFRESH;
                    flow_ex_o = `FLOW_REFRESH;
                    next_pc_o = pc_adder_i + imm_i;
                end
                else next_pc_four_o = 1'b1;
            default:
                next_pc_four_o = 1'b1;
        endcase
    end
    else if (jump_i != `WIDTH_JUMP'b00) begin
        flow_pc_o = `FLOW_WORK;
        flow_de_o = `FLOW_REFRESH;
        flow_ex_o = `FLOW_REFRESH;
        flow_as_o = `FLOW_WORK;
        flow_wb_o = `FLOW_WORK;
        next_pc_four_o = 1'b0;
        case(jump_i)
            `JUMP_JAL:
                next_pc_o = pc_adder_i + imm_i;
            `JUMP_JALR:
                next_pc_o = imm_i + reg1_rd_data_i;
            `JUMP_FENCE:
                next_pc_o = pc_adder_i + `CPU_WIDTH'd4;
            default:
                next_pc_four_o = 1'b1;
        endcase
    end
    else if(jtag_halt_flag_i) begin
        flow_pc_o = `FLOW_STOP;
        flow_de_o = `FLOW_STOP;
        flow_ex_o = `FLOW_STOP;
        flow_as_o = `FLOW_STOP;
        flow_wb_o = `FLOW_STOP;
    end
    else begin 
        flow_pc_o = `FLOW_WORK;
        flow_de_o = `FLOW_WORK;
        flow_ex_o = `FLOW_WORK;
        flow_as_o = `FLOW_WORK;
        flow_wb_o = `FLOW_WORK;
        next_pc_four_o = 1'b1;   
    end
end

endmodule //flow_ctrl
