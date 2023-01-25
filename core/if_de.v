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

`include "rooth_defines.v"

module if_de (
    input                       clk,
    input                       rst_n,
    input [`FLOW_WIDTH-1:0]     flow_de_i,

    input [`CPU_WIDTH-1:0]      pc_adder_i,
    input [`CPU_WIDTH-1:0]      inst_i,

    output reg [`CPU_WIDTH-1:0] pc_adder_o,
    output reg [`CPU_WIDTH-1:0] inst_o
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pc_adder_o <= `CPU_WIDTH'b0;
        inst_o <= `CPU_WIDTH'b0;//`CPU_WIDTH'h00000013;//nop
    end
    else begin
        case(flow_de_i)
            `FLOW_WORK: begin
                pc_adder_o <= pc_adder_i;
                inst_o <= inst_i;
            end
            `FLOW_STOP: begin
                pc_adder_o <= pc_adder_o;
                inst_o <= inst_o;
            end
            `FLOW_REFRESH: begin
                pc_adder_o <= `CPU_WIDTH'b0;
                inst_o <= `CPU_WIDTH'h00000013;//nop
            end
            default: begin
                pc_adder_o <= `CPU_WIDTH'b0;
                inst_o <= `CPU_WIDTH'b0;
            end
        endcase
    end
end

endmodule //if_de