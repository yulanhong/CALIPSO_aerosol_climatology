pro plot_cloud_4p,obsnumh,icenumh_aero,icenumh_noaero,watnumh_aero,watnumh_noaero,$
	lat,lon,maplimit,fname
 
    icefre_aero=icenumh_aero/float(obsnumh)
    icefre_noaero=icenumh_noaero/float(obsnumh)
    watfre_aero=watnumh_aero/float(obsnumh)
    watfre_noaero=watnumh_noaero/float(obsnumh)

    pos1=[0.1,0.55,0.45,1.0]
    pos2=[0.55,0.55,0.90,1.0]
    pos3=[0.1,0.13,0.45,0.55]
    pos4=[0.55,0.13,0.90,0.55]

;    n=21
;    index=findgen(21)*12.5	
    fontsz=10
	
;    horlevs=[0,0.02,0.04,0.06,0.08,0.1,0.125,0.15,0.175,0.2,$
;             0.25,0.3,0.35,0.4,0.45,0.5,0.6,0.7,$
;             0.8,0.9,1]
;    tickname=['0','','','','','0.1','','','','0.2','','0.3','',$
;        '0.4','','0.5','','0.7','','','1.0']

    title='Cloud With Aerosol Overlap'

    c=image(icefre_aero,lon,lat,dim=[600,500],rgb_table=33,$
        position=pos1,max_value=0.7,min_value=0.0)
        mp=map('Geographic',limit=maplimit, overplot=c,transparency=30,$
	font_size=fontsz)
        grid=mp.MAPGRID
        grid.label_position=0
        grid.linestyle='dotted'
        grid.grid_longitude=90
        grid.grid_latitude=45
        mc=mapcontinents(/continents,transparency=30)
        mc['Longitudes'].label_angle=0
        t=text(0.3,0.94,title,font_size=fontsz,/normal)
        t=text(0.12,0.90,'a)',font_size=fontsz,/normal)



    c1=image(watfre_aero,lon,lat,rgb_table=33,$
        position=pos2,/current,max_value=0.7,min_value=0.0)
        mp=map('Geographic',limit=maplimit, overplot=c1,transparency=30,$
	font_size=fontsz)
        grid=mp.MAPGRID
        grid.label_position=0
        grid.linestyle='dotted'
        grid.grid_longitude=90
        grid.grid_latitude=45
        mc=mapcontinents(/continents,transparency=30)
        mc['Longitudes'].label_angle=0
        t=text(0.56,0.90,'b)',font_size=fontsz,/normal)

    c2=image(icefre_noaero,lon,lat,rgb_table=33,$
        position=pos3,max_value=0.7,min_value=0.0,/current)
        mp=map('Geographic',limit=maplimit, overplot=c2,transparency=30,$
	font_size=fontsz)
        grid=mp.MAPGRID
        grid.label_position=0
        grid.linestyle='dotted'
        grid.grid_longitude=90
        grid.grid_latitude=45
        mc=mapcontinents(/continents,transparency=30)
        mc['Longitudes'].label_angle=0
    
	title=' Cloud without Aerosol Overlap'
        t=text(0.3,0.5,title,font_size=fontsz,/normal)
        t=text(0.12,0.46,'c)',font_size=fontsz,/normal)

	pos=c2.pos
	ct=colorbar(target=c2,title='Ice Cloud Frequency',taper=0,border=1,$
	orientation=0,position=[pos[0],pos[1]-0.08,pos[2],pos[1]-0.06],$
	font_size=fontsz)
	

    c3=image(watfre_noaero,lon,lat,rgb_table=33,$
        position=pos4,/current,max_value=0.7,min_value=0.0)
        mp=map('Geographic',limit=maplimit, overplot=c3,transparency=30,$
	font_size=fontsz)
        grid=mp.MAPGRID
        grid.label_position=0
        grid.linestyle='dotted'
        grid.grid_longitude=90
        grid.grid_latitude=45
        mc=mapcontinents(/continents,transparency=30)
        mc['Longitudes'].label_angle=0
        t=text(0.56,0.46,'d)',font_size=fontsz,/normal)

	pos=c3.pos
	ct=colorbar(target=c3,title='Water Cloud Frequency',taper=0,border=1,$
	orientation=0,position=[pos[0],pos[1]-0.08,pos[2],pos[1]-0.06],$
	font_size=fontsz)


	c.save,fname

      stop
 stop	
end
