
pro plot_subarea
; maplimit=[0,105,30,135]
 maplimit=[-30,-15,0,20]
 subarea=[5,115,22.5,130]
 subarea1=[-25,-7.5,-5,15]
 subarea2=[7.5,-175,25,-120]

 fontsz=12
 mp=map('Geographic',limit=maplimit, overplot=c,transparency=30,position=[0.1,0.2,0.9,0.85],$
        font_size=fontsz)
 
 grid=mp.MAPGRID
 grid.label_position=0
 grid.linestyle='dotted'
 grid.box_axes=1
 
 mc=mapcontinents(/continents,transparency=30)
 mc['Longitudes'].label_angle=0
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

 ;========== to plot subarea1
 x=fltarr(nx+1)
 x[*]=subarea1[1]
 y=findgen(ny+1)*(subarea1[2]-subarea1[0])/ny+subarea1[0]
 p=plot(x,y,overplot=mp,color='black',/current,thick=3)

 x=fltarr(nx+1)
 x[*]=subarea1[3]
 p1=plot(x,y,overplot=mp,color='black',/current,thick=3)

 y=fltarr(ny+1)
 y[*]=subarea1[0]
 x=findgen(nx+1)*(subarea1[3]-subarea1[1])/nx+subarea1[1]
 p2=plot(x,y,overplot=mp,color='black',/current,thick=3)

 y=fltarr(ny+1)
 y[*]=subarea1[2]
 p2=plot(x,y,overplot=mp,color='black',/current,thick=3)

 ;========== to plot subarea2
 x=fltarr(nx+1)
 x[*]=subarea2[1]
 y=findgen(ny+1)*(subarea2[2]-subarea2[0])/ny+subarea2[0]
 p=plot(x,y,overplot=mp,color='black',/current,thick=3)

 x=fltarr(nx+1)
 x[*]=subarea2[3]
 p1=plot(x,y,overplot=mp,color='black',/current,thick=3)

 y=fltarr(ny+1)
 y[*]=subarea2[0]
 x=findgen(nx+1)*(subarea2[3]-subarea2[1])/nx+subarea2[1]
 p2=plot(x,y,overplot=mp,color='black',/current,thick=3)

 y=fltarr(ny+1)
 y[*]=subarea2[2]
 p2=plot(x,y,overplot=mp,color='black',/current,thick=3)

 ;=== to plot camp2ex track====
 date=['20190827','20190904','20190913','20190915','20190921','20190923',$
          '20190925','20191001','20191003']

 symcolor=['r','pink','orange','brown','green','cyan','slate blue','blue','olive']
 lnthick=2
 for di=0,n_elements(date)-1 do begin 
 	hsrl_file='/u/sciteam/yulanh/mydata/HSRL_out/CAMP2Ex/CAMP2EX-HSRL2_P3B_'+date[di]+'_R0.h5'
	read_hdf5,hsrl_file,'/Nav_Data/gps_lat',hsrl_lat
    read_hdf5,hsrl_file,'/Nav_Data/gps_lon',hsrl_lon

	;pt=plot(hsrl_lon,hsrl_lat,color=symcolor[di],overplot=mp,thick=lnthick)
    ;t=text(0.8,0.8-di*0.05,date[di],color=symcolor[di]) 
 endfor

 date=['20160912','20160916','20160918','20160920','20160922','20160924']
 symcolor=['r','pink','orange','green','cyan','blue']
 for di=0,n_elements(date)-1 do begin
	 hsrl_file='/u/sciteam/yulanh/scratch/HSRL/ORACLES/HSRL2_ER2_'+date[di]+'_R7.h5'
	 read_hdf5,hsrl_file,'/ER2_IMU/gps_lat',hsrl_lat
     read_hdf5,hsrl_file,'/ER2_IMU/gps_lon',hsrl_lon
     read_hdf5,hsrl_file,'/ER2_IMU/gps_alt',hsrl_alt

	pt=plot(hsrl_lon,hsrl_lat,color=symcolor[di],overplot=mp,thick=lnthick)
    t=text(0.85,0.8-di*0.05,date[di],color=symcolor[di]) 
 endfor
 mp.save,'Cldaero_subarea1.png'
 stop
end

