
pro plot_subarea_paper_v

 maplimit=[-90,-180,90,180]

 minlat=[20 ,10, 44,-20, 25,  30, -10,  5,-20]
 maxlat=[40 ,25, 55, -5, 45,  45,  10, 25,  0]
 minlon=[105,70,-10, -5,-90,-140,  95,-45,-65]
 maxlon=[120,85, 30, 20,-75,-125, 150,-18,-45]
 location=['East_Asia','India','Europe','Africa','East_US','West_US','Indonesia','Center Atlantic','Amazon']
 
 fontsz=12

 mp=map('Geographic',limit=maplimit, overplot=c,transparency=30,position=[0.1,0.2,0.9,0.85],$
        font_size=fontsz)
 
 grid=mp.MAPGRID
 grid.label_position=0
 grid.linestyle='dotted'
 grid.box_axes=1
 
 mc=mapcontinents(/continents,transparency=30)
 mc['Longitudes'].label_angle=0

 for i=0, n_elements(minlat)-1 do begin
 subarea=[minlat[i],minlon[i],maxlat[i],maxlon[i]]
 ny=10
 nx=10
 x=fltarr(nx+1)
 x[*]=subarea[1]
 y=findgen(ny+1)*(subarea[2]-subarea[0])/ny+subarea[0]
 p=plot(x,y,overplot=mp,color='black',/current,thick=3)
	print,y
 x=fltarr(nx+1)
 x[*]=subarea[3]
; y=findgen(ny)*(subarea[2]-subarea[0])/ny-subarea[0]
 p1=plot(x,y,overplot=mp,color='black',/current,thick=3)

 y=fltarr(ny+1)
 y[*]=subarea[0]
 x=findgen(nx+1)*(subarea[3]-subarea[1])/nx+subarea[1]
 p2=plot(x,y,overplot=mp,color='black',/current,thick=3)

 y=fltarr(ny+1)
; x=findgen(nx)*(subarea[3]-subarea[1])/nx+subarea[1]
 y[*]=subarea[2]
 p2=plot(x,y,overplot=mp,color='black',/current,thick=3)

; t=text(0.85,0.8-di*0.05,date[di],color=symcolor[di]) 
endfor

 mp.save,'subarea_paper.png'
 stop
end

