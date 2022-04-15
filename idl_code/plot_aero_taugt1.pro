pro plot_aero_taugt1

  dir='/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap'

  fname=file_search(dir,'*.hdf')

  Nf=n_elements(fname)

  fontsz=13
  Taeroonlygt1=0L
  Tisolate_aerogt1=0L
  Tincloud_aerogt1=0L 

  Taeroonly=0L
  Tisolate_aero=0L
  Tincloud_aero=0L 

  dimx=72
  dimy=90
  lon=findgen(dimx)*5-180
  lat=findgen(dimy)*2-90+1

  for fi=0,Nf-1 do begin
	read_dardar,fname[fi],'aerosol_taugt1_only_numh',aeroonlygt1
	read_dardar,fname[fi],'aerosol_only_numh',aeroonly
	read_dardar,fname[fi],'isolate_aerosol_taugt1_num',isolate_aerogt1
	read_dardar,fname[fi],'isolate_aerosol_num',isolate_aero
	read_dardar,fname[fi],'incloud_aerosol_taugt1_num',incloud_aerogt1
	read_dardar,fname[fi],'incloud_aerosol_num',incloud_aero

	Taeroonlygt1=Taeroonlygt1+aeroonlygt1
	Tisolate_aerogt1=Tisolate_aerogt1+isolate_aerogt1
	Tincloud_aerogt1=Tincloud_aerogt1+incloud_aerogt1	

	Taeroonly=Taeroonly+aeroonly
	Tisolate_aero=Tisolate_aero+isolate_aero
	Tincloud_aero=Tincloud_aero+incloud_aero	

  endfor

  pos1=[0.08,0.74,0.98,0.96]
  pos2=[0.08,0.44,0.98,0.66]
  pos3=[0.08,0.14,0.98,0.36]

  maxvalue=0.5

  c=image(Taeroonlygt1/float(Taeroonly),lon,lat,dim=[450,650],min_value=0,max_value=maxvalue,font_size=fontsz,$
	position=pos1,rgb_table=33)
  mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
  grid=mp.MAPGRID
  grid.label_position=0
  grid.linestyle='dotted'
  grid.grid_longitude=60
  grid.grid_latitude=30
  grid.font_size=fontsz-3
  mc=mapcontinents(/continents,transparency=30)
  mc['Longitudes'].label_angle=0
  t1=text(pos1[0]+0.1,pos1[3]+0.01,'a) Cloud-free aerosol')  
  c.scale,1.1,1.0
;  ct=colorbar(target=c,title=bartitle,taper=1,position=barpos,$
;          border=1,font_size=fontsz-1,orientation=0)

  c1=image(total(Tisolate_aerogt1,3)/float(total(Tisolate_aero,3)),lon,lat,min_value=0,max_value=maxvalue,font_size=fontsz,$
	position=pos2,/current,rgb_table=33)
  mp=map('Geographic',limit=maplimit,transparency=30,overplot=c1)
  grid=mp.MAPGRID
  grid.label_position=0
  grid.linestyle='dotted'
  grid.grid_longitude=60
  grid.grid_latitude=30
  grid.font_size=fontsz-3
  mc=mapcontinents(/continents,transparency=30)
  mc['Longitudes'].label_angle=0
  t2=text(pos2[0]+0.1,pos2[3]+0.01,'b) Isolated-cloud aerosol')  
  c1.scale,1.1,1.0
  
;  ct=colorbar(target=c1,title=bartitle,taper=1,$
;          border=1,font_size=fontsz-1,orientation=0,position=barpos)

  c2=image(total(Tincloud_aerogt1,3)/float(total(Tincloud_aero,3)),lon,lat,min_value=0,max_value=maxvalue,font_size=fontsz,$
	position=pos3,/current,rgb_table=33)
  mp=map('Geographic',limit=maplimit,transparency=30,overplot=c2)
  grid=mp.MAPGRID
  grid.label_position=0
  grid.linestyle='dotted'
  grid.grid_longitude=60
  grid.grid_latitude=30
  grid.font_size=fontsz-3
  mc=mapcontinents(/continents,transparency=30)
  mc['Longitudes'].label_angle=0
  t3=text(pos3[0]+0.1,pos3[3]+0.01,'c) In-cloud aerosol')  
  
  bartitle='Fraction of aerosol with $\tau$ > 1.0'
  barpos=[pos3[0]+0.1,pos3[1]-0.06,pos3[2]-0.1,pos3[1]-0.04]
  ct=colorbar(target=c2,title=bartitle,taper=1,$
          border=1,font_size=fontsz-2,orientation=0,position=barpos)
  c2.scale,1.1,1.0
  c.save,'aerosol_only_cloud_taugt1_fraction.png'

 ;============= to plot above and below cloud aerosol
  pos1=[0.08,0.62,0.98,0.95]
  pos2=[0.08,0.19,0.98,0.52]
  maxvalue=0.3
  p=image((reform(Tisolate_aerogt1[*,*,0])+reform(Tisolate_aerogt1[*,*,3]))/float(total(Tisolate_aero,3)),lon,lat,$
	min_value=0,max_value=maxvalue,font_size=fontsz,$
	position=pos1,rgb_table=33,dim=[450,450])
  mp=map('Geographic',limit=maplimit,transparency=30,overplot=p)
  grid=mp.MAPGRID
  grid.label_position=0
  grid.linestyle='dotted'
  grid.grid_longitude=60
  grid.grid_latitude=30
  grid.font_size=fontsz-3
  mc=mapcontinents(/continents,transparency=30)
  mc['Longitudes'].label_angle=0
  t2=text(pos1[0]+0.1,pos1[3]+0.01,'a) Below-cloud aerosol')  
  p.scale,1.1,1.0

  p1=image(10.0*(reform(Tisolate_aerogt1[*,*,1])+reform(Tisolate_aerogt1[*,*,4]))/float(total(Tisolate_aero,3)),lon,lat,$
	min_value=0,max_value=maxvalue,font_size=fontsz,$
	position=pos2,/current,rgb_table=33)
  mp=map('Geographic',limit=maplimit,transparency=30,overplot=p1)
  grid=mp.MAPGRID
  grid.label_position=0
  grid.linestyle='dotted'
  grid.grid_longitude=60
  grid.grid_latitude=30
  grid.font_size=fontsz-3
  mc=mapcontinents(/continents,transparency=30)
  mc['Longitudes'].label_angle=0
  t2=text(pos2[0]+0.1,pos2[3]+0.01,'b) Above-cloud aerosol(x 0.1)')  

  bartitle='Fraction of aerosol with $\tau$ > 1.0'
  barpos=[pos2[0]+0.1,pos2[1]-0.07,pos2[2]-0.1,pos2[1]-0.05]
  ct=colorbar(target=p2,title=bartitle,taper=1,$
          border=1,font_size=fontsz-2,orientation=0,position=barpos)
  p1.scale,1.1,1.0
  p.save,'aerosol_isolated_cloud_taugt1_fraction.png'

	stop

end
