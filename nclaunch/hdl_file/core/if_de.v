// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : if_de.v
// Author        : whr
// Created On    : 2022-08-12 16:20
// Last Modified : 2022-08-12 17:06
// ---------------------------------------------------------------------------------
// Description   :
// 
//
//
// -FHDR----------------------------------------------------------------------------

`include "./hdl_file/soc/rooth_defines.v"

module if_de (
    input                       		clk,
    input                       		rst_n,
    input [`FLOW_WIDTH-1:0]     		flow_de_i,

    input [`CPU_WIDTH-1:0]				pc_adder_i,
    input [`CPU_WIDTH-1:0]      		inst_i,

    output reg		[`CPU_WIDTH-1:0]    pc_adder_o,
    output wire	[`CPU_WIDTH-1:0]        inst_o
);

reg [`FLOW_WIDTH-1:0]	flow_flag;
reg [`CPU_WIDTH-1:0]	p_inst_o;

assign inst_o = (flow_flag == `FLOW_WORK) ? inst_i :
				(flow_flag == `FLOW_STOP) ? p_inst_o :
				(flow_flag == `FLOW_REFRESH) ? `CPU_WIDTH'b0 : `CPU_WIDTH'b0;


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
			flow_flag <= `FLOW_REFRESH;
			pc_adder_o <= `CPU_WIDTH'b0;
			p_inst_o <= `CPU_WIDTH'b0;
    end
    else begin
		p_inst_o <= inst_o;
        case(flow_de_i)
            `FLOW_WORK: begin
                pc_adder_o <= pc_adder_i;
				flow_flag <= `FLOW_WORK;
            end
            `FLOW_STOP: begin
                pc_adder_o <= pc_adder_o;
				flow_flag <= `FLOW_STOP;
            end
            `FLOW_REFRESH: begin
                pc_adder_o <= `CPU_WIDTH'b0;
				flow_flag <= `FLOW_REFRESH;
            end
            default: begin
                pc_adder_o <= `CPU_WIDTH'b0;
				flow_flag <= `FLOW_REFRESH;
            end
        endcase
    end
end

endmodule //if_de
