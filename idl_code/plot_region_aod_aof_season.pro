
pro plot_region_aod_aof_season

  warm_tau   =[0.02,  0.02, 0.02, 0.02, 0.02, 0.02,0.02, 0.02, 0.02,  0.02]
  warm_tauerr=[0.01,  0.01, 0.01, 0.01, 0.01, 0.01,0.01, 0.01, 0.01,  0.01]
  cold_tau   =[0.03,  0.03, 0.03, 0.03, 0.03, 0.03,0.03, 0.03, 0.03,  0.03]
  cold_tauerr=[0.01,  0.01, 0.01, 0.01, 0.01, 0.01,0.01, 0.01, 0.01,  0.01]
  warm_fre   =[  10,    10,   10,   10,   10,   10,  10,   10,   10,    10]
  cold_fre   =[  20,    20,   20,   20,   20,   20,  20,   20,   20,    20]
  region_ind =[    1,    2,    3,    4,    5,    6,   7,     8,    9,   10]
  region_name=['','GLO','EAS','WUS','EUS','IND','EUR','SAF','MIN','CAF','AMZ',''] 
  region_name1=['','','','','','','','','','','',''] 

  warm_aeroonly_tau   =[0.143,0.318,0.087,0.144,0.528,0.151,0.302,0.112,0.300,0.195]
  warm_aeroonly_tauerr=[0.049,0.133,0.035,0.057,0.179,0.059,0.098,0.046,0.088,0.077]
  warm_aeroonly_fre   =[ 20.9, 26.8, 22.3, 32.0, 21.0, 27.8, 34.5, 14.7, 45.5, 45.5]
  cold_aeroonly_tau   =[0.127,0.307,0.094,0.107,0.389,0.132,0.166,0.133,0.219,0.260]
  cold_aeroonly_tauerr=[0.045,0.125,0.033,0.041,0.151,0.050,0.058,0.051,0.071,0.109]
  cold_aeroonly_fre   =[ 21.3, 37.3, 21.9, 26.0, 57.6, 16.0, 13.5, 12.6, 46.9, 10.3]
  
  warm_incldonly_tau   =[0.139,0.246,0.090,0.154,0.542,0.157,0.210,0.161,0.263,0.230]
  warm_incldonly_tauerr=[0.052,0.099,0.035,0.062,0.193,0.073,0.063,0.073,0.076,0.099]
  warm_incldonly_fre   =[  3.1,  3.6,  3.6,  2.0,  2.3,  2.6,  7.5,  0.9,  5.7, 1.9]
  cold_incldonly_tau   =[0.123,0.180,0.123,0.149,0.476,0.142,0.145,0.203,0.198,0.241]
  cold_incldonly_tauerr=[0.049,0.072,0.045,0.065,0.186,0.065,0.052,0.081,0.066,0.120]
  cold_incldonly_fre   =[  3.4,  6.8,  3.1,  3.0,  3.0,  3.0,  2.5,  0.8,  3.4, 1.1]

  warm_incldbc_tau   =[0.127,0.170,0.089,0.146,0.284,0.143,0.183,0.154,0.203,0.206]
  warm_incldbc_tauerr=[0.084,0.103,0.070,0.102,0.146,0.100,0.093,0.136,0.109,0.283]
  warm_incldbc_fre   =[  1.3,  1.7,  1.0,  1.1,  2.2,  1.2,  2.3,  1.9,  1.3, 1.3]
  cold_incldbc_tau   =[0.129,0.153,0.115,0.151,0.292,0.131,0.129,0.159,0.197,0.203]
  cold_incldbc_tauerr=[0.089,0.208,0.059,0.116,0.238,0.078,0.075,0.119,0.101,0.384]
  cold_incldbc_fre   =[  1.2,  1.2,  1.5,  1.0,  0.9,  1.6,  2.3,  2.1,  1.2, 2.3]

  warm_incldac_tau   =[0.084,0.126,0.078,0.102,0.170,0.092,0.184,0.124,0.220,0.127]
  warm_incldac_tauerr=[0.047,0.064,0.043,0.083,0.083,0.045,0.072,0.131,0.120,0.115]
  warm_incldac_fre   =[  0.6,  0.6,  0.4,  0.3,  0.8,  0.5,  0.6,  0.5,  0.6, 0.4]
  cold_incldac_tau   =[0.076,0.127,0.084,0.100,0.189,0.084,0.115,0.129,0.121,0.120]
  cold_incldac_tauerr=[0.047,0.066,0.048,0.059,0.083,0.061,0.060,0.086,0.060,0.083]
  cold_incldac_fre   =[  0.6,  0.5,  0.5,  0.5,  0.2,  0.7,  0.8,  0.5,  0.3, 0.7]

  warm_aerobc_tau   =[0.172,0.281,0.131,0.175,0.422,0.179,0.329,0.129,0.344,0.245]
  warm_aerobc_tauerr=[0.094,0.139,0.106,0.093,0.192,0.116,0.133,0.074,0.130,0.157]
  warm_aerobc_fre   =[  7.8, 12.8,  4.0, 13.2, 17.7,  8.9, 11.7, 25.7, 11.9, 13.6]
  cold_aerobc_tau   =[0.159,0.308,0.143,0.157,0.292,0.167,0.223,0.139,0.261,0.307]
  cold_aerobc_tauerr=[0.082,0.164,0.084,0.093,0.238,0.119,0.121,0.076,0.111,0.196]
  cold_aerobc_fre   =[  8.1,  6.5,  7.4,  6.8,  0.8,  6.8, 14.1, 29.6, 16.4, 17.2]


  warm_aeroac_tau   =[0.066,0.114,0.050,0.061,0.225,0.050,0.211,0.082,0.245,0.100]
  warm_aeroac_tauerr=[0.043,0.052,0.033,0.038,0.124,0.036,0.065,0.081,0.063,0.075]
  warm_aeroac_fre   =[  1.8,  1.7,  6.0,  1.2,  0.5,  1.7, 10.2,  0.3,  4.1,  0.5]
  cold_aeroac_tau   =[0.044,0.110,0.039,0.048,0.205,0.037,0.106,0.089,0.090,0.089]
  cold_aeroac_tauerr=[0.033,0.045,0.031,0.032,0.084,0.029,0.042,0.114,0.041,0.098]
  cold_aeroac_fre   =[  1.4,  2.3,  1.7,  1.2,  0.3,  1.4,  5.2,  0.2,  0.7,  0.5]


  yerr=fltarr(n_elements(region_ind))
  lnthick=2
  fontsz=12
  capsz = 0.1	
  symsz=1.5
  xrange=[0,0.6]
  yrange=[0,11]
 
 ; p=errorplot(cold_aeroonly_tau,region_ind,cold_aeroonly_tauerr,yerr,symbol='circle',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='cyan',errorbar_capsize=capsz,errorbar_color='cyan',xrange=xrange,$
;		layout=[2,1,1],yrange=yrange,xtitle='$\tau_a$',margin=[0.15,0.15,0.0,0.15],font_size=fontsz)
;  p.ymajor=12
;  p.yminor=0
;  p.yticklen=0.03
;  p.ytickname=region_name

;  p1=errorplot(warm_aeroonly_tau,region_ind,warm_aeroonly_tauerr,yerr,symbol='circle',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='red',errorbar_capsize=capsz,overplot=p,errorbar_color='red')

;  p2=errorplot(warm_incldonly_tau,region_ind,warm_incldonly_tauerr,yerr,symbol='square',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='red',errorbar_capsize=capsz,overplot=p,errorbar_color='red')
;  p3=errorplot(cold_incldonly_tau,region_ind,cold_incldonly_tauerr,yerr,symbol='square',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='cyan',errorbar_capsize=capsz,overplot=p,errorbar_color='cyan')

;  p4=errorplot(warm_incldbc_tau,region_ind,warm_incldbc_tauerr,yerr,symbol='Triangle_down',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='red',errorbar_capsize=capsz,overplot=p,errorbar_color='red')
;  p5=errorplot(cold_incldbc_tau,region_ind,cold_incldbc_tauerr,yerr,symbol='Triangle_down',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='cyan',errorbar_capsize=capsz,overplot=p,errorbar_color='cyan')

;  p6=errorplot(warm_incldac_tau,region_ind,warm_incldac_tauerr,yerr,symbol='Triangle',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='red',errorbar_capsize=capsz,overplot=p,errorbar_color='red')
;  p7=errorplot(cold_incldac_tau,region_ind,cold_incldac_tauerr,yerr,symbol='Triangle',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='cyan',errorbar_capsize=capsz,overplot=p,errorbar_color='cyan')

;  p8=errorplot(warm_aerobc_tau,region_ind,warm_aerobc_tauerr,yerr,symbol='diamond',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='red',errorbar_capsize=capsz,overplot=p,errorbar_color='red')
;  p9=errorplot(cold_aerobc_tau,region_ind,cold_aerobc_tauerr,yerr,symbol='diamond',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='cyan',errorbar_capsize=capsz,overplot=p,errorbar_color='cyan')

 ; p10=errorplot(warm_aeroac_tau,region_ind,warm_aeroac_tauerr,yerr,symbol='star',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='red',errorbar_capsize=capsz,overplot=p,errorbar_color='red')
;  p11=errorplot(cold_aeroac_tau,region_ind,cold_aeroac_tauerr,yerr,symbol='star',sym_filled=1,linestyle='',$
;		thick=lnthick,sym_color='cyan',errorbar_capsize=capsz,overplot=p,errorbar_color='cyan')


  p=plot(cold_aeroonly_tau,region_ind,symbol='circle',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz,xrange=xrange,$
		layout=[2,1,1],yrange=yrange,xtitle='$\tau_a$',margin=[0.15,0.15,0.0,0.15],font_size=fontsz)
  p.ymajor=12
  p.yminor=0
  p.yticklen=0.03
  p.ytickname=region_name

  p1=plot(warm_aeroonly_tau,region_ind,symbol='circle',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red',sym_size=symsz,overplot=p,errorbar_color='red')

  p2=plot(warm_incldonly_tau,region_ind,symbol='square',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red',sym_size=symsz,overplot=p)
  p3=plot(cold_incldonly_tau,region_ind,symbol='square',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz,overplot=p)

  p4=plot(warm_incldbc_tau,region_ind,symbol='Triangle_down',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red',sym_size=symsz,overplot=p)
  p5=plot(cold_incldbc_tau,region_ind,symbol='Triangle_down',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz,overplot=p)

  p6=plot(warm_incldac_tau,region_ind,symbol='Triangle',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red',sym_size=symsz,overplot=p)
  p7=plot(cold_incldac_tau,region_ind,symbol='Triangle',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz,overplot=p)

  p8=plot(warm_aerobc_tau,region_ind,symbol='diamond',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red',sym_size=symsz,overplot=p)
  p9=plot(cold_aerobc_tau,region_ind,symbol='diamond',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz,overplot=p)

  p10=plot(warm_aeroac_tau,region_ind,symbol='star',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red',sym_size=symsz,overplot=p)
  p11=plot(cold_aeroac_tau,region_ind,symbol='star',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz,overplot=p)



  p0=plot(cold_aeroonly_fre,region_ind,/current,layout=[2,1,2],symbol='circle',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz,xtitle='$f_a$',margin=[0.10,0.15,0.1,0.15],font_size=fontsz,$
		yrange=yrange)

  p0.ymajor=12
  p0.yminor=0
  p0.yticklen=0.03
  p0.ytickname=region_name1
  p01=plot(warm_aeroonly_fre,region_ind,overplot=p0,symbol='circle',sym_size=symsz,sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red')
  p02=plot(cold_incldonly_fre,region_ind,overplot=p0,symbol='square',sym_filled=1,sym_size=symsz,linestyle='',$
		thick=lnthick,sym_color='cyan')
  p03=plot(warm_incldonly_fre,region_ind,overplot=p0,symbol='square',sym_filled=1,linestyle='',sym_size=symsz,$
		thick=lnthick,sym_color='red')

  p04=plot(cold_incldbc_fre,region_ind,overplot=p0,symbol='Triangle_down',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz)
  p05=plot(warm_incldbc_fre,region_ind,overplot=p0,symbol='Triangle_down',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red',sym_size=symsz)

  p06=plot(cold_incldac_fre,region_ind,overplot=p0,symbol='Triangle',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz)
  p07=plot(warm_incldac_fre,region_ind,overplot=p0,symbol='Triangle',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red',sym_size=symsz)

  p08=plot(cold_aerobc_fre,region_ind,overplot=p0,symbol='diamond',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz)
  p09=plot(warm_aerobc_fre,region_ind,overplot=p0,symbol='diamond',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red',sym_size=symsz)

  p10=plot(cold_aeroac_fre,region_ind,overplot=p0,symbol='star',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='cyan',sym_size=symsz)
  p11=plot(warm_aeroac_fre,region_ind,overplot=p0,symbol='star',sym_filled=1,linestyle='',$
		thick=lnthick,sym_color='red',sym_size=symsz)

  p.save,'region_season_meanaodaof.png'
	stop
end





