pro plot_aerosol_only,obsnumh,aeronumh,aerotau,obsnumv,aeronumv,lat,lon,$
	maplimit,fname
 
   
	horfre=aeronumh/float(obsnumh)
	verfre=aeronumv/float(obsnumv)
	aerotau1=aerotau

    pos1=[0.05,0.60,0.24,0.95]
    pos2=[0.05,0.18,0.24,0.53]
    pos3=[0.27,0.60,0.47,0.95]

    n=21
    index=findgen(21)*12.5	
    fontsz=12 
	
    horlevs=[0,0.02,0.04,0.06,0.08,0.1,0.125,0.15,0.175,0.2,$
             0.25,0.3,0.35,0.4,0.45,0.5,0.6,0.7,$
             0.8,0.9,1]
    tickname=['0','','','','','0.1','','','','0.2','','0.3','',$
        '0.4','','0.5','','0.7','','','1.0']

    title=' Aerosols without cloud overlap CAD Score > 20'

	title1='a) Aerosol frequency'
    c=contour(horfre,lon,lat,c_value=horlevs,n_levels=n,$
        dim=[1000,500],rgb_table=33,rgb_indices=index,/fill,$
        position=pos1,font_size=fontsz)
        mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
        grid=mp.MAPGRID
        grid.label_position=0
        grid.linestyle='dotted'
        grid.grid_longitude=20
        mc=mapcontinents(/continents,transparency=30)
        mc['Longitudes'].label_angle=0
        t=text(pos1[0],pos1[3],title1,font_size=fontsz,/normal)

	title1='b) AOD'
    c1=contour(aerotau1,lon,lat,c_value=horlevs,n_levels=n,$
        rgb_table=33,rgb_indices=index,/fill,$
        position=pos2,font_size=fontsz,/current)
        mp=map('Geographic',limit=maplimit, overplot=c1,transparency=30)
        grid=mp.MAPGRID
        grid.label_position=0
        grid.linestyle='dotted'
        grid.grid_longitude=20
        mc=mapcontinents(/continents,transparency=30)
        mc['Longitudes'].label_angle=0
        t=text(pos1[0],pos1[3],title1,font_size=fontsz,/normal)

	hgt=25-findgen(101)*0.25
  	horlevs=findgen(n)*0.004+0.005
    tickname=['0.005','','','','','0.025','','','','','0.045','','',$
         '','','0.065','','','','','0.085']

	c2=contour(verfre,lat,hgt,c_value=horlevs,n_levels=n,$
        rgb_table=33,rgb_indices=index,/fill,/current,$
        position=pos3,font_size=fontsz,axis_style=2,yrange=yrange,$
        xtitle='Latitude',ytitle='Altitude (km)')

    t=text(pos[0],pos3[3]+0.01,title,font_size=fontsz,/normal)

  stop	
end
