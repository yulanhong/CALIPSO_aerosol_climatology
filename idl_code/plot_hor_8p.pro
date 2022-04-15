
 pro plot_hor_8p,highcad,lowcad,icenum,watnum,uncernum,icewatnum,iceuncernum,watuncernum,horobs,lon,lat,maplimit

   nx=n_elements(lon)
   ny=n_elements(lat)

   monind=[2,3,4]
   highcad_1=total(highcad[*,*,monind],3) 
   lowcad_1=total(lowcad[*,*,monind],3) 
   icenum_1=total(icenum[*,*,monind],3) 
   watnum_1=total(watnum[*,*,monind],3) 
   uncernum_1=total(uncernum[*,*,monind],3) 
   icewatnum_1=total(icewatnum[*,*,monind],3) 
   iceuncernum_1=total(iceuncernum[*,*,monind],3) 
   watuncernum_1=total(watuncernum[*,*,monind],3) 
   tphorobs=total(horobs[*,*,monind],3) 

   pos1=[0.05,0.60,0.24,0.95]
   pos2=[0.05,0.18,0.24,0.53]
   pos3=[0.27,0.60,0.47,0.95]
   pos4=[0.27,0.18,0.47,0.53]
   pos5=[0.50,0.60,0.70,0.95]
   pos6=[0.50,0.18,0.70,0.53]
   pos7=[0.73,0.60,0.93,0.95]
   pos8=[0.73,0.18,0.93,0.53]
 
   fontsz=11 
   
   n=21
   index=findgen(n)*12.5
;   horlevs=findgen(n)*0.025
   horlevs=[0,0.02,0.04,0.06,0.08,0.1,0.125,0.15,0.175,0.2,$
	     0.25,0.3,0.35,0.4,0.45,0.5,0.6,0.7,$
	     0.8,0.9,1]
   tickname=['0','','','','','0.1','','','','0.2','','0.3','',$
        '0.4','','0.5','','0.7','','','1.0']
 
   For i=0,7 Do Begin
    if i eq 0 then begin
	title='a) Clouds CAD Score > 20'
 	horfre=highcad_1/float(tphorobs)
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

	t=text(pos1[0],pos1[3],title,font_size=fontsz,/normal)
    endif
    if i eq 1 then begin
	pos=pos2
	horfre=lowcad_1/float(tphorobs)
	title='b) Clouds CAD Score <= 20'
    endif
    if i eq 2 then begin
	title='c) Ice Cloud'
 	horfre=icenum_1/float(tphorobs)
	pos=pos3
    endif     

    if i eq 3 then begin
	pos=pos4
	horfre=watuncernum_1/float(tphorobs)
	title='d) Liquid-unknow Cloud'
    endif

    if i eq 4 then begin
	title='e) Liquid Cloud'
 	horfre=watnum_1/float(tphorobs)
	pos=pos5
    endif     

    if i eq 5 then begin
	pos=pos6
	horfre=icewatnum_1/float(tphorobs)
	title='f) Ice-liquid Cloud'
    endif

    if i eq 6 then begin
	title='g) Unknow Cloud'
 	horfre=uncernum_1/float(tphorobs)
	pos=pos7
    endif     

    if i eq 7 then begin
	title='h) Ice-unknow Cloud'
 	horfre=iceuncernum_1/float(tphorobs)
	pos=pos8
    endif     

    if i ge 1 then begin 
	c1=contour(horfre,lon,lat,c_value=horlevs,n_levels=n,$
       	rgb_table=33,rgb_indices=index,/fill,/current,$
      	position=pos,font_size=fontsz)
	mp=map('Geographic',limit=maplimit, overplot=c1,transparency=30)
   	grid=mp.MAPGRID
   	grid.label_position=0
   	grid.linestyle='dotted'
   	grid.grid_longitude=20
	mc=mapcontinents(/continents,transparency=30)
  	mc['Longitudes'].label_angle=0

	t=text(pos[0],pos[3],title,font_size=fontsz,/normal)
   endif
	
   EndFor

     barpos=[pos1[2],pos2[1]-0.08,pos7[0],pos2[1]-0.05]
     ct=colorbar(target=c1,title='Cloud Frequency',taper=0,border=1,$
        orientation=0,position=barpos,tickname=tickname)
     ct.font_size=fontsz
 
   c.save,'aerosol_cloud_classifyhor_JJASON.png' 
 end
