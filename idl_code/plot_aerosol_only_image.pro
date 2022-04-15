pro plot_aerosol_only_image,obsnumh,aeronumh,aerotau,obsnumv,aeronumv,lat,lon,$
	maplimit,fname
   
;    month=1 ; 2-july
;    lonind=9 ;9-107.5 degree
;    montext='Jul.'
    horfre=aeronumh/float(obsnumh)
	verfre=aeronumv/float(obsnumv)
	aerotau1=aerotau

    pos1=[0.1,0.55,0.45,1.0]
    pos2=[0.55,0.55,0.90,1.0]
    pos3=[0.25,0.10,0.65,0.52]

;    n=21
;    index=findgen(21)*12.5	
    fontsz=11
	
;    horlevs=[0,0.02,0.04,0.06,0.08,0.1,0.125,0.15,0.175,0.2,$
;             0.25,0.3,0.35,0.4,0.45,0.5,0.6,0.7,$
;             0.8,0.9,1]
;    tickname=['0','','','','','0.1','','','','0.2','','0.3','',$
;        '0.4','','0.5','','0.7','','','1.0']

    title=' Aerosols Without Cloud Overlap'

	title1= 'Aerosol frequency'
    c=image(horfre,lon,lat,dim=[600,500],rgb_table=33,$
        position=pos1,max_value=1.0,min_value=0.0)
        mp=map('Geographic',limit=maplimit, overplot=c,transparency=30,$
	font_size=fontsz)
        grid=mp.MAPGRID
        grid.label_position=0
        grid.linestyle='dotted'
        grid.grid_longitude=45
        mc=mapcontinents(/continents,transparency=30)
        mc['Longitudes'].label_angle=0
        t=text(0.3,0.94,title,font_size=fontsz,/normal)
        t=text(0.12,0.90,'a)',font_size=fontsz,/normal)

	pos=c.pos
	ct=colorbar(target=c,title='Aerosol Frequency',taper=0,border=1,$
	orientation=0,position=[pos[0],pos[1]-0.08,pos[2],pos[1]-0.06],$
	font_size=fontsz)

	title1='b) AOD'

    c1=image(aerotau1,lon,lat,rgb_table=33,$
        position=pos2,/current,max_value=1.5,min_value=0.0)
        mp=map('Geographic',limit=maplimit, overplot=c1,transparency=30,$
	font_size=fontsz)
        grid=mp.MAPGRID
        grid.label_position=0
        grid.linestyle='dotted'
        grid.grid_longitude=45
        mc=mapcontinents(/continents,transparency=30)
        mc['Longitudes'].label_angle=0
        t=text(pos1[0],pos1[3],title1,font_size=fontsz,/normal)
	pos=c1.pos
	ct=colorbar(target=c1,title='AOD',taper=0,border=1,$
	orientation=0,position=[pos[0],pos[1]-0.08,pos[2],pos[1]-0.06],$
	font_size=fontsz)
        t=text(0.55,0.90,'b)',font_size=fontsz,/normal)


	hgt=25-findgen(101)*0.25
	
	c2= image(verfre,lat,hgt,yrange=[0,10],$
        rgb_table=33,/current,position=pos3,axis_style=2,$
        xtitle='Latitude',ytitle='Altitude (km)')
	pos=c2.pos
	ct=colorbar(target=c2,title='Aerosol Frequency',taper=0,border=1,$
	orientation=1,position=[pos[2]+0.12,pos[1],pos[2]+0.14,pos[3]],$
	font_size=fontsz)
        t=text(pos3[0]+0.05,0.45,'c)',font_size=fontsz,/normal)

;    t=text(pos3[0],pos3[3]+0.01,title,font_size=fontsz,/normal)

	c.save,fname	
end
