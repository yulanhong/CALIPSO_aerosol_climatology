
pro match_modis_cldsat
 print,systime()
  cldfname='/u/sciteam/yulanh/scratch/2C-ICE/2009/'+$
	'2009231162830_17611_CS_2C-ICE_GRANULE_P1_R04_E02.hdf'	
 
  cwcfname='/u/sciteam/yulanh/scratch/CWC-RVOD/2009/'+$
	'2009231162830_17611_CS_2B-CWC-RVOD_GRANULE_P_R04_E02.hdf'
 
  mod06fname='/u/sciteam/yulanh/scratch/MODIS/Bill_hurricane_2009_08_19/'+$
	'MYD06_L2.A2009231.1720.061.2018045232605.hdf'
 
  mod02fname='/u/sciteam/yulanh/scratch/MODIS/Bill_hurricane_2009_08_19/'+$
	'MYD021KM.A2009231.1720.061.2018045110613.hdf'

  mod03fname='/u/sciteam/yulanh/scratch/MODIS/Bill_hurricane_2009_08_19/'+$
	'MYD03.A2009231.1720.061.2018045001905.hdf'

  ; cloudsat data
  read_cloudsat,cldfname,'2C-ICE','Latitude',cldlat
  read_cloudsat,cldfname,'2C-ICE','Longitude',cldlon
  read_cloudsat,cldfname,'2C-ICE','IWC',iwc
  read_cloudsat,cldfname,'2C-ICE','re',ire
  read_cloudsat,cldfname,'2C-ICE','Height',cldhgt
  read_cloudsat,cldfname,'2C-ICE','Profile_time',time
  read_cloudsat,cwcfname,'2B-CWC-RVOD','RVOD_liq_water_content',lwc
  read_cloudsat,cwcfname,'2B-CWC-RVOD','RVOD_liq_water_path',lwp
  read_cloudsat,cwcfname,'2B-CWC-RVOD','RVOD_liq_effective_radius',lre
  
 ;== to read modis data=============================
  fid=hdf_sd_start(mod02fname,/read)
   
  sds_index=hdf_sd_nametoindex(fid,'EV_250_Aggr1km_RefSB')
  nid=hdf_sd_select(fid,sds_index)
  hdf_sd_getdata,nid,modis_250
  scale_ind=hdf_sd_attrfind(nid,'radiance_scales')
  hdf_sd_attrinfo,nid,scale_ind,data=scale
  scale_ind=hdf_sd_attrfind(nid,'radiance_offsets')
  hdf_sd_attrinfo,nid,scale_ind,data=offset
  rad_062=scale[0]*(modis_250[*,*,0]-offset[0])

  sds_index=hdf_sd_nametoindex(fid,'EV_500_Aggr1km_RefSB')
  nid=hdf_sd_select(fid,sds_index)
  hdf_sd_getdata,nid,modis_500
  scale_ind=hdf_sd_attrfind(nid,'radiance_scales')
  hdf_sd_attrinfo,nid,scale_ind,data=scale
  scale_ind=hdf_sd_attrfind(nid,'radiance_offsets')
  hdf_sd_attrinfo,nid,scale_ind,data=offset
  rad_21=scale[4]*(modis_500[*,*,4]-offset[4])

  sds_index=hdf_sd_nametoindex(fid,'EV_1KM_Emissive')
  nid=hdf_sd_select(fid,sds_index)
  hdf_sd_getdata,nid,modis_emis
  scale_ind=hdf_sd_attrfind(nid,'radiance_scales')
  hdf_sd_attrinfo,nid,scale_ind,data=scale
  scale_ind=hdf_sd_attrfind(nid,'radiance_offsets')
  hdf_sd_attrinfo,nid,scale_ind,data=offset
  rad_85=scale[8]*(modis_emis[*,*,8]-offset[8])
  rad_120=scale[11]*(modis_emis[*,*,11]-offset[11])

  hdf_sd_end,fid

 ;============end reading modis file==========================
  read_modis_1,mod03fname,'Latitude',modlat
  read_modis_1,mod03fname,'Longitude',modlon
  read_modis_1,mod03fname,'SolarZenith',solarzenith
  read_modis_1,mod03fname,'SolarAzimuth',solarazimuth
  solarzenith=solarzenith/100.0
  solarazimuth=solarazimuth/100.0
  read_modis_1,mod06fname,'Cloud_Water_Path',modcwp

  minlat=min(modlat)
  maxlat=max(modlat)
  minlon=min(modlon)
  maxlon=max(modlon)

  ind=where((cldlat ge minlat) and (cldlat le maxlat))
  cldlat1=reform(cldlat[ind])
  cldlon1=reform(cldlon[ind])
  iwc_1=reform(iwc[*,ind])
  ire_1=reform(ire[*,ind])
  lwc_1=lwc[*,ind]
  lwp_1=lwp[ind]
  lre_1=lre[*,ind]
  cldhgt_1=cldhgt[*,ind]
 
  ind=where((cldlon1 ge minlon) and (cldlon1 le maxlon),count)
  cldlat2=temporary(cldlat1[ind])
  cldlon2=temporary(cldlon1[ind])
  iwc_2=temporary(iwc_1[*,ind])
  ire_2=temporary(ire_1[*,ind])
  lwc_2=temporary(lwc_1[*,ind])
  lwp_2=temporary(lwp_1[ind])
  lre_2=temporary(lre_1[*,ind])
  cldhgt_2=temporary(cldhgt_1[*,ind])

  Ns=count
;====to get the radiance from MODIS to the closest point of cloudsat======================

  cld_modis_rad=fltarr(2030,4) ; for four wavelenths: 1: 0.62-0.67; 7: 2.105-2.155; 29: 8.4-8.7; 32: 11.77-12.27 
  cld_modis_zenith=fltarr(2030)
  cld_modis_azimuth=fltarr(2030) ; match to modis
  cld_modis_pos=intarr(2030,2) ; i,j 
  modis_rad=fltarr(61,2030,4)
  modis_lat=fltarr(61,2030)
  modis_lon=fltarr(61,2030)
  modis_solar=fltarr(61,2030)
  modis_azimuth=fltarr(61,2030)
  match_cld_pos=fltarr(2030); to record CloudSat's position 
  modis_cwp=fltarr(61,2030)
  match_time=fltarr(2030)

  x=findgen(Ns)
  cldtrfit=linfit(cldlon2,cldlat2)
  red_materr=fltarr(2030)

  for si=0,2030-1 do begin
      tplat=modlat[*,si]
      tplon=modlon[*,si]

      ;======match to cloudsat track, and look for several points to match to modis	
      modtrfit=linfit(tplon,tplat)
      cld_mlon=(modtrfit[0]-cldtrfit[0])/(cldtrfit[1]-modtrfit[1])	
      cld_mlat=modtrfit[1]*cld_mlon+modtrfit[0]

      difflat = abs(cldlat2 - cld_mlat)
      difflon = abs(cldlon2 - cld_mlon)
 
      cld_dis=sqrt(difflat*difflat+difflon*difflon)   
      bin = where(min(cld_dis) eq cld_dis,count)  	
      bin = bin[0]
      cldmscp=bin-2

      ;====== match to modis============
      chi=0
      diss_err=1
      while diss_err ge 0.007 do begin ; around 700m
      difflat = abs(tplat - cldlat2[cldmscp+chi])
      difflon = abs(tplon - cldlon2[cldmscp+chi])
 
      modcld_dis=sqrt(difflat*difflat+difflon*difflon)   
      bin = where(min(modcld_dis) eq modcld_dis,count)  	
      bin = bin[0]
     ; print , cldmscp+chi, cldlat2[cldmscp+chi],cldlon2[cldmscp+chi], modcld_dis[bin]
      diss_err=modcld_dis[bin]
      chi=chi+1
      endwhile
      match_cld_pos[si]=cldmscp+chi

      red_materr[si]=modcld_dis[bin]	
      ; get x,y subscript from one-dim subscrip 
      scpind=[bin,si]     
      cld_modis_pos[si,*]=scpind  ; record the position of best match
      cld_modis_rad[si,0]=rad_062[scpind[0],scpind[1]]
      cld_modis_rad[si,1]=rad_21[scpind[0],scpind[1]]
      cld_modis_rad[si,2]=rad_85[scpind[0],scpind[1]]
      cld_modis_rad[si,3]=rad_120[scpind[0],scpind[1]]
      cld_modis_zenith[si]=solarzenith[scpind[0],scpind[1]]
      cld_modis_azimuth[si]=solarazimuth[scpind[0],scpind[1]]	 
      modis_rad[*,scpind[1],0]= rad_062[scpind[0]-30:scpind[0]+30,scpind[1]]
      modis_rad[*,scpind[1],1]= rad_21[scpind[0]-30:scpind[0]+30,scpind[1]]
      modis_rad[*,scpind[1],2]= rad_85[scpind[0]-30:scpind[0]+30,scpind[1]]
      modis_rad[*,scpind[1],3]= rad_120[scpind[0]-30:scpind[0]+30,scpind[1]]
      modis_lat[*,si]= modlat[scpind[0]-30:scpind[0]+30,si]
      modis_lon[*,si]= modlon[scpind[0]-30:scpind[0]+30,si]
      modis_solar[*,si]=solarzenith[scpind[0]-30:scpind[0]+30,si]
      modis_azimuth[*,si]=solarazimuth[scpind[0]-30:scpind[0]+30,si]
      modis_cwp[*,si]=modcwp[scpind[0]-30:scpind[0]+30,si]
  endfor  
   
  ;================ to extrapolate CloudSat-CALIPSO curtain to MODIS====
  nsize=size(solarzenith)
  dimx=61
  dimy=nsize[2]
  cld_modis_iwc=fltarr(dimx,dimy,125)
  cld_modis_ire=fltarr(dimx,dimy,125)
  cld_modis_raddiff=fltarr(dimx,dimy)
  cld_modis_iwp=fltarr(dimx,dimy)
  cld_modis_lwc=fltarr(dimx,dimy,125)
  cld_modis_lwp=fltarr(dimx,dimy)
  cld_modis_lre=fltarr(dimx,dimy,125)
  cld_modis_hgt=fltarr(dimx,dimy,125)

  m1=200
  m2=200

  iwc_3=iwc_2[*,match_cld_pos]
  ire_3=ire_2[*,match_cld_pos]
  lwc_3=lwc_2[*,match_cld_pos]
  lwp_3=lwp_2[match_cld_pos]
  lre_3=lre_2[*,match_cld_pos]
  cldhgt_3=cldhgt_2[*,match_cld_pos]
  match_lat=cldlat2[match_cld_pos]
  match_lon=cldlon2[match_cld_pos]

  for j=0, dimx-1 do begin ; across longitude (across CC-track)
    for i=0,dimy-1 do begin ; only scan across latitude (along CC-track) 130 m centered at CloudSat-CALIPSO track
        F_cost=fltarr(401) ; m1+m2+1
	tprad062=modis_rad[j,i,0]
	tprad21 =modis_rad[j,i,1]
	tprad85 =modis_rad[j,i,2]
	tprad120=modis_rad[j,i,3]
	tpzenith=modis_solar[j,i]
	tpmu=cos(tpzenith*!pi/180.)
	tpazimuth=modis_azimuth[j,i]
	tpmodlat=modis_lat[j,i]
	tpmodlon=modis_lon[j,i]

	;==== radiance, solar info under cloudsat track for matching modis image==
	cldlowscp=i-m1
	cldupscp=i+m2

	If cldlowscp lt 0 then cldlowscp=0
        If cldupscp ge dimy then cldupscp=dimy-1
	
	tpcld_modis_rad=cld_modis_rad[cldlowscp:cldupscp,*]
	tpcld_modis_zenith=cld_modis_zenith[cldlowscp:cldupscp,*]
	tpcld_modis_mu=cos(tpcld_modis_zenith*!pi/180.0)
	tpcld_modis_azimuth=cld_modis_azimuth[cldlowscp:cldupscp,*]	
	iwc_4=iwc_3[*,cldlowscp:cldupscp]
	ire_4=ire_3[*,cldlowscp:cldupscp]
	lwc_4=lwc_3[*,cldlowscp:cldupscp]
	lwp_4=lwp_3[cldlowscp:cldupscp]
	lre_4=lre_3[*,cldlowscp:cldupscp]
   	cldhgt_4=cldhgt_3[*,cldlowscp:cldupscp]	
	;====== first condition delta_mu = 0.01,delta_phi = 10degrees=========		
	F_costind=$
	where(abs(tpmu-tpcld_modis_mu) le 0.01 and abs(tpazimuth-tpcld_modis_azimuth) le 10,count)	
	Ns_match=count
	IF Ns_match le 12 then begin
	 cld_modis_iwc[j,i,*]=!values.f_nan
	 cld_modis_ire[j,i,*]=!values.f_nan
	 cld_modis_raddiff[j,i]=!values.f_nan
	Endif else begin
	 F_cost[F_costind] = (1-tpcld_modis_rad[F_costind,0]/tprad062)^2.0+$
			     (1-tpcld_modis_rad[F_costind,1]/tprad21)^2.0 +$
			     (1-tpcld_modis_rad[F_costind,2]/tprad85)^2.0 +$
			     (1-tpcld_modis_rad[F_costind,3]/tprad120)^2.0  
	 minind=where(min(F_cost[F_costind]) eq F_cost[F_costind])
	 cld_modis_iwc[j,i,*]=iwc_4[*,F_costind[minind[0]]]
	 cld_modis_iwp[j,i]=total(iwc_4[*,F_costind[minind[0]]]*240)
	 cld_modis_ire[j,i,*]=ire_4[*,F_costind[minind[0]]]
 	 cld_modis_raddiff[j,i]=F_cost[F_costind[minind[0]]] 

	 cld_modis_lwc[j,i,*]=lwc_4[*,F_costind[minind[0]]]
	 cld_modis_lwp[j,i]=lwp_4[F_costind[minind[0]]]
	 cld_modis_lre[j,i,*]=lre_4[*,F_costind[minind[0]]]
	 cld_modis_hgt[j,i,*]=cldhgt_4[*,F_costind[minind[0]]]
;	 if Ns_match gt 10 then stop		
	Endelse

    endfor
  endfor
  ;================end extraploate =====================================================
 
  save,cld_modis_iwc,filename='hurricane_bill_extrapolated_iwc.sav'  
  save,cld_modis_iwp,filename='hurricane_bill_extrapolated_iwp.sav'  
  save,cld_modis_ire,filename='hurricane_bill_extrapolated_ire.sav'  
  save,cld_modis_raddiff,filename='hurricane_bill_extrapolated_Fcost.sav'  
  save,cld_modis_lwc,filename='hurricane_bill_extrapolated_lwc.sav'  
  save,cld_modis_lwp,filename='hurricane_bill_extrapolated_lwp.sav'  
  save,cld_modis_lre,filename='hurricane_bill_extrapolated_lre.sav'  
  save,modis_cwp,filename='hurricane_bill_modis_cwp.sav'
  save,match_lat,filename='hurricane_bill_match_lat.sav'
  save,match_lon,filename='hurricane_bill_match_lon.sav'
  
 ; im=contour(cld_modis_iwp,modlon,modlat,min_value=0,rgb_table=33,/fill)
 ; im1=contour(cld_modis_lwp,modlon,modlat,min_value=0,rgb_table=33,/fill)
 ;========== write HDF file==============================================
 wfname='3D_test_hurricane_bill.hdf'

 fid=hdf_sd_start(wfname,/create)

 sid=hdf_sd_create(fid,'latitude',[61,dimy],/float)
 hdf_sd_adddata,sid, modis_lat

 sid=hdf_sd_create(fid,'longitude',[61,dimy],/float)
 hdf_sd_adddata,sid, modis_lon

 sid=hdf_sd_create(fid,'height',[61,dimy,125],/float)
 hdf_sd_adddata,sid, cld_modis_hgt

 sid=hdf_sd_create(fid,'time',[dimy],/float)
 hdf_sd_adddata,sid, match_time
 
 sid=hdf_sd_create(fid,'modis_cloud_water_path',[61,dimy],/float)
 hdf_sd_adddata,sid, modis_cwp

 sid=hdf_sd_create(fid,'reconstructed_IWC',[61,dimy,125],/float)
 hdf_sd_adddata,sid, cld_modis_iwc
 hdf_sd_attrset,sid,'name','three-dimensional IWC',/dfnt_char
 hdf_sd_attrset,sid,'unit','g m^{-3}',/dfnt_char

 sid=hdf_sd_create(fid,'reconstructed_ice_re',[61,dimy,125],/float)
 hdf_sd_adddata,sid, cld_modis_ire

 sid=hdf_sd_create(fid,'reconstructed_LWC',[61,dimy,125],/float)
 hdf_sd_adddata,sid, cld_modis_lwc

 sid=hdf_sd_create(fid,'reconstructed_liquid_re',[61,dimy,125],/float)
 hdf_sd_adddata,sid, cld_modis_lre

 sid=hdf_sd_create(fid,'minimized_cost_function',[61,dimy],/float)
 hdf_sd_adddata,sid, cld_modis_raddiff

 sid=hdf_sd_create(fid,'solar_zenith',[61,dimy],/float)
 hdf_sd_adddata,sid, modis_solar
 
 sid=hdf_sd_create(fid,'solar_azimuth',[61,dimy],/float)
 hdf_sd_adddata,sid, modis_azimuth

 hdf_sd_endaccess,sid
 hdf_sd_end,fid
 

 print,systime()
  stop
end
