
pro plot_annual_aerosol_mergedaynight_fretau2
 
print,systime()

;   lidfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen','*cad20*')
   lidfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen_2','*night*')

   Nf=n_elements(lidfname)

   Nmon=Nf ;5-10
   month=intarr(Nmon)
   wyear=dblarr(Nmon)
   
   latres=5
   lonres=6
   dimx=360/lonres
   dimy=180/latres
   dimh=399
	
   hgt=fltarr(dimh)
  hgt[0:53]=29.92-findgen(54)*0.18
     hgt[54:253]=20.2-findgen(200)*0.06
     hgt[254:398]=8.2-findgen(145)*0.06


    pos1=[0.05,0.55,0.35,0.90]
    pos2=[0.40,0.55,0.70,0.90]
    pos3=[0.05,0.10,0.35,0.45]
    pos4=[0.40,0.10,0.70,0.45]
	barpos1=[0.78,0.54,0.80,0.91]
	barpos2=[0.78,0.09,0.80,0.46]
	ppos1=[0.89,0.57,0.98,0.92]
	ppos2=[0.89,0.10,0.98,0.45]
	fontsz=11
    lnthick=2

   Tobsnumh=Ulonarr(dimx,dimy)
   Tobsnumv=Ulonarr(dimy,dimh)

   Taero_only_numh=Ulonarr(dimx,dimy)
   Taero_cld_numh=Ulonarr(dimx,dimy)
   Taero_all_tau=Dblarr(dimx,dimy)
   Taero_only_tau=Dblarr(dimx,dimy)
   Taero_cld_tau=Dblarr(dimx,dimy)
  
  Taero_only_numv=Ulonarr(dimy,dimh)
  Taero_only_beta=Dblarr(dimy,dimh)
 
  Taero_incld_numv_one=Ulonarr(dimy,dimh)
  Taero_incld_numv_belcld=Ulonarr(dimy,dimh)
  Taero_incld_numv_abvcld=Ulonarr(dimy,dimh) 	
  Taero_incld_numv_other=Ulonarr(dimy,dimh) 	
  Taero_incld_beta_one=Ulonarr(dimy,dimh)
  Taero_incld_beta_belcld=Ulonarr(dimy,dimh)
  Taero_incld_beta_abvcld=Ulonarr(dimy,dimh) 	
  Taero_incld_beta_other=Ulonarr(dimy,dimh) 	

  Taero_isolate_numv_belcld=Ulonarr(dimy,dimh)
  Taero_isolate_numv_abvcld=Ulonarr(dimy,dimh) 	
  Taero_isolate_numv_other=Ulonarr(dimy,dimh) 	
  Taero_isolate_beta_belcld=Ulonarr(dimy,dimh)
  Taero_isolate_beta_abvcld=Ulonarr(dimy,dimh) 	
  Taero_isolate_beta_other=Ulonarr(dimy,dimh) 	

   for i=0,Nf-1 do begin
	fname=lidfname[i]
	
	IF (strlen(fname) le 151) Then Begin
 	print,fname

	read_dardar,fname,'latitude',lat 
	lat=lat+latres/2.
	read_dardar,fname,'longitude',lon
	read_dardar,fname,'obs_numh',obsnumh
	Tobsnumh=Tobsnumh+obsnumh
	read_dardar,fname,'obs_numv',obsnumv
	Tobsnumv=Tobsnumv+total(obsnumv,1)	
	
    ;********** with aerosols ********************	
	read_dardar,fname,'aero_only_tau',aero_only_tau
	read_dardar,fname,'aero_only_numh',aero_only_numh
	read_dardar,fname,'aero_only_numv',aero_only_numv
	read_dardar,fname,'aero_only_backscatter_profile',aero_only_beta

	ind=where(aero_only_numv eq 0)
	aero_only_beta[ind]=0.0
	Taero_only_numv=Taero_only_numv+total(aero_only_numv,1)
	Taero_only_beta=Taero_only_beta+total(aero_only_beta*aero_only_numv,1)	

    ind=where(aero_only_numh eq 0)
	aero_only_tau[ind]=0.0
	Taero_only_tau=Taero_only_tau+aero_only_tau*aero_only_numh
	Taero_only_numh=Taero_only_numh+aero_only_numh

	read_dardar,fname,'isolate_aero_tau',aero_isolate_tau
	read_dardar,fname,'isolate_aero_numh',aero_isolate_numh
	ind=where(aero_isolate_numh eq 0)
	aero_isolate_tau[ind]=0.0
	read_dardar,fname,'isolate_aero_numv_belcld',aero_isolate_numv_belcld
	read_dardar,fname,'isolate_aero_backscatter_profile_belcld',aero_isolate_beta_belcld

	ind=where(aero_isolate_numv_belcld eq 0)
	aero_isolate_beta_belcld[ind]=0.0
	Taero_isolate_numv_belcld=Taero_isolate_numv_belcld+total(aero_isolate_numv_belcld,1)
	Taero_isolate_beta_belcld=Taero_isolate_beta_belcld+total(aero_isolate_beta_belcld*aero_isolate_numv_belcld,1)

	read_dardar,fname,'isolate_aero_numv_abvcld',aero_isolate_numv_abvcld
	read_dardar,fname,'isolate_aero_backscatter_profile_abvcld',aero_isolate_beta_abvcld
	ind=where(aero_isolate_numv_abvcld eq 0) 
	aero_isolate_beta_abvcld[ind]=0.0
	Taero_isolate_numv_abvcld=Taero_isolate_numv_abvcld+total(aero_isolate_numv_abvcld,1)
	Taero_isolate_beta_abvcld=Taero_isolate_beta_abvcld+total(aero_isolate_beta_abvcld*aero_isolate_numv_abvcld,1)


	read_dardar,fname,'isolate_aero_numv_other',aero_isolate_numv_other
	read_dardar,fname,'isolate_aero_backscatter_profile_other',aero_isolate_beta_other
	ind=where(aero_isolate_numv_other eq 0)
	aero_isolate_beta_other[ind]=0.0
	Taero_isolate_numv_other=Taero_isolate_numv_other+total(aero_isolate_numv_other,1)
	Taero_isolate_beta_other=Taero_isolate_beta_other+total(aero_isolate_beta_other*aero_isolate_numv_other,1)
		
	read_dardar,fname,'incld_aero_tau',aero_incld_tau
	read_dardar,fname,'incld_aero_numh',aero_incld_numh

	read_dardar,fname,'incld_aero_numv_one',aero_incld_numv_one
	read_dardar,fname,'incld_aero_backscatter_profile_one',aero_incld_beta_one

	ind=where(aero_incld_numv_one eq 0)
	aero_incld_beta_one[ind]=0.0
	Taero_incld_numv_one=Taero_incld_numv_one+total(aero_incld_numv_one,1)
	Taero_incld_beta_one=Taero_incld_beta_one+total(aero_incld_beta_one*aero_incld_numv_one,1)
	
	read_dardar,fname,'incld_aero_numv_belcld',aero_incld_numv_belcld
	read_dardar,fname,'incld_aero_backscatter_profile_belcld',aero_incld_beta_belcld
	ind=where(aero_incld_numv_belcld eq 0) 
	aero_incld_beta_belcld[ind]=0.0
	Taero_incld_numv_belcld=Taero_incld_numv_belcld+total(aero_incld_numv_belcld,1)
	Taero_incld_beta_belcld=Taero_incld_beta_belcld+total(aero_incld_beta_belcld*aero_incld_Numv_belcld,1)

	read_dardar,fname,'incld_aero_numv_abvcld',aero_incld_numv_abvcld
	read_dardar,fname,'incld_aero_backscatter_profile_abvcld',aero_incld_beta_abvcld
	ind=where(aero_incld_numv_abvcld eq 0)
	aero_incld_beta_abvcld[ind]=0.0
	Taero_incld_numv_abvcld=Taero_incld_numv_abvcld+total(aero_incld_numv_abvcld,1)
	Taero_incld_beta_abvcld=Taero_incld_beta_abvcld+total(aero_incld_beta_abvcld*aero_incld_numv_abvcld,1)

	read_dardar,fname,'incld_aero_numv_other',aero_incld_numv_other
	read_dardar,fname,'incld_aero_backscatter_profile_other',aero_incld_beta_other
	ind=where(aero_incld_numv_other eq 0)
	aero_incld_beta_other[ind]=0.0
	Taero_incld_numv_other=Taero_incld_numv_other+total(aero_incld_numv_other,1)
	Taero_incld_beta_other=Taero_incld_beta_other+total(aero_incld_beta_other*aero_incld_Numv_other,1)

	ind=where(aero_incld_numh eq 0)
	aero_incld_tau[ind]=0.0

	Taero_cld_tau=Taero_cld_tau+total(aero_isolate_tau*aero_isolate_numh,3)+$
		total(aero_incld_tau*aero_incld_numh,3)
	Taero_cld_numh=Taero_cld_numh+total(aero_isolate_numh,3)+total(aero_incld_numh,3)
	
	EndIf
   endfor


    aveaero_only_tau=fltarr(dimx,dimy)
    aveaero_cld_tau=fltarr(dimx,dimy)
    aveaero_allcld_tau=fltarr(dimx,dimy)
	aero_cld_fre=fltarr(dimx,dimy)

	aveaero_only_tau=Taero_only_tau/Taero_only_numh
	aero_only_fre=Taero_only_numh/float(Tobsnumh)
	zonal_aeroonly_tau=total(Taero_only_tau,1)/total(Taero_only_numh,1)		
	zonal_aeroonly_fre=total(Taero_only_numh,1)/total(Tobsnumh,1)		
	; area weighted averages
	Tobsnumh1=total(Tobsnumh,1)
	weights=cos(lat*!pi/180)
	ind=where(Tobsnumh1 eq 0)
	weights[ind]=0.0

;	area_weighted_mean,weights,aero_only_fre;--- this may be wrong
  ;  print,'aerosol only weighted fre',total(weights*total(aero_only_fre,1,/nan))/(dimy*total(weights))
    print,'aerosol only obs weighted fre',total(Taero_only_numh)/float(total(Tobsnumh))

	ind=where(Taero_only_numh eq 0)
	aveaero_only_tau[ind]=0.0
	
    ;print,'aerosol only weighted tau',total(weights*total(aveaero_only_tau,1))/(dimy*total(weights))
    print,'aerosol only number weighted tau',total(Taero_only_tau)/float(total(Taero_only_numh))
 
    aveaero_allcld_tau = Taero_cld_tau/Taero_cld_numh
	aero_allcld_fre=Taero_cld_numh/float(Tobsnumh)
	zonal_allcld_tau=total(Taero_cld_tau,1)/total(Taero_cld_numh,1)
	zonal_allcld_fre=total(Taero_cld_numh,1)/total(Tobsnumh,1)

	;globally weighted average
    ;print,'aerosol-cloud weighted fre',total(weights*total(aero_allcld_fre,1,/nan))/(dimy*total(weights))
    print,'aerosol-cloud obsnum weighted fre',total(Taero_cld_numh)/float(total(Tobsnumh))
	ind=where(Taero_cld_numh eq 0)
	aveaero_allcld_tau[ind]=0.0
;    print,'aerosol-cloud weighted tau',total(weights*total(aveaero_allcld_tau,1))/(dimy*total(weights))
    print,'aerosol-cloud num weighted tau',total(Taero_cld_tau)/float(total(Taero_cld_numh))

;   for total aerosols
	allaero_num=Taero_only_numh+Taero_cld_numh
	allaero_tau=Taero_only_tau+Taero_cld_tau
	allaero_fre=allaero_num/float(Tobsnumh)
	allaero_avetau=allaero_tau/allaero_num
	;print,'all aerosol weighted fre',total(weights*total(allaero_fre,1,/nan))/(dimy*total(weights))
	print,'all aerosol num  weighted fre',total(allaero_num)/float(total(Tobsnumh))
	ind=where(allaero_num eq 0)
	allaero_avetau[ind]=0.0
;	print,'all aero weighted ave tau',total(weights*total(allaero_avetau,1,/nan))/(dimy*total(weights))
	print,'all aero num weighted ave tau',total(allaero_tau)/float(total(allaero_num))
	
    ca=image(allaero_avetau,lon,lat,rgb_table=33,min_value=0,max_value=0.8,$
		font_size=fontsz)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=ca)
    grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=60
    grid.grid_latitude=30
	grid.font_size=fontsz-3
    mc=mapcontinents(/continents,transparency=30)
    mc['Longitudes'].label_angle=0
	ca.scale,5.2,5
 	ct=colorbar(target=ca,title='Aerosol Optical Depth',taper=1,$
 	     border=1,position=[0.25,0.25,0.75,0.28],font_size=fontsz-1,orientation=0)
	ca.save,'annual_allsky_aod_ocean_night_cad20.png'

    c=image(aero_only_fre,lon,lat,dim=[750,400],rgb_table=33,min_value=0,max_value=0.8,$
		position=pos1,font_size=fontsz)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
    grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=60
    grid.grid_latitude=30
	grid.font_size=fontsz-3
    mc=mapcontinents(/continents,transparency=30)
    mc['Longitudes'].label_angle=0
	c.scale,1,1.3
	t1=text(pos1[0]+0.02,pos1[3]+0.02,'a)',font_size=fontsz)
	t11=text(pos1[0]+0.065,pos1[3]+0.02,'Cloud-free Aerosol',font_size=fontsz+1)
	
    c1=image(aero_allcld_fre,lon,lat,rgb_table=33,min_value=0.0,max_value=0.8,$
		position=pos2,/current,font_size=fontsz)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=c1)
    grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=60
    grid.grid_latitude=30
	grid.font_size=fontsz-3
    mc=mapcontinents(/continents,transparency=30)
    mc['Longitudes'].label_angle=0
	c1.scale,1,1.3
	t2=text(pos2[0]+0.02,pos2[3]+0.02,'b)',font_size=fontsz)
	t22=text(pos2[0]+0.065,pos2[3]+0.02,'Cloudy Aerosol',font_size=fontsz+1)

	; to plot colorbar
 	ct=colorbar(target=c,title='Aerosol Occurrence Frequency',taper=1,$
 	     border=1,position=barpos1,font_size=fontsz-1,orientation=1)
	p1=plot(zonal_aeroonly_fre,lat,position=ppos1,color='black',/current,font_size=fontsz,$
		thick=lnthick,yrange=[-90,90],yminor=0,ymajor=5,xminor=0,xmajor=4,xrange=[0,0.6],$
		ytitle='Latitude (degree)',xtitle='Frequency')
	p2=plot(zonal_allcld_fre,lat,overplot=p1,color='red',font_size=fontsz,thick=lnthick)
	t3=text(ppos1[0]+0.06,ppos1[3]-0.04,'e)',font_size=fontsz)

    c2=image(aveaero_only_tau,lon,lat,rgb_table=33,min_value=0.0,max_value=0.8,$
		position=pos3,/current)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=c2)
    grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=60
    grid.grid_latitude=30
	grid.font_size=fontsz-3
    mc=mapcontinents(/continents,transparency=30)
    mc['Longitudes'].label_angle=0
	c2.scale,1,1.3
	t4=text(pos3[0]+0.02,pos3[3]+0.02,'c)',font_size=fontsz)

    c3=image(aveaero_allcld_tau,lon,lat,rgb_table=33,min_value=0.0,max_value=0.8,$
		position=pos4,/current)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=c3)
    grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=60
    grid.grid_latitude=30
	grid.font_size=fontsz-3

    mc=mapcontinents(/continents,transparency=30)
    mc['Longitudes'].label_angle=0
	c3.scale,1,1.3
	t5=text(pos4[0]+0.02,pos4[3]+0.02,'d)',font_size=fontsz)

	; to plot colorbar
 	ct=colorbar(target=c2,title='Aerosol Optical Depth',taper=1,$
 	     border=1,position=barpos2,font_size=fontsz-1,orientation=1)
	p1=plot(zonal_aeroonly_tau,lat,position=ppos2,color='black',/current,font_size=fontsz,$
		thick=lnthick,yrange=[-90,90],yminor=0,ymajor=5,xminor=1,xmajor=3,xrange=[0,0.4],$
		ytitle='Latitude (degree)',xtitle='AOD')
	p2=plot(zonal_allcld_tau,lat,overplot=p1,color='red',font_size=fontsz,thick=lnthick)
	t6=text(ppos2[0]+0.06,ppos2[3]-0.04,'f)',font_size=fontsz)
	print,systime()
	c.save,'annual_aerosol_aod_freq_ocean_night_cad20_screened.png'

	;=========== to plot the zonal average ===== 
    ave_aeroonly_fre_prof=total(Taero_only_numv,1)/total(Tobsnumv,1)		
	ave_aeroonly_beta_prof=total(Taero_only_beta,1)/total(Taero_only_numv,1)

	ave_aero_isolate_fre_profbelcld=total(Taero_isolate_numv_belcld,1)/total(Tobsnumv,1)
	ave_aero_isolate_beta_profbelcld=total(Taero_isolate_beta_belcld,1)/total(Taero_isolate_numv_belcld,1)

	ave_aero_isolate_fre_profabvcld=total(Taero_isolate_numv_abvcld,1)/total(Tobsnumv,1)
	ave_aero_isolate_beta_profabvcld=total(Taero_isolate_beta_abvcld,1)/total(Taero_isolate_numv_abvcld,1)

	ave_aero_isolate_fre_profother=total(Taero_isolate_numv_other,1)/total(Tobsnumv,1)
	ave_aero_isolate_beta_profother=total(Taero_isolate_beta_other,1)/total(Taero_isolate_numv_other,1)

	ave_aero_isolate_fre_profall=total((Taero_isolate_numv_belcld+Taero_isolate_numv_abvcld+Taero_isolate_numv_other),1)/$
								total(Tobsnumv,1)
	ave_aero_isolate_beta_profall=total((Taero_isolate_beta_belcld+Taero_isolate_beta_abvcld+Taero_isolate_beta_other),1)/$
			total((Taero_isolate_numv_belcld+Taero_isolate_numv_abvcld+Taero_isolate_numv_other),1)
	
	ave_aero_incld_fre_profone=total(Taero_incld_numv_one,1)/total(Tobsnumv,1)
	ave_aero_incld_beta_profone=total(Taero_incld_beta_one,1)/total(Taero_incld_numv_one,1)

	ave_aero_incld_fre_profbelcld=total(Taero_incld_numv_belcld,1)/total(Tobsnumv,1)
	ave_aero_incld_beta_profbelcld=total(Taero_incld_beta_belcld,1)/total(Taero_incld_numv_belcld,1)

	ave_aero_incld_fre_profabvcld=total(Taero_incld_numv_abvcld,1)/total(Tobsnumv,1)
	ave_aero_incld_beta_profabvcld=total(Taero_incld_beta_abvcld,1)/total(Taero_incld_numv_abvcld,1)

	ave_aero_incld_fre_profother=total(Taero_incld_numv_other,1)/total(Tobsnumv,1)
	ave_aero_incld_beta_profother=total(Taero_incld_beta_other,1)/total(Taero_incld_numv_other,1)

	ave_aero_incld_fre_profall=total((Taero_incld_numv_one+Taero_incld_numv_belcld+Taero_incld_numv_abvcld+Taero_incld_numv_other),1)/$
								total(Tobsnumv,1)
	ave_aero_incld_beta_profall=total((Taero_incld_beta_one+Taero_incld_beta_belcld+Taero_incld_beta_abvcld+Taero_incld_beta_other),1)/$
			total((Taero_incld_numv_one+Taero_incld_numv_belcld+Taero_incld_numv_abvcld+Taero_incld_numv_other),1)

	ave_aero_allcld_fre_prof=ave_aero_incld_fre_profall+ave_aero_isolate_fre_profall
	ave_aero_allcld_beta_prof=(total((Taero_incld_beta_one+Taero_incld_beta_belcld+Taero_incld_beta_abvcld+Taero_incld_beta_other),1)$
							+total((Taero_isolate_beta_belcld+Taero_isolate_beta_abvcld+Taero_isolate_beta_other),1))/$
							(total((Taero_isolate_numv_belcld+Taero_isolate_numv_abvcld+Taero_isolate_numv_other),1)+$
							 total((Taero_incld_numv_one+Taero_incld_numv_belcld+Taero_incld_numv_abvcld+Taero_incld_numv_other),1))

	pos1=[0.10,0.15,0.49,0.9]
	pos2=[0.57,0.15,0.95,0.91]
	lnthick=2
    p0=plot(ave_aeroonly_fre_prof,hgt,dim=[600,300],position=pos1,thick=lnthick,name='Cloud-free',$
		xtitle='Occurrence Frequency',ytitle='Altitude (km)',yrange=[0,15],xmajor=5,xrange=[0,0.16])
;	p1=plot(ave_aero_allcld_fre_prof,hgt,overplot=p0,color='black',linestyle='dashed',thick=lnthick,name='Cloudy')
	p02=plot(ave_aero_isolate_fre_profall,hgt,overplot=p0,color='black',linestyle='dashed',thick=lnthick,name='Isolated-cloud')
	p03=plot(ave_aero_incld_fre_profall,hgt,overplot=p0,color='black',linestyle='dotted',thick=lnthick,name='In-cloud')

    p=plot(ave_aeroonly_beta_prof,hgt,position=pos2,thick=lnthick,yrange=[0,15],/current,$
		xtitle='$\beta (km^{-1} Sr^{-1})$',ytitle='',xrange=[0,0.008])
;	p2=plot(ave_aero_allcld_beta_prof,hgt,overplot=p,color='black',thick=lnthick,linestyle='dashed')
	p2=plot(ave_aero_isolate_beta_profall,hgt,overplot=p,color='black',thick=lnthick,linestyle='dashed')
	p3=plot(ave_aero_incld_beta_profall,hgt,overplot=p,color='black',thick=lnthick,linestyle='dotted')
	lg=legend(target=[p0,p02,p03],position=[0.85,0.75],transparency=100)
	p0.save,'annual_aerosolcld_beta_freq_profile_ocean_night_cad20_screened.png'
stop
end
