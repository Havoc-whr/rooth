// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : pc_reg.v
// Author        : whr
// Created On    : 2022-06-29 20:00
// Last Modified : 2022-08-14 16:41
// ---------------------------------------------------------------------------------
// Description   : Update the current pc value 
//
// -FHDR----------------------------------------------------------------------------
`include "rooth_defines.v"

module pc_reg (
    input                           clk,        // system clock
    input                           rst_n,      // active low reset
    input                           jtag_reset_flag_i,
    input      [`FLOW_WIDTH-1:0]    flow_pc_i,
    input                           next_pc_four_i,     
    input      [`CPU_WIDTH-1:0]     next_pc_i,  // next pc addr
    output reg  [`CPU_WIDTH-1:0]    curr_pc_o   // current pc addr
);

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n || jtag_reset_flag_i)
        curr_pc_o <= `CPU_WIDTH'b0;
    else begin
        case(flow_pc_i)
            `FLOW_WORK: begin
                if(next_pc_four_i) curr_pc_o <= curr_pc_o + `CPU_WIDTH'd4;
                else curr_pc_o <= next_pc_i;
            end
            `FLOW_STOP: curr_pc_o <= curr_pc_o;
            `FLOW_REFRESH: curr_pc_o <= `CPU_WIDTH'b0;
            default: curr_pc_o <= `CPU_WIDTH'b0;
        endcase
    end
end    

endmodule