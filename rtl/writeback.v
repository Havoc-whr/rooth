// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2023 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : writeback.v
// Author        : whr
// Created On    : 2023-05-03 12:04
// Last Modified : 2022-05-03 16:40
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
`include "rooth_defines.v"
module writeback(
    input [`CPU_WIDTH-1:0]              wb_reg_wr_data_i,
    input                               no_writing_mem_i,
    input [`CPU_WIDTH-1:0]              data_mem_data_i,
    input [`FUNCT3_WIDTH-1:0]           funct3_i,
    input [1:0]                         mem_addr_index_i,

    output reg [`CPU_WIDTH-1:0]         reg_wr_data_o
);

always @( *) begin
    if(no_writing_mem_i) begin
        case(funct3_i)
            `INST_LB://符号位扩展
                case (mem_addr_index_i)
                    2'b00: reg_wr_data_o = {{24{data_mem_data_i[7]}},data_mem_data_i[7:0]};
                    2'b01: reg_wr_data_o = {{24{data_mem_data_i[15]}},data_mem_data_i[15:8]};
                    2'b10: reg_wr_data_o = {{24{data_mem_data_i[23]}},data_mem_data_i[23:16]};
                    default: reg_wr_data_o = {{24{data_mem_data_i[31]}},data_mem_data_i[31:24]};
                endcase
            `INST_LH:
                case (mem_addr_index_i)
                    2'b00: reg_wr_data_o = {{16{data_mem_data_i[15]}},data_mem_data_i[15:0]};
                    default: reg_wr_data_o = {{16{data_mem_data_i[31]}},data_mem_data_i[31:16]};
                endcase
            `INST_LW:
                reg_wr_data_o = data_mem_data_i[31:0];
            `INST_LBU://高位补零
                case (mem_addr_index_i)
                    2'b00: reg_wr_data_o = {24'h0, data_mem_data_i[7:0]};
                    2'b01: reg_wr_data_o = {24'h0, data_mem_data_i[15:8]};
                    2'b10: reg_wr_data_o = {24'h0, data_mem_data_i[23:16]};
                    default: reg_wr_data_o = {24'h0, data_mem_data_i[31:24]};
                endcase
            `INST_LHU:
                case (mem_addr_index_i)
                    2'b00: reg_wr_data_o = {{16{1'b0}},data_mem_data_i[15:0]};
                    default: reg_wr_data_o = {{16{1'b0}},data_mem_data_i[31:16]};
                endcase
        endcase
    end
    else begin
        reg_wr_data_o = wb_reg_wr_data_i;
    end
end

endmodule