 /*                                                                      
 Copyright 2019 Blue Liang, liangkangnan@163.com
                                                                         
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

`include "rooth_defines.v"

// ����ģ��
// ���̷�ʵ��32λ��������
// ÿ�γ�������������Ҫ33��ʱ�����ڲ������
module div(

    input wire                      clk,
    input wire                      rst_n,

    // from ex
    input wire[`CPU_WIDTH-1:0]      dividend_i,      // ������
    input wire[`CPU_WIDTH-1:0]      divisor_i,       // ����
    input wire                      start_i,                
    input wire[`FUNCT3_WIDTH-1:0]   op_i,            // ��������һ��ָ��

    // to ex
    output reg[`CPU_WIDTH-1:0]      result_o,        // �������
    output reg                      ready_o,         // ��������ź�
    output reg                      busy_o           // ���������ź�

    );

    // ״̬����
    localparam STATE_IDLE  = 4'b0001;
    localparam STATE_START = 4'b0010;
    localparam STATE_CALC  = 4'b0100;
    localparam STATE_END   = 4'b1000;

    reg[`CPU_WIDTH-1:0] dividend_r;
    reg[`CPU_WIDTH-1:0] divisor_r;
    reg[2:0] op_r;
    reg[3:0] state;
    reg[31:0] count;
    reg[`CPU_WIDTH-1:0] div_result;
    reg[`CPU_WIDTH-1:0] div_remain;
    reg[`CPU_WIDTH-1:0] minuend;
    reg invert_result;

    wire op_div = (op_r == `INST_DIV);
    wire op_divu = (op_r == `INST_DIVU);
    wire op_rem = (op_r == `INST_REM);
    wire op_remu = (op_r == `INST_REMU);

    wire[31:0] dividend_invert = (-dividend_r);
    wire[31:0] divisor_invert = (-divisor_r);
    wire minuend_ge_divisor = minuend >= divisor_r;
    wire[31:0] minuend_sub_res = minuend - divisor_r;
    wire[31:0] div_result_tmp = minuend_ge_divisor? ({div_result[30:0], 1'b1}): ({div_result[30:0], 1'b0});
    wire[31:0] minuend_tmp = minuend_ge_divisor? minuend_sub_res[30:0]: minuend[30:0];

    // ״̬��ʵ��
    always @ (posedge clk) begin
        if (rst_n == 1'b0) begin
            state <= STATE_IDLE;
            ready_o <= 1'b0;
            result_o <= `CPU_WIDTH'b0;
            div_result <= `CPU_WIDTH'b0;
            div_remain <= `CPU_WIDTH'b0;
            op_r <= 3'h0;
            dividend_r <= `CPU_WIDTH'b0;
            divisor_r <= `CPU_WIDTH'b0;
            minuend <= `CPU_WIDTH'b0;
            invert_result <= 1'b0;
            busy_o <= 1'b0;
            count <= `CPU_WIDTH'b0;
        end
        else begin
            case (state)
                STATE_IDLE: begin
                    if (start_i == 1'b1) begin
                        op_r <= op_i;
                        dividend_r <= dividend_i;
                        divisor_r <= divisor_i;
                        state <= STATE_START;
                        busy_o <= 1'b1;
                    end
                    else begin
                        op_r <= 3'h0;
                        dividend_r <= `CPU_WIDTH'b0;
                        divisor_r <= `CPU_WIDTH'b0;
                        ready_o <= 1'b0;
                        result_o <= `CPU_WIDTH'b0;
                        busy_o <= 1'b0;
                    end
                end

                STATE_START: begin
                    if (start_i == 1'b1) begin
                        // ����Ϊ0
                        if (divisor_r == `CPU_WIDTH'b0) begin
                            if (op_div | op_divu) begin
                                result_o <= 32'hffffffff;
                            end else begin
                                result_o <= dividend_r;
                            end
                            ready_o <= 1'b1;
                            state <= STATE_IDLE;
                            busy_o <= 1'b0;
                        // ������Ϊ0
                        end
                        else begin
                            busy_o <= 1'b1;
                            count <= 32'h40000000;
                            state <= STATE_CALC;
                            div_result <= `CPU_WIDTH'b0;
                            div_remain <= `CPU_WIDTH'b0;

                            // DIV��REM������ָ�����з���������ָ��
                            if (op_div | op_rem) begin
                                // ����������
                                if (dividend_r[31] == 1'b1) begin
                                    dividend_r <= dividend_invert;
                                    minuend <= dividend_invert[31];
                                end
                                else begin
                                    minuend <= dividend_r[31];
                                end
                                // ��������
                                if (divisor_r[31] == 1'b1) begin
                                    divisor_r <= divisor_invert;
                                end
                            end
                            else begin
                                minuend <= dividend_r[31];
                            end

                            // ����������Ƿ�Ҫ�Խ��ȡ����
                            if ((op_div && (dividend_r[31] ^ divisor_r[31] == 1'b1))
                                || (op_rem && (dividend_r[31] == 1'b1))) begin
                                invert_result <= 1'b1;
                            end
                            else begin
                                invert_result <= 1'b0;
                            end
                        end
                    end
                    else begin
                        state <= STATE_IDLE;
                        result_o <= `CPU_WIDTH'b0;
                        ready_o <= 1'b0;
                        busy_o <= 1'b0;
                    end
                end

                STATE_CALC: begin
                    if (start_i == 1'b1) begin
                        dividend_r <= {dividend_r[30:0], 1'b0};
                        div_result <= div_result_tmp;
                        count <= {1'b0, count[31:1]};
                        if (|count) begin
                            minuend <= {minuend_tmp[30:0], dividend_r[30]};
                        end
                        else begin
                            state <= STATE_END;
                            if (minuend_ge_divisor) begin
                                div_remain <= minuend_sub_res;
                            end else begin
                                div_remain <= minuend;
                            end
                        end
                    end
                    else begin
                        state <= STATE_IDLE;
                        result_o <= `CPU_WIDTH'b0;
                        ready_o <= 1'b0;
                        busy_o <= 1'b0;
                    end
                end

                STATE_END: begin
                    if (start_i == 1'b1) begin
                        ready_o <= 1'b1;
                        state <= STATE_IDLE;
                        busy_o <= 1'b0;
                        if (op_div | op_divu) begin
                            if (invert_result) begin
                                result_o <= (-div_result);
                            end
                            else begin
                                result_o <= div_result;
                            end
                        end
                        else begin
                            if (invert_result) begin
                                result_o <= (-div_remain);
                            end
                            else begin
                                result_o <= div_remain;
                            end
                        end
                    end
                    else begin
                        state <= STATE_IDLE;
                        result_o <= `CPU_WIDTH'b0;
                        ready_o <= 1'b0;
                        busy_o <= 1'b0;
                    end
                end

            endcase
        end
    end

endmodule
