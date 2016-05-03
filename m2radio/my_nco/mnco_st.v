//	Copyright (C) 1988-2012 Altera Corporation

//	Any megafunction design, and related net list (encrypted or decrypted),
//	support information, device programming or simulation file, and any other
//	associated documentation or information provided by Altera or a partner
//	under Altera's Megafunction Partnership Program may be used only to
//	program PLD devices (but not masked PLD devices) from Altera.  Any other
//	use of such megafunction design, net list, support information, device
//	programming or simulation file, or any other related documentation or
//	information is prohibited for any other purpose, including, but not
//	limited to modification, reverse engineering, de-compiling, or use with
//	any other silicon devices, unless such use is explicitly licensed under
//	a separate agreement with Altera or a megafunction partner.  Title to
//	the intellectual property, including patents, copyrights, trademarks,
//	trade secrets, or maskworks, embodied in any such megafunction design,
//	net list, support information, device programming or simulation file, or
//	any other related documentation or information provided by Altera or a
//	megafunction partner, remains with Altera, the megafunction partner, or
//	their respective licensors.  No other licenses, including any licenses
//	needed under any third party's intellectual property, are provided herein.


module mnco_st(clk, reset_n, clken, phi_inc_i, fsin_o, fcos_o, out_valid);

parameter mpr = 10;
parameter apr = 32;
parameter apri= 10;
parameter aprf= 32;
parameter aprp= 16;
parameter aprid=15;
parameter dpri= 5;
parameter cpr= 4;
parameter mval= 10;
parameter nstages = 21;
parameter X0 = 307;
parameter Z0 = 256;
parameter Z1 = 151;
parameter Z2 = 79;
parameter Z3 = 40;
parameter Z4 = 20;
parameter Z5 = 10;
parameter Z6 = 5;
parameter Z7 = 2;
parameter Z8 = 1;
parameter Z9 = 0;
parameter Z10 = 0;
parameter Z11 = 0;
parameter Z12 = 0;
parameter Z13 = 0;
parameter Z14 = 0;
parameter Z15 = 0;
parameter Z16 = 0;
parameter Z17 = 0;
parameter Z18 = 0;
parameter Z19 = 0;
parameter Z20 = 0;
parameter Z21 = 0;
parameter Z22 = 0;
parameter Z23 = 0;
parameter Z24 = 0;
parameter Z25 = 0;
parameter Z26 = 0;
parameter Z27 = 0;
parameter Z28 = 0;
parameter Z29 = 0;
parameter Z30 = 0;
parameter Z31 = 0;
parameter nc = 1;
parameter pl = nc;
parameter log2nc =0;
parameter outselinit = -1;
parameter paci0= 0;
parameter paci1= 0;
parameter paci2= 0;
parameter paci3= 0;
parameter paci4= 0;
parameter paci5= 0;
parameter paci6= 0;
parameter paci7= 0;

input clk; 
input reset_n; 
input clken; 
input [apr-1:0] phi_inc_i; 

output [mpr-1:0] fsin_o;
output [mpr-1:0] fcos_o;
output out_valid;
wire reset; 
assign reset = !reset_n;

wire [apr-1:0]  phi_inc_i_w;
wire [apr-1:0]  phi_acc_w;
wire [aprid-1:0] phi_acc_w_d;
wire [aprid-1:0] phi_acc_w_di;
wire [dpri-1:0] rval_w_d;
wire [dpri-1:0] rval_w;
wire [mpr-1:0] cordic_0x;
wire [mpr-1:0] cordic_0y;
wire [apri-1:0] cordic_0z;
wire [mpr-1:0] cordic_0x_w;
wire [mpr-1:0] cordic_0y_w;
wire [apri-1:0] cordic_0z_w;
wire [mpr-1:0] cordic_1x;
wire [mpr-1:0] cordic_1y;
wire [apri-1:0] cordic_1z;
wire [mpr-1:0] cordic_1x_w;
wire [mpr-1:0] cordic_1y_w;
wire [apri-1:0] cordic_1z_w;
wire [mpr-1:0] cordic_2x;
wire [mpr-1:0] cordic_2y;
wire [apri-1:0] cordic_2z;
wire [mpr-1:0] cordic_2x_w;
wire [mpr-1:0] cordic_2y_w;
wire [apri-1:0] cordic_2z_w;
wire [mpr-1:0] cordic_3x;
wire [mpr-1:0] cordic_3y;
wire [apri-1:0] cordic_3z;
wire [mpr-1:0] cordic_3x_w;
wire [mpr-1:0] cordic_3y_w;
wire [apri-1:0] cordic_3z_w;
wire [mpr-1:0] cordic_4x;
wire [mpr-1:0] cordic_4y;
wire [apri-1:0] cordic_4z;
wire [mpr-1:0] cordic_4x_w;
wire [mpr-1:0] cordic_4y_w;
wire [apri-1:0] cordic_4z_w;
wire [mpr-1:0] cordic_5x;
wire [mpr-1:0] cordic_5y;
wire [apri-1:0] cordic_5z;
wire [mpr-1:0] cordic_5x_w;
wire [mpr-1:0] cordic_5y_w;
wire [apri-1:0] cordic_5z_w;
wire [mpr-1:0] cordic_6x;
wire [mpr-1:0] cordic_6y;
wire [apri-1:0] cordic_6z;
wire [mpr-1:0] cordic_6x_w;
wire [mpr-1:0] cordic_6y_w;
wire [apri-1:0] cordic_6z_w;
wire [mpr-1:0] cordic_7x;
wire [mpr-1:0] cordic_7y;
wire [apri-1:0] cordic_7z;
wire [mpr-1:0] cordic_7x_w;
wire [mpr-1:0] cordic_7y_w;
wire [apri-1:0] cordic_7z_w;
wire [mpr-1:0] cordic_8x;
wire [mpr-1:0] cordic_8y;
wire [apri-1:0] cordic_8z;
wire [mpr-1:0] cordic_8x_w;
wire [mpr-1:0] cordic_8y_w;
wire [apri-1:0] cordic_8z_w;
wire [mpr-1:0] cordic_9x;
wire [mpr-1:0] cordic_9y;
wire [apri-1:0] cordic_9z;
wire [mpr-1:0] cordic_9x_w;
wire [mpr-1:0] cordic_9y_w;
wire [apri-1:0] cordic_9z_w;
wire [mpr-1:0] cordic_10x_w;
wire [mpr-1:0] cordic_10y_w;
wire [mpr-1:0] cordic_x_res;
wire [mpr-1:0] cordic_y_res;
wire [mpr-1:0] cordic_x_res_d;
wire [mpr-1:0] cordic_y_res_d;
wire [mpr-1:0] cordic_x_res_2c;
wire [mpr-1:0] cordic_y_res_2c;
wire [1:0] qd;
wire [1:0] curqd;
wire [mpr-1:0] sin_o_w;
wire [mpr-1:0] cos_o_w;
wire [mpr-1:0] fsin_o_w;	
wire [mpr-1:0] fcos_o_w;	





assign cordic_1x = cordic_1x_w;
assign cordic_1y = cordic_1y_w;
assign cordic_1z = cordic_1z_w;
assign cordic_2x = cordic_2x_w;
assign cordic_2y = cordic_2y_w;
assign cordic_2z = cordic_2z_w;
assign cordic_3x = cordic_3x_w;
assign cordic_3y = cordic_3y_w;
assign cordic_3z = cordic_3z_w;
assign cordic_4x = cordic_4x_w;
assign cordic_4y = cordic_4y_w;
assign cordic_4z = cordic_4z_w;
assign cordic_5x = cordic_5x_w;
assign cordic_5y = cordic_5y_w;
assign cordic_5z = cordic_5z_w;
assign cordic_6x = cordic_6x_w;
assign cordic_6y = cordic_6y_w;
assign cordic_6z = cordic_6z_w;
assign cordic_7x = cordic_7x_w;
assign cordic_7y = cordic_7y_w;
assign cordic_7z = cordic_7z_w;
assign cordic_8x = cordic_8x_w;
assign cordic_8y = cordic_8y_w;
assign cordic_8z = cordic_8z_w;
assign cordic_9x = cordic_9x_w;
assign cordic_9y = cordic_9y_w;
assign cordic_9z = cordic_9z_w;
assign cordic_x_res = cordic_10x_w;
assign cordic_y_res = cordic_10y_w;

cord_init ci(.clk(clk),
                .reset(reset), 
                .clken(clken), 
             .phi_acc_w(phi_acc_w_d),
             .corx(cordic_0x),
             .cory(cordic_0y),
             .corz(cordic_0z)
);
defparam ci.apr=aprid;
defparam ci.apri=apri;
defparam ci.mpr=mpr;
defparam ci.X0=X0;

cord_fs cfs(.clk(clk),
            .reset(reset),
            .clken(clken), 
            .cor0x(cordic_0x),
            .cor0y(cordic_0y),
            .cor0zmsb(cordic_0z[apri-1]),
            .cor1x(cordic_1x_w),
            .cor1y(cordic_1y_w)
           );
defparam cfs.mpr=mpr;



assign curqd = phi_acc_w_d[aprid-1:aprid-2];

cord_seg_sel css(.clk(clk),
                 .reset(reset),
                 .clken(clken), 
                 .cur_seg(curqd),
                 .seg_rot(qd)
                 );
defparam css.nstages = nstages;

assign phi_inc_i_w = phi_inc_i;

asj_altqmcpipe ux000 (.clk(clk), 
             .reset(reset), 
             .clken(clken), 
             .phi_inc_int(phi_inc_i_w), 
             .phi_acc_reg(phi_acc_w)
             );

defparam ux000.apr = apr ;
defparam ux000.lat = 1 ;
defparam ux000.nc = pl ;
defparam ux000.paci0 = paci0 ;
defparam ux000.paci1 = paci1 ;
defparam ux000.paci2 = paci2 ;
defparam ux000.paci3 = paci3 ;
defparam ux000.paci4 = paci4 ;
defparam ux000.paci5 = paci5 ;
defparam ux000.paci6 = paci6 ;
defparam ux000.paci7 = paci7 ;

asj_dxx_g ux001(.clk(clk), 
            .clken(clken), 
              .reset(reset), 
              .dxxrv(rval_w_d)
              );
defparam ux001.dpri = dpri;
assign rval_w = rval_w_d;
asj_dxx ux002(.clk(clk), 
            .clken(clken), 
	         .reset(reset), 
            .dxxpdi(phi_acc_w_di), 
            .rval(rval_w), 
            .dxxpdo(phi_acc_w_d) 
           );

defparam ux002.aprid = aprid;
defparam ux002.dpri = dpri;

asj_nco_apr_dxx ux0219(.pcc_w(phi_acc_w),
                         .pcc_d(phi_acc_w_di)
                         ); 
defparam ux0219.apr = apr;    
defparam ux0219.aprid = aprid;



cordic_zxor_1p_lpm u3(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_0z),
                                          .zdata(cordic_0z[apri-1]), .result(cordic_1z_w));
defparam u3.mpr = apri;
defparam u3.Zn = Z0;
defparam u3.pipe = 1;
cordic_sxor_1p_lpm u4(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_1x), .datab(cordic_1y),
                                            .zdata(cordic_1z[apri-1]), .result(cordic_2x_w));
defparam u4.shiftby = 1;
defparam u4.mpr = mpr;
defparam u4.pipe = 1;
cordic_axor_1p_lpm u5(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_1y), .datab(cordic_1x),
                                            .zdata(cordic_1z[apri-1]), .result(cordic_2y_w));
defparam u5.shiftby = 1;
defparam u5.mpr = mpr;
defparam u5.pipe = 1;
cordic_zxor_1p_lpm u6(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_1z),
                                          .zdata(cordic_1z[apri-1]), .result(cordic_2z_w));
defparam u6.mpr = apri;
defparam u6.Zn = Z1;
defparam u6.pipe = 1;
cordic_sxor_1p_lpm u7(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_2x), .datab(cordic_2y),
                                            .zdata(cordic_2z[apri-1]), .result(cordic_3x_w));
defparam u7.shiftby = 2;
defparam u7.mpr = mpr;
defparam u7.pipe = 1;
cordic_axor_1p_lpm u8(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_2y), .datab(cordic_2x),
                                            .zdata(cordic_2z[apri-1]), .result(cordic_3y_w));
defparam u8.shiftby = 2;
defparam u8.mpr = mpr;
defparam u8.pipe = 1;
cordic_zxor_1p_lpm u9(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_2z),
                                          .zdata(cordic_2z[apri-1]), .result(cordic_3z_w));
defparam u9.mpr = apri;
defparam u9.Zn = Z2;
defparam u9.pipe = 1;
cordic_sxor_1p_lpm u10(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_3x), .datab(cordic_3y),
                                            .zdata(cordic_3z[apri-1]), .result(cordic_4x_w));
defparam u10.shiftby = 3;
defparam u10.mpr = mpr;
defparam u10.pipe = 1;
cordic_axor_1p_lpm u11(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_3y), .datab(cordic_3x),
                                            .zdata(cordic_3z[apri-1]), .result(cordic_4y_w));
defparam u11.shiftby = 3;
defparam u11.mpr = mpr;
defparam u11.pipe = 1;
cordic_zxor_1p_lpm u12(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_3z),
                                          .zdata(cordic_3z[apri-1]), .result(cordic_4z_w));
defparam u12.mpr = apri;
defparam u12.Zn = Z3;
defparam u12.pipe = 1;
cordic_sxor_1p_lpm u13(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_4x), .datab(cordic_4y),
                                            .zdata(cordic_4z[apri-1]), .result(cordic_5x_w));
defparam u13.shiftby = 4;
defparam u13.mpr = mpr;
defparam u13.pipe = 1;
cordic_axor_1p_lpm u14(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_4y), .datab(cordic_4x),
                                            .zdata(cordic_4z[apri-1]), .result(cordic_5y_w));
defparam u14.shiftby = 4;
defparam u14.mpr = mpr;
defparam u14.pipe = 1;
cordic_zxor_1p_lpm u15(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_4z),
                                          .zdata(cordic_4z[apri-1]), .result(cordic_5z_w));
defparam u15.mpr = apri;
defparam u15.Zn = Z4;
defparam u15.pipe = 1;
cordic_sxor_1p_lpm u16(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_5x), .datab(cordic_5y),
                                            .zdata(cordic_5z[apri-1]), .result(cordic_6x_w));
defparam u16.shiftby = 5;
defparam u16.mpr = mpr;
defparam u16.pipe = 1;
cordic_axor_1p_lpm u17(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_5y), .datab(cordic_5x),
                                            .zdata(cordic_5z[apri-1]), .result(cordic_6y_w));
defparam u17.shiftby = 5;
defparam u17.mpr = mpr;
defparam u17.pipe = 1;
cordic_zxor_1p_lpm u18(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_5z),
                                          .zdata(cordic_5z[apri-1]), .result(cordic_6z_w));
defparam u18.mpr = apri;
defparam u18.Zn = Z5;
defparam u18.pipe = 1;
cordic_sxor_1p_lpm u19(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_6x), .datab(cordic_6y),
                                            .zdata(cordic_6z[apri-1]), .result(cordic_7x_w));
defparam u19.shiftby = 6;
defparam u19.mpr = mpr;
defparam u19.pipe = 1;
cordic_axor_1p_lpm u20(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_6y), .datab(cordic_6x),
                                            .zdata(cordic_6z[apri-1]), .result(cordic_7y_w));
defparam u20.shiftby = 6;
defparam u20.mpr = mpr;
defparam u20.pipe = 1;
cordic_zxor_1p_lpm u21(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_6z),
                                          .zdata(cordic_6z[apri-1]), .result(cordic_7z_w));
defparam u21.mpr = apri;
defparam u21.Zn = Z6;
defparam u21.pipe = 1;
cordic_sxor_1p_lpm u22(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_7x), .datab(cordic_7y),
                                            .zdata(cordic_7z[apri-1]), .result(cordic_8x_w));
defparam u22.shiftby = 7;
defparam u22.mpr = mpr;
defparam u22.pipe = 1;
cordic_axor_1p_lpm u23(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_7y), .datab(cordic_7x),
                                            .zdata(cordic_7z[apri-1]), .result(cordic_8y_w));
defparam u23.shiftby = 7;
defparam u23.mpr = mpr;
defparam u23.pipe = 1;
cordic_zxor_1p_lpm u24(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_7z),
                                          .zdata(cordic_7z[apri-1]), .result(cordic_8z_w));
defparam u24.mpr = apri;
defparam u24.Zn = Z7;
defparam u24.pipe = 1;
cordic_sxor_1p_lpm u25(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_8x), .datab(cordic_8y),
                                            .zdata(cordic_8z[apri-1]), .result(cordic_9x_w));
defparam u25.shiftby = 8;
defparam u25.mpr = mpr;
defparam u25.pipe = 1;
cordic_axor_1p_lpm u26(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_8y), .datab(cordic_8x),
                                            .zdata(cordic_8z[apri-1]), .result(cordic_9y_w));
defparam u26.shiftby = 8;
defparam u26.mpr = mpr;
defparam u26.pipe = 1;
cordic_zxor_1p_lpm u27(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_8z),
                                          .zdata(cordic_8z[apri-1]), .result(cordic_9z_w));
defparam u27.mpr = apri;
defparam u27.Zn = Z8;
defparam u27.pipe = 1;
cordic_sxor_1p_lpm u28(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_9x), .datab(cordic_9y),
                                            .zdata(cordic_9z[apri-1]), .result(cordic_10x_w));
defparam u28.shiftby = 9;
defparam u28.mpr = mpr;
defparam u28.pipe = 1;
cordic_axor_1p_lpm u29(.clk(clk), .reset(reset), .clken(clken), .dataa(cordic_9y), .datab(cordic_9x),
                                            .zdata(cordic_9z[apri-1]), .result(cordic_10y_w));
defparam u29.shiftby = 9;
defparam u29.mpr = mpr;
defparam u29.pipe = 1;

cord_2c cordinv(.clk(clk),
                .reset(reset), 
                .clken(clken), 
                .cordic_x_res(cordic_x_res),
                .cordic_y_res(cordic_y_res),
                .cordic_x_res_d(cordic_x_res_d),
                .cordic_y_res_d(cordic_y_res_d),
                .cordic_x_res_2c(cordic_x_res_2c),
                .cordic_y_res_2c(cordic_y_res_2c)
               );
defparam cordinv.mpr = mpr;

asj_crd     ux005(.clk(clk),
                  .reset(reset),
                  .clken(clken),
                  .qd(qd),
                  .cordic_x_res_d(cordic_x_res_d),
                  .cordic_y_res_d(cordic_y_res_d),
                  .cordic_x_res_2c(cordic_x_res_2c),
                  .cordic_y_res_2c(cordic_y_res_2c),
                  .sin_o(sin_o_w),
                  .cos_o(cos_o_w)
                  );
defparam ux005.mpr = mpr;

dop_reg dop(.clk(clk),
            .reset(reset),
            .clken(clken), 
            .sin_i(sin_o_w),
            .cos_i(cos_o_w),
            .sin_o(fsin_o_w),
            .cos_o(fcos_o_w)
           );
defparam dop.mpr=mpr;
assign fsin_o = fsin_o_w;
assign fcos_o = fcos_o_w;


asj_nco_isdr ux710isdr(.clk(clk),                              
                    .reset(reset),                          
                    .clken(clken),                  
                    .data_ready(out_valid)          
                    );                                      
defparam ux710isdr.ctc=26;                                       
defparam ux710isdr.cpr=5;                                   
                                                            

endmodule