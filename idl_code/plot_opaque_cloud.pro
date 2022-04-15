
pro plot_opaque_cloud

;	fname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen_2/','*.hdf')
	lidfname=file_search('/u/sciteam/yulanh/scratch/CALIOP/output','*.hdf')
    fnamelen=strlen(lidfname)

    ind=where(fnamelen eq 86)
    fname=lidfname[ind]

	Nf=n_elements(fname)

	dimx=60
	dimy=36

	fontsz=13
    Topaque_cld=dblarr(dimx,dimy)
	Tobsnumh=dblarr(dimx,dimy)
	
	Tfilter_all=0L

	lon=findgen(dimx)*6-180
    lat=findgen(dimy)*5-90+2.5


	 for fi=0,Nf-1 do begin
	    read_dardar,fname[fi],'obs_numh',obsnum
 	    Tobsnumh=Tobsnumh+obsnum
		read_dardar,fname[fi],'all_filter',filter_all
		Tfilter_all=Tfilter_all+filter_all

		read_dardar,fname[fi],'opaque_cloud_numh',opaquenum
		Topaque_cld=Topaque_cld+opaquenum

	endfor
	fre=float(Topaque_cld)/float(Tobsnumh-Tfilter_all)
	print,'total frequency',total(Topaque_cld)/float(total(Tobsnumh-Tfilter_all))
;	weights=cos(lat*!pi/180)
;	print,'ave opaque cloud frequency, weight average',total(weights*total(fre,1),/nan)/(dimx*total(weights))
	c=image(fre,lon,lat,rgb_table=33,min_value=0,max_value=0.6,font_size=fontsz)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
    grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=60
    grid.grid_latitude=30
    grid.font_size=fontsz-3
    mc=mapcontinents(/continents,transparency=30)
    mc['Longitudes'].label_angle=0
	c.scale,7,8
	bartitle='Occurrence Frequency'	
	ct=colorbar(target=c,title=bartitle,taper=1,$
            border=1,font_size=fontsz-1,orientation=0)

	c.save,'opaque_cloud_frequency_noscreen.png'
	stop	
end
