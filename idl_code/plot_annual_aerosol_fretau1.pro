
pro plot_annual_aerosol_fretau1
 
print,systime()

;   lidfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen','*cad20*')
   lidfname=file_search('/u/sciteam/yulanh/scratch/Res_aerocld_overlap','*cad50*')

   Nf=n_elements(lidfname)
   Nmon=Nf ;5-10
   month=intarr(Nmon)
   wyear=dblarr(Nmon)
   
   latres=2
   lonres=5
   dimx=360/lonres
   dimy=180/latres
   dimh=101 
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

   Taero_only_numh=Ulonarr(dimx,dimy)
   Taero_cld_numh=Ulonarr(dimx,dimy)
   Taero_all_tau=Dblarr(dimx,dimy)
   Taero_all_tauerr=Dblarr(dimx,dimy)
   Taero_only_tau=Dblarr(dimx,dimy)
   Taero_only_tauerr=Dblarr(dimx,dimy)
   Taero_cld_tau=Dblarr(dimx,dimy)
   Taero_cld_tauerr=Dblarr(dimx,dimy) 

   for i=0,Nf-1 do begin
	fname=lidfname[i]
	
	IF (strlen(fname) eq 98) Then Begin
 	print,fname

	read_dardar,fname,'latitude',lat 
	read_dardar,fname,'longitude',lon
	read_dardar,fname,'obs_numh',obsnumh
	
    ;********** with aerosols ********************	
	read_dardar,fname,'aerosol_only_tau',aero_only_tau
	read_dardar,fname,'aerosol_only_numh',aero_only_numh
	read_dardar,fname,'aerosol_only_negativetau_numh',aeroonly_tau0_numh
	read_dardar,fname,'aerosol_only_tau_uncer',aero_only_tauerr

    ind=where(aero_only_numh eq 0)
	aero_only_tau[ind]=0.0
	aero_only_tauerr[ind]=0.0
	Taero_only_tau=Taero_only_tau+total(total(aero_only_tau*(aero_only_numh-aeroonly_tau0_numh),4),3)
	Taero_only_tauerr=Taero_only_tauerr+total(total(aero_only_tauerr*(aero_only_numh-aeroonly_tau0_numh),4),3)
	Taero_only_numh=Taero_only_numh+total(total(aero_only_numh,4),3)

	read_dardar,fname,'isolate_aerosol_tau',aero_isolate_tau
	read_dardar,fname,'isolate_aerosol_num',aero_isolate_num
	read_dardar,fname,'isolate_aerosol_negativetau_num',aero_isolate_tau0_numh
	read_dardar,fname,'isolate_aerosol_tau_uncer',aero_isolate_tauerr
	ind=where(aero_isolate_num eq 0)
	aero_isolate_tau[ind]=0.0
	aero_isolate_tauerr[ind]=0.0
		
	read_dardar,fname,'incloud_aerosol_tau',aero_incloud_tau
	read_dardar,fname,'incloud_aerosol_num',aero_incloud_num
	read_dardar,fname,'incloud_aerosol_negativetau_num',aero_incloud_tau0_numh
	read_dardar,fname,'incloud_aerosol_tau_uncer',aero_incloud_tauerr
	ind=where(aero_incloud_num eq 0)
	aero_incloud_tau[ind]=0.0
	aero_incloud_tauerr[ind]=0.0

	Taero_cld_tau=Taero_cld_tau+total(total(aero_isolate_tau*(aero_isolate_num-aero_isolate_tau0_numh),4),3)+$
		total(total(aero_incloud_tau*(aero_incloud_num-aero_incloud_tau0_numh),4),3)
	Taero_cld_tauerr=Taero_cld_tauerr+total(total(aero_isolate_tauerr*(aero_isolate_num-aero_isolate_tau0_numh),4),3)+$
		total(total(aero_incloud_tauerr*(aero_incloud_num-aero_incloud_tau0_numh),4),3)
	Taero_cld_numh=Taero_cld_numh+total(total(aero_isolate_num-aero_isolate_tau0_numh,4),3)+total(total(aero_incloud_num-aero_incloud_tau0_numh,4),3)

	Tobsnumh=Tobsnumh+total(obsnumh,3)
	
	EndIf
   endfor


    aveaero_only_tau=fltarr(dimx,dimy)
    aveaero_only_tauerr=fltarr(dimx,dimy)
    aveaero_cld_tau=fltarr(dimx,dimy)
    aveaero_cld_tauerr=fltarr(dimx,dimy)
    aveaero_allcld_tau=fltarr(dimx,dimy)
    aveaero_allcld_tauerr=fltarr(dimx,dimy)
	aero_cld_fre=fltarr(dimx,dimy)

	aveaero_only_tau=Taero_only_tau/Taero_only_numh
	aveaero_only_tauerr=Taero_only_tauerr/Taero_only_numh
	aero_only_fre=Taero_only_numh/float(Tobsnumh)
	zonal_aeroonly_tau=total(Taero_only_tau,1)/total(Taero_only_numh,1)		
	zonal_aeroonly_tauerr=total(Taero_only_tauerr,1)/total(Taero_only_numh,1)		
	zonal_aeroonly_fre=total(Taero_only_numh,1)/total(Tobsnumh,1)		
	; area weighted averages
	Tobsnumh1=total(Tobsnumh,1)
	weights=cos(lat*!pi/180)
	ind=where(Tobsnumh1 eq 0)
	weights[ind]=0.0

;	area_weighted_mean,weights,aero_only_fre
    print,'aerosol only weighted fre',total(weights*total(aero_only_fre,1,/nan))/(72*total(weights))

	ind=where(Taero_only_numh eq 0)
	aveaero_only_tau[ind]=0.0
	aveaero_only_tauerr[ind]=0.0
	
    print,'aerosol only weighted tau',total(weights*total(aveaero_only_tau,1))/(72*total(weights))
    print,'aerosol only weighted tauerr',total(weights*total(aveaero_only_tauerr,1))/(72*total(weights))

 
    lon=findgen(dimx)*5-180
    lat=findgen(dimy)*2-90+1 
    aveaero_allcld_tau = Taero_cld_tau/Taero_cld_numh
    aveaero_allcld_tauerr = Taero_cld_tauerr/Taero_cld_numh
	aero_allcld_fre=Taero_cld_numh/float(Tobsnumh)
	zonal_allcld_tau=total(Taero_cld_tau,1)/total(Taero_cld_numh,1)
	zonal_allcld_tauerr=total(Taero_cld_tauerr,1)/total(Taero_cld_numh,1)
	zonal_allcld_fre=total(Taero_cld_numh,1)/total(Tobsnumh,1)

	;globally weighted average
    print,'aerosol-cloud weighted fre',total(weights*total(aero_allcld_fre,1,/nan))/(72*total(weights))
	ind=where(Taero_cld_numh eq 0)
	aveaero_allcld_tau[ind]=0.0
	aveaero_allcld_tauerr[ind]=0.0
    print,'aerosol-cloud weighted tau',total(weights*total(aveaero_allcld_tau,1))/(72*total(weights))
    print,'aerosol-cloud weighted tauerr',total(weights*total(aveaero_allcld_tauerr,1))/(72*total(weights))

;   for total aerosols
	allaero_num=Taero_only_numh+Taero_cld_numh
	allaero_tau=Taero_only_tau+Taero_cld_tau
	allaero_tauerr=Taero_only_tauerr+Taero_cld_tauerr
	allaero_fre=allaero_num/float(Tobsnumh)
	allaero_avetau=allaero_tau/allaero_num
	allaero_avetauerr=allaero_tauerr/allaero_num
	print,'all aerosol weighted fre',total(weights*total(allaero_fre,1,/nan))/(72*total(weights))
	ind=where(allaero_num eq 0)
	allaero_avetau[ind]=0.0
	allaero_avetauerr[ind]=0.0
	print,'all aero weighted ave tau',total(weights*total(allaero_avetau,1,/nan))/(72*total(weights))
	print,'all aero weighted ave tauerr',total(weights*total(allaero_avetauerr,1,/nan))/(72*total(weights))
	
;    ca=image(allaero_avetau,lon,lat,rgb_table=33,min_value=0,max_value=1.0,$
;		font_size=fontsz)
;	mp=map('Geographic',limit=maplimit,transparency=30,overplot=ca)
;    grid=mp.MAPGRID
;    grid.label_position=0
;    grid.linestyle='dotted'
;    grid.grid_longitude=60
;    grid.grid_latitude=30
;	grid.font_size=fontsz-3
;    mc=mapcontinents(/continents,transparency=30)
;    mc['Longitudes'].label_angle=0
;	ca.scale,1,1.3


    c=image(aero_only_fre,lon,lat,dim=[750,400],rgb_table=33,min_value=0,max_value=1.0,$
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
	
    c1=image(aero_allcld_fre,lon,lat,rgb_table=33,min_value=0.0,max_value=1.0,$
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

    c2=image(aveaero_only_tau,lon,lat,rgb_table=33,min_value=0.0,max_value=1.0,$
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

    c3=image(aveaero_allcld_tau,lon,lat,rgb_table=33,min_value=0.0,max_value=1.0,$
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
;	c.save,'annual_aerosol_aod_freq_cad50.png'

stop
end
