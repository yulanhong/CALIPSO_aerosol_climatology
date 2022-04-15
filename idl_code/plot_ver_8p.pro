
   pro plot_ver_8p,highcad,lowcad,icenum,watnum,uncernum,icewatnum,iceuncernum,watuncernum,obsnum,lon,lat

   nx=n_elements(lon)
   ny=n_elements(lat)
   hgt=25-findgen(101)*0.25
   monind=[2,3,4]
   lonind=6 ;8,10 107.5,117.5,127.5
   lontext='Lon 107.5$\deg$'
   
   highcad_1=total(highcad[*,*,*,monind],4)
   lowcad_1=total(lowcad[*,*,*,monind],4)
   icenum_1=total(icenum[*,*,*,monind],4)
   watnum_1=total(watnum[*,*,*,monind],4)
   uncernum_1=total(uncernum[*,*,*,monind],4)
   icewatnum_1=total(icewatnum[*,*,*,monind],4)
   iceuncernum_1=total(iceuncernum[*,*,*,monind],4)
   watuncernum_1=total(watuncernum[*,*,*,monind],4)
   tpobsnum=total(obsnum[*,*,*,monind],4)
 
   pos1=[0.05,0.62,0.24,0.95]
   pos2=[0.05,0.20,0.24,0.53]
   pos3=[0.28,0.62,0.48,0.95]
   pos4=[0.28,0.20,0.48,0.53]
   pos5=[0.52,0.62,0.72,0.95]
   pos6=[0.52,0.20,0.72,0.53]
   pos7=[0.76,0.62,0.96,0.95]
   pos8=[0.76,0.20,0.96,0.53]
 
   fontsz=10
   yrange=[0,20] 
   n=21
  index=findgen(n)*12.5
  horlevs=findgen(n)*0.004
 
;   horlevs=findgen(n)*0.01
;   horlevs=horlevs[1:n-1]
;   tickname=['0.01','','','','','0.06','','','','0.1','','','',$
;        '0.14','','','','','','0.2']

    horlevs=findgen(n)*0.004+0.005
    
    tickname=['0.005','','','','','0.025','','','','','0.045','','',$
         '','','0.065','','','','','0.085']
 
   For i=0,7 Do Begin
    if i eq 0 then begin
	title='a) Cloud CAD Score > 20 '
	xtitle=''
	ytitle='Altitude (km)'
 	verfre=reform(highcad_1[lonind,*,*])/reform(tpobsnum[lonind,*,*])
	c=contour(verfre,lat,hgt,c_value=horlevs,n_levels=n,$
       	dim=[1000,500],rgb_table=33,rgb_indices=index,/fill,$
      	position=pos1,font_size=fontsz,axis_style=2,yrange=yrange,$
	xtitle=xtitle,ytitle=ytitle)

	t=text(pos1[0],pos1[3]+0.01,title,font_size=fontsz,/normal)
	t1=text(pos1[2]-0.08,pos1[3]-0.04,lontext,font_size=fontsz,/normal)
    endif

    if i eq 1 then begin
	pos=pos2
	xtitle='Latitude (deg)'
	ytitle='Altitude (km)'
 	verfre=reform(lowcad_1[lonind,*,*])/reform(tpobsnum[lonind,*,*])
	title='b) Cloud CAD Score <= 20'
    endif
    if i eq 2 then begin
	title='c) Ice Cloud '
	xtitle=''
	ytitle=''
	pos=pos3
 	verfre=reform(icenum_1[lonind,*,*])/reform(tpobsnum[lonind,*,*])
    endif     

    if i eq 3 then begin
	pos=pos4
	title='d) Liquid-unknow Cloud'
	xtitle='Latitude (deg)'
	ytitle=''
 	verfre=reform(watuncernum_1[lonind,*,*])/reform(tpobsnum[lonind,*,*])
    endif

    if i eq 4 then begin
	pos=pos5
	title='e) Liquid Cloud'
	xtitle=''
	ytitle=''
 	verfre=reform(watnum_1[lonind,*,*])/reform(tpobsnum[lonind,*,*])
    endif     

    if i eq 5 then begin
	pos=pos6
	title='f) Ice-liquid Cloud '
	xtitle='Latitude (deg)'
	ytitle=''
 	verfre=reform(icewatnum_1[lonind,*,*])/reform(tpobsnum[lonind,*,*])
    endif

    if i eq 6 then begin
	title='g) Unknow Cloud'
	pos=pos7
	xtitle=''
	ytitle=''
 	verfre=reform(uncernum_1[lonind,*,*])/reform(tpobsnum[lonind,*,*])
    endif     

    if i eq 7 then begin
	title='h) Ice-unknow Cloud'
	xtitle='Latitude (deg)'
	ytitle=''
	pos=pos8
 	verfre=reform(iceuncernum_1[lonind,*,*])/reform(tpobsnum[lonind,*,*])
    endif     

    if i ge 1 then begin 

	c1=contour(verfre,lat,hgt,c_value=horlevs,n_levels=n,$
       	rgb_table=33,rgb_indices=index,/fill,/current,$
      	position=pos,font_size=fontsz,axis_style=2,yrange=yrange,$
	xtitle=xtitle,ytitle=ytitle)
	
	t=text(pos[0],pos[3]+0.01,title,font_size=fontsz,/normal)
	t1=text(pos[2]-0.08,pos[3]-0.04,lontext,font_size=fontsz,/normal)
   endif
	
   EndFor

     barpos=[pos1[2],pos2[1]-0.1,pos7[0],pos2[1]-0.08]
     ct=colorbar(target=c1,title='Cloud Frequency',taper=0,border=1,$
        orientation=0,position=barpos,tickname=tickname)
     ct.font_size=fontsz
 
  c.save,'aerosol_cloud_classifyver_JJASON.png' 
 end
