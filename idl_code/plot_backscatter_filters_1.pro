
pro plot_backscatter_filters_1
  
	dimh=399
       hgt=fltarr(dimh)
     hgt[0:53]=29.92-findgen(54)*0.18
     hgt[54:253]=20.2-findgen(200)*0.06
     hgt[254:398]=8.2-findgen(145)*0.06


   restore,'filters_all_beta_fre_profiles.sav'
   all_aeroonly_beta=ave_aeroonly_beta_prof
   all_aeroonly_fre=ave_aeroonly_fre_prof
   all_incld_aero_beta=AVE_AERO_INCLD_BETA_PROFALL
   all_incld_aero_fre=AVE_AERO_INCLD_FRE_PROFALL
   all_isolate_aero_beta=AVE_AERO_ISOLATE_BETA_PROFALL
   all_isolate_aero_fre=AVE_AERO_ISOLATE_FRE_PROFALL
   	
   restore,'filters_nocad_beta_fre_profiles.sav'
   nocad_aeroonly_beta=ave_aeroonly_beta_prof
   nocad_aeroonly_fre=ave_aeroonly_fre_prof
   nocad_incld_aero_beta=AVE_AERO_INCLD_BETA_PROFALL
   nocad_incld_aero_fre=AVE_AERO_INCLD_FRE_PROFALL
   nocad_isolate_aero_beta=AVE_AERO_ISOLATE_BETA_PROFALL
   nocad_isolate_aero_fre=AVE_AERO_ISOLATE_FRE_PROFALL
  	
   restore,'filters_noextqc_beta_fre_profiles.sav'
   noextqc_aeroonly_beta=ave_aeroonly_beta_prof
   noextqc_aeroonly_fre=ave_aeroonly_fre_prof
   noextqc_incld_aero_beta=AVE_AERO_INCLD_BETA_PROFALL
   noextqc_incld_aero_fre=AVE_AERO_INCLD_FRE_PROFALL
   noextqc_isolate_aero_beta=AVE_AERO_ISOLATE_BETA_PROFALL
   noextqc_isolate_aero_fre=AVE_AERO_ISOLATE_FRE_PROFALL

;   restore,'filters_noaod_beta_fre_profiles.sav'
;   noaod_aeroonly_beta=ave_aeroonly_beta_prof
;   noaod_aeroonly_fre=ave_aeroonly_fre_prof
;   noaod_incld_aero_beta=AVE_AERO_INCLD_BETA_PROFALL
;   noaod_incld_aero_fre=AVE_AERO_INCLD_FRE_PROFALL
;   noaod_isolate_aero_beta=AVE_AERO_ISOLATE_BETA_PROFALL
;   noaod_isolate_aero_fre=AVE_AERO_ISOLATE_FRE_PROFALL

   restore,'filters_noci_beta_fre_profiles.sav'
   noci_aeroonly_beta=ave_aeroonly_beta_prof
   noci_aeroonly_fre=ave_aeroonly_fre_prof
   noci_incld_aero_beta=AVE_AERO_INCLD_BETA_PROFALL
   noci_incld_aero_fre=AVE_AERO_INCLD_FRE_PROFALL
   noci_isolate_aero_beta=AVE_AERO_ISOLATE_BETA_PROFALL
   noci_isolate_aero_fre=AVE_AERO_ISOLATE_FRE_PROFALL

   lnthick=2.0
   fontsz=10
	pos1=[0.09,0.20,0.33,0.9]
	pos2=[0.41,0.20,0.65,0.9]
	pos3=[0.72,0.20,0.96,0.9]

   p0=plot(all_aeroonly_beta,hgt,dim=[800,250],position=pos1,thick=lnthick,title='a) Cloud-free',$
      xtitle='$\beta$',ytitle='Altitude (km)',yrange=[0,20],xmajor=5,xrange=[0,0.008],name='All filters')
   p01=plot(nocad_aeroonly_beta,hgt,overplot=p0,color='r',name='No CAD filter',thick=lnthick)
   p02=plot(noextqc_aeroonly_beta,hgt,overplot=p0,color='g',name='No Ext_QC fitler',thick=lnthick)
 ;  p03=plot(noaod_aeroonly_beta,hgt,overplot=p0,color='purple',name='No AOD filter',thick=lnthick)
   p04=plot(noci_aeroonly_beta,hgt,overplot=p0,color='pink',name='No Cirrus filter',thick=lnthick)	

   p1=plot(all_incld_aero_beta,hgt,position=pos2,thick=lnthick,title='b) In-cloud',/current,$
      xtitle='$\beta$',ytitle='',yrange=[0,20],xmajor=5,xrange=[0,0.008],name='All filters')
   p11=plot(nocad_incld_aero_beta,hgt,overplot=p1,color='r',name='No CAD filter',thick=lnthick)
   p12=plot(noextqc_incld_aero_beta,hgt,overplot=p1,color='g',name='No Ext_QC fitler',thick=lnthick)
;   p13=plot(noaod_incld_aero_beta,hgt,overplot=p1,color='purple',name='No AOD filter',thick=lnthick)
   p14=plot(noci_incld_aero_beta,hgt,overplot=p1,color='pink',name='No Cirrus filter',thick=lnthick)	

   p2=plot(all_isolate_aero_beta,hgt,position=pos3,thick=lnthick,title='c) Isolate-cloud',/current,$
      xtitle='$\beta$',ytitle='',yrange=[0,20],xmajor=5,xrange=[0,0.008],name='All filters')
   p21=plot(nocad_isolate_aero_beta,hgt,overplot=p2,color='r',name='No CAD filter',thick=lnthick)
   p22=plot(noextqc_isolate_aero_beta,hgt,overplot=p2,color='g',name='No Ext_QC fitler',thick=lnthick)
;   p23=plot(noaod_isolate_aero_beta,hgt,overplot=p2,color='purple',name='No AOD filter',thick=lnthick)
   p24=plot(noci_isolate_aero_beta,hgt,overplot=p2,color='pink',name='No Cirrus filter',thick=lnthick)	

   ld=legend(target=[p0,p01,p02,p04],transparency=100,position=[0.97,0.87],font_size=fontsz)

   p0.save,'filters_sensitivity_backscatter_profile.png'

	stop

end
