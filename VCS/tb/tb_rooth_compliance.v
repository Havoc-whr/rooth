// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2023 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : tb_rooth_compliance.v
// Author        : whr
// Created On    : 2023-01-23 11:12:33
// Last Modified : 2023-01-23 11:30:29
// ---------------------------------------------------------------------------------
// Description   :
// 
//
//
// -FHDR----------------------------------------------------------------------------
`include "/home/ICer/ic_prjs/rooth/VCS/rtl/soc/rooth_defines.v"

// testbench module
module tinyriscv_soc_tb;

    reg clk;
    reg rst_n;

wire [15:0] gpio;
wire uart_tx_pin;
wire uart_rx_pin;

wire spi_miso;
wire spi_mosi;
wire spi_ss;
wire spi_clk;
wire jtag_TCK;
wire jtag_TMS;
wire jtag_TDI;
wire jtag_TDO;
wire halted_ind;

    reg [50*8-1:0]        inst_name;

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


    wire[31:0] ex_end_flag = u_rooth_soc_0.u_data_mem_0. ram_file[4];
    wire[31:0] begin_signature = u_rooth_soc_0.u_data_mem_0. ram_file[2];
    wire[31:0] end_signature = u_rooth_soc_0.u_data_mem_0. ram_file[3];

    integer r;
    integer fd;

    always #(`SIM_PERIOD/2) clk = ~clk;

    initial begin
        inst_name = "../verification/inst.data";
        $readmemh ("../tb/SETREG", u_rooth_soc_0.u_rooth_0. u_regs_file_0. register);
        $readmemh (inst_name, u_rooth_soc_0.u_inst_mem_0. inst_mem_f);
        clk = 0;
        rst_n = 1'b0;
        $display("test running...");
        #40
        rst_n = 1'b1;
        #200

        wait(ex_end_flag == 32'h1);  // wait sim end

        fd = $fopen("../verification/result.output");
        for (r = begin_signature; r < end_signature; r = r + 4) begin
            $fdisplay(fd, "%x", u_rooth_soc_0.u_inst_mem_0. inst_mem_f[r[31:2]]);
        end
        $fclose(fd);
        $finish;
    end

    // sim timeout
    initial begin
        #300000
        $display("Time Out");
        $finish;
    end

    // generate wave file, used by verdi
    initial begin
        $fsdbDumpfile("tb.fsdb");       
        $fsdbDumpvars;
    end

rooth_soc u_rooth_soc_0(
    .clk            (clk),
    .rst_n          (rst_n),
    .gpio           (gpio),
    .uart_tx_pin    (uart_tx_pin),
    .uart_rx_pin    (uart_rx_pin),
    .spi_miso       (spi_miso),
    .spi_mosi       (spi_mosi),
    .spi_ss         (spi_ss),
    .spi_clk        (spi_clk),
    .jtag_TCK       (jtag_TCK),
    .jtag_TMS       (jtag_TMS),
    .jtag_TDI       (jtag_TDI),
    .jtag_TDO       (jtag_TDO),
    .halted_ind     (halted_ind)
);

endmodule
