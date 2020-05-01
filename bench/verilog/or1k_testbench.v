////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _               //
//                                           / _(_)    | |   | |              //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
//                  | |                                                       //
//                  |_|                                                       //
//                                                                            //
//                                                                            //
//              MPSoC-OR1K CPU                                                //
//              Processing Unit                                               //
//              Wishbone Bus Interface                                        //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

/* Copyright (c) 2018-2019 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =============================================================================
 * Author(s):
 *   Francisco Javier Reina Campo <frareicam@gmail.com>
 */

module or1k_testbench;

  localparam MEM_SIZE = 32'h02000000; //Set default memory size to 32MB

  vlog_tb_utils vlog_tb_utils0();

  ////////////////////////////////////////////////////////////////////////
  //
  // JTAG VPI interface
  //
  ////////////////////////////////////////////////////////////////////////

  wire tms;
  wire tck;
  wire tdi;
  wire tdo;

  reg enable_jtag_vpi;
  initial enable_jtag_vpi = $test$plusargs("enable_jtag_vpi");

  jtag_vpi jtag_vpi0 (
    .tms       (tms),
    .tck       (tck),
    .tdi       (tdi),
    .tdo       (tdo),
    .enable    (enable_jtag_vpi),
    .init_done (or1k_testbench.dut.wb_rst)
  );

  ////////////////////////////////////////////////////////////////////////
  //
  // ELF program loading
  //
  ////////////////////////////////////////////////////////////////////////
  integer mem_words;
  integer i;

  reg [  31:0] mem_word;
  reg [1023:0] elf_file;

  initial begin
    if ($test$plusargs("clear_ram")) begin
      $display("Clearing RAM");
      for(i=0; i < MEM_SIZE/4; i = i+1)
        or1k_testbench.dut.wb_bfm_memory0.ram0.mem[i] = 32'h00000000;
    end
    if($value$plusargs("elf_load=%s", elf_file)) begin
      $elf_load_file(elf_file);

      mem_words = $elf_get_size/4;
      $display("Loading %d words", mem_words);
      for(i=0; i < mem_words; i = i+1)
        or1k_testbench.dut.wb_bfm_memory0.ram0.mem[i] = $elf_read_32(i*4);
    end else
      $display("No ELF file specified");
  end

  ////////////////////////////////////////////////////////////////////////
  //
  // Clock and reset generation
  //
  ////////////////////////////////////////////////////////////////////////
  reg syst_clk = 1;
  reg syst_rst = 1;

  always #5 syst_clk <= ~syst_clk;
  initial #100 syst_rst <= 0;

  ////////////////////////////////////////////////////////////////////////
  //
  // mor1kx monitor
  //
  ////////////////////////////////////////////////////////////////////////
  mor1kx_monitor #(
    .LOG_DIR(".")
  )
  i_monitor();

  ////////////////////////////////////////////////////////////////////////
  //
  // DUT
  //
  ////////////////////////////////////////////////////////////////////////
  or1k_pu #(
    .MEM_SIZE (MEM_SIZE)
  )
  dut (
    .wb_clk_i (syst_clk),
    .wb_rst_i (syst_rst),

    .tms_pad_i (tms),
    .tck_pad_i (tck),
    .tdi_pad_i (tdi),
    .tdo_pad_o (tdo)
  );
endmodule
