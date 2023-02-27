// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : csr_reg.v
// Author        : whr
// Created On    : 2022-08-10 23:08
// Last Modified : 2023-01-14 17:07
// ---------------------------------------------------------------------------------
// Description   : 
//  
//
// -FHDR----------------------------------------------------------------------------
`include "./hdl_file/soc/rooth_defines.v"

module csr_reg (
    input                           clk,
    input                           rst_n,

    input                           csr_wr_en_i,
    input [`CSR_ADDR_WIDTH-1:0]     csr_wr_adder_i,
    input [`CPU_WIDTH-1:0]          csr_wr_data_i,
    input [`CSR_ADDR_WIDTH-1:0]     csr_rd_adder_i,
    
    output reg [`CPU_WIDTH-1:0]     csr_rd_data_o,

    input                           client_csr_wr_en_i,
    input [`CSR_ADDR_WIDTH-1:0]     client_csr_wr_adder_i,
    input [`CPU_WIDTH-1:0]          client_csr_wr_data_i,
//    input [`CSR_ADDER_WIDTH-1:0]    client_csr_rd_adder_i,

//    output reg [`CPU_WIDTH-1:0]     client_csr_rd_data_o,

    output wire [`CPU_WIDTH-1:0]    clint_csr_mtvec_o,
    output wire [`CPU_WIDTH-1:0]    clint_csr_mepc_o,
    output wire [`CPU_WIDTH-1:0]    clint_csr_mstatus_o
);

reg [`CPU_WIDTH*2-1:0]  cycle; //readonly
reg [`CPU_WIDTH-1:0]    mtvec;
reg [`CPU_WIDTH-1:0]    mcause;
reg [`CPU_WIDTH-1:0]    mepc;
reg [`CPU_WIDTH-1:0]    mie;
reg [`CPU_WIDTH-1:0]    mstatus;
reg [`CPU_WIDTH-1:0]    mscratch;

assign clint_csr_mtvec_o = mtvec;
assign clint_csr_mepc_o = mepc;
assign clint_csr_mstatus_o = mstatus;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) cycle <= `CPU_WIDTH*2'b0;
    else cycle <= cycle + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mtvec <= `CPU_WIDTH'b0;
        mcause <= `CPU_WIDTH'b0;
        mepc <= `CPU_WIDTH'b0;
        mie <= `CPU_WIDTH'b0;
        mstatus <= `CPU_WIDTH'b0;
        mscratch <= `CPU_WIDTH'b0;
    end
    else begin
        if(client_csr_wr_en_i) begin
            case(client_csr_wr_adder_i)
                `CSR_MTVEC: mtvec <= client_csr_wr_data_i;
                `CSR_MCAUSE: mcause <= client_csr_wr_data_i;
                `CSR_MEPC: mepc <= client_csr_wr_data_i;
                `CSR_MIE: mie <= client_csr_wr_data_i;
                `CSR_MSTATUS: mstatus <= client_csr_wr_data_i;
                `CSR_MSCRATCH: mscratch <= client_csr_wr_data_i;
            endcase
        end
        else if(csr_wr_en_i) begin
            case(csr_wr_adder_i)
                `CSR_MTVEC: mtvec <= csr_wr_data_i;
                `CSR_MCAUSE: mcause <= csr_wr_data_i;
                `CSR_MEPC: mepc <= csr_wr_data_i;
                `CSR_MIE: mie <= csr_wr_data_i;
                `CSR_MSTATUS: mstatus <= csr_wr_data_i;
                `CSR_MSCRATCH: mscratch <= csr_wr_data_i;
            endcase
        end
    end
end

always @( *) begin
    if((csr_rd_adder_i == csr_wr_adder_i) && (csr_wr_en_i))
        csr_rd_data_o = csr_wr_data_i;
    else begin
        case(csr_rd_adder_i) 
            `CSR_CYCLE: csr_rd_data_o = cycle[`CPU_WIDTH-1:0];
            `CSR_CYCLEH: csr_rd_data_o = cycle[`CPU_WIDTH*2-1:`CPU_WIDTH];
            `CSR_MTVEC: csr_rd_data_o = mtvec;
            `CSR_MCAUSE: csr_rd_data_o = mcause;
            `CSR_MEPC: csr_rd_data_o = mepc;
            `CSR_MIE: csr_rd_data_o =  mie;
            `CSR_MSTATUS: csr_rd_data_o = mstatus;
            `CSR_MSCRATCH: csr_rd_data_o = mscratch;
            default : csr_rd_data_o = `CPU_WIDTH'b0;
        endcase
    end
end

/*always @( *) begin
    if((client_csr_rd_adder_i == client_csr_wr_adder_i) && (client_csr_wr_en_i))
        client_csr_rd_data_o = client_csr_wr_data_i;
    else begin
        case(csr_rd_adder_i) 
            `CSR_CYCLE: client_csr_rd_data_o = cycle[`CPU_WIDTH-1:0];
            `CSR_CYCLEH: client_csr_rd_data_o = cycle[`CPU_WIDTH*2-1:`CPU_WIDTTH];
            `CSR_MTVEC: client_csr_rd_data_o = mtvec;
            `CSR_MCAUSE: client_csr_rd_data_o = mcause;
            `CSR_MEPC: client_csr_rd_data_o = mepc;
            `CSR_MIE: client_csr_rd_data_o =  mie;
            `CSR_MSTATUS: client_csr_rd_data_o = mstatus;
            `CSR_MSCRATCH: client_csr_rd_data_o = mscratch;
            default : client_csr_rd_data_o = `CPU_WIDTH'b0;
        endcase
    end
end*/

endmodule //csr_reg
