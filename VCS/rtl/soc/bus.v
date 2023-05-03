// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2023 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : bus.v
// Author        : whr
// Created On    : 2023-05-03 23:14
// Last Modified : 2023-05-04 17:01
// ---------------------------------------------------------------------------------
// Description   : 
//
// -FHDR----------------------------------------------------------------------------

//`include "../soc/rooth_defines.v"


// RIB总线模块
module bus(

    input wire clk,
    input wire rst_n,

    // master 0 interface
    input wire[`CPU_WIDTH-1:0] m0_addr_i,     // 主设备0读、写地址
    input wire[`CPU_WIDTH-1:0] m0_data_i,         // 主设备0写数据
    output wire [`CPU_WIDTH-1:0] m0_data_o,         // 主设备0读取到的数据
    input wire m0_req_i,                   // 主设备0访问请求标志
    input wire m0_we_i,                    // 主设备0写标志

    // master 1 interface
    input wire[`CPU_WIDTH-1:0] m1_addr_i,     // 主设备1读、写地址
    output reg[`CPU_WIDTH-1:0] m1_data_o,         // 主设备1读取到的数据

    // master 2 interface
    input wire[`CPU_WIDTH-1:0] m2_addr_i,     // 主设备2读、写地址
    input wire[`CPU_WIDTH-1:0] m2_data_i,         // 主设备2写数据
    output reg[`CPU_WIDTH-1:0] m2_data_o,         // 主设备2读取到的数据
    input wire m2_req_i,                   // 主设备2访问请求标志
    input wire m2_we_i,                    // 主设备2写标志

    // master 3 interface
    input wire[`CPU_WIDTH-1:0] m3_addr_i,     // 主设备3读、写地址
    input wire[`CPU_WIDTH-1:0] m3_data_i,         // 主设备3写数据
    output reg[`CPU_WIDTH-1:0] m3_data_o,         // 主设备3读取到的数据
    input wire m3_req_i,                   // 主设备3访问请求标志
    input wire m3_we_i,                    // 主设备3写标志

    // slave 0 interface
    output reg[`CPU_WIDTH-1:0] s0_addr_o,     // 从设备0读、写地址
    output reg[`CPU_WIDTH-1:0] s0_data_o,         // 从设备0写数据
    input wire[`CPU_WIDTH-1:0] s0_data_i,         // 从设备0读取到的数据
    output reg s0_we_o,                    // 从设备0写标志

    // slave 1 interface
    output reg[`CPU_WIDTH-1:0] s1_addr_o,     // 从设备1读、写地址
    output reg[`CPU_WIDTH-1:0] s1_data_o,         // 从设备1写数据
    input wire[`CPU_WIDTH-1:0] s1_data_i,         // 从设备1读取到的数据
    output reg s1_we_o,                    // 从设备1写标志

    // slave 2 interface
    output reg[`CPU_WIDTH-1:0] s2_addr_o,     // 从设备2读、写地址
    output reg[`CPU_WIDTH-1:0] s2_data_o,         // 从设备2写数据
    input wire[`CPU_WIDTH-1:0] s2_data_i,         // 从设备2读取到的数据
    output reg s2_we_o,                    // 从设备2写标志

    // slave 3 interface
    output reg[`CPU_WIDTH-1:0] s3_addr_o,     // 从设备3读、写地址
    output reg[`CPU_WIDTH-1:0] s3_data_o,         // 从设备3写数据
    input wire[`CPU_WIDTH-1:0] s3_data_i,         // 从设备3读取到的数据
    output reg s3_we_o,                    // 从设备3写标志

    // slave 4 interface
    output reg[`CPU_WIDTH-1:0] s4_addr_o,     // 从设备4读、写地址
    output reg[`CPU_WIDTH-1:0] s4_data_o,         // 从设备4写数据
    input wire[`CPU_WIDTH-1:0] s4_data_i,         // 从设备4读取到的数据
    output reg s4_we_o,                    // 从设备4写标志

    // slave 5 interface
    output reg[`CPU_WIDTH-1:0] s5_addr_o,     // 从设备5读、写地址
    output reg[`CPU_WIDTH-1:0] s5_data_o,         // 从设备5写数据
    input wire[`CPU_WIDTH-1:0] s5_data_i,         // 从设备5读取到的数据
    output reg s5_we_o,                    // 从设备5写标志

    output reg hold_flag_o                 // 暂停流水线标志

    );


    // 访问地址的最高4位决定要访问的是哪一个从设备
    // 因此最多支持16个从设备
    parameter [3:0]slave_0 = 4'b0000;
    parameter [3:0]slave_1 = 4'b0001;
    parameter [3:0]slave_2 = 4'b0010;
    parameter [3:0]slave_3 = 4'b0011;
    parameter [3:0]slave_4 = 4'b0100;
    parameter [3:0]slave_5 = 4'b0101;

    parameter [1:0]grant0 = 2'h0;
    parameter [1:0]grant1 = 2'h1;
    parameter [1:0]grant2 = 2'h2;
    parameter [1:0]grant3 = 2'h3;

    wire[3:0] req;
    reg[1:0] grant;
    reg[3:0] next_m0_data_o;
    reg[3:0] current_m0_data_o;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            current_m0_data_o <= `CPU_WIDTH'b0;
        end
        else begin
            current_m0_data_o <= next_m0_data_o;
        end
    end

    assign m0_data_o = (current_m0_data_o == 4'd0) ? s0_data_i :
				    (current_m0_data_o == 4'd1) ? s1_data_i :
                    (current_m0_data_o == 4'd2) ? s2_data_i :
                    (current_m0_data_o == 4'd3) ? s3_data_i :
				    (current_m0_data_o == 4'd4) ? s4_data_i : s5_data_i;

    // 仲裁逻辑
    // 固定优先级仲裁机制
    // 优先级由高到低：主设备3，主设备0，主设备2，主设备1
    // master0-core_data_req、master1-core_inst_req、master2-jtag、master3-other;
    always @ (*) begin
        if (m3_req_i) begin
            grant = grant3;
            hold_flag_o = 1'b1;
        end
        else if (m0_req_i) begin
            grant = grant0;
            hold_flag_o = 1'b1;
        end
        else if (m2_req_i) begin
            grant = grant2;
            hold_flag_o = 1'b1;
        end
        else begin
            grant = grant1;
            hold_flag_o = 1'b0;
        end
    end

    // 根据仲裁结果，选择(访问)对应的从设备
    always @ (*) begin
        next_m0_data_o = 4'b0;
        m1_data_o = s0_data_i;
        m2_data_o = `CPU_WIDTH'b0;
        m3_data_o = `CPU_WIDTH'b0;

        s0_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
        s0_data_o = `CPU_WIDTH'b0;
        s0_we_o = 1'b0;

        s1_addr_o = `CPU_WIDTH'b0;
        s2_addr_o = `CPU_WIDTH'b0;
        s3_addr_o = `CPU_WIDTH'b0;
        s4_addr_o = `CPU_WIDTH'b0;
        s5_addr_o = `CPU_WIDTH'b0;
        s1_data_o = `CPU_WIDTH'b0;
        s2_data_o = `CPU_WIDTH'b0;
        s3_data_o = `CPU_WIDTH'b0;
        s4_data_o = `CPU_WIDTH'b0;
        s5_data_o = `CPU_WIDTH'b0;
        s1_we_o = 1'b0;
        s2_we_o = 1'b0;
        s3_we_o = 1'b0;
        s4_we_o = 1'b0;
        s5_we_o = 1'b0;

        case (grant)
            grant0: begin
                case (m0_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m0_we_i;
                        s0_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s0_data_o = m0_data_i;
                        next_m0_data_o = 4'd0;
                    end
                    slave_1: begin
                        s1_we_o = m0_we_i;
                        s1_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s1_data_o = m0_data_i;
                        next_m0_data_o = 4'd1;
                    end
                    slave_2: begin
                        s2_we_o = m0_we_i;
                        s2_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s2_data_o = m0_data_i;
                        next_m0_data_o = 4'd2;
                    end
                    slave_3: begin
                        s3_we_o = m0_we_i;
                        s3_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s3_data_o = m0_data_i;
                        next_m0_data_o = 4'd3;
                    end
                    slave_4: begin
                        s4_we_o = m0_we_i;
                        s4_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s4_data_o = m0_data_i;
                        next_m0_data_o = 4'd4;
                    end
                    slave_5: begin
                        s5_we_o = m0_we_i;
                        s5_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s5_data_o = m0_data_i;
                        next_m0_data_o = 4'd5;
                    end
                    default: begin

                    end
                endcase
            end
            grant2: begin
                case (m2_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m2_we_i;
                        s0_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
                        s0_data_o = m2_data_i;
                        m2_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m2_we_i;
                        s1_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
                        s1_data_o = m2_data_i;
                        m2_data_o = s1_data_i;
                    end
                    slave_2: begin
                        s2_we_o = m2_we_i;
                        s2_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
                        s2_data_o = m2_data_i;
                        m2_data_o = s2_data_i;
                    end
                    slave_3: begin
                        s3_we_o = m2_we_i;
                        s3_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
                        s3_data_o = m2_data_i;
                        m2_data_o = s3_data_i;
                    end
                    slave_4: begin
                        s4_we_o = m2_we_i;
                        s4_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
                        s4_data_o = m2_data_i;
                        m2_data_o = s4_data_i;
                    end
                    slave_5: begin
                        s5_we_o = m2_we_i;
                        s5_addr_o = {{4'h0}, {m2_addr_i[27:0]}};
                        s5_data_o = m2_data_i;
                        m2_data_o = s5_data_i;
                    end
                    default: begin

                    end
                endcase
            end
            grant3: begin
                case (m3_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m3_we_i;
                        s0_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
                        s0_data_o = m3_data_i;
                        m3_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m3_we_i;
                        s1_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
                        s1_data_o = m3_data_i;
                        m3_data_o = s1_data_i;
                    end
                    slave_2: begin
                        s2_we_o = m3_we_i;
                        s2_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
                        s2_data_o = m3_data_i;
                        m3_data_o = s2_data_i;
                    end
                    slave_3: begin
                        s3_we_o = m3_we_i;
                        s3_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
                        s3_data_o = m3_data_i;
                        m3_data_o = s3_data_i;
                    end
                    slave_4: begin
                        s4_we_o = m3_we_i;
                        s4_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
                        s4_data_o = m3_data_i;
                        m3_data_o = s4_data_i;
                    end
                    slave_5: begin
                        s5_we_o = m3_we_i;
                        s5_addr_o = {{4'h0}, {m3_addr_i[27:0]}};
                        s5_data_o = m3_data_i;
                        m3_data_o = s5_data_i;
                    end
                    default: begin

                    end
                endcase
            end
            default: begin

            end
        endcase
    end

endmodule
