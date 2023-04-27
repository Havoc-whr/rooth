// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : reg_clash_fb.v
// Author        : whr
// Created On    : 2022-08-13 17:31
// Last Modified : 2022-08-15 12:11
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
`include "./hdl_file/soc/rooth_defines.v"

module reg_clash_fb (
    input                               as_reg_wr_en_i,
    input [`REG_ADDR_WIDTH-1:0]         as_reg_wr_adder_i,
    input [`CPU_WIDTH-1:0]              as_reg_wr_data_i,
    input                               as_csr_wr_en_i,
    input [`CSR_ADDR_WIDTH-1:0]         as_csr_wr_adder_i,
    input [`CPU_WIDTH-1:0]              as_csr_wr_data_i, 

    input                               wb_reg_wr_en_i,
    input [`REG_ADDR_WIDTH-1:0]         wb_reg_wr_adder_i,
    input [`CPU_WIDTH-1:0]              wb_reg_wr_data_i,
    input                               wb_csr_wr_en_i,
    input [`CSR_ADDR_WIDTH-1:0]         wb_csr_wr_adder_i,
    input [`CPU_WIDTH-1:0]              wb_csr_wr_data_i, 

    input [`CSR_ADDR_WIDTH-1:0]         csr_rd_adder_i,
    input [`REG_ADDR_WIDTH-1:0]         reg1_rd_adder_i,
    input [`REG_ADDR_WIDTH-1:0]         reg2_rd_adder_i,

    input [`CPU_WIDTH-1:0]              reg1_rd_data_i,
    input [`CPU_WIDTH-1:0]              reg2_rd_data_i,
    input [`CPU_WIDTH-1:0]              csr_rd_data_i,

    output reg [`CPU_WIDTH-1:0]         reg1_rd_data_o,
    output reg [`CPU_WIDTH-1:0]         reg2_rd_data_o,
    output reg [`CPU_WIDTH-1:0]         csr_rd_data_o,
    output reg [`REG_ADDR_WIDTH-1:0]    reg1_rd_adder_o,
    output reg [`REG_ADDR_WIDTH-1:0]    reg2_rd_adder_o,
    output reg [`CSR_ADDR_WIDTH-1:0]    csr_rd_adder_o
);

// reg1
always @( *) begin 
    if(reg1_rd_adder_i == `REG_ADDR_WIDTH'b0) begin
        reg1_rd_adder_o = `REG_ADDR_WIDTH'b0;
        reg1_rd_data_o = `CPU_WIDTH'b0;
    end
    else if(as_reg_wr_en_i && (reg1_rd_adder_i == as_reg_wr_adder_i)) begin
        reg1_rd_adder_o = `REG_ADDR_WIDTH'b0;
        reg1_rd_data_o = as_reg_wr_data_i;
    end
    else if(wb_reg_wr_en_i && (reg1_rd_adder_i == wb_reg_wr_adder_i)) begin
        reg1_rd_adder_o = `REG_ADDR_WIDTH'b0;
        reg1_rd_data_o = wb_reg_wr_data_i;
    end
    else begin
        reg1_rd_adder_o = reg1_rd_adder_i;
        reg1_rd_data_o = reg1_rd_data_i;
    end
end

// reg2
always @( *) begin
    if(reg2_rd_adder_i == `REG_ADDR_WIDTH'b0) begin
        reg2_rd_adder_o = `REG_ADDR_WIDTH'b0;
        reg2_rd_data_o = `CPU_WIDTH'b0;
    end
    else if(as_reg_wr_en_i && (reg2_rd_adder_i == as_reg_wr_adder_i)) begin
        reg2_rd_adder_o = `REG_ADDR_WIDTH'b0;
        reg2_rd_data_o = as_reg_wr_data_i;
    end
    else if(wb_reg_wr_en_i && (reg2_rd_adder_i == wb_reg_wr_adder_i)) begin
        reg2_rd_adder_o = `REG_ADDR_WIDTH'b0;
        reg2_rd_data_o = wb_reg_wr_data_i;
    end
    else begin
        reg2_rd_adder_o = reg2_rd_adder_i;
        reg2_rd_data_o = reg2_rd_data_i;
    end
end

// csr
always @( *) begin
    if(as_csr_wr_en_i && (csr_rd_adder_i == as_csr_wr_adder_i)) begin
        csr_rd_adder_o = `CSR_ADDR_WIDTH'b0;
        csr_rd_data_o = as_csr_wr_data_i;
    end
    else if(wb_csr_wr_en_i && (csr_rd_adder_i == wb_csr_wr_adder_i)) begin
        csr_rd_adder_o = `CSR_ADDR_WIDTH'b0;
        csr_rd_data_o = wb_csr_wr_data_i;
    end
    else begin
        csr_rd_adder_o = csr_rd_adder_i;
        csr_rd_data_o = csr_rd_data_i;
    end
end

endmodule //clash_ctrl
