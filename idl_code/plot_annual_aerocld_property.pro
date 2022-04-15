
pro  plot_annual_aerocld_property

	fname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen/','*.hdf')

  	Nf=n_elements(fname)

    dimx=72
	dimy=90
	Ntau=601
	Ndep=201
	Nsca=501
	Nisolate=9
	Nincld=6
	Nonly=2
	;flags
	plotpdf=1 ;to plot pdf
	check_data=0 ; to check data
	plotfre=1 ; to plot the frequency/tau of aerosol-cloud overlap
	fontsz=11

	lon=findgen(dimx)*5-180
	lat=findgen(dimy)*2-90+1

    Tobsnum=ulonarr(dimx,dimy)

    Taeroonly_num=ulonarr(dimx,dimy,2)
    Taeroonly_negativetau_num=ulonarr(dimx,dimy,2)
	Taeroonly_tau=dblarr(dimx,dimy,2)
	Taeroonly_dep=dblarr(dimx,dimy,2)
	Taeroonly_sca=dblarr(dimx,dimy,2)
	Taeroonly_taupdf=dblarr(Ntau,2)
	Taeroonly_deppdf=dblarr(Ndep,2)
	Taeroonly_scapdf=dblarr(Nsca,2)
	
    Taeroisolate_num=ulonarr(dimx,dimy,Nisolate)
    Taeroisolate_negativetau_num=ulonarr(dimx,dimy,Nisolate)
	Taeroisolate_tau=dblarr(dimx,dimy,Nisolate)
	Taeroisolate_dep=dblarr(dimx,dimy,Nisolate)
	Taeroisolate_sca=dblarr(dimx,dimy,Nisolate)
	Taeroisolate_taupdf=dblarr(Ntau,Nisolate)
	Taeroisolate_deppdf=dblarr(Ndep,Nisolate)
	Taeroisolate_scapdf=dblarr(Nsca,Nisolate)

    Taeroincld_num=ulonarr(dimx,dimy,Nincld)
    Taeroincld_negativetau_num=ulonarr(dimx,dimy,Nincld)
	Taeroincld_tau=dblarr(dimx,dimy,Nincld)
	Taeroincld_dep=dblarr(dimx,dimy,Nincld)
	Taeroincld_sca=dblarr(dimx,dimy,Nincld)
	Taeroincld_taupdf=dblarr(Ntau,Nincld)
	Taeroincld_deppdf=dblarr(Ndep,Nincld)
	Taeroincld_scapdf=dblarr(Nsca,Nincld)

    for fi=0,Nf-1 do begin

		IF (strlen(fname[fi]) eq 130) Then Begin
		read_dardar,fname[fi],'obs_numh',obsnum
		Tobsnum=Tobsnum+obsnum

		read_dardar,fname[fi],'aerosol_only_numh',aeroonly_num
		read_dardar,fname[fi],'aerosol_only_negativetau_numh',aeroonly_negativetau_num
		read_dardar,fname[fi],'aerosol_only_tau',aeroonly_tau
		read_dardar,fname[fi],'aerosol_only_depratio',aeroonly_dep
		read_dardar,fname[fi],'aerosol_only_backscatt',aeroonly_sca
		read_dardar,fname[fi],'pdf_aero_only_tau',aeroonly_taupdf
		read_dardar,fname[fi],'pdf_aero_only_depratio',aeroonly_deppdf
		read_dardar,fname[fi],'pdf_aero_only_backscatt',aeroonly_scapdf
	
		ind=where(aeroonly_num eq 0)
		aeroonly_tau[ind]=0.0
		aeroonly_dep[ind]=0.0
		aeroonly_sca[ind]=0.0
		Taeroonly_num=Taeroonly_num + aeroonly_num
		Taeroonly_negativetau_num=Taeroonly_negativetau_num + aeroonly_negativetau_num
		Taeroonly_tau=Taeroonly_tau + aeroonly_tau*(aeroonly_num-aeroonly_negativetau_num)	
		Taeroonly_dep=Taeroonly_dep + aeroonly_dep*aeroonly_num
		Taeroonly_sca=Taeroonly_sca + aeroonly_sca*aeroonly_num
		Taeroonly_taupdf=Taeroonly_taupdf + aeroonly_taupdf	
		Taeroonly_deppdf=Taeroonly_deppdf + aeroonly_deppdf
		Taeroonly_scapdf=Taeroonly_scapdf + aeroonly_scapdf
		
		read_dardar,fname[fi],'isolate_aerosol_num',aeroisolate_num
		read_dardar,fname[fi],'isolate_aerosol_negativetau_num',aeroisolate_negativetau_num
		read_dardar,fname[fi],'isolate_aerosol_tau',aeroisolate_tau
		read_dardar,fname[fi],'isolate_aerosol_depratio',aeroisolate_dep
		read_dardar,fname[fi],'isolate_aerosol_backscatt',aeroisolate_sca
		read_dardar,fname[fi],'pdf_isolate_aero_tau',aeroisolate_taupdf
		read_dardar,fname[fi],'pdf_isolate_aero_depratio',aeroisolate_deppdf
		read_dardar,fname[fi],'pdf_isolate_aero_backscatt',aeroisolate_scapdf

		ind=where(aeroisolate_num eq 0)
		aeroisolate_tau[ind]=0.0
		aeroisolate_dep[ind]=0.0
		aeroisolate_sca[ind]=0.0
		Taeroisolate_num=Taeroisolate_num + aeroisolate_num
		Taeroisolate_negativetau_num=Taeroisolate_negativetau_num + aeroisolate_negativetau_num
		Taeroisolate_tau=Taeroisolate_tau + aeroisolate_tau*(aeroisolate_num-aeroisolate_negativetau_num)	
		Taeroisolate_dep=Taeroisolate_dep + aeroisolate_dep*aeroisolate_num
		Taeroisolate_sca=Taeroisolate_sca + aeroisolate_sca*aeroisolate_num
		Taeroisolate_taupdf=Taeroisolate_taupdf + aeroisolate_taupdf	
		Taeroisolate_deppdf=Taeroisolate_deppdf + aeroisolate_deppdf
		Taeroisolate_scapdf=Taeroisolate_scapdf + aeroisolate_scapdf

		read_dardar,fname[fi],'incloud_aerosol_num',aeroincld_num
		read_dardar,fname[fi],'incloud_aerosol_negativetau_num',aeroincld_negativetau_num
		read_dardar,fname[fi],'incloud_aerosol_tau',aeroincld_tau
		read_dardar,fname[fi],'incloud_aerosol_depratio',aeroincld_dep
		read_dardar,fname[fi],'incloud_aerosol_backscatt',aeroincld_sca
		read_dardar,fname[fi],'pdf_incld_aero_tau',aeroincld_taupdf
		read_dardar,fname[fi],'pdf_incld_aero_depratio',aeroincld_deppdf
		read_dardar,fname[fi],'pdf_incld_aero_backscatt',aeroincld_scapdf

		ind=where(aeroincld_num eq 0)
		aeroincld_tau[ind]=0.0
		aeroincld_dep[ind]=0.0
		aeroincld_sca[ind]=0.0
		Taeroincld_num=Taeroincld_num + aeroincld_num
		Taeroincld_negativetau_num=Taeroincld_negativetau_num + aeroincld_negativetau_num
		Taeroincld_tau=Taeroincld_tau + aeroincld_tau*(aeroincld_num-aeroincld_negativetau_num)	
		Taeroincld_dep=Taeroincld_dep + aeroincld_dep*aeroincld_num
		Taeroincld_sca=Taeroincld_sca + aeroincld_sca*aeroincld_num
		Taeroincld_taupdf=Taeroincld_taupdf + aeroincld_taupdf	
		Taeroincld_deppdf=Taeroincld_deppdf + aeroincld_deppdf
		Taeroincld_scapdf=Taeroincld_scapdf + aeroincld_scapdf
		EndIf
	endfor

	;===========================================================

	avetau_incld=Taeroincld_tau/(Taeroincld_num-Taeroincld_negativetau_num)
	avetau_only=Taeroonly_tau/(Taeroonly_num-Taeroonly_negativetau_num)
	avetau_isolate=Taeroisolate_tau/(Taeroisolate_num-Taeroisolate_negativetau_num)
	avetau_allcld=(total(Taeroincld_tau,3)+total(Taeroisolate_tau,3))/$
		total((Taeroincld_num+Taeroisolate_num-Taeroincld_negativetau_num-Taeroisolate_negativetau_num),3)

	avedep_incld=Taeroincld_dep/(Taeroincld_num)
	avedep_only=Taeroonly_dep/(Taeroonly_num)
	avedep_isolate=Taeroisolate_dep/(Taeroisolate_num)
	avedep_allcld=(total(Taeroincld_dep,3)+total(Taeroisolate_dep,3))/$
		total((Taeroincld_num+Taeroisolate_num),3)
	
	avesca_incld=Taeroincld_sca/(Taeroincld_num)
	avesca_only=Taeroonly_sca/(Taeroonly_num)
	avesca_isolate=Taeroisolate_sca/(Taeroisolate_num)
	avesca_allcld=(total(Taeroincld_sca,3)+total(Taeroisolate_sca,3))/$
		total((Taeroincld_num+Taeroisolate_num),3)

	;===========================================================
	;============ calculate average tau ========================
	; total aero-cld case
	weights=cos(lat*!pi/180)
	avetau_aerocld=$
	(total(Taeroincld_tau,3)+total(Taeroisolate_tau,3))$
	/total((Taeroincld_num-Taeroincld_negativetau_num+Taeroisolate_num-Taeroisolate_negativetau_num),3)
	print,'avetau_aerocld tau, weight average',total(weights*total(avetau_aerocld,1,/nan))/(dimx*total(weights))
 
	avetau_aerois=$
	(total(Taeroisolate_tau,3))$
	/total((Taeroisolate_num-Taeroisolate_negativetau_num),3)
	print,'avetau_aero isolated tau, weight average',total(weights*total(avetau_aerois,1,/nan))/(dimx*total(weights))
 
	avetau_aeroin=$
	(total(Taeroincld_tau,3))$
	/total((Taeroincld_num-Taeroincld_negativetau_num),3)
	print,'avetau_aero incld tau, weight average',total(weights*total(avetau_aeroin,1,/nan))/(dimx*total(weights))

	print,'avetau_only,tau, onelayer',total(weights*total(reform(avetau_only[*,*,0]),1,/nan))/(dimx*total(weights))
	print,'avetau_only,tau, multilayer',total(weights*total(reform(avetau_only[*,*,1]),1,/nan))/(dimx*total(weights))
	fre1=reform(Taeroonly_num[*,*,0])/float(Tobsnum)
	fre2=reform(Taeroonly_num[*,*,1])/float(Tobsnum)
	print,'aero only fre, onelayer',total(weights*total(fre1,1,/nan))/(dimx*total(weights))
	print,'aero only fre, multilayer',total(weights*total(fre2,1,/nan))/(dimx*total(weights))

	posx1=[0.10,0.56,0.10,0.56]
	posx2=[0.50,0.96,0.50,0.96]
	posy1=[0.60,0.60,0.21,0.21]
	posy2=[0.90,0.90,0.51,0.51]
	maplimit=[-90,-180,90,180]
    minvalue=0	
	maxvalue=1.0
	barpos=[0.2,0.09,0.8,0.12]
;    title=['a) Below-cloud aerosol','b) Above-cloud aerosol','c) Inbetween-cloud aerosol']
;	title=['a) Below-cloud aerosol (one-layer cloud)','b) Above-cloud aerosol (one-layer cloud)','c) Cloud inbetween aerosol (one-layer cloud)','d) Multi-layer aerosols and clouds'] ; for isolated cases
	title=['a) One merged layer','b) Below-cloud merged layer','c) Above-cloud merged layer','d) Inbetween-cloud merged layer'] ; for merged layers
 	;title=['a) Multi-layer aerosol,One-layer cloud','b Multi-layer aerosol and cloud']
	
	;title=['a) One-layer aerosol','b) Multi-layer aerosol']
	Imagetitle='Aerosol-Cloud Merged'	
; 	bartitle='Aerosol tau'
	; to plot the frequency of cloud aerosol overlap
	data=Taeroincld_num
;	data=Taeroisolate_num

	;to plot tau
;	data=avetau_incld
   ind=where(Tobsnum eq 0)
 
	IF (plotfre eq 1) Then Begin
		for i=0,3 do begin
			pos=[posx1[i],posy1[i],posx2[i],posy2[i]]
			data1=data[*,*,i]/float(Tobsnum)
;			data1=reform(data[*,*,i])
			ind=where(finite(data1) eq 0)
			data1[ind]=0.0
	
			print,i,'weight average',total(weights*total(data1,1,/nan))/(dimx*total(weights))

			IF (i eq 0 ) Then begin
			 c=image(data1,lon,lat,dim=[700,400],rgb_table=33,min_value=minvalue,max_value=maxvalue,$
	         position=pos,font_size=fontsz)
		     mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
		     grid=mp.MAPGRID
			 grid.label_position=0
			 grid.linestyle='dotted'
			 grid.grid_longitude=60
			 grid.grid_latitude=30
			 grid.font_size=fontsz-3
			 mc=mapcontinents(/continents,transparency=30)
			 mc['Longitudes'].label_angle=0
			 t1=text(0.4,0.945,Imagetitle)
			 c.scale,1.0,1
			EndIF else begin
			 c1=image(data1,lon,lat,rgb_table=33,min_value=minvalue,max_value=maxvalue,$
	         position=pos,font_size=fontsz,/current)
		     mp=map('Geographic',limit=maplimit,transparency=30,overplot=c1)
		     grid=mp.MAPGRID
			 grid.label_position=0
			 grid.linestyle='dotted'
			 grid.grid_longitude=60
			 grid.grid_latitude=30
			 grid.font_size=fontsz-3
			 mc=mapcontinents(/continents,transparency=30)
			 mc['Longitudes'].label_angle=0
			 c1.scale,1.0,1
			EndElse
			tx=text(pos[0]+0.02,pos[3],title[i])
		endfor
		  	ct=colorbar(target=c,title=bartitle,taper=1,$
            border=1,position=barpos,font_size=fontsz-1,orientation=0)
			c.save,'Onelay_aerosol_cldmerged_'+bartitle+'.png'

	EndIf

	;taumax=1.0
    fremax=1.0
	;scamax=0.008
	;depmax=0.2
	
	;check data
	IF (check_data eq 1) Then Begin
	For i=0, 0 do begin
;	data=reform(Taeroincld_num[*,*,i])/float(Tobsnum)
	data=(total(Taeroincld_num,3)+total(Taeroisolate_num,3))/float(Tobsnum)
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
	dep_interval=findgen(Ndep)*0.005
	sca_interval=findgen(Nsca)*0.01-5
	;for tau
;	xrange=[-3,1]
;	yrange=[0,0.015]
;	xtitle='$log10(\tau)$'
	;for dep
;	xrange=[0,0.2]
;	yrange=[0,0.15]
;	xtitle='Depolarization ratio'

	;for backscat
	xrange=[-4.5,-0.5]
	yrange=[0,0.015]
	xtitle='Backscatter'

	xdata=sca_interval
	
;	ydata1=float(Taeroonly_taupdf[*,0])/total(Taeroonly_taupdf[*,0])
;	ydata1=float(Taeroonly_deppdf[0:Ndep-2],0)/total(Taeroonly_deppdf[0:Ndep-2,0])
	ydata1=float(Taeroonly_scapdf[*,0])/total(Taeroonly_scapdf[*,0])
	
 	po1=plot(xdata,ydata1,color='black',xrange=xrange,yrange=yrange,thick=lnthk,$
		title='Aerosol Cloud Isolated',xtitle=xtitle,name='Single-layer cloud-free aerosol')
;	ydata2=float(Taeroonly_deppdf[0:Ndep-2,1])/total(Taeroonly_deppdf[0:Ndep-2,1])
;	ydata2=float(Taeroonly_taupdf[*,1])/total(Taeroonly_taupdf[*,1])
	ydata2=float(Taeroonly_scapdf[*,1])/total(Taeroonly_scapdf[*,1])

	po11=plot(xdata,ydata2,thick=lnthk,name='Multi-layer cloud-free aerosol',linestyle='dashed',overplot=po1)
	ld=legend(target=[po1,po11],position=[0.1,0.85],transparency=100,horizontal_alignment=0)

 	po2=plot(xdata,ydata1,color='black',xrange=xrange,yrange=yrange,thick=lnthk,$
		title='Aerosol Cloud Merged',xtitle=xtitle,name='Single-layer cloud-free aerosol')
	po21=plot(xdata,ydata2,thick=lnthk,name='Multi-layer cloud-free aerosol',linestyle='dashed',overplot=po2)
	ld=legend(target=[po2,po21],position=[0.1,0.85],transparency=100,horizontal_alignment=0)

	 for i=0,Nisolate-1 do begin
;		ydata2=float(reform(Taeroisolate_taupdf[*,i]))/total(Taeroisolate_taupdf[*,i])
;		ydata2=float(reform(Taeroisolate_deppdf[0:Ndep-2,i]))/total(Taeroisolate_deppdf[0:Ndep-2,i])
	   ydata2=float(reform(Taeroisolate_scapdf[*,i]))/total(Taeroisolate_scapdf[*,i])
	 	p1=plot(xdata,ydata2,color=iscolor[i],xrange=xrange,yrange=yrange,thick=lnthk,$
		overplot=po1,name=isname[i])
		ld=legend(target=[p1],position=[0.6,0.88-i*0.03],transparency=100,horizontal_alignment=0)
	 endfor

	 for i=0,Nincld-1 do begin
;		ydata3=float(reform(Taeroincld_taupdf[*,i]))/total(Taeroincld_taupdf[*,i])
		;ydata3=float(reform(Taeroincld_deppdf[0:Ndep-2,i]))/total(Taeroincld_deppdf[0:Ndep-2,i])
		ydata3=float(reform(Taeroincld_scapdf[*,i]))/total(Taeroincld_scapdf[*,i])
		p2=plot(xdata,ydata3,color=incolor[i],xrange=xrange,yrange=yrange,thick=lnthk,$
		overplot=po2,name=inname[i])
		ld=legend(target=[p2],position=[0.6,0.88-i*0.03],transparency=100,horizontal_alignment=0)
	 endfor
	
;	  po1.save,'taupdf_aerocld_isolate.png'
;	  po2.save,'taupdf_aerocld_merge.png'
	  po1.save,'scapdf_aerocld_isolate.png'
	  po2.save,'scapdf_aerocld_merge.png'
;	  po1.save,'deppdf_aerocld_isolate.png'
;	  po2.save,'deppdf_aerocld_merge.png'
   EndIf ;end plotpdf

end
