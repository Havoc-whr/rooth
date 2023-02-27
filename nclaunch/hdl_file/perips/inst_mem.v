// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : inst_mem.v
// Author        : whr
// Created On    : 2022-06-29 19:53
// Last Modified : 2023-01-08 16:53
// ---------------------------------------------------------------------------------
// Description   : Instruction memory, the initial value is given by testbench. 
//
//
// -FHDR----------------------------------------------------------------------------
`include "./hdl_file/soc/rooth_defines.v"
module inst_mem (
    input                               clk,
    input                               rst_n,

    input                               wr_en_i,
    input       [`CPU_WIDTH-1:0]        data_i,
    input       [`CPU_WIDTH-1:0]        curr_pc_i, // current pc addr
    output reg  [`CPU_WIDTH-1:0]        inst_o     // instruction
);

reg [`CPU_WIDTH-1:0] inst_mem_f [0:`INST_MEM_ADDR_DEPTH-1];

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
    end
	else begin
		if(wr_en_i)inst_mem_f[curr_pc_i[`CPU_WIDTH-1:2]] <= data_i;
	end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
    end
    else begin
        inst_o = inst_mem_f[curr_pc_i[`CPU_WIDTH-1:2]]; 
    end
end

endmodule
