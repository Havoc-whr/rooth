// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : if_wb.v
// Author        : whr
// Created On    : 2022-08-12 23:04
// Last Modified : 2022-08-14 16:40
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------

//`include "../soc/rooth_defines.v"

module if_wb (
    input                               clk,
    input                               rst_n,
    input [`CPU_WIDTH-1:0]              inst_i, 
    input [`CPU_WIDTH-1:0]              pc_adder_i,
    input [`FLOW_WIDTH-1:0]             flow_wb_i,

    input                               reg_wr_en_i,
    input [`REG_ADDR_WIDTH-1:0]         reg_wr_adder_i,
    input [`CPU_WIDTH-1:0]              reg_wr_data_i,
    input                               csr_wr_en_i,
    input [`CSR_ADDR_WIDTH-1:0]         csr_wr_adder_i,
    input [`CPU_WIDTH-1:0]              csr_wr_data_i,
    input [1:0]                         mem_addr_index_i,
    input                               no_writing_mem_i,

    output reg                          reg_wr_en_o,
    output reg [`REG_ADDR_WIDTH-1:0]    reg_wr_adder_o,
    output reg [`CPU_WIDTH-1:0]         reg_wr_data_o,
    output reg                          csr_wr_en_o,
    output reg [`CSR_ADDR_WIDTH-1:0]    csr_wr_adder_o,
    output reg [`CPU_WIDTH-1:0]         csr_wr_data_o,
    output reg [`CPU_WIDTH-1:0]         inst_o,
    output reg [`CPU_WIDTH-1:0]         pc_adder_o,
    output reg [1:0]                    mem_addr_index_o,
    output reg                          no_writing_mem_o
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        reg_wr_en_o <= 1'b0;
        reg_wr_adder_o <= `REG_ADDR_WIDTH'b0;
        reg_wr_data_o <= `CPU_WIDTH'b0;
        csr_wr_en_o <= 1'b0;
        csr_wr_adder_o <= `CSR_ADDR_WIDTH'b0;
        csr_wr_data_o <= `CPU_WIDTH'b0;
        inst_o <= `CPU_WIDTH'b0;
        pc_adder_o <= `CPU_WIDTH'b0;
        mem_addr_index_o <= 2'b0;
        no_writing_mem_o <= 1'b0;
    end
    else begin
        case(flow_wb_i)
            `FLOW_WORK: begin
                reg_wr_en_o <= reg_wr_en_i;
                reg_wr_adder_o <= reg_wr_adder_i;
                reg_wr_data_o <= reg_wr_data_i;
                csr_wr_en_o <= csr_wr_en_i;
                csr_wr_adder_o <= csr_wr_adder_i;
                csr_wr_data_o <= csr_wr_data_i;
                inst_o <= inst_i;
                pc_adder_o <= pc_adder_i;
                mem_addr_index_o <= mem_addr_index_i;
                no_writing_mem_o <= no_writing_mem_i;
            end
            `FLOW_STOP: begin
                reg_wr_en_o <= reg_wr_en_o;
                reg_wr_adder_o <= reg_wr_adder_o;
                reg_wr_data_o <= reg_wr_data_o;
                csr_wr_en_o <= csr_wr_en_o;
                csr_wr_adder_o <= csr_wr_adder_o;
                csr_wr_data_o <= csr_wr_data_o;
                inst_o <= inst_o;
                pc_adder_o <= pc_adder_o;
                mem_addr_index_o <= mem_addr_index_o;
                no_writing_mem_o <= no_writing_mem_o;
            end
            `FLOW_REFRESH: begin
                reg_wr_en_o <= 1'b0;
                reg_wr_adder_o <= `REG_ADDR_WIDTH'b0;
                reg_wr_data_o <= `CPU_WIDTH'b0;
                csr_wr_en_o <= 1'b0;
                csr_wr_adder_o <= `CSR_ADDR_WIDTH'b0;
                csr_wr_data_o <= `CPU_WIDTH'b0;
                inst_o <= `CPU_WIDTH'b0;
                pc_adder_o <= `CPU_WIDTH'b0;
                mem_addr_index_o <= 2'b0;
                no_writing_mem_o <= 1'b0;
            end
            default: begin
                reg_wr_en_o <= 1'b0;
                reg_wr_adder_o <= `REG_ADDR_WIDTH'b0;
                reg_wr_data_o <= `CPU_WIDTH'b0;
                csr_wr_en_o <= 1'b0;
                csr_wr_adder_o <= `CSR_ADDR_WIDTH'b0;
                csr_wr_data_o <= `CPU_WIDTH'b0;
                inst_o <= `CPU_WIDTH'b0;
                pc_adder_o <= `CPU_WIDTH'b0;
                mem_addr_index_o <= 2'b0;
                no_writing_mem_o <= 1'b0;
            end
        endcase
    end
end

endmodule //if_wb
