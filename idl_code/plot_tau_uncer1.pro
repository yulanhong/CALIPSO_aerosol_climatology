
pro plot_tau_uncer1

	plot_isolated=1 ; get the spatial distribution of tauerr
	plot_clrcld=0 ; get the relationship of aerosol tauerr vs tau
    plot_cldtauvsaerotau=0

	lnthk=2.0
	fontsz=11

;	dir='/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap/'
	lidfname=file_search('/u/sciteam/yulanh/scratch/CALIOP/output','*night.hdf')

	Nf=n_elements(lidfname)

	Taero_only_numh=0L
	Taeroonly_tau0_numh=0L
	Taeroonly_tauerr_spa=0.0
	Taeroonly_tauvsuncer=0.0
    Taeroonly_pdf=0.0

	Taero_isolate_numh=0L
	Taero_isolate_tau0_numh=0L
	Taeroisolate_tauerr_spa=0.0
	Taeroisolate_tauvsuncer=0.0
    Taeroisolate_pdf=0.0

	Taero_incld_numh=0L
	Taero_incld_tau0_numh=0L
	Taeroincld_tauerr_spa=0.0
	Taeroincld_tauvsuncer=0.0
    Taeroincld_pdf=0.0


	Tfilter_all=0L

	;======== check cloud and aerosol tau relationship ====
	Tisolate_cldtau=0.0
    Tisolate_cldtauerr=0.0	
	Tincld_cldtau=0.0
	Tincld_cldtauerr=0.0

	Ntau=601
	tau_interval=findgen(Ntau)*0.01-4
	tau=10.0^tau_interval

	lonres=6
	latres=5
	dimx=360/lonres
	dimy=180/latres

 	lon=findgen(dimx)*lonres-180+lonres/2.0
    lat=findgen(dimy)*latres-90+latres/2.0


    for fi=0,Nf-1 do begin
		fname=lidfname[fi]

		IF (strlen(fname) eq 97 or strlen(fname) eq 98) Then Begin ;;86 for all, 96 for day_land, 97 for day_night, 96 for ocean_day, 98 for ocean_night

			print,fname

			read_dardar,fname,'aero_only_numh',aero_only_numh
			read_dardar,fname,'aero_onlytau_uncer',aeroonly_tauuncer_spatial

			Taero_only_numh= Taero_only_numh + aero_only_numh
			ind=where(aero_only_numh eq 0.0)
			aeroonly_tauuncer_spatial[ind]=0.0
			Taeroonly_tauerr_spa=Taeroonly_tauerr_spa+aeroonly_tauuncer_spatial*aero_only_numh

			read_dardar,fname,'isolate_aero_numh',aero_isolate_numh
			read_dardar,fname,'isolate_aerotau_uncer',aeroisolate_tauuncer_spatial

			Taero_isolate_numh= Taero_isolate_numh + aero_isolate_numh
			ind=where(aero_isolate_numh eq 0.0)
			aeroisolate_tauuncer_spatial[ind]=0.0
			Taeroisolate_tauerr_spa=Taeroisolate_tauerr_spa + aeroisolate_tauuncer_spatial*$
				(aero_isolate_numh)
	

			read_dardar,fname,'incld_aero_numh',aero_incld_numh
			read_dardar,fname,'incld_aerotau_uncer',aeroincld_tauuncer_spatial

			Taero_incld_numh = Taero_incld_numh + aero_incld_numh
			ind=where(aero_incld_numh eq 0.0)
			aeroincld_tauuncer_spatial[ind]=0.0
			Taeroincld_tauerr_spa=Taeroincld_tauerr_spa + aeroincld_tauuncer_spatial*$
				(aero_incld_numh)
	
		EndIf

	endfor

	print,'total isolated tau err',total(Taeroisolate_tauerr_spa)/total(Taero_isolate_numh)
	print,'total incld tau err',total(Taeroincld_tauerr_spa)/total(Taero_incld_numh)
	print,'total aeroonly tauerr',total(Taeroonly_tauerr_spa)/total(Taero_only_numh)
	cloudy_tau_err=total(Taeroisolate_tauerr_spa,3)+total(Taeroincld_tauerr_spa,3)
	cloudy_tau_numh=total(Taero_isolate_numh,3)+total(Taero_incld_numh,3)
	print,'total cloudy tauerr',total(cloudy_tau_err)/total(cloudy_tau_numh)
	print,'total all aero tauerr',total(cloudy_tau_err+Taeroonly_tauerr_spa)/total(cloudy_tau_numh+Taero_only_numh)

	stop

IF (plot_cldtauvsaerotau eq 1) Then Begin
		Ntau=601
		lnthk=2.0
		yrange=[0,10]
		ytitle='Cloud $\tau$'
	    xtitle='Aerosol $\tau$'
		fontsz=11
		xdata=findgen(Ntau)*0.01-4
		xdata=10.0^xdata

	xrange=[0.001,4.0]

	xtickv=[0.001,0.01,0.1,1.0]
	xtickname=['$10^{-3}$','$10^{-2}$','$10^{-1}$','$10^{0}$']
		pos1=[0.10,0.15,0.50,0.9]
    	pos2=[0.58,0.15,0.98,0.9]
		Tisolate_cldtau1=total(Tisolate_cldtau,3)
		Tisolate_cldtauerr1=total(Tisolate_cldtauerr,3)
		Taeroisolate_pdf1= total(Taeroisolate_pdf,3) 

		Tincld_cldtau1=total(Tincld_cldtau,3)
		Tincld_cldtauerr1=total(Tincld_cldtauerr,3)
		Taeroincld_pdf1= total(Taeroincld_pdf,3) 

		ydata1=(Tisolate_cldtau1[*,0]+Tisolate_cldtau1[*,3]+Tisolate_cldtau1[*,7])/$
			(Taeroisolate_pdf1[*,0]+Taeroisolate_pdf1[*,3]+Taeroisolate_pdf1[*,7])
		
		ydataerr1=(Tisolate_cldtauerr1[*,0]+Tisolate_cldtauerr1[*,3]+Tisolate_cldtauerr1[*,7])/$
			(Taeroisolate_pdf1[*,0]+Taeroisolate_pdf1[*,3]+Taeroisolate_pdf1[*,7])

		 po1=plot(xdata,ydata1,color='r',xrange=xrange,yrange=yrange,thick=lnthk,$
         xtitle=xtitle,name='Below-cloud aerosol',xticklen=0.02,yticklen=0.02,$
         dim=[650,300],position=pos2,ytitle=ytitle,font_size=fontsz,xlog=1,$
			 xtickvalues=xtickv,xtickname=xtickname)

		 ydata2=(Tisolate_cldtau1[*,1]+Tisolate_cldtau1[*,4]+Tisolate_cldtau1[*,6])/$
			(Taeroisolate_pdf1[*,1]+Taeroisolate_pdf1[*,4]+Taeroisolate_pdf1[*,6])
		
		 p1=plot(xdata,ydata2,color='g',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po1,name='Above-cloud aerosol')

		 ydata3=(Tisolate_cldtau1[*,2]+Tisolate_cldtau1[*,5]+Tisolate_cldtau1[*,8])/$
			(Taeroisolate_pdf1[*,2]+Taeroisolate_pdf1[*,5]+Taeroisolate_pdf1[*,8])

		 p2=plot(xdata,ydata3,color='cyan',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po1,name='Others')

		 ld=legend(target=[po1,p1,p2],position=[pos2[0]+0.02,pos2[3]-0.01],transparency=100,horizontal_alignment=0,$
         font_size=fontsz,vertical_spacing=0.01)
		 a1=text(pos2[0]+0.03,pos2[3]+0.01,'b)',font_size=fontsz)

	

		 ydata1=(Tincld_cldtau1[*,0])/(Taeroincld_pdf1[*,0])
		 po2=plot(xdata,ydata1,color='pink',xrange=xrange,yrange=yrange,thick=lnthk,$
         xtitle=xtitle,name='Merged layer only',xticklen=0.02,yticklen=0.02,$
         position=pos1,ytitle=ytitle,font_size=fontsz,/current,xlog=1,$
		  xtickvalues=xtickv,xtickname=xtickname)
		 
		 ydata2=(Tincld_cldtau1[*,1])/(Taeroincld_pdf1[*,1])
		 p21=plot(xdata,ydata2,color='r',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po2,name='Merged layer below cloud')
			
		 ydata3=(Tincld_cldtau1[*,2]+Tincld_cldtau1[*,3])/(Taeroincld_pdf1[*,2]+Tincld_cldtau1[*,3])
		 p22=plot(xdata,ydata3,color='g',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po2,name='Merged layer above cloud')

		 ydata4=(Tincld_cldtau1[*,4]+Tincld_cldtau1[*,5])/(Taeroincld_pdf1[*,4]+Tincld_cldtau1[*,5])
		 p23=plot(xdata,ydata4,color='cyan',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po2,name='Others')

		 ld=legend(target=[po2,p21,p22,p23],position=[pos1[0]+0.02,pos1[3]-0.01],transparency=100,horizontal_alignment=0,$
         font_size=fontsz,vertical_spacing=0.01)
		 a1=text(pos1[0]+0.03,pos1[3]+0.01,'a)',font_size=fontsz)
		
		stop
	EndIf

	minvalue=0.0
	maxvalue=0.6

    IF (plot_clrcld eq 1) Then Begin
	
	maxvalue=0.5
	 fontsz=12
	 pos1=[0.08,0.55,0.49,0.95]
     pos2=[0.56,0.55,0.97,0.95]
     pos3=[0.11,0.10,0.50,0.45]
     pos4=[0.58,0.10,0.97,0.45]

	Taeroonly_numh1=total(total(Taero_only_numh,3),3)
	Taeroonly_tauerr_spa1=total(total(Taeroonly_tauerr_spa,3),3)
	c1=image(Taeroonly_tauerr_spa1/Taeroonly_numh1,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
			position=pos1,font_size=fontsz,dim=[600,600])
   		mp=map('Geographic',limit=maplimit,transparency=30,overplot=c1)
        grid=mp.MAPGRID
        grid.label_position=0
        grid.linestyle='dotted'
        grid.grid_longitude=60
        grid.grid_latitude=45
        grid.font_size=fontsz-2
        mc=mapcontinents(/continents,transparency=30)
        mc['Longitudes'].label_angle=0
        c1.scale,1.0,1
        pos=c1.position
        t1=text(pos[0],pos[3],'a) Cloud-free $\tau$ uncertainty',font_size=fontsz)

	Taerocld_numh1=total(total(Taero_isolate_numh+Taero_incld_numh-Taero_incld_tau0_numh-Taero_isolate_tau0_numh,3),3)
	Taerocld_tauerr_spa1=total(total(Taeroisolate_tauerr_spa+Taeroincld_tauerr_spa,3),3)

	c2=image(Taerocld_tauerr_spa1/Taerocld_numh1,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
		position=pos2,font_size=fontsz,/current)
   		mp=map('Geographic',limit=maplimit,transparency=30,overplot=c2)
        grid=mp.MAPGRID
        grid.label_position=0
        grid.linestyle='dotted'
        grid.grid_longitude=60
        grid.grid_latitude=45
        grid.font_size=fontsz-2
        mc=mapcontinents(/continents,transparency=30)
        mc['Longitudes'].label_angle=0
        c2.scale,1.0,1
        pos=c2.position
        t1=text(pos[0],pos[3],'b) Cloudy $\tau$ uncertainty',font_size=fontsz)
	barpos=[pos1[0]+0.1,pos3[3]+0.11,pos2[2]-0.1,pos3[3]+0.13]
	ct=colorbar(target=c1,title='Aerosol $\tau$ uncertainty',taper=1,$
         border=1,position=barpos,font_size=fontsz+1,orientation=0)

	xrange=[0.001,4.0]
	yrange=[0.001,4.0]
	xtitle='Aerosol $\tau$'
	ytitle='Aerosol $\tau$ uncertainty'

	xtickv=[0.001,0.01,0.1,1.0]
	ytickv=[0.001,0.01,0.1,1.0]
	xtickname=['$10^{-3}$','$10^{-2}$','$10^{-1}$','$10^{0}$']
	ytickname=['$10^{-3}$','$10^{-2}$','$10^{-1}$','$10^{0}$']

	; for cloud-free aerosol
	tauvserr_aeroonly=total(total(Taeroonly_tauvsuncer,2),2)/total(total(Taeroonly_pdf,2),2)		
	po1=plot(tau,tauvserr_aeroonly,color='black',xrange=xrange,yrange=yrange,thick=lnthk,$
         xtitle=xtitle,name='Cloud-free aerosol',xticklen=0.02,yticklen=0.02,$
         position=pos3,ytitle=ytitle,font_size=fontsz,xlog=1,ylog=1,/current,$
		 xtickvalues=xtickv,xtickname=xtickname,ytickvalues=ytickv,ytickname=ytickname)
    a1=text(pos3[0]+0.03,pos3[3]+0.01,'c)',font_size=fontsz)

	po2=plot(tau,tauvserr_aeroonly,color='black',xrange=xrange,yrange=yrange,thick=lnthk,$
         xtitle=xtitle,name='Cloud-free aerosol',xticklen=0.02,yticklen=0.02,$
        position=pos4,ytitle='',font_size=fontsz,/current,xlog=1,ylog=1,$
		 xtickvalues=xtickv,xtickname=xtickname,ytickvalues=ytickv,ytickname=ytickname)
    a2=text(pos4[0]+0.03,pos4[3]+0.01,'d)',font_size=fontsz)

 	; for cloud-aerosol merged aerosol
	tauvserr_mergedonly=total(reform(Taeroincld_tauvsuncer[*,0,*]),2)/total(reform(Taeroincld_pdf[*,0,*]),2)
	i1=plot(tau,tauvserr_mergedonly,color='pink',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po1,name='Merged layer only')
	tauvserr_mbc=total(reform(Taeroincld_tauvsuncer[*,1,*]),2)/total(reform(Taeroincld_pdf[*,1,*]),2)
	i2=plot(tau,tauvserr_mbc,color='r',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po1,name='Merged layer below cloud')
	tauvserr_mac=total(reform(Taeroincld_tauvsuncer[*,2,*]+Taeroincld_tauvsuncer[*,3,*]),2)/$
		total(reform(Taeroincld_pdf[*,2,*]+Taeroincld_pdf[*,3,*]),2)
	i3=plot(tau,tauvserr_mac,color='g',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po1,name='Merged layer above cloud')
	tauvserr_moth=total(reform(Taeroincld_tauvsuncer[*,4,*]+Taeroincld_tauvsuncer[*,5,*]),2)/$
		total(reform(Taeroincld_pdf[*,4,*]+Taeroincld_pdf[*,5,*]),2)
	i4=plot(tau,tauvserr_moth,color='cyan',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po1,name='Others')
	ld=legend(target=[po1,i1,i2,i3,i4],position=[pos3[0]+0.01,pos3[3]-0.01],transparency=100,horizontal_alignment=0,$
         font_size=fontsz-1,vertical_spacing=0.01,sample_width=0.08)
	
	; for cloud-aerosol spaerated aerosol
	tauvserr_ibca=total(reform(Taeroisolate_tauvsuncer[*,0,*]+Taeroisolate_tauvsuncer[*,3,*]+Taeroisolate_tauvsuncer[*,7,*]),2)/$
		total(reform(Taeroisolate_pdf[*,0,*]+Taeroisolate_pdf[*,3,*]+Taeroisolate_pdf[*,7,*]),2)
	p1=plot(tau,tauvserr_ibca,color='r',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po2,name='Below-cloud aerosol')	
	tauvserr_iaca=total(reform(Taeroisolate_tauvsuncer[*,1,*]+Taeroisolate_tauvsuncer[*,4,*]+Taeroisolate_tauvsuncer[*,6,*]),2)/$
		total(reform(Taeroisolate_pdf[*,1,*]+Taeroisolate_pdf[*,4,*]+Taeroisolate_pdf[*,6,*]),2)
	p2=plot(tau,tauvserr_iaca,color='g',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po2,name='Above-cloud aerosol')	
	tauvserr_ioth=total(reform(Taeroisolate_tauvsuncer[*,2,*]+Taeroisolate_tauvsuncer[*,5,*]+Taeroisolate_tauvsuncer[*,8,*]),2)/$
		total(reform(Taeroisolate_pdf[*,2,*]+Taeroisolate_pdf[*,5,*]+Taeroisolate_pdf[*,8,*]),2)
	p3=plot(tau,tauvserr_ioth,color='cyan',xrange=xrange,yrange=yrange,thick=lnthk,$
         overplot=po2,name='Others')	
	
	ld=legend(target=[po2,p1,p2,p3],position=[pos4[0]+0.01,pos4[3]-0.01],transparency=100,horizontal_alignment=0,$
        font_size=fontsz-1,vertical_spacing=0.01,sample_width=0.08)

	c1.save,'cldclr_cloudtype_tauuncer_cad20.png'

;	Taeroincld_numh1=total(total(Taero_incld_numh,3),3)
;	Taeroincld_tauerr_spa1=total(total(Taeroincld_tauerr_spa,3),3)
;	c3=image(Taeroincld_tauerr_spa1/Taeroincld_numh1,rgb_table=33,min_value=minvalue,max_value=maxvalue)
;	c3.scale,5,4
	stop
	EndIf

	; to plot spatial tauerr distributions 

	IF (plot_isolated eq 1) Then Begin
		
 	  weights=cos(lat*!pi/180)

	  pos1=[0.11,0.79,0.47,0.97]
      pos2=[0.60,0.79,0.96,0.97]
      pos3=[0.11,0.56,0.47,0.74]
      pos4=[0.60,0.56,0.96,0.74]
      pos5=[0.11,0.33,0.47,0.51] 
      pos6=[0.60,0.33,0.96,0.51]
      pos7=[0.11,0.10,0.47,0.28]
      pos8=[0.60,0.10,0.96,0.28]


      minvalue=0.0
      maxvalue=0.5
      minvalue1=0.0
      maxvalue1=1.0
		
	  weights=1
 	  ;alltauerr=total(total(Taeroisolate_tauerr_spa,3),3)/total(total(Taero_isolate_numh),3)
	  ;alltauerr1=total(weights*total(alltauerr,1,/nan))/(dimx*total(weights))

		tauerr=reform(Taeroisolate_tauerr_spa[*,*,0]+Taeroisolate_tauerr_spa[*,*,3]+Taeroisolate_tauerr_spa[*,*,7])/$
        reform(Taero_isolate_numh[*,*,0]+Taero_isolate_numh[*,*,3]+Taero_isolate_numh[*,*,7]);-$
;        Taero_isolate_tau0_numh[*,*,0,*]-Taero_isolate_tau0_numh[*,*,3,*]-Taero_isolate_tau0_numh[*,*,7,*]),3)
		tauerr1=total(Taeroisolate_tauerr_spa[*,*,0]+Taeroisolate_tauerr_spa[*,*,3]+Taeroisolate_tauerr_spa[*,*,7])/$
        total(Taero_isolate_numh[*,*,0]+Taero_isolate_numh[*,*,3]+Taero_isolate_numh[*,*,7]);-$
		
  ;      tauerr1=total(weights*total(tauerr,1,/nan))/(dimx*total(weights))
        tauerr1=strcompress(tauerr1,/rem)
        tauerr1=strmid(tauerr1,0,5)
		
 		c=image(tauerr,lon,lat,dim=[550,650],rgb_table=33,min_value=minvalue,max_value=maxvalue,$
              position=pos1,font_size=fontsz)
              mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
              grid=mp.MAPGRID
              grid.label_position=0
              grid.linestyle='dotted'
              grid.grid_longitude=60
              grid.grid_latitude=45
              grid.font_size=fontsz-3
              mc=mapcontinents(/continents,transparency=30)
              mc['Longitudes'].label_angle=0
              c.scale,1.0,1
              pos=c.position
              t1=text(pos[0],pos[3],'a1) ave $\tau$ error='+tauerr1,font_size=fontsz)
              t1=text(pos[0]-0.075,pos[1]+0.01,'Below-cloud',orientation=90,font_size=fontsz)
              t1=text(pos[0]-0.055,pos[1]+0.04,'aerosol',orientation=90,font_size=fontsz)

		tauerr2=reform(Taeroisolate_tauerr_spa[*,*,1]+Taeroisolate_tauerr_spa[*,*,4]+Taeroisolate_tauerr_spa[*,*,6])/$
        reform(Taero_isolate_numh[*,*,1]+Taero_isolate_numh[*,*,4]+Taero_isolate_numh[*,*,6]);-$
;        Taero_isolate_tau0_numh[*,*,1,*]-Taero_isolate_tau0_numh[*,*,4,*]-Taero_isolate_tau0_numh[*,*,6,*]),3)
;        tauerr1=total(weights*total(tauerr2,1,/nan))/(dimx*total(weights))
		tauerr1=total(Taeroisolate_tauerr_spa[*,*,1]+Taeroisolate_tauerr_spa[*,*,4]+Taeroisolate_tauerr_spa[*,*,6])/$
        total(Taero_isolate_numh[*,*,1]+Taero_isolate_numh[*,*,4]+Taero_isolate_numh[*,*,6]);-$

        tauerr1=strcompress(tauerr1,/rem)
        tauerr1=strmid(tauerr1,0,5)
		
 		c1=image(tauerr2,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
              position=pos3,font_size=fontsz,/current)
              mp=map('Geographic',limit=maplimit,transparency=30,overplot=c1)
              grid=mp.MAPGRID
              grid.label_position=0
              grid.linestyle='dotted'
              grid.grid_longitude=60
              grid.grid_latitude=45
              grid.font_size=fontsz-3
              mc=mapcontinents(/continents,transparency=30)
              mc['Longitudes'].label_angle=0
              c1.scale,1.0,1
              pos=c1.position
              t1=text(pos[0],pos[3],'a2) ave $\tau$ error='+tauerr1,font_size=fontsz)
              t1=text(pos[0]-0.075,pos[1]+0.01,'Above-cloud',orientation=90,font_size=fontsz)
              t1=text(pos[0]-0.055,pos[1]+0.04,'aerosol',orientation=90,font_size=fontsz)
	
		
		tauerr3=reform(Taeroisolate_tauerr_spa[*,*,2]+Taeroisolate_tauerr_spa[*,*,5]+Taeroisolate_tauerr_spa[*,*,8])/$
        reform(Taero_isolate_numh[*,*,2]+Taero_isolate_numh[*,*,5]+Taero_isolate_numh[*,*,8]);-$
;        Taero_isolate_tau0_numh[*,*,2,*]-Taero_isolate_tau0_numh[*,*,5,*]-Taero_isolate_tau0_numh[*,*,8,*]),3)
;        tauerr1=total(weights*total(tauerr3,1,/nan))/(dimx*total(weights))
		tauerr1=total(Taeroisolate_tauerr_spa[*,*,2]+Taeroisolate_tauerr_spa[*,*,5]+Taeroisolate_tauerr_spa[*,*,8])/$
        total(Taero_isolate_numh[*,*,2]+Taero_isolate_numh[*,*,5]+Taero_isolate_numh[*,*,8]);-$

        tauerr1=strcompress(tauerr1,/rem)
        tauerr1=strmid(tauerr1,0,5)

 		c2=image(tauerr3,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
              position=pos5,font_size=fontsz,/current)
              mp=map('Geographic',limit=maplimit,transparency=30,overplot=c2)
              grid=mp.MAPGRID
              grid.label_position=0
              grid.linestyle='dotted'
              grid.grid_longitude=60
              grid.grid_latitude=45
              grid.font_size=fontsz-3
              mc=mapcontinents(/continents,transparency=30)
              mc['Longitudes'].label_angle=0
              c2.scale,1.0,1
              pos=c2.position
              t1=text(pos[0],pos[3],'a3) ave $\tau$ error='+tauerr1,font_size=fontsz)
              t1=text(pos[0]-0.055,pos[1]+0.01,'Others',orientation=90,font_size=fontsz)
		
		;=== for merged layer clouds

 	  	;alltauerr=total(total(Taeroincld_tauerr_spa,3),3)/total(total(Taero_incld_numh,3),3)
	  	;alltauerr1=total(weights*total(alltauerr,1,/nan))/(dimx*total(weights))

		tauerrm0=reform(Taeroincld_tauerr_spa[*,*,0])/$
        reform(Taero_incld_numh[*,*,0]);-Taero_incld_tau0_numh[*,*,0,*]),3)
		tauerr1=total(Taeroincld_tauerr_spa[*,*,0])/$
        total(Taero_incld_numh[*,*,0]);-Taero_incld_tau0_numh[*,*,0,*]),3)
;        tauerr1=total(weights*total(tauerrm0,1,/nan))/(dimx*total(weights))
        tauerr1=strcompress(tauerr1,/rem)
        tauerr1=strmid(tauerr1,0,5)
 		c3=image(tauerrm0,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
              position=pos2,font_size=fontsz,/current)
              mp=map('Geographic',limit=maplimit,transparency=30,overplot=c3)
              grid=mp.MAPGRID
              grid.label_position=0
              grid.linestyle='dotted'
              grid.grid_longitude=60
              grid.grid_latitude=45
              grid.font_size=fontsz-3
              mc=mapcontinents(/continents,transparency=30)
              mc['Longitudes'].label_angle=0
              c3.scale,1.0,1
              pos=c3.position
              t1=text(pos[0],pos[3],'b1) ave $\tau$ error='+tauerr1,font_size=fontsz)
              t1=text(pos[0]-0.075,pos[1]-0.01,'Merged layer only',orientation=90,font_size=fontsz)
					
		tauerrm1=reform(Taeroincld_tauerr_spa[*,*,1])/$
        reform(Taero_incld_numh[*,*,1]);-Taero_incld_tau0_numh[*,*,1,*]),3)
		tauerr1=total(Taeroincld_tauerr_spa[*,*,1])/$
        total(Taero_incld_numh[*,*,1]);-Taero_incld_tau0_numh[*,*,1,*]),3)
;        tauerr1=total(weights*total(tauerrm1,1,/nan))/(dimx*total(weights))
        tauerr1=strcompress(tauerr1,/rem)
        tauerr1=strmid(tauerr1,0,5)
 		c4=image(tauerrm1,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
              position=pos4,font_size=fontsz,/current)
              mp=map('Geographic',limit=maplimit,transparency=30,overplot=c4)
              grid=mp.MAPGRID
              grid.label_position=0
              grid.linestyle='dotted'
              grid.grid_longitude=60
              grid.grid_latitude=45
              grid.font_size=fontsz-3
              mc=mapcontinents(/continents,transparency=30)
              mc['Longitudes'].label_angle=0
              c4.scale,1.0,1
              pos=c4.position
              t1=text(pos[0],pos[3],'b2) ave $\tau$ error='+tauerr1,font_size=fontsz)
              t1=text(pos[0]-0.075,pos[1]-0.02,'Merged layer below',orientation=90,font_size=fontsz)
			  t1=text(pos[0]-0.055,pos[1]+0.04,'cloud',orientation=90,font_size=fontsz)
	
		tauerrm2=reform(Taeroincld_tauerr_spa[*,*,2]+Taeroincld_tauerr_spa[*,*,3])/$
        reform(Taero_incld_numh[*,*,2]+Taero_incld_numh[*,*,3]);-$
		tauerr1=total(Taeroincld_tauerr_spa[*,*,2]+Taeroincld_tauerr_spa[*,*,3])/$
        total(Taero_incld_numh[*,*,2]+Taero_incld_numh[*,*,3]);-$
;			Taero_incld_tau0_numh[*,*,2,*]-Taero_incld_tau0_numh[*,*,3,*]),3)
;        tauerr1=total(weights*total(tauerrm2,1,/nan))/(dimx*total(weights))
        tauerr1=strcompress(tauerr1,/rem)
        tauerr1=strmid(tauerr1,0,5)
 		c5=image(tauerrm2,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
              position=pos6,font_size=fontsz,/current)
              mp=map('Geographic',limit=maplimit,transparency=30,overplot=c5)
              grid=mp.MAPGRID
              grid.label_position=0
              grid.linestyle='dotted'
              grid.grid_longitude=60
              grid.grid_latitude=45
              grid.font_size=fontsz-3
              mc=mapcontinents(/continents,transparency=30)
              mc['Longitudes'].label_angle=0
              c5.scale,1.0,1
              pos=c5.position
              t1=text(pos[0],pos[3],'b3) ave $\tau$ error='+tauerr1,font_size=fontsz)
              t1=text(pos[0]-0.075,pos[1]-0.02,'Merged layer above',orientation=90,font_size=fontsz)
			  t1=text(pos[0]-0.055,pos[1]+0.04,'cloud',orientation=90,font_size=fontsz)
		
		tauerrm3=reform(Taeroincld_tauerr_spa[*,*,4]+Taeroincld_tauerr_spa[*,*,5])/$
        reform(Taero_incld_numh[*,*,4]+Taero_incld_numh[*,*,5])
		tauerr1=total(Taeroincld_tauerr_spa[*,*,4]+Taeroincld_tauerr_spa[*,*,5])/$
        total(Taero_incld_numh[*,*,4]+Taero_incld_numh[*,*,5])
;        tauerr1=total(weights*total(tauerrm3,1,/nan))/(dimx*total(weights))
        tauerr1=strcompress(tauerr1,/rem)
        tauerr1=strmid(tauerr1,0,5)
 		c6=image(tauerrm3,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
              position=pos8,font_size=fontsz,/current)
              mp=map('Geographic',limit=maplimit,transparency=30,overplot=c6)
              grid=mp.MAPGRID
              grid.label_position=0
              grid.linestyle='dotted'
              grid.grid_longitude=60
              grid.grid_latitude=45
              grid.font_size=fontsz-3
              mc=mapcontinents(/continents,transparency=30)
              mc['Longitudes'].label_angle=0
              c6.scale,1.0,1
              pos=c6.position
              t1=text(pos[0],pos[3],'b4) ave $\tau$ error='+tauerr1,font_size=fontsz)
              t1=text(pos[0]-0.075,pos[1]-0.02,'Other merged layer',orientation=90,font_size=fontsz)

	  barpos2=[pos7[0]-0.02,pos7[1]+0.12,pos7[2],pos7[1]+0.14]
	  ct=colorbar(target=c,title='Aerosol optical depth uncertainty',taper=1,$
         border=1,position=barpos2,font_size=fontsz-1,orientation=0)


	c.save,'aerosol_tau_uncertainty_spacad20.png'
	stop
	EndIf
	


	stop
end
