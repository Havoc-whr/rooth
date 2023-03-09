 /*                                                                      
 Copyright 2020 Blue Liang, liangkangnan@163.com
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
 Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */

`include "../core/rooth_defines.v"


// RIB����ģ��
module rib(

    input wire clk,
    input wire rst,

    // master 0 interface
    input wire[`CPU_WIDTH-1:0] m0_addr_i,     // ���豸0����д��ַ
    input wire[`CPU_WIDTH-1:0] m0_data_i,         // ���豸0д����
    output reg[`CPU_WIDTH-1:0] m0_data_o,         // ���豸0��ȡ��������
    input wire m0_req_i,                   // ���豸0���������־
    input wire m0_we_i,                    // ���豸0д��־

    // master 1 interface
    input wire[`CPU_WIDTH-1:0] m1_addr_i,     // ���豸1����д��ַ
    input wire[`CPU_WIDTH-1:0] m1_data_i,         // ���豸1д����
    output reg[`CPU_WIDTH-1:0] m1_data_o,         // ���豸1��ȡ��������
    input wire m1_req_i,                   // ���豸1���������־
    input wire m1_we_i,                    // ���豸1д��־

    // master 2 interface
    input wire[`CPU_WIDTH-1:0] m2_addr_i,     // ���豸2����д��ַ
    input wire[`CPU_WIDTH-1:0] m2_data_i,         // ���豸2д����
    output reg[`CPU_WIDTH-1:0] m2_data_o,         // ���豸2��ȡ��������
    input wire m2_req_i,                   // ���豸2���������־
    input wire m2_we_i,                    // ���豸2д��־

    // master 3 interface
    input wire[`CPU_WIDTH-1:0] m3_addr_i,     // ���豸3����д��ַ
    input wire[`CPU_WIDTH-1:0] m3_data_i,         // ���豸3д����
    output reg[`CPU_WIDTH-1:0] m3_data_o,         // ���豸3��ȡ��������
    input wire m3_req_i,                   // ���豸3���������־
    input wire m3_we_i,                    // ���豸3д��־

    // slave 0 interface
    output reg[`CPU_WIDTH-1:0] s0_addr_o,     // ���豸0����д��ַ
    output reg[`CPU_WIDTH-1:0] s0_data_o,         // ���豸0д����
    input wire[`CPU_WIDTH-1:0] s0_data_i,         // ���豸0��ȡ��������
    output reg s0_we_o,                    // ���豸0д��־

    // slave 1 interface
    output reg[`CPU_WIDTH-1:0] s1_addr_o,     // ���豸1����д��ַ
    output reg[`CPU_WIDTH-1:0] s1_data_o,         // ���豸1д����
    input wire[`CPU_WIDTH-1:0] s1_data_i,         // ���豸1��ȡ��������
    output reg s1_we_o,                    // ���豸1д��־

    // slave 2 interface
    output reg[`CPU_WIDTH-1:0] s2_addr_o,     // ���豸2����д��ַ
    output reg[`CPU_WIDTH-1:0] s2_data_o,         // ���豸2д����
    input wire[`CPU_WIDTH-1:0] s2_data_i,         // ���豸2��ȡ��������
    output reg s2_we_o,                    // ���豸2д��־

    // slave 3 interface
    output reg[`CPU_WIDTH-1:0] s3_addr_o,     // ���豸3����д��ַ
    output reg[`CPU_WIDTH-1:0] s3_data_o,         // ���豸3д����
    input wire[`CPU_WIDTH-1:0] s3_data_i,         // ���豸3��ȡ��������
    output reg s3_we_o,                    // ���豸3д��־

    // slave 4 interface
    output reg[`CPU_WIDTH-1:0] s4_addr_o,     // ���豸4����д��ַ
    output reg[`CPU_WIDTH-1:0] s4_data_o,         // ���豸4д����
    input wire[`CPU_WIDTH-1:0] s4_data_i,         // ���豸4��ȡ��������
    output reg s4_we_o,                    // ���豸4д��־

    // slave 5 interface
    output reg[`CPU_WIDTH-1:0] s5_addr_o,     // ���豸5����д��ַ
    output reg[`CPU_WIDTH-1:0] s5_data_o,         // ���豸5д����
    input wire[`CPU_WIDTH-1:0] s5_data_i,         // ���豸5��ȡ��������
    output reg s5_we_o,                    // ���豸5д��־

    output reg hold_flag_o                 // ��ͣ��ˮ�߱�־

    );


    // ���ʵ�ַ�����4λ����Ҫ���ʵ�����һ�����豸
    // ������֧��16�����豸
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


    // ���豸�����ź�
    assign req = {m3_req_i, m2_req_i, m1_req_i, m0_req_i};

    // �ٲ��߼�
    // �̶����ȼ��ٲû���
    // ���ȼ��ɸߵ��ͣ����豸3�����豸0�����豸2�����豸1
    always @ (*) begin
        if (req[3]) begin
            grant = grant3;
            hold_flag_o = 1'b1;
        end else if (req[0]) begin
            grant = grant0;
            hold_flag_o = 1'b1;
        end else if (req[2]) begin
            grant = grant2;
            hold_flag_o = 1'b1;
        end else begin
            grant = grant1;
            hold_flag_o = 1'b0;
        end
    end

    // �����ٲý����ѡ��(����)��Ӧ�Ĵ��豸
    always @ (*) begin
        m0_data_o = `CPU_WIDTH'b0;
        m1_data_o = `CPU_WIDTH'b0;
        m2_data_o = `CPU_WIDTH'b0;
        m3_data_o = `CPU_WIDTH'b0;

        s0_addr_o = `CPU_WIDTH'b0;
        s1_addr_o = `CPU_WIDTH'b0;
        s2_addr_o = `CPU_WIDTH'b0;
        s3_addr_o = `CPU_WIDTH'b0;
        s4_addr_o = `CPU_WIDTH'b0;
        s5_addr_o = `CPU_WIDTH'b0;
        s0_data_o = `CPU_WIDTH'b0;
        s1_data_o = `CPU_WIDTH'b0;
        s2_data_o = `CPU_WIDTH'b0;
        s3_data_o = `CPU_WIDTH'b0;
        s4_data_o = `CPU_WIDTH'b0;
        s5_data_o = `CPU_WIDTH'b0;
        s0_we_o = 1'b0;
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
                        m0_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m0_we_i;
                        s1_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s1_data_o = m0_data_i;
                        m0_data_o = s1_data_i;
                    end
                    slave_2: begin
                        s2_we_o = m0_we_i;
                        s2_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s2_data_o = m0_data_i;
                        m0_data_o = s2_data_i;
                    end
                    slave_3: begin
                        s3_we_o = m0_we_i;
                        s3_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s3_data_o = m0_data_i;
                        m0_data_o = s3_data_i;
                    end
                    slave_4: begin
                        s4_we_o = m0_we_i;
                        s4_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s4_data_o = m0_data_i;
                        m0_data_o = s4_data_i;
                    end
                    slave_5: begin
                        s5_we_o = m0_we_i;
                        s5_addr_o = {{4'h0}, {m0_addr_i[27:0]}};
                        s5_data_o = m0_data_i;
                        m0_data_o = s5_data_i;
                    end
                    default: begin

                    end
                endcase
            end
            grant1: begin
                case (m1_addr_i[31:28])
                    slave_0: begin
                        s0_we_o = m1_we_i;
                        s0_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s0_data_o = m1_data_i;
                        m1_data_o = s0_data_i;
                    end
                    slave_1: begin
                        s1_we_o = m1_we_i;
                        s1_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s1_data_o = m1_data_i;
                        m1_data_o = s1_data_i;
                    end
                    slave_2: begin
                        s2_we_o = m1_we_i;
                        s2_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s2_data_o = m1_data_i;
                        m1_data_o = s2_data_i;
                    end
                    slave_3: begin
                        s3_we_o = m1_we_i;
                        s3_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s3_data_o = m1_data_i;
                        m1_data_o = s3_data_i;
                    end
                    slave_4: begin
                        s4_we_o = m1_we_i;
                        s4_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s4_data_o = m1_data_i;
                        m1_data_o = s4_data_i;
                    end
                    slave_5: begin
                        s5_we_o = m1_we_i;
                        s5_addr_o = {{4'h0}, {m1_addr_i[27:0]}};
                        s5_data_o = m1_data_i;
                        m1_data_o = s5_data_i;
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
