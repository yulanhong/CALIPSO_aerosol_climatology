
pro plot_allcld_twoseason,hornum,horobs,vernum,verobs,lat,lon
   
;  csea_horfre=float(reform(hornum[*,*,11])+total(hornum[*,*,0:4],3))/(reform(horobs[*,*,11])+total(horobs[*,*,0:4],3))
;  wsea_horfre=float(total(hornum[*,*,5:10],3))/total(horobs[*,*,5:10],3)
  slmon1=0
  slmon2=1
  montext1='May.'
  montext2='Jun.'
  csea_horfre=float(reform(hornum[*,*,slmon1]))/(reform(horobs[*,*,slmon1]))
  wsea_horfre=float(reform(hornum[*,*,slmon2]))/(reform(horobs[*,*,slmon2]))

  hgt=25-(findgen(101)+1)*0.25
  fontsz=11 

  n=21
  index=findgen(n)*12.5
  horlevs=findgen(n)*0.05
  tickname=['0','','','','0.2','','','','0.4','','','','0.6',$
	'','','','0.8','','','','1.0']
  pos1=[0.10,0.80,0.50,0.95]
  pos2=[0.55,0.80,0.95,0.95]
  barpos1=[pos1[0],pos1[1]-0.05,pos2[2],pos1[1]-0.03]
  bartitle='Cloud Frequency'
  pos3=[0.10,0.52,0.50,0.67]
  pos4=[0.55,0.52,0.95,0.67]
  pos5=[0.10,0.31,0.50,0.46]
  pos6=[0.55,0.31,0.95,0.46]
  pos7=[0.10,0.10,0.50,0.25]
  pos8=[0.55,0.10,0.95,0.25]
  barpos2=[pos7[0],pos7[1]-0.05,pos8[2],pos8[1]-0.03]
  bartitle2='Crosssection of Cloud Top Frequency'
  verlevs=findgen(n)*0.01
  verlevs=verlevs[1:n-1]
  ticknamever=['0.01','','','','','0.06','','','','0.1','','','',$
        '0.14','','','','','','0.2']
;  verlevs=findgen(n)*0.025
;  tickname=['0.0','','','','0.1','','','','0.2','','','','0.3','',$
;        '','','0.4','','','','0.5']


  maplimit=[-10,75,35,155]

    
  c=contour(csea_horfre,lon,lat,c_value=horlevs,n_levels=n,$
      dim=[550,850],rgb_table=33,rgb_indices=index,/fill,title=$
      'a) '+montext1+' CC Cloud Frequency',position=pos1,font_size=fontsz)
   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'
   grid.grid_longitude=20
  nlon=n_elements(lon)
  xlon=fltarr(nlon)
  xlon[*]=107.5
  p=plot(xlon,lat,overplot=c,/current)
  xlon[*]=117.5
  p1=plot(xlon,lat,overplot=c,/current)
  xlon[*]=127.5
  p2=plot(xlon,lat,overplot=c,/current)

  mc=mapcontinents(/continents,transparency=30)
  mc['Longitudes'].label_angle=0

  c1=contour(wsea_horfre,lon,lat,c_value=horlevs,n_levels=n,$
      rgb_table=33,rgb_indices=index,/fill,title=$
      'b) '+montext2+' CC Cloud Frequency',position=pos2,/current,font_size=fontsz)

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'
   grid.grid_longitude=20
  mc=mapcontinents(/continents,transparency=30)
   mc['Longitudes'].label_angle=0
 
  ct=colorbar(target=c,title=bartitle,taper=0,border=1,$
        orientation=0,position=barpos1,tickname=tickname) 
  ct.font_size=fontsz

  vind=[6,8,10]
  for i=0,2 do begin 
   vernum1=reform(vernum[vind[i],*,*,*])	
   verobs1=reform(verobs[vind[i],*,*,*])	
  csea_verfre=float(reform(vernum1[*,*,slmon1]))/(reform(verobs1[*,*,slmon1]))

  wsea_verfre=float(reform(vernum1[*,*,slmon2]))/(reform(verobs1[*,*,slmon2]))
;   csea_verfre=float(reform(vernum1[*,*,11])+total(vernum1[*,*,0:4],3))/(reform(verobs1[*,*,11])+total(verobs1[*,*,0:4],3))
 
;   wsea_verfre=float(total(vernum1[*,*,5:10],3))/total(verobs1[*,*,5:10],3)
   if i eq 0 then begin
	pos11=pos3
	pos12=pos4
	title1='c) '+montext1+' 107.5 $\deg$'
	title2='d) '+montext2+' 107.5 $\deg$' 
   endif
   if i eq 1 then begin
	pos11=pos5
	pos12=pos6
	title1='e) '+montext1+' 117.5 $\deg$'
	title2='f) '+montext2+' 117.5 $\deg$' 
   endif
   if i eq 2 then begin
	pos11=pos7
	pos12=pos8
	title1='g) '+montext1+' 127.5 $\deg$'
	title2='h) '+montext2+' 127.5 $\deg$' 
   endif
   
   c2=contour(csea_verfre,lat,hgt,c_value=verlevs,n_levels=n,$
      rgb_table=33,rgb_indices=index,/fill,position=pos11,/current,$
	yrange=[0,20],xrange=[maplimit[0],maplimit[2]],axis_style=2,$
	title=title1,font_size=fontsz)

   c3=contour(wsea_verfre,lat,hgt,c_value=verlevs,n_levels=n,$
      rgb_table=33,rgb_indices=index,/fill,position=pos12,/current,$
	yrange=[0,20],xrange=[maplimit[0],maplimit[2]],axis_style=2,$
	title=title2,font_size=fontsz)

  endfor
  ct=colorbar(target=c2,title=bartitle2,taper=0,border=1,$
        orientation=0,position=barpos2,tickname=ticknamever) 
  ct.font_size=fontsz
  stop
end
