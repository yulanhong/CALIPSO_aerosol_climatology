
pro plot_distribution_filters

 	fname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen_2','*.hdf')

	Nf=n_elements(fname)

	Tobsnum=0L
	Tfiltercad=0L
	Tfilterci=0L
	Tfilter_extqc=0L
	Tfilter_aod=0L
	Tfilter_all=0L

	for fi=0,Nf-1 do begin
		IF (strlen(fname[fi]) eq 139) Then Begin
			read_dardar,fname[fi],'latitude',lat
			read_dardar,fname[fi],'longitude',lon
			read_dardar,fname[fi],'obs_numh',obsnum
			read_dardar,fname[fi],'Lowcad_filter',filtercad
			read_dardar,fname[fi],'qcext_filter',filterextqc
			read_dardar,fname[fi],'largeaod_filter',filteraod
			read_dardar,fname[fi],'cirrus_filter',filterci
			read_dardar,fname[fi],'all_filter',filterall

			Tfiltercad=Tfiltercad+filtercad
			Tfilterci=Tfilterci+filterci
			Tfilter_extqc=Tfilter_extqc+filterextqc
			Tfilter_aod=Tfilter_aod+filteraod
			Tfilter_all=Tfilter_all+filterall
			Tobsnum=Tobsnum+obsnum
		EndIf
	endfor


	print,'filter all',total(Tfilter_all)/float(total(Tobsnum))
	print,'filter cad fre',total(Tfiltercad)/float(total(Tobsnum))
	print,'filter ci fre',total(Tfilterci)/float(total(Tobsnum))
	print,'filter extqc fre',total(Tfilter_extqc)/float(total(Tobsnum))
	print,'filter aod fre',total(Tfilter_aod)/float(total(Tobsnum))
	
	data=fltarr(n_elements(lon),n_elements(lat),5)
	data[*,*,0]=Tfiltercad/float(Tobsnum)
	data[*,*,1]=Tfilterci/float(Tobsnum)
	data[*,*,2]=Tfilter_extqc/float(Tobsnum)
	data[*,*,3]=Tfilter_aod/float(Tobsnum)
	data[*,*,4]=Tfilter_all/float(Tobsnum)

	fontsz=13
	title=['CAD Score filter','Cirrus filter','Extinction QC filter','Isolated large AOD filter','All filter']
	for mi=0,4 do begin
		ca=image(reform(data[*,*,mi]),lon,lat,rgb_table=33,min_value=0,max_value=0.25,$
         font_size=fontsz,title=title[mi])
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
	    ct=colorbar(target=ca,title='Frequency',taper=1,$
	         border=1,position=[0.25,0.25,0.75,0.28],font_size=fontsz-1,orientation=0)

	   ca.save,strcompress('filter_'+title[mi]+'_frequency.png',/rem)
	endfor
end
