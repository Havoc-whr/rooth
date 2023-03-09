// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : client.v
// Author        : whr
// Created On    : 2023-01-14 9:37
// Last Modified : 2023-01-14 18:24
// ---------------------------------------------------------------------------------
// Description   : 
// 
//
// -FHDR----------------------------------------------------------------------------
`include "rooth_defines.v"
module clinet (
    input                           clk,
    input                           rst_n,

    // from external-core
    input [`INT_BUS]                int_flag_i,      // 中断输入信号

    // from pc_reg
    input [`CPU_WIDTH-1:0]          pc_inst_addr_i,  // 指令地址，来自取指阶段
    // from if_de
    input [`CPU_WIDTH-1:0]          de_inst_addr_i,  // 指令地址，来自译码阶段
    // from if_ex
    input [`CPU_WIDTH-1:0]          ex_inst_addr_i,  // 指令地址，来自执行阶段
    // from if_as
    input [`CPU_WIDTH-1:0]          as_inst_addr_i,  // 指令地址，来自访存阶段

    // from if_as_out
    input [`CPU_WIDTH-1:0]          wb_inst_i,       // 指令内容，来自写回阶段
    input [`CPU_WIDTH-1:0]          wb_inst_addr_i,  // 指令地址，来自写回阶段

    // from csr_reg
    input [`CPU_WIDTH-1:0]          csr_mtvec,       // mtvec寄存器
    input [`CPU_WIDTH-1:0]          csr_mepc,        // mepc寄存器
    input [`CPU_WIDTH-1:0]          csr_mstatus,     // mstatus寄存器

    // to csr_reg
    output reg                      we_o,            // 写CSR寄存器标志
    output reg[`CSR_ADDR_WIDTH-1:0] waddr_o,         // 写CSR寄存器地址
//    output reg[`CSR_ADDR_WIDTH-1:0] raddr_o,         // 读CSR寄存器地址
    output reg[`CPU_WIDTH-1:0]      data_o,          // 写CSR寄存器数据

    // to flow_ctrl
    output                          hold_flag_o,     // 流水线暂停标志
    output reg[`CPU_WIDTH-1:0]      int_addr_o,      // 中断入口地址
    output reg                      int_assert_o     // 中断标志
);

// 中断状态定义
localparam S_INT_IDLE            = 4'b0001;
localparam S_INT_SYNC_ASSERT     = 4'b0010;
localparam S_INT_ASYNC_ASSERT    = 4'b0100;
localparam S_INT_MRET            = 4'b1000;

// 写CSR寄存器状态定义
localparam S_CSR_IDLE            = 5'b00001;
localparam S_CSR_MSTATUS         = 5'b00010;
localparam S_CSR_MEPC            = 5'b00100;
localparam S_CSR_MSTATUS_MRET    = 5'b01000;
localparam S_CSR_MCAUSE          = 5'b10000;

reg[3:0] int_state;
reg[4:0] csr_state;
reg[`CPU_WIDTH-1:0] inst_addr;
reg[31:0] cause;

assign hold_flag_o = ((int_state != S_INT_IDLE) | (csr_state != S_CSR_IDLE))? 1'b1 : 1'b0;


// 中断仲裁逻辑
always @ (*) begin
    if (~rst_n) begin
        int_state = S_INT_IDLE;
    end 
    else begin
        if (wb_inst_i == `INST_ECALL || wb_inst_i == `INST_EBREAK) begin
            int_state = S_INT_SYNC_ASSERT;
        end
        else if (int_flag_i != `INT_NONE && csr_mstatus[3] == 1'b1) begin //csr_mstatus[3]为全局中断使能标志位
            int_state = S_INT_ASYNC_ASSERT;
        end
        else if (wb_inst_i == `INST_MRET) begin
            int_state = S_INT_MRET;
        end
        else begin
            int_state = S_INT_IDLE;
        end
    end
end

// 写CSR寄存器状态切换
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        csr_state <= S_CSR_IDLE;
        cause <= `CPU_WIDTH'b0;
        inst_addr <= `CPU_WIDTH'b0;
    end 
    else begin
        case (csr_state)
            S_CSR_IDLE: begin
                // 同步中断
                if (int_state == S_INT_SYNC_ASSERT) begin
                    csr_state <= S_CSR_MEPC;
                    inst_addr <= wb_inst_addr_i;
                    case (wb_inst_i)
                        `INST_ECALL: begin
                            cause <= 32'd11;
                        end
                        `INST_EBREAK: begin
                            cause <= 32'd3;
                        end
                        default: begin
                            cause <= 32'd10;
                        end
                    endcase
                // 异步中断
                end
                else if (int_state == S_INT_ASYNC_ASSERT) begin
                    // 定时器中断
                    cause <= 32'h80000004;
                    csr_state <= S_CSR_MEPC;
                    if (as_inst_addr_i) begin
                        inst_addr <= as_inst_addr_i - 32'h4;
                    end
                    else if (ex_inst_addr_i) begin
                        inst_addr <= ex_inst_addr_i - 32'h4;
                    end
                    else if (de_inst_addr_i) begin
                        inst_addr <= de_inst_addr_i - 32'h4;
                    end
                    else begin
                        inst_addr <= pc_inst_addr_i;
                    end
                // 中断返回
                end
                else if (int_state == S_INT_MRET) begin
                    csr_state <= S_CSR_MSTATUS_MRET;
                end
            end
            S_CSR_MEPC: begin
                csr_state <= S_CSR_MSTATUS;
            end
            S_CSR_MSTATUS: begin
                csr_state <= S_CSR_MCAUSE;
            end
            S_CSR_MCAUSE: begin
                csr_state <= S_CSR_IDLE;
            end
            S_CSR_MSTATUS_MRET: begin
                csr_state <= S_CSR_IDLE;
            end
            default: begin
                csr_state <= S_CSR_IDLE;
            end
        endcase
    end
end

// 发出中断信号前，先写几个CSR寄存器
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        we_o <= 1'b0;
        waddr_o <= `CSR_ADDR_WIDTH'b0;
        data_o <= `CPU_WIDTH'b0;
    end else begin
        case (csr_state)
            // 将mepc寄存器的值设为当前指令地址
            S_CSR_MEPC: begin
                we_o <= 1'b1;
                waddr_o <= {20'h0, `CSR_MEPC};
                data_o <= inst_addr;
            end
            // 写中断产生的原因
            S_CSR_MCAUSE: begin
                we_o <= 1'b1;
                waddr_o <= {20'h0, `CSR_MCAUSE};
                data_o <= cause;
            end
            // 关闭全局中断
            S_CSR_MSTATUS: begin
                we_o <= 1'b1;
                waddr_o <= {20'h0, `CSR_MSTATUS};
                data_o <= {csr_mstatus[31:4], 1'b0, csr_mstatus[2:0]};
            end
            // 中断返回
            S_CSR_MSTATUS_MRET: begin
                we_o <= 1'b1;
                waddr_o <= {20'h0, `CSR_MSTATUS};
                data_o <= {csr_mstatus[31:4], csr_mstatus[7], csr_mstatus[2:0]};
            end
            default: begin
                we_o <= 1'b0;
                waddr_o <= `CSR_ADDR_WIDTH'b0;
                data_o <= `CPU_WIDTH'b0;
            end
        endcase
    end
end

// 发出中断信号给ex模块
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        int_assert_o <= 1'b0;
        int_addr_o <= `CPU_WIDTH'b0;
    end else begin
        case (csr_state)
            // 发出中断进入信号.写完mcause寄存器才能发
            S_CSR_MCAUSE: begin
                int_assert_o <= 1'b1;
                int_addr_o <= csr_mtvec;
            end
            // 发出中断返回信号
            S_CSR_MSTATUS_MRET: begin
                int_assert_o <= 1'b1;
                int_addr_o <= csr_mepc;
            end
            default: begin
                int_assert_o <= 1'b0;
                int_addr_o <= `CPU_WIDTH'b0;
            end
        endcase
    end
end

endmodule //clinet
