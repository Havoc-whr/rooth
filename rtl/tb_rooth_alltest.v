// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : tb_rooth_alltest.v
// Author        : whr
// Created On    : 2022-06-29 20:08
// Last Modified : 2023-01-14 21:42
// ---------------------------------------------------------------------------------
// Description   : 
// RISC-V RV32I指令集测试
//
// -FHDR----------------------------------------------------------------------------
`timescale 1ns / 1ps
`include "../rtl/rooth_defines.v"
`include "../rtl/rooth_soc.v"

module tb_rooth_alltest ();

reg                  clk;
reg                  rst_n; 

reg [20*8-1:0]        inst_name;

wire [`CPU_WIDTH-1:0] zero_x0  = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[0];
wire [`CPU_WIDTH-1:0] ra_x1    = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[1];
wire [`CPU_WIDTH-1:0] sp_x2    = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[2];
wire [`CPU_WIDTH-1:0] gp_x3    = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[3];
wire [`CPU_WIDTH-1:0] tp_x4    = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[4];
wire [`CPU_WIDTH-1:0] t0_x5    = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[5];
wire [`CPU_WIDTH-1:0] t1_x6    = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[6];
wire [`CPU_WIDTH-1:0] t2_x7    = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[7];
wire [`CPU_WIDTH-1:0] s0_fp_x8 = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[8];
wire [`CPU_WIDTH-1:0] s1_x9    = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[9];
wire [`CPU_WIDTH-1:0] a0_x10   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[10];
wire [`CPU_WIDTH-1:0] a1_x11   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[11];
wire [`CPU_WIDTH-1:0] a2_x12   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[12];
wire [`CPU_WIDTH-1:0] a3_x13   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[13];
wire [`CPU_WIDTH-1:0] a4_x14   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[14];
wire [`CPU_WIDTH-1:0] a5_x15   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[15];
wire [`CPU_WIDTH-1:0] a6_x16   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[16];
wire [`CPU_WIDTH-1:0] a7_x17   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[17];
wire [`CPU_WIDTH-1:0] s2_x18   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[18];
wire [`CPU_WIDTH-1:0] s3_x19   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[19];
wire [`CPU_WIDTH-1:0] s4_x20   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[20];
wire [`CPU_WIDTH-1:0] s5_x21   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[21];
wire [`CPU_WIDTH-1:0] s6_x22   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[22];
wire [`CPU_WIDTH-1:0] s7_x23   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[23];
wire [`CPU_WIDTH-1:0] s8_x24   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[24];
wire [`CPU_WIDTH-1:0] s9_x25   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[25];
wire [`CPU_WIDTH-1:0] s10_x26  = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[26];
wire [`CPU_WIDTH-1:0] s11_x27  = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[27];
wire [`CPU_WIDTH-1:0] t3_x28   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[28];
wire [`CPU_WIDTH-1:0] t4_x29   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[29];
wire [`CPU_WIDTH-1:0] t5_x30   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[30];
wire [`CPU_WIDTH-1:0] t6_x31   = u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[31];

initial begin
    inst_name = "../tb/ADD";
    inst_test(inst_name);
    inst_name = "../tb/SUB";
    inst_test(inst_name);
    inst_name = "../tb/XOR";
    inst_test(inst_name);
    inst_name = "../tb/OR";
    inst_test(inst_name);
    inst_name = "../tb/AND";
    inst_test(inst_name);
    inst_name = "../tb/SLL";
    inst_test(inst_name);
    inst_name = "../tb/SRL";
    inst_test(inst_name);
    inst_name = "../tb/SRA";
    inst_test(inst_name);
    inst_name = "../tb/SLT";
    inst_test(inst_name);
    inst_name = "../tb/SLTU";
    inst_test(inst_name);
    inst_name = "../tb/XORI";
    inst_test(inst_name);
    inst_name = "../tb/ORI";
    inst_test(inst_name);
    inst_name = "../tb/ANDI";
    inst_test(inst_name);
    inst_name = "../tb/SLLI";
    inst_test(inst_name);
    inst_name = "../tb/SRLI";
    inst_test(inst_name);
    inst_name = "../tb/SRAI";
    inst_test(inst_name);
    inst_name = "../tb/SLTI";
    inst_test(inst_name);
    inst_name = "../tb/SLTIU";
    inst_test(inst_name);
    inst_name = "../tb/BEQ";
    inst_test(inst_name);
    inst_name = "../tb/BNE";
    inst_test(inst_name);
    inst_name = "../tb/BLT";
    inst_test(inst_name);
    inst_name = "../tb/BGE";
    inst_test(inst_name);
    inst_name = "../tb/BLTU";
    inst_test(inst_name);
    inst_name = "../tb/BGEU";
    inst_test(inst_name);
    inst_name = "../tb/JAL";
    inst_test(inst_name);
    inst_name = "../tb/JALR";
    inst_test(inst_name);
    inst_name = "../tb/LUI";
    inst_test(inst_name);
    inst_name = "../tb/AUIPC";
    inst_test(inst_name);
    inst_name = "../tb/LB";
    inst_test(inst_name);
    inst_name = "../tb/LH";
    inst_test(inst_name);
    inst_name = "../tb/LW";
    inst_test(inst_name);
    inst_name = "../tb/LBU";
    inst_test(inst_name);
    inst_name = "../tb/LHU";
    inst_test(inst_name);
    inst_name = "../tb/MUL";
    inst_test(inst_name);
    inst_name = "../tb/MULH";
    inst_test(inst_name);
    inst_name = "../tb/MULHU";
    inst_test(inst_name);
    inst_name = "../tb/MULHSU";
    inst_test(inst_name);
    inst_name = "../tb/DIV";
    inst_test(inst_name);
    inst_name = "../tb/DIVU";
    inst_test(inst_name);
    inst_name = "../tb/REM";
    inst_test(inst_name);
    inst_name = "../tb/REMU";
    inst_test(inst_name);
    inst_name = "../tb/FENCE_I";
    inst_test(inst_name);
    inst_name = "../tb/SB";
    inst_test(inst_name);
    inst_name = "../tb/SH";
    inst_test(inst_name);
    inst_name = "../tb/SW";
    inst_test(inst_name);
    inst_name = "../tb/CTEST";
    inst_test(inst_name);
    #(`SIM_PERIOD * 50);
    $display("~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~");
    $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~");
    $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~");
    $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~");
    $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~");
    $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~");
    $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    $finish;
end

initial begin
    #(`SIM_PERIOD * 50000);
    $display("Time Out");
    $finish;
end

always #(`SIM_PERIOD/2) clk = ~clk;

task reset;                // reset 1 clock
    begin
        rst_n = 0; 
        #(`SIM_PERIOD * 1);
        rst_n = 1;
    end
endtask

task inst_load;
    input [20*8-1:0] inst_name;
    begin
        #(`SIM_PERIOD/2);
        clk       = 1'b0;
        rst_n     = 1'b0;
		$readmemh ("../tb/SETREG", u_rooth_soc_0.u_rooth_0. u_regs_file_0. register);
        $readmemh ("../tb/SETRAM", u_rooth_soc_0.u_data_mem_0. ram_file);
        $readmemh (inst_name, u_rooth_soc_0.u_inst_mem_0. inst_mem_f);
    end
endtask

task inst_test;
    integer r;
    input [20*8-1:0] inst_name;
    begin
    inst_load(inst_name);
    #(`SIM_PERIOD * 1);
    rst_n = 1'b1;
    wait(s10_x26 == 32'b1)   // when x26 == 1 sim will be stop
        #(`SIM_PERIOD * 1 + 1)
        if (s11_x27 == 32'b1) begin
            $display("~~~~~~~~~~~~~~~~~~~ %s PASS ~~~~~~~~~~~~~~~~~~~",inst_name);
            #(`SIM_PERIOD * 1);
        end 
        else begin
            $display("~~~~~~~~~~~~~~~~~~~ %s FAIL ~~~~~~~~~~~~~~~~~~~~",inst_name);
            $display("fail testnum = %2d", gp_x3);
            #(`SIM_PERIOD * 1);
            for (r = 0; r < 32; r = r + 1)
                $display("x%2d = 0x%x", r, u_rooth_soc_0.u_rooth_0. u_regs_file_0. register[r]);
            $finish;
        end
    end
endtask

rooth_soc u_rooth_soc_0(
    .clk                            ( clk                           ),
    .rst_n                          ( rst_n                         )
);

// iverilog 
initial begin
    $dumpfile("sim_out.vcd");
    $dumpvars;
end

endmodule
