
pro plot_annual_aerosol_fretau
 
	print,systime()

   lidfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/all_aerosols','*.hdf')

   Nf=n_elements(lidfname)
   Nmon=Nf ;5-10
   month=intarr(Nmon)
   wyear=dblarr(Nmon)
   
   latres=2
   lonres=5
   dimx=360/lonres
   dimy=180/latres
   dimh=101 

   maplimit=[-10,80,30,150]

   Tobsnumh=Ulonarr(dimx,dimy)
   Ticenumh=Ulonarr(dimx,dimy)
   Twatnumh=Ulonarr(dimx,dimy)
   Tuncernumh=Ulonarr(dimx,dimy)
   Ticewatnumh=Ulonarr(dimx,dimy)
   Ticeuncernumh=Ulonarr(dimx,dimy)
   Twatuncernumh=Ulonarr(dimx,dimy)
   Tlowconfnumh=Ulonarr(dimx,dimy)

   Taero_only_numh=Ulonarr(dimx,dimy)
   Taero_all_tau=Dblarr(dimx,dimy)
   Taero_only_tau=Dblarr(dimx,dimy)
   Taero_cld_tau=Dblarr(dimx,dimy,6) 
   temp_aerocld_tau=Dblarr(dimx,dimy,6)

 
   for i=0,Nf-1 do begin
	fname=lidfname[i]
	year=strmid(fname,9,4,/rev)

	IF (strlen(fname) eq 113 and year ne '2006') Then Begin; and year ne '2017') Then Begin

 	print,fname

	read_dardar,fname,'latitude',lat 
	read_dardar,fname,'longitude',lon
	read_dardar,fname,'height',hgt
	read_dardar,fname,'obs_numh',obsnumh
	
    ;********** with aerosols ********************	
	read_dardar,fname,'aerosol_ice_numh',aeroicenumh
	read_dardar,fname,'aerosol_water_numh',aerowatnumh
	read_dardar,fname,'aerosol_uncer_numh',aerouncernumh
	read_dardar,fname,'aerosol_icewat_numh',aeroicewatnumh
	read_dardar,fname,'aerosol_iceuncer_numh',aeroiceuncernumh
	read_dardar,fname,'aerosol_watuncer_numh',aerowatuncernumh
	read_dardar,fname,'aerosol_cloud_tau',aero_cld_tau
	read_dardar,fname,'aerosol_only_numh',aero_only_numh
	read_dardar,fname,'aerosol_only_tau',aero_only_tau
   	
	Tobsnumh=Tobsnumh+obsnumh
  	Ticenumh=Ticenumh+aeroicenumh
   	Twatnumh=Twatnumh+aerowatnumh
   	Tuncernumh=Tuncernumh+aerouncernumh
   	Ticewatnumh=Ticewatnumh+aeroicewatnumh
   	Ticeuncernumh=Ticeuncernumh+aeroiceuncernumh
   	Twatuncernumh=Twatuncernumh+aerowatuncernumh

   	Taero_only_numh = Taero_only_numh + aero_only_numh
	aeroind=where(finite(aero_only_tau) eq 0)
	If (aeroind[0] ne -1) then aero_only_tau[aeroind]=0.0
   	Taero_only_tau=Taero_only_tau+aero_only_tau*aero_only_numh
	
	aeroind=where(finite(aero_cld_tau) eq 0)
    temp_aerocld_tau=Dblarr(dimx,dimy,6)
	If(aeroind[0] ne -1) then aero_cld_tau[aeroind]=0.0
		temp_aerocld_tau[*,*,0]=aero_cld_tau[*,*,0]*aeroicenumh
		temp_aerocld_tau[*,*,1]=aero_cld_tau[*,*,1]*aerouncernumh
		temp_aerocld_tau[*,*,2]=aero_cld_tau[*,*,2]*aerowatnumh
		temp_aerocld_tau[*,*,3]=aero_cld_tau[*,*,3]*aeroicewatnumh
		temp_aerocld_tau[*,*,4]=aero_cld_tau[*,*,4]*aeroiceuncernumh
		temp_aerocld_tau[*,*,5]=aero_cld_tau[*,*,5]*aerowatuncernumh

   	Taero_cld_tau = Taero_cld_tau + temp_aerocld_tau

	;for all aerosols 
	Taero_all_tau = Taero_all_tau + aero_only_tau*aero_only_numh+total(temp_aerocld_tau,3)

	EndIf; endif strlen(fname)	
   endfor

    allcldnumh=Ticenumh+Twatnumh+Tuncernumh+$
	Ticewatnumh+Ticeuncernumh+Twatuncernumh

    aveaero_only_tau=fltarr(dimx,dimy)
    aveaero_cld_tau=fltarr(dimx,dimy,6)
    aveaero_allcld_tau=fltarr(dimx,dimy)
	aero_cld_fre=fltarr(dimx,dimy,6)

	aveaero_only_tau=Taero_only_tau/Taero_only_numh
	aero_only_fre=Taero_only_numh/float(Tobsnumh)
	zonal_aeroonly_tau=total(Taero_only_tau,1)/total(Taero_only_numh,1)		
	zonal_aeroonly_fre=total(Taero_only_numh,1)/total(Tobsnumh,1)		
	; area weighted averages
	weights=cos(lat*!pi/180)
	ind=where(Tobsnumh eq 0)
	aero_only_fre[ind]=0.0
;	area_weighted_mean,weights,aero_only_fre
    print,'aerosol only weighted fre',total(weights*total(aero_only_fre,1))/(72*total(weights))

	ind=where(Taero_only_numh eq 0)
	aveaero_only_tau[ind]=0.0
    print,'aerosol only weighted tau',total(weights*total(aveaero_only_tau,1))/(72*total(weights))

	aveaero_cld_tau[*,*,0]=Taero_cld_tau[*,*,0]/Ticenumh
	aveaero_cld_tau[*,*,1]=Taero_cld_tau[*,*,1]/Tuncernumh
	aveaero_cld_tau[*,*,2]=Taero_cld_tau[*,*,2]/Twatnumh
	aveaero_cld_tau[*,*,3]=Taero_cld_tau[*,*,3]/Ticewatnumh
	aveaero_cld_tau[*,*,4]=Taero_cld_tau[*,*,4]/Ticeuncernumh
	aveaero_cld_tau[*,*,5]=Taero_cld_tau[*,*,5]/Twatuncernumh
        
	aero_cld_fre[*,*,0]=Ticenumh/Tobsnumh
	aero_cld_fre[*,*,1]=Tuncernumh/Tobsnumh
	aero_cld_fre[*,*,2]=Twatnumh/Tobsnumh
	aero_cld_fre[*,*,3]=Ticewatnumh/Tobsnumh
	aero_cld_fre[*,*,4]=Ticeuncernumh/Tobsnumh
	aero_cld_fre[*,*,5]=Twatuncernumh/Tobsnumh
 
    lon=findgen(dimx)*5-180
    lat=findgen(dimy)*2-90 
    aveaero_allcld_tau = total(Taero_cld_tau,3)/allcldnumh
    aero_allcld_fre=float(allcldnumh)/tobsnumh 
	zonal_allcld_tau=total(total(Taero_cld_tau,3),1)/total(allcldnumh,1)
	zonal_allcld_fre=total(allcldnumh,1)/total(Tobsnumh,1)
	; globally weighted average
	weights=cos(lat*!pi/180)
	ind=where(Tobsnumh eq 0)
	aero_allcld_fre[ind]=0.0
    print,'aerosol-cloud weighted fre',total(weights*total(aero_allcld_fre,1))/(72*total(weights))
	ind=where(allcldnumh eq 0)
	aveaero_allcld_tau[ind]=0.0
    print,'aerosol-cloud weighted tau',total(weights*total(aveaero_allcld_tau,1))/(72*total(weights))

    pos1=[0.05,0.55,0.35,0.90]
    pos2=[0.40,0.55,0.70,0.90]
    pos3=[0.05,0.10,0.35,0.45]
    pos4=[0.40,0.10,0.70,0.45]
	barpos1=[0.78,0.54,0.80,0.91]
	barpos2=[0.78,0.09,0.80,0.46]
	ppos1=[0.89,0.57,0.98,0.92]
	ppos2=[0.89,0.10,0.98,0.45]
	fontsz=12
    lnthick=2

    c=image(aero_only_fre,lon,lat,dim=[750,400],rgb_table=33,min_value=0,max_value=1.0,$
		position=pos1,font_size=fontsz)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
    grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20
    grid.grid_latitude=10
	grid.font_size=fontsz-3
    mc=mapcontinents(/continents,transparency=30)
    mc['Longitudes'].label_angle=0
	c.scale,1,1.0
	t1=text(pos1[0]+0.02,pos1[3]+0.02,'a)',font_size=fontsz)
	t11=text(pos1[0]+0.065,pos1[3]+0.02,'Cloud-free Aerosol',font_size=fontsz+1)
	
    c1=image(aero_allcld_fre,lon,lat,rgb_table=33,min_value=0.0,max_value=1.0,$
		position=pos2,/current,font_size=fontsz)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=c1)
    grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20
    grid.grid_latitude=10
	grid.font_size=fontsz-3
    mc=mapcontinents(/continents,transparency=30)
    mc['Longitudes'].label_angle=0
	c1.scale,1,1.0
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
    grid.grid_longitude=20
    grid.grid_latitude=10
	grid.font_size=fontsz-3
    mc=mapcontinents(/continents,transparency=30)
    mc['Longitudes'].label_angle=0
	c2.scale,1,1.0
	t4=text(pos3[0]+0.02,pos3[3]+0.02,'c)',font_size=fontsz)

    c3=image(aveaero_allcld_tau,lon,lat,rgb_table=33,min_value=0.0,max_value=1.0,$
		position=pos4,/current)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=c3)
    grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20
    grid.grid_latitude=10
	grid.font_size=fontsz-3

    mc=mapcontinents(/continents,transparency=30)
    mc['Longitudes'].label_angle=0
	c3.scale,1,1.0
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
	c.save,'annual_aerosol_aod_freq_SEA.png'

stop
end
