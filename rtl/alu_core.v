// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : alu.v
// Author        : whr
// Created On    : 2022-07-02 20:58
// Last Modified : 2023-01-25 11:13
// ---------------------------------------------------------------------------------
// Description   :ALU核心单元，仅用与数据的运算，源操作数的选择由选择器模块控
// 制
//
//
// -FHDR----------------------------------------------------------------------------
`include "rooth_defines.v"
module alu_core (
    input                       clk,
    input                       rst_n,

    input                       flow_wait_fc,
    
    input [`ALU_OP_WIDTH-1:0]   alu_op_i,
    input [`CPU_WIDTH-1:0]      alu_src1_i,
    input [`CPU_WIDTH-1:0]      alu_src2_i,

    output reg                  zero_o,
    output reg                  less_o,
    output reg                  more_zero_o,

    input                       div_res_ready_i,
    input      [`CPU_WIDTH-1:0] div_result_i,
    output reg [`CPU_WIDTH-1:0] dividend_o,
    output reg [`CPU_WIDTH-1:0] divisor_o,
    output reg                  div_start_o,
    output reg                  alu_busy_o,


    output reg [`CPU_WIDTH-1:0] alu_res_o
);

wire [`CPU_WIDTH-1:0]alu_src1_invert;
wire [`CPU_WIDTH-1:0]alu_src2_invert;
wire [`CPU_DOUBLE_WIDTH-1:0] multiply_result;
wire [`CPU_DOUBLE_WIDTH-1:0] multiply_result_invert;
reg  [`CPU_DOUBLE_WIDTH-1:0] extends_reg;
reg                          extends_flag;
wire                         extend_end;

assign alu_src1_invert = ~alu_src1_i + 1'b1;
assign alu_src2_invert = ~alu_src2_i + 1'b1;
assign multiply_result = extends_reg[`CPU_DOUBLE_WIDTH-1:`CPU_WIDTH] * extends_reg[`CPU_WIDTH-1:0];
assign multiply_result_invert = ~multiply_result + 1'b1;

always @(*) begin
    alu_res_o = `CPU_WIDTH'b0;
    dividend_o = `CPU_WIDTH'b0;
    divisor_o = `CPU_WIDTH'b0;
    div_start_o = 1'b0;
    zero_o = 1'b0;
    less_o = 1'b0;
    more_zero_o = 1'b0;
    alu_busy_o = 1'b0;
    case(alu_op_i)
        `ALU_ADD:
            alu_res_o = alu_src1_i + alu_src2_i;
        `ALU_SUB: begin
            alu_res_o = alu_src1_i - alu_src2_i;
            zero_o = (alu_res_o == `CPU_WIDTH'b0) ? 1'b1 : 1'b0;
        end
        `ALU_XOR:
            alu_res_o = alu_src1_i ^ alu_src2_i;
        `ALU_OR:
            alu_res_o = alu_src1_i | alu_src2_i;
        `ALU_AND:
            alu_res_o = alu_src1_i & alu_src2_i;
        `ALU_SLL:
            alu_res_o = alu_src1_i << {27'b0,alu_src2_i[4:0]};
        `ALU_SRL:
            alu_res_o = alu_src1_i >> {27'b0,alu_src2_i[4:0]};
        `ALU_SRA: begin
            if(extends_flag) alu_busy_o = 1'b0;
            else alu_busy_o = 1'b1;
            alu_res_o = extends_reg[`CPU_WIDTH-1:0];
        end
        `ALU_SLT: //complement judge
            if(alu_src1_i[`CPU_WIDTH-1] && !alu_src2_i[`CPU_WIDTH-1]) begin
                alu_res_o = `CPU_WIDTH'b1;
                more_zero_o = 1'b0;
                less_o = 1'b1;
            end
            else if (!alu_src1_i[`CPU_WIDTH-1] && alu_src2_i[`CPU_WIDTH-1]) begin
                alu_res_o = `CPU_WIDTH'b0;
                more_zero_o = 1'b1;
                less_o = 1'b0;
            end
            else begin
                alu_res_o = (alu_src1_i < alu_src2_i) ? 1 : 0;
                more_zero_o = (alu_res_o == `CPU_WIDTH'b0) ? 1 : 0;
                less_o = (alu_res_o == `CPU_WIDTH'b1) ? 1 : 0;
            end
        `ALU_SLTU: begin
            alu_res_o = (alu_src1_i < alu_src2_i) ? 1 : 0;
            more_zero_o = (alu_res_o == `CPU_WIDTH'b0) ? 1 : 0;
            less_o = (alu_res_o == `CPU_WIDTH'b1) ? 1 : 0;
        end
        `ALU_MUL:begin
            if(extends_flag) alu_busy_o = 1'b0;
            else alu_busy_o = 1'b1;
            alu_res_o = multiply_result[`CPU_WIDTH-1:0];
        end
        `ALU_MULH:begin
            if(extends_flag) alu_busy_o = 1'b0;
            else alu_busy_o = 1'b1;
            case({alu_src1_i[`CPU_WIDTH-1],alu_src2_i[`CPU_WIDTH-1]})
                2'b00:   alu_res_o = multiply_result[`CPU_DOUBLE_WIDTH-1:`CPU_WIDTH];
                2'b11:   alu_res_o = multiply_result[`CPU_DOUBLE_WIDTH-1:`CPU_WIDTH];
                2'b01:   alu_res_o = multiply_result_invert[`CPU_DOUBLE_WIDTH-1:`CPU_WIDTH];
                default: alu_res_o = multiply_result_invert[`CPU_DOUBLE_WIDTH-1:`CPU_WIDTH];
            endcase
        end
        `ALU_MULHU:begin
            if(extends_flag) alu_busy_o = 1'b0;
            else alu_busy_o = 1'b1;
            alu_res_o = multiply_result[`CPU_DOUBLE_WIDTH-1:`CPU_WIDTH];
        end
        `ALU_MULHSU:begin
            if(extends_flag) alu_busy_o = 1'b0;
            else alu_busy_o = 1'b1;
            alu_res_o = alu_src1_i[`CPU_WIDTH-1] ? multiply_result_invert[`CPU_DOUBLE_WIDTH-1:`CPU_WIDTH] : multiply_result[`CPU_DOUBLE_WIDTH-1:`CPU_WIDTH];
        end
        `ALU_DIV,`ALU_DIVU,`ALU_REM,`ALU_REMU:begin
            if(div_res_ready_i)begin
                alu_res_o = div_result_i;
                alu_busy_o = 1'b0;
            end
            else begin
                dividend_o = alu_src1_i;
                divisor_o = alu_src2_i;
                if(~flow_wait_fc) begin
                    div_start_o = 1'b1;
                    alu_busy_o = 1'b1;
                end
                else begin
                    div_start_o = 1'b0;
                    alu_busy_o = 1'b0;
                end
            end
        end
        default: begin
            alu_res_o = `CPU_WIDTH'b0;
            dividend_o = `CPU_WIDTH'b0;
            divisor_o = `CPU_WIDTH'b0;
            div_start_o = 1'b0;
            zero_o = 1'b0;
            less_o = 1'b0;
            more_zero_o = 1'b0;
            alu_busy_o = 1'b0;
        end
    endcase
end
always @(posedge clk or negedge rst_n)begin
    if(~rst_n) begin
        extends_reg <= `CPU_DOUBLE_WIDTH'b0;
        extends_flag <=1'b0;
    end
    else begin
        if(extends_flag || flow_wait_fc) begin
            extends_flag <= 1'b0;
        end
        else begin
            case(alu_op_i)
                `ALU_SRA:begin
                    extends_reg <= {{`CPU_WIDTH{alu_src1_i[31]}},alu_src1_i} >> {59'b0,alu_src2_i[4:0]};
                    extends_flag <=1'b1;
                end
                `ALU_MUL: begin
                    extends_reg <= {alu_src1_i,alu_src2_i};
                    extends_flag <=1'b1;
                end
                `ALU_MULH: begin
                    extends_reg <= {(alu_src1_i[`CPU_WIDTH-1] ? alu_src1_invert : alu_src1_i),(alu_src2_i[`CPU_WIDTH-1] ? alu_src2_invert : alu_src2_i)};
                    extends_flag <=1'b1;
                end
                `ALU_MULHU:begin
                    extends_reg <= {alu_src1_i,alu_src2_i};
                    extends_flag <=1'b1;
                end
                `ALU_MULHSU:begin
                    extends_reg <= {(alu_src1_i[`CPU_WIDTH-1] ? alu_src1_invert : alu_src1_i),alu_src2_i};
                    extends_flag <=1'b1;
                end
                default:begin
                    extends_reg <= `CPU_DOUBLE_WIDTH'b0;
                    extends_flag <=1'b0;
                end
            endcase
        end
    end
end
endmodule

