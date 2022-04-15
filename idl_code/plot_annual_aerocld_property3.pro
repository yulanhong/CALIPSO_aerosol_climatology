
pro  plot_annual_aerocld_property3

;	fname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen_2/','*land_daynight.hdf')
   fname=file_search('/u/sciteam/yulanh/scratch/CALIOP/output','*.hdf');_day.hdf')

  	Nf=n_elements(fname)

    gontsdimx=72
	Ntau=501
	Ndep=201
	Nsca=501
	Nisolate=9
	Nincld=6
	Nonly=2
	;flags
	plotpdf=1 ;to plot tau pdf
	check_data=0 ; to check data
	plotfre_merged=0 ; to plot the frequency/tau of aerosol-cloud overlap
	plotfre_isolated=1 ; to plot the frequency/tau of aerosol-cloud overlap
	fontsz=11

    lon_res=6
	lat_res=5
	dimx=360./lon_res
	dimy=180./lat_res
	lon=findgen(dimx)*lon_res-180
	lat=findgen(dimy)*lat_res-90+lat_res/2.0

    Tobsnum=ulonarr(dimx,dimy)
	Tfilter_all=0L

    Taeroonly_num=ulonarr(dimx,dimy)
	Taeroonly_tau=dblarr(dimx,dimy)
	Taeroonly_dep=dblarr(dimx,dimy)
	Taeroonly_sca=dblarr(dimx,dimy)
	Taeroonly_taupdf=dblarr(dimx,dimy,Ntau)
	
    Taeroisolate_num=ulonarr(dimx,dimy,Nisolate)
	Taeroisolate_tau=dblarr(dimx,dimy,Nisolate)
	Taeroisolate_taupdf=dblarr(dimx,dimy,Ntau,Nisolate)

    Taeroincld_num=ulonarr(dimx,dimy,Nincld)
	Taeroincld_tau=dblarr(dimx,dimy,Nincld)
	Taeroincld_taupdf=dblarr(dimx,dimy,Ntau,Nincld)

    for fi=0,Nf-1 do begin
		IF (strlen(fname[fi]) eq 86) Then Begin ;97 for land_night, 86 for all, 95 for day_land, 97 for day_night, 96 for ocean_day, 98 for ocean_night
		print,fname[fi]
		read_dardar,fname[fi],'obs_numh',obsnum
		Tobsnum=Tobsnum+obsnum

		read_dardar,fname[fi],'aero_only_numh',aeroonly_num
		read_dardar,fname[fi],'aero_only_tau',aeroonly_tau
		read_dardar,fname[fi],'pdf_aero_only_tau',aeroonly_taupdf
		read_dardar,fname[fi],'all_filter',filter_all
		Tfilter_all=Tfilter_all+filter_all
	
		ind=where(aeroonly_num eq 0)
		aeroonly_tau[ind]=0.0
		Taeroonly_num=Taeroonly_num + aeroonly_num
		Taeroonly_tau=Taeroonly_tau + aeroonly_tau*aeroonly_num	
		Taeroonly_taupdf=Taeroonly_taupdf + aeroonly_taupdf	
		
		read_dardar,fname[fi],'isolate_aero_numh',aeroisolate_num
		read_dardar,fname[fi],'isolate_aero_tau',aeroisolate_tau
		read_dardar,fname[fi],'pdf_isolate_aero_tau',aeroisolate_taupdf

		ind=where(aeroisolate_num eq 0)
		aeroisolate_tau[ind]=0.0
		Taeroisolate_num=Taeroisolate_num + aeroisolate_num
		Taeroisolate_tau=Taeroisolate_tau + aeroisolate_tau*aeroisolate_num	
		Taeroisolate_taupdf=Taeroisolate_taupdf + aeroisolate_taupdf	

		read_dardar,fname[fi],'incld_aero_numh',aeroincld_num
		read_dardar,fname[fi],'incld_aero_tau',aeroincld_tau
		read_dardar,fname[fi],'pdf_incld_aero_tau',aeroincld_taupdf

		ind=where(aeroincld_num eq 0)
		aeroincld_tau[ind]=0.0
		Taeroincld_num=Taeroincld_num + aeroincld_num
		Taeroincld_tau=Taeroincld_tau + aeroincld_tau*aeroincld_num	
		Taeroincld_taupdf=Taeroincld_taupdf + aeroincld_taupdf	
		
		EndIf
	endfor

	;===========================================================

	avetau_incld=Taeroincld_tau/Taeroincld_num
	avetau_only=Taeroonly_tau/Taeroonly_num
	avetau_isolate=Taeroisolate_tau/Taeroisolate_num

	;============ calculate average tau ========================
	; total aero-cld case
	weights=cos(lat*!pi/180)
	obsnum1=total(Tobsnum,1)
    ind=where(obsnum1 eq 0.0)
	weights[ind]=0.0

    avetau_aeroonly=total(Taeroonly_tau)/total(Taeroonly_num)
    print,'ave aeroonly tau',avetau_aeroonly
	print,'ave aeroonly freh',total(Taeroonly_num)/float(total(Tobsnum-Tfilter_all))


    avetau_aerocld=$
	(total(Taeroincld_tau)+total(Taeroisolate_tau))$
	/(total(Taeroincld_num)+total(Taeroisolate_num))
;	print,'avetau_aerocld tau, weight average',total(weights*total(avetau_aerocld,1,/nan))/(dimx*total(weights))
	print,'ave aerocld num weight tau',avetau_aerocld 
	print,'ave aerocld num freh',(total(Taeroincld_num)+total(Taeroisolate_num))/float(total(Tobsnum-Tfilter_all))

	avetau_aerois=$
	total(Taeroisolate_tau)/total((Taeroisolate_num))
;	print,'avetau_aero isolated tau, weight average',total(weights*total(avetau_aerois,1,/nan))/(dimx*total(weights))
	print,'ave tau aero isoated num weighted tau',avetau_aerois
	print,'ave aero isolated freh',total(Taeroisolate_num)/float(total(Tobsnum-Tfilter_all))
 
	avetau_aeroin=$
	(total(Taeroincld_tau))/total((Taeroincld_num))
;	print,'avetau_aero incld tau, weight average',total(weights*total(avetau_aeroin,1,/nan))/(dimx*total(weights))
	print,'ave tau incld num weighted tau',avetau_aeroin
	print,'ave aero incld fre',total(Taeroincld_num)/float(total(Tobsnum-Tfilter_all))

    avetau_aeroall=(total(Taeroincld_tau)+total(Taeroisolate_tau)+total(Taeroonly_tau))/$
		(total(Taeroincld_num)+total(Taeroisolate_num)+total(Taeroonly_num))
	print,'ave tau all sky',avetau_aeroall
	print,'ave fre all sky',(total(Taeroincld_num)+total(Taeroisolate_num)+total(Taeroonly_num))/float(total(Tobsnum-Tfilter_all))

	Tallaero_num=total(Taeroincld_num,3) + total(Taeroisolate_num,3) + Taeroonly_num

	maplimit=[-90,-180,90,180]
    minvalue=0	
	maxvalue=0.15
	minvalue1=0.0
	maxvalue1=.8

	;=============== to plot the merged cases =============== 
	IF (plotfre_merged eq 1) Then Begin
	 	pos1=[0.11,0.79,0.50,0.97]
     	pos2=[0.57,0.79,0.96,0.97]
     	pos3=[0.11,0.56,0.50,0.74]
     	pos4=[0.57,0.56,0.96,0.74]
     	pos5=[0.11,0.33,0.50,0.51]
     	pos6=[0.57,0.33,0.96,0.51]
		pos7=[0.11,0.10,0.50,0.28]
		pos8=[0.57,0.10,0.96,0.28]

		tauerr=['0.050','0.086','0.046','0.085'] ; 5heck update from plot_tau_uncer2.pro

		data=Taeroincld_num
		Nmerged=6
		freh_ave=fltarr(Nmerged)
		tau_ave=fltarr(Nmerged)
		for i=0,Nmerged-1 do begin
			freh=(reform(data[*,*,i]))/float(Tobsnum-Tfilter_all)
            ind=where(finite(freh) eq 0)
            freh[ind]=0.0
            ;freh1=total(weights*total(freh,1,/nan))/(dimx*total(weights))
			;tau=(reform(Taeroincld_tau[*,*,i]))/reform(Taeroincld_num[*,*,i])
			;tau1=total(weights*total(tau,1,/nan))/(dimx*total(weights))
			freh_ave[i]=total(data[*,*,i])/float(total(Tobsnum-Tfilter_all))
			tau_ave[i]=total(Taeroincld_tau[*,*,i])/float(total(data[*,*,i]))
			print,'num weighted freh and tau',freh_ave[i],tau_ave[i]
		endfor		

		data1=(reform(data[*,*,0]))/float(Tobsnum - Tfilter_all)
;		data1=reform(data[*,*,i])
		ind=where(finite(data1) eq 0)
		freh1=strcompress(freh_ave[0]*100,/rem)	
		freh1=strmid(freh1,0,4)	
		c=image(data1,lon,lat,dim=[570,650],rgb_table=33,min_value=minvalue,max_value=maxvalue,$
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
			 t1=text(pos[0],pos[3]+0.01,'(a1) $ave f$='+freh1+'%'+'   scale=1.0',font_size=fontsz)
			 t1=text(pos[0]-0.055,pos[1]-0.01,'Merged-layer-only',orientation=90,font_size=fontsz)

			data2=reform(Taeroincld_tau[*,*,0])/reform(Taeroincld_num[*,*,0])

			tau1=strcompress(tau_ave[0],/rem)
			tau1=strmid(tau1,0,5)
			 c1=image(data2,lon,lat,rgb_table=33,min_value=minvalue1,max_value=maxvalue1,$
	         position=pos2,font_size=fontsz,/current)
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
			 t2=text(pos[0],pos[3]+0.01,'(b1) ave $\tau=$'+tau1+'$\pm$'+tauerr[0],font_size=fontsz)

			data1=(reform(data[*,*,1]))/float(Tobsnum - Tfilter_all)
;		data1=reform(data[*,*,i])
			ind=where(finite(data1) eq 0)
			data1[ind]=0.0
			freh1=strcompress(freh_ave[1]*100,/rem)	
			freh1=strmid(freh1,0,4)	
			c=image(data1*5,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
	         position=pos3,font_size=fontsz,/current)
		     mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
		     grid=mp.MAPGRID
			 grid.label_position=0
			 grid.linestyle='dotted'
			 grid.grid_longitude=60
			 grid.grid_latitude=45
			 grid.font_size=fontsz-3
			 mc=mapcontinents(/continents,transparency=30)
			 mc['Longitudes'].label_angle=0
			 pos=c.position
			 t1=text(pos[0],pos[3]+0.01,'(a2) ave f='+freh1+'%'+'   scale=0.2',font_size=fontsz)
		   	 t1=text(pos[0]-0.075,pos[1]-0.02,'Merged-layer-below',orientation=90,font_size=fontsz)
		   	 t1=text(pos[0]-0.055,pos[1]+0.04,'cloud',orientation=90,font_size=fontsz)
			 c.scale,1.0,1

			data2=reform(Taeroincld_tau[*,*,1])/reform(Taeroincld_num[*,*,1])

			tau1=strcompress(tau_ave[1],/rem)
			tau1=strmid(tau1,0,5)
			 c1=image(data2,lon,lat,rgb_table=33,min_value=minvalue1,max_value=maxvalue1,$
	         position=pos4,font_size=fontsz,/current)
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
			 t2=text(pos[0],pos[3]+0.01,'(b2) ave $\tau=$'+tau1+'$\pm$'+tauerr[1],font_size=fontsz)


			data3=(reform(data[*,*,2])+reform(data[*,*,3]))/float(Tobsnum - Tfilter_all)
			ind=where(finite(data3) eq 0)
			data3[ind]=0.0
			freh=total(data3*(Tobsnum - Tfilter_all))/total(float(Tobsnum - Tfilter_all))
			freh1=strcompress(freh*100,/rem)	
			freh1=strmid(freh1,0,4)	
			c2=image(data3*5,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
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
			 t3=text(pos[0],pos[3]+0.01,'(a3) ave f='+freh1+'%'+'   scale=0.2',font_size=fontsz)
		   	 t1=text(pos[0]-0.075,pos[1]-0.02,'Merged-layer-above',orientation=90,font_size=fontsz)
		   	 t1=text(pos[0]-0.055,pos[1]+0.04,'cloud',orientation=90,font_size=fontsz)
	
			data4=(reform(Taeroincld_tau[*,*,2])+reform(Taeroincld_tau[*,*,3]))/$
				(reform(Taeroincld_num[*,*,2])+reform(Taeroincld_num[*,*,3]))

			tau=total(reform(Taeroincld_tau[*,*,2])+reform(Taeroincld_tau[*,*,3]))/$
				total(reform(Taeroincld_num[*,*,2])+reform(Taeroincld_num[*,*,3]))
			tau1=strcompress(tau,/rem)
			tau1=strmid(tau1,0,5)

			 c4=image(data4,lon,lat,rgb_table=33,min_value=minvalue1,max_value=maxvalue1,$
	         position=pos6,font_size=fontsz,/current)
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
			 t4=text(pos[0],pos[3]+0.01,'(b3) ave $\tau=$'+tau1+'$\pm$'+tauerr[2],font_size=fontsz)

			data5=(reform(data[*,*,4])+reform(data[*,*,5]))/float(Tobsnum - Tfilter_all)
			ind=where(finite(data5) eq 0)
			data5[ind]=0.0
			freh=total(data5*(Tobsnum - Tfilter_all))/total(float(Tobsnum-Tfilter_all))
			freh1=strcompress(freh*100,/rem)	
			freh1=strmid(freh1,0,4)	
			c5=image(data5*5,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
	         position=pos7,font_size=fontsz,/current)
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
			 t5=text(pos[0],pos[3]+0.01,'(a4) ave f='+freh1+'%'+'   scale=0.2',font_size=fontsz)
		   	 t1=text(pos[0]-0.055,pos[1]-0.02,'Other-in-cloud',orientation=90,font_size=fontsz)

			data6=(reform(Taeroincld_tau[*,*,4])+reform(Taeroincld_tau[*,*,5]))/$
				(reform(Taeroincld_num[*,*,4])+reform(Taeroincld_num[*,*,5]))

			tau=total(reform(Taeroincld_tau[*,*,4])+reform(Taeroincld_tau[*,*,5]))/$
				total(reform(Taeroincld_num[*,*,4])+reform(Taeroincld_num[*,*,5]))
			tau1=strcompress(tau,/rem)
			tau1=strmid(tau1,0,5)
			 c6=image(data6,lon,lat,rgb_table=33,min_value=minvalue1,max_value=maxvalue1,$
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
			 t6=text(pos[0],pos[3]+0.01,'(b4) ave $\tau$='+tau1+'$\pm$'+tauerr[3],font_size=fontsz)
			
			barpos1=[pos7[0],pos7[1]-0.05,pos7[2],pos7[1]-0.03]
		  	ct=colorbar(target=c,title='Aerosol occurrence frequency',taper=1,$
            border=1,position=barpos1,font_size=fontsz-1,orientation=0,major=7)

			barpos2=[pos8[0],pos8[1]-0.05,pos8[2],pos8[1]-0.03]
		  	ct=colorbar(target=c1,title='Aerosol optical depth',taper=1,$
            border=1,position=barpos2,font_size=fontsz-1,orientation=0)

			c.save,'aerosol_cldmerged_fre_aod_cad20_screened_ocean_land.png'

	EndIf

	;=============== to plot the isolated cases ====================================
	IF (plotfre_isolated eq 1) Then Begin
		pos1=[0.11,0.74,0.50,0.96]
		pos2=[0.57,0.74,0.96,0.96]
		pos3=[0.11,0.44,0.50,0.66]
		pos4=[0.57,0.44,0.96,0.66]
		pos5=[0.11,0.14,0.50,0.36]
		pos6=[0.57,0.14,0.96,0.36]
		minvalue=0.0
		maxvalue=1.0
		minvalue1=0.0
		maxvalue1=1.0

		Nisolate=9
		data=Taeroisolate_num

		tauerr=['0.087','0.039','0.083'] ; from  plot_tau_uncer.pro

		for i=0,Nisolate-1 do begin
			freh1=total(reform(data[*,*,i]))/total(float(Tallaero_num));!total(float(Tobsnum -Tfilter_all))
			tau1=total(Taeroisolate_tau[*,*,i])/float(total(data[*,*,i]))
			print,'isolated weighted freh and tau',freh1,tau1
		endfor		
		;== to plot=== 
		data1=(reform(data[*,*,0])+reform(data[*,*,3])+reform(data[*,*,7]))/float(Tallaero_num);float(Tobsnum - Tfilter_all)
        ind=where(finite(data1) eq 0)
        data1[ind]=0.0
        ;freh=total(weights*total(data1,1,/nan))/(dimx*total(weights))
		freh=total(data1*(Tobsnum - Tfilter_all))/float(total(Tobsnum - Tfilter_all))
        print,'below-cloud aerosol weighted freh',freh
        freh1=strcompress(freh*100,/rem)
        freh1=strmid(freh1,0,4)
        c=image(data1,lon,lat,dim=[550,500],rgb_table=33,min_value=minvalue,max_value=maxvalue,$
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
             t1=text(pos[0],pos[3]+0.01,'(a1) ave f='+freh1+'%'+'   scale=1.0',font_size=fontsz)
             t1=text(pos[0]-0.075,pos[1]+0.01,'Below-cloud',orientation=90,font_size=fontsz)
             t1=text(pos[0]-0.055,pos[1]+0.04,'aerosol',orientation=90,font_size=fontsz)

		tau=(reform(Taeroisolate_tau[*,*,0])+reform(Taeroisolate_tau[*,*,3])+reform(Taeroisolate_tau[*,*,7]))/$
		reform(Taeroisolate_num[*,*,0]+Taeroisolate_num[*,*,3]+Taeroisolate_num[*,*,7])
		tau1=total(reform(Taeroisolate_tau[*,*,0])+reform(Taeroisolate_tau[*,*,3])+reform(Taeroisolate_tau[*,*,7]))/$
		total(Taeroisolate_num[*,*,0]+Taeroisolate_num[*,*,3]+Taeroisolate_num[*,*,7])
	;	tau1=total(weights*total(tau,1,/nan))/(dimx*total(weights))
		tau1=strcompress(tau1,/rem)
        tau1=strmid(tau1,0,5)
		
		c1=image(tau,lon,lat,rgb_table=33,min_value=minvalue1,max_value=maxvalue1,$
              position=pos2,font_size=fontsz,/current)
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
              t2=text(pos[0],pos[3]+0.01,'(b1) ave $\tau=$'+tau1+'$\pm$'+tauerr[0],font_size=fontsz)

		data2=(reform(data[*,*,1])+reform(data[*,*,4])+reform(data[*,*,6]))/float(Tallaero_num);float(Tobsnum - Tfilter_all)
        ind=where(finite(data2) eq 0)
        data2[ind]=0.0
        freh=total((data2*(Tobsnum - Tfilter_all)))/total(Tobsnum - Tfilter_all)
        print,'above-cloud aerosol weighted freh',freh
        freh1=strcompress(freh*100,/rem)
        freh1=strmid(freh1,0,4)
        c2=image(data2,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
             position=pos3,font_size=fontsz,/current)
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
             t1=text(pos[0],pos[3]+0.01,'(a2) ave f='+freh1+'%'+'   scale=0.5',font_size=fontsz)
             t1=text(pos[0]-0.075,pos[1]+0.01,'Above-cloud',orientation=90,font_size=fontsz)
             t1=text(pos[0]-0.055,pos[1]+0.04,'aerosol',orientation=90,font_size=fontsz)

		tau=(reform(Taeroisolate_tau[*,*,1])+reform(Taeroisolate_tau[*,*,4])+reform(Taeroisolate_tau[*,*,6]))/$
		reform(Taeroisolate_num[*,*,1]+Taeroisolate_num[*,*,4]+Taeroisolate_num[*,*,6])
		;tau1=total(weights*total(tau,1,/nan))/(dimx*total(weights))
		tau1=total(reform(Taeroisolate_tau[*,*,1])+reform(Taeroisolate_tau[*,*,4])+reform(Taeroisolate_tau[*,*,6]))/$
		total(Taeroisolate_num[*,*,1]+Taeroisolate_num[*,*,4]+Taeroisolate_num[*,*,6])
		tau1=strcompress(tau1,/rem)
        tau1=strmid(tau1,0,5)
		
		c3=image(tau,lon,lat,rgb_table=33,min_value=minvalue1,max_value=maxvalue1,$
              position=pos4,font_size=fontsz,/current)
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
              t2=text(pos[0],pos[3]+0.01,'(b2) ave $\tau=$'+tau1+'$\pm$'+tauerr[1],font_size=fontsz)

		data3=(reform(data[*,*,2])+reform(data[*,*,5])+reform(data[*,*,8]))/float(Tallaero_num);float(Tobsnum - Tfilter_all)
        ind=where(finite(data3) eq 0)
        data3[ind]=0.0
        ;freh=total(weights*total(data3,1,/nan))/(dimx*total(weights))
		freh=total(data3*(Tobsnum - Tfilter_all))/float(total(Tobsnum - Tfilter_all))
        print,'other cloud aerosol weighted freh',freh
        freh1=strcompress(freh*100,/rem)
        freh1=strmid(freh1,0,4)
        c4=image(data3*10,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
             position=pos5,font_size=fontsz,/current)
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
             t1=text(pos[0],pos[3]+0.01,'(a3) ave f='+freh1+'%'+'   scale=0.1',font_size=fontsz)
             t1=text(pos[0]-0.055,pos[1]+0.02,'Other-isolated-cloud',orientation=90,font_size=fontsz)

		tau=(reform(Taeroisolate_tau[*,*,2])+reform(Taeroisolate_tau[*,*,5])+reform(Taeroisolate_tau[*,*,8]))/$
		reform(Taeroisolate_num[*,*,2]+Taeroisolate_num[*,*,5]+Taeroisolate_num[*,*,8])
		tau1=total(reform(Taeroisolate_tau[*,*,2])+reform(Taeroisolate_tau[*,*,5])+reform(Taeroisolate_tau[*,*,8]))/$
		total(Taeroisolate_num[*,*,2]+Taeroisolate_num[*,*,5]+Taeroisolate_num[*,*,8])
;		tau1=total(weights*total(tau,1,/nan))/(dimx*total(weights))
		tau1=strcompress(tau1,/rem)
        tau1=strmid(tau1,0,5)
		
		c5=image(tau,lon,lat,rgb_table=33,min_value=minvalue1,max_value=maxvalue1,$
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
              t2=text(pos[0],pos[3]+0.01,'(b3) ave $\tau=$'+tau1+'$\pm$'+tauerr[2],font_size=fontsz)

			barpos1=[pos5[0],pos5[1]-0.06,pos5[2],pos5[1]-0.04]
		  	ct=colorbar(target=c,title='Aerosol occurrence frequency',taper=1,$
            border=1,position=barpos1,font_size=fontsz-1,orientation=0,major=8)

			barpos2=[pos6[0],pos6[1]-0.06,pos6[2],pos6[1]-0.04]
		  	ct=colorbar(target=c1,title='Aerosol optical depth',taper=1,$
            border=1,position=barpos2,font_size=fontsz-1,orientation=0)

		c.save,'aerosol_cldisolate_fre_aod_cad20_screened_ocean_land.png'	

	EndIf
	;================ end plot isolated-cloud aerosols distributions================
	;taumax=1.0
    fremax=1.0
	;scamax=0.008
	;depmax=0.2
	
	;check data
	IF (check_data eq 1) Then Begin
	For i=0, 0 do begin
;	data=reform(Taeroincld_num[*,*,i])/float(Tobsnum)
	data=(total(Taeroincld_num,3)+total(Taeroisolate_num,3))/float(Tobsnum - Tfilter_all)
;	data=float(Taeroonly_num)/float(Tobsnum)
;	data=reform(avedep_isolate[*,*,i])
;	data=avedep_only

	c=image(data,lon,lat,rgb_table=33,min_value=0,max_value=fremax,$
         font_size=fontsz)
    mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
      grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'
   grid.grid_longitude=60
   grid.grid_latitude=30
   grid.font_size=fontsz-3
   mc=mapcontinents(/continents,transparency=30)
   mc['Longitudes'].label_angle=0
   c.scale,5,4
   endfor
   endIF
	
	lnthk=2.0
	iscolor=['peru','pink','green','red','blue','light blue','magenta','Khaki','olive']
	isname =['aero below cld','aero above cld','aero between cld','multi-aero,one-cloud above','multi-aero,one-cloud below',$
			'multi-aero,one-cld inbetween','multi-aero,multi-cld,aero above','multi-aero,multi-cld,aero below','multi-aero,multi-cld,others']
	incolor=['pink','green','red','blue','light blue','cyan','peru']
	inname =['merged layer','merged layer below cld','merged layer above cld','merged layer between cld',$
			'multi-aero,one-cld','multi-aero,multi-cld']

   IF (plotpdf eq 1) Then Begin
	tau_interval=findgen(Ntau)*0.01-4
	;for tau
	xrange=[-3,1]
	yrange=[0,1.5]
	xtitle='$log10(\tau)$'
	ytitle='Frequency (%)'
	;for dep
;	xrange=[0,0.2]
;	yrange=[0,0.15]
;	xtitle='Depolarization ratio'

	;for backscat
;	xrange=[-4.5,-0.5]
;	yrange=[0,0.015]
;	xtitle='Backscatter'

	xdata=tau_interval

	pos1=[0.10,0.15,0.50,0.9]	
	pos2=[0.58,0.15,0.98,0.9]	

	ydata1=100*float(total(total(Taeroonly_taupdf,1),1))/total(Taeroonly_taupdf)
	
 	po1=plot(xdata,ydata1,color='black',xrange=xrange,yrange=yrange,thick=lnthk,$
		xtitle=xtitle,name='Cloud-free aerosol',xticklen=0.02,yticklen=0.02,$
		dim=[650,300],position=pos1,ytitle=ytitle,font_size=fontsz)
	a1=text(pos1[0]+0.03,pos1[3]+0.01,'(a)',font_size=fontsz)

	pdf2cdf,ydata1,ydata1_cdf
	res=interpol(xdata,ydata1_cdf,50)
	print,'cloud-free aerosol median', 10.0^res
	res=where(max(ydata1) eq ydata1)
	print,'cloud-free aerosol mode',10.0^xdata[res[0]]
	
 	po2=plot(xdata,ydata1,color='black',xrange=xrange,yrange=yrange,thick=lnthk,$
		xtitle=xtitle,name='Cloud-free aerosol',xticklen=0.02,yticklen=0.02,$
		/current,position=pos2,ytitle=ytitle,font_size=fontsz)
	a2=text(pos2[0]+0.03,pos2[3]+0.01,'(b)',font_size=fontsz)

	ydata2=100*float(total(total(reform(Taeroisolate_taupdf[*,*,*,0]+Taeroisolate_taupdf[*,*,*,3]+Taeroisolate_taupdf[*,*,*,7]),1),1))/$
		total(Taeroisolate_taupdf[*,*,*,0]+Taeroisolate_taupdf[*,*,*,3]+Taeroisolate_taupdf[*,*,*,7])

	pdf2cdf,ydata2,ydata2_cdf
	res=interpol(xdata,ydata2_cdf,50.0)
	print,'below cloud aerosol median', 10.0^res
	res=where(max(ydata2) eq ydata2)
	print,'below cloud aerosol mode',10.0^xdata[res[0]]

	p1=plot(xdata,ydata2,color='r',xrange=xrange,yrange=yrange,thick=lnthk,$
		overplot=po2,name='Below-cloud aerosol')

	ydata3=100*float(total(total(reform(Taeroisolate_taupdf[*,*,*,1]+Taeroisolate_taupdf[*,*,*,4]+Taeroisolate_taupdf[*,*,*,6]),1),1))/$
		total(Taeroisolate_taupdf[*,*,*,1]+Taeroisolate_taupdf[*,*,*,4]+Taeroisolate_taupdf[*,*,*,6])
	pdf2cdf,ydata3,ydata3_cdf
	res=interpol(xdata,ydata3_cdf,50.0)
	print,'above cloud aerosol median', 10.0^res
	res=where(max(ydata3) eq ydata3)
	print,'above cloud aerosol mode',10.0^xdata[res[0]]

	p2=plot(xdata,ydata3,color='g',xrange=xrange,yrange=yrange,thick=lnthk,$
		overplot=po2,name='Above-cloud aerosol')
	ydata4=100*float(total(total(reform(Taeroisolate_taupdf[*,*,*,2]+Taeroisolate_taupdf[*,*,*,5]+Taeroisolate_taupdf[*,*,*,8]),1),1))/$
		total(Taeroisolate_taupdf[*,*,*,2]+Taeroisolate_taupdf[*,*,*,5]+Taeroisolate_taupdf[*,*,*,8])
	pdf2cdf,ydata4,ydata4_cdf
	res=interpol(xdata,ydata4_cdf,50.0)
	print,'other cloud aerosol median', 10.0^res
	res=where(max(ydata4) eq ydata4)
	print,'other cloud aerosol mode',10.0^xdata[res[0]]

	p3=plot(xdata,ydata4,color='cyan',xrange=xrange,yrange=yrange,thick=lnthk,$
		overplot=po2,name='Other-isolated-cloud')
	ld=legend(target=[po2,p1,p2,p3],position=[pos2[0]+0.02,pos2[3]-0.01],transparency=100,horizontal_alignment=0,$
		font_size=fontsz,vertical_spacing=0.01)

	ydata5=100*float(total(total(reform(Taeroincld_taupdf[*,*,*,0]),1),1))/total(Taeroincld_taupdf[*,*,*,0])
	pdf2cdf,ydata5,ydata5_cdf
	res=interpol(xdata,ydata5_cdf,50.0)
	print,'merged layer only aerosol median', 10.0^res
	res=where(max(ydata5) eq ydata5)
	print,'merged lyaer only aerosol mode',10.0^xdata[res[0]]


	i1=plot(xdata,ydata5,color='pink',xrange=xrange,yrange=yrange,thick=lnthk,$
		overplot=po1,name='Merged-layer-only')

	ydata6=100*float(total(total(reform(Taeroincld_taupdf[*,*,*,1]),1),1))/total(Taeroincld_taupdf[*,*,*,1])
	pdf2cdf,ydata6,ydata6_cdf
	res=interpol(xdata,ydata6_cdf,50.0)
	print,'merged layer below cloud median', 10.0^res
	res=where(max(ydata6) eq ydata6)
	print,'merged layer below cloud  mode',10.0^xdata[res[0]]


	i2=plot(xdata,ydata6,color='r',xrange=xrange,yrange=yrange,thick=lnthk,$
		overplot=po1,name='Merged-layer-below-cloud')

	ydata7=100*float(total(total(reform(Taeroincld_taupdf[*,*,*,2]+Taeroincld_taupdf[*,*,*,3]),1),1))/$
		total(reform(Taeroincld_taupdf[*,*,*,2]+Taeroincld_taupdf[*,*,*,3]))
	pdf2cdf,ydata7,ydata7_cdf

	res=interpol(xdata,ydata7_cdf,50.0)
	print,'merged layer above cloud median', 10.0^res
	res=where(max(ydata7) eq ydata7)
	print,'merged layer above cloud  mode',10.0^xdata[res[0]]

	i3=plot(xdata,ydata7,color='g',xrange=xrange,yrange=yrange,thick=lnthk,$
		overplot=po1,name='Merged-layer-above-cloud')
	ydata8=100*float(total(total(reform(Taeroincld_taupdf[*,*,*,4]+Taeroincld_taupdf[*,*,*,5]),1),1))/$
		total(Taeroincld_taupdf[*,*,*,4]+Taeroincld_taupdf[*,*,*,5])
	pdf2cdf,ydata8,ydata8_cdf
	res=interpol(xdata,ydata8_cdf,50.0)
	print,'other merged layer  median', 10.0^res
	res=where(max(ydata8) eq ydata8)
	print,'other merged layer  mode',10.0^xdata[res[0]]
	i4=plot(xdata,ydata8,color='cyan',xrange=xrange,yrange=yrange,thick=lnthk,$
		overplot=po1,name='Other-in-cloud')

	ld=legend(target=[po1,i1,i2,i3,i4],position=[pos1[0]+0.02,pos1[3]-0.01],transparency=100,horizontal_alignment=0,$
		font_size=fontsz,vertical_spacing=0.01)
	
	  po1.save,'taupdf_aerocld_merged_isolated_combine_cad20_noextqc.png'

   EndIf ;end plotpdf

stop
end
