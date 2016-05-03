// ================================================================================
// Legal Notice: Copyright (C) 1991-2008 Altera Corporation
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.
// ================================================================================
//

`timescale 1ns / 1ps


  module mcic_tb;

// inputs
  reg clk;    
  reg reset_n;
  wire clken;
  reg[15:0] in_data;
  wire[15:0] out_data;
  wire[1:0] in_error;
  wire[1:0] out_error;
  reg in_valid;
  wire out_ready;
  wire in_ready;
  wire out_valid;
  reg start;
  reg end_test;
  integer data_in_int,data_file_in,data_file_out;           
  integer data_out_int;


  parameter              MAXVAL_c = 32768;
  parameter              OFFSET_c = 65535;

   initial
   begin
      data_file_in = $fopen("mcic_tb_input.txt","r");
      data_file_out = $fopen("mcic_tb_output.txt");
     
      ///////////////////////////////////////////////////////////////////////////////////////////////
      // Reset Generation
      #0 clk = 1'b0;
      #0 reset_n = 1'b0;
      #92 reset_n = 1'b1;
   end

   ///////////////////////////////////////////////////////////////////////////////////////////////
   // Clock Generation                                                                         
   ///////////////////////////////////////////////////////////////////////////////////////////////
   always
   begin
      if (end_test == 1'b1) 
      begin
         clk = 1'b0;
         $fclose(data_file_in);
         $fclose(data_file_out);
         $finish;     //stop
      end
      else
      begin
         #5 clk = 1'b1;
         #5 clk = 1'b0;
      end
   end


  // clock enable
  // always enabled
  assign clken = 1'b1;

  // for example purposes, the ready wire is always asserted.
  assign out_ready = 1'b1;

  // no input error
  assign in_error = 2'b0;

  // start valid for first cycle to indicate that the file reading should start.
  always @ (posedge clk)
  begin
    if (reset_n == 1'b0)
       start <= 1'b1;
     else
       begin
         if (in_valid == 1'b1 & in_ready == 1'b1)
           start <= 1'b0;
       end
   end


   //////////////////////////////////////////////////////////////////////////////////////////////
   // Read input data from files                                                                  
   //////////////////////////////////////////////////////////////////////////////////////////////
   integer c_x;

   always @ (posedge clk)
   begin
      if (reset_n == 1'b0)
      begin
         in_data  <= 16'b0;
         in_valid <= 1'b0;
         end_test <= 1'b0;
      end
      else
      begin
         if (!$feof(data_file_in))
         begin
            if ((in_valid == 1'b1 & in_ready == 1'b1) ||
               (start == 1'b1 & !(in_valid == 1'b1 & in_ready == 1'b0)))
            begin
               c_x = $fscanf(data_file_in,"%d",data_in_int);
               in_data  <= data_in_int;
               in_valid <= 1'b1;
            end
         end
         else
         begin
            if (end_test == 1'b0)
            begin
               if (in_valid == 1'b1 & in_ready == 1'b1)
               begin
                  end_test <= 1'b1;
                  in_valid <= 1'b0;
                  in_data  <= 16'b0;
               end
               else
               begin
                  in_valid <= 1'b1;
                  in_data  <= data_in_int;
               end
            end
         end
      end
   end

   ////////////////////////////////////////////////////////////////////////////////////////////
   // Write data output to Files                                               
   ////////////////////////////////////////////////////////////////////////////////////////////
   always @ (posedge clk)
   begin
      if (reset_n == 1'b1 & out_valid == 1'b1 & out_ready == 1'b1)
      begin
         data_out_int = out_data;
         $fdisplay(data_file_out, "%d", (data_out_int < MAXVAL_c) ? data_out_int : data_out_int - OFFSET_c - 1);
      end
   end

  ////////////////////////////////////////////////////////////////////////////////////////////
  // CIC Module Instantiation                                                               
  ////////////////////////////////////////////////////////////////////////////////////////////
  mcic mcic_inst (
      .clk(clk),
      .clken(clken),
      .reset_n(reset_n),
      .in_ready(in_ready),
      .in_valid(in_valid),
      .in_data(in_data),
      .out_data(out_data),
      .in_error(in_error),
      .out_error(out_error),
      .out_ready(out_ready),
      .out_valid(out_valid)
      );


endmodule
