// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : fetch.v
// Author        : whr
// Created On    : 2022-07-16 09:34
// Last Modified : 2023-01-08 14:55
// ---------------------------------------------------------------------------------
// Description   : 
// 决定存储数据最终流向 
//
// -FHDR----------------------------------------------------------------------------
`include "./hdl_file/soc/rooth_defines.v"
module fetch(
    input                                   clk,
    input                                   rst_n,

    input   [`CPU_WIDTH-1:0]                rs1_data_i,
    input   [`CPU_WIDTH-1:0]                rs2_data_i,
    input   [`CPU_WIDTH-1:0]                csr_rd_data_i,
    input   [`CPU_WIDTH-1:0]                imm_i,
    input   [`FUNCT3_WIDTH-1:0]             funct3_i,
    input   [`OPCODE_WIDTH-1:0]             opcode_i,

    input   [`WIDTH_RESCTRL-1:0]            alu_res_op_i,

    input      [`CPU_WIDTH-1:0]             alu_res_i,

    output reg [`CPU_WIDTH-1:0]             data_mem_addr_o,
    output reg                              data_mem_wr_en_o,
    output reg                              data_mem_req_o,
    input      [`CPU_WIDTH-1:0]             data_mem_data_i,

    output reg [`CPU_WIDTH-1:0]             data_mem_data_o,
    output reg [`CPU_WIDTH-1:0]             reg_wr_data_o,

    output reg [`CPU_WIDTH-1:0]             csr_wr_data_o,
    output wire                             access_mem_hold_o,
    output wire[1:0]                        mem_addr_index_o,
    output reg                              no_writing_mem_o,
    output reg                              pc_hold_o
);
wire acess_mem_flag;
reg  writing_mem;
reg  writing_reg;
assign acess_mem_flag = ((alu_res_op_i == `RESCTRL_MEM) || ((alu_res_op_i == `RESCTRL_REG) && (opcode_i == `INST_TYPE_IL))) ? 1'b1 : 1'b0;
assign access_mem_hold_o = (~writing_mem) && acess_mem_flag && (~no_writing_mem_o) && (~writing_reg);

assign mem_addr_index_o = alu_res_i[1:0] & 2'b11;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        writing_mem <= 1'b0;
    end
    else begin
        if(acess_mem_flag && (~no_writing_mem_o) && (~writing_reg)) begin
            if(~writing_mem) writing_mem <= 1'b1;
            else writing_mem <= 1'b0;
        end
        else begin
            writing_mem <= 1'b0;
        end
    end
end

always @(*) begin
    data_mem_wr_en_o = 1'b0;
    data_mem_addr_o = alu_res_i;
    data_mem_data_o = `CPU_WIDTH'b0;
    reg_wr_data_o = `CPU_WIDTH'b0;
    data_mem_req_o = 1'b0;
    csr_wr_data_o = `CPU_WIDTH'b0;
    no_writing_mem_o =1'b0;
    pc_hold_o = 1'b0;
    writing_reg = 1'b0;
    if(alu_res_op_i == `RESCTRL_MEM) begin // 访存
        data_mem_addr_o = alu_res_i;
        data_mem_req_o = 1'b1;
        if(writing_mem)begin
            data_mem_wr_en_o = 1'b1;
            if(alu_res_i[31:28] == 4'b0000) begin
                pc_hold_o = 1'b1;
            end
            case(funct3_i)
                `INST_SB:
                    case (mem_addr_index_o)
                        2'b00: data_mem_data_o = {data_mem_data_i[31:8], rs2_data_i[7:0]};
                        2'b01: data_mem_data_o = {data_mem_data_i[31:16], rs2_data_i[7:0], data_mem_data_i[7:0]};
                        2'b10: data_mem_data_o = {data_mem_data_i[31:24], rs2_data_i[7:0], data_mem_data_i[15:0]};
                        default: data_mem_data_o = {rs2_data_i[7:0], data_mem_data_i[23:0]};
                    endcase
                `INST_SH:
                    case (mem_addr_index_o)
                        2'b00: data_mem_data_o = {data_mem_data_i[31:16], rs2_data_i[15:0]};
                        default: data_mem_data_o = {rs2_data_i[15:0], data_mem_data_i[15:0]};
                    endcase
                `INST_SW:
                    data_mem_data_o = rs2_data_i[31:0];
            endcase
        end
    end
    else if(alu_res_op_i == `RESCTRL_CSR) begin // 写CSR
        reg_wr_data_o = csr_rd_data_i;
        case(funct3_i)
            `INST_CSRRW: csr_wr_data_o = rs1_data_i;
            `INST_CSRRWI: csr_wr_data_o = imm_i;
            default: csr_wr_data_o = alu_res_i;
        endcase
    end
    else if(alu_res_op_i == `RESCTRL_REG) begin // alu_res_op_i == RESCTRL_REG
        data_mem_req_o = 1'b0;
        if(opcode_i == `INST_TYPE_IL) begin
            data_mem_req_o = 1'b1;
            data_mem_addr_o = alu_res_i;
            if(alu_res_i[31:28] == 4'b0000) begin
                pc_hold_o = 1'b1;
                if(writing_mem) begin
                    case(funct3_i)
                        `INST_LB://符号位扩展
                            case (mem_addr_index_o)
                                2'b00: reg_wr_data_o = {{24{data_mem_data_i[7]}},data_mem_data_i[7:0]};
                                2'b01: reg_wr_data_o = {{24{data_mem_data_i[15]}},data_mem_data_i[15:8]};
                                2'b10: reg_wr_data_o = {{24{data_mem_data_i[23]}},data_mem_data_i[23:16]};
                                default: reg_wr_data_o = {{24{data_mem_data_i[31]}},data_mem_data_i[31:24]};
                            endcase
                        `INST_LH:
                            case (mem_addr_index_o)
                                2'b00: reg_wr_data_o = {{16{data_mem_data_i[15]}},data_mem_data_i[15:0]};
                                default: reg_wr_data_o = {{16{data_mem_data_i[31]}},data_mem_data_i[31:16]};
                            endcase
                        `INST_LW:
                            reg_wr_data_o = data_mem_data_i[31:0];
                        `INST_LBU://高位补零
                            case (mem_addr_index_o)
                                2'b00: reg_wr_data_o = {24'h0, data_mem_data_i[7:0]};
                                2'b01: reg_wr_data_o = {24'h0, data_mem_data_i[15:8]};
                                2'b10: reg_wr_data_o = {24'h0, data_mem_data_i[23:16]};
                                default: reg_wr_data_o = {24'h0, data_mem_data_i[31:24]};
                            endcase
                        `INST_LHU:
                            case (mem_addr_index_o)
                                2'b00: reg_wr_data_o = {{16{1'b0}},data_mem_data_i[15:0]};
                                default: reg_wr_data_o = {{16{1'b0}},data_mem_data_i[31:16]};
                            endcase
                    endcase
                end
            end
            else if(alu_res_i[31:28] == 4'b0001) begin
                no_writing_mem_o = 1'b1;
            end
            else begin
                writing_reg = 1'b1;
                case(funct3_i)
                    `INST_LB://符号位扩展
                        case (mem_addr_index_o)
                            2'b00: reg_wr_data_o = {{24{data_mem_data_i[7]}},data_mem_data_i[7:0]};
                            2'b01: reg_wr_data_o = {{24{data_mem_data_i[15]}},data_mem_data_i[15:8]};
                            2'b10: reg_wr_data_o = {{24{data_mem_data_i[23]}},data_mem_data_i[23:16]};
                            default: reg_wr_data_o = {{24{data_mem_data_i[31]}},data_mem_data_i[31:24]};
                        endcase
                    `INST_LH:
                        case (mem_addr_index_o)
                            2'b00: reg_wr_data_o = {{16{data_mem_data_i[15]}},data_mem_data_i[15:0]};
                            default: reg_wr_data_o = {{16{data_mem_data_i[31]}},data_mem_data_i[31:16]};
                        endcase
                    `INST_LW:
                        reg_wr_data_o = data_mem_data_i[31:0];
                    `INST_LBU://高位补零
                        case (mem_addr_index_o)
                            2'b00: reg_wr_data_o = {24'h0, data_mem_data_i[7:0]};
                            2'b01: reg_wr_data_o = {24'h0, data_mem_data_i[15:8]};
                            2'b10: reg_wr_data_o = {24'h0, data_mem_data_i[23:16]};
                            default: reg_wr_data_o = {24'h0, data_mem_data_i[31:24]};
                        endcase
                    `INST_LHU:
                        case (mem_addr_index_o)
                            2'b00: reg_wr_data_o = {{16{1'b0}},data_mem_data_i[15:0]};
                            default: reg_wr_data_o = {{16{1'b0}},data_mem_data_i[31:16]};
                        endcase
                endcase
            end
        end
        else
            reg_wr_data_o = alu_res_i;
    end
    else begin
        //null
    end
end
endmodule
