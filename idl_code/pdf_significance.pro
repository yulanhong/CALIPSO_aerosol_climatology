
pro pdf_significance 

;	fname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen_2/','*land_daynight.hdf')
   fname=file_search('/u/sciteam/yulanh/scratch/CALIOP/output','*.hdf')


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
	plotfre_merged=1 ; to plot the frequency/tau of aerosol-cloud overlap
	plotfre_isolated=1 ; to plot the frequency/tau of aerosol-cloud overlap
	fontsz=11

    lon_res=6
	lat_res=5
	dimx=360./lon_res
	dimy=180./lat_res
	lon=findgen(dimx)*lon_res-180
	lat=findgen(dimy)*lat_res-90+lat_res/2.0

    Tobsnum=ulonarr(dimx,dimy)

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
		IF (strlen(fname[fi]) le 86) Then Begin ;86 for all, 96 for day_land, 97 for day_night, 96 for ocean_day, 98 for ocean_night
		print,fname[fi]
		read_dardar,fname[fi],'obs_numh',obsnum
		Tobsnum=Tobsnum+obsnum

		read_dardar,fname[fi],'aero_only_numh',aeroonly_num
		read_dardar,fname[fi],'aero_only_tau',aeroonly_tau
		read_dardar,fname[fi],'pdf_aero_only_tau',aeroonly_taupdf
	
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
	print,'ave aeroonly freh',total(Taeroonly_num)/float(total(Tobsnum))


    avetau_aerocld=$
	(total(Taeroincld_tau)+total(Taeroisolate_tau))$
	/(total(Taeroincld_num)+total(Taeroisolate_num))
;	print,'avetau_aerocld tau, weight average',total(weights*total(avetau_aerocld,1,/nan))/(dimx*total(weights))
	print,'ave aerocld num weight tau',avetau_aerocld 
	print,'ave aerocld num freh',(total(Taeroincld_num)+total(Taeroisolate_num))/float(total(Tobsnum))

	avetau_aerois=$
	total(Taeroisolate_tau)/total((Taeroisolate_num))
;	print,'avetau_aero isolated tau, weight average',total(weights*total(avetau_aerois,1,/nan))/(dimx*total(weights))
	print,'ave tau aero isoated num weighted tau',avetau_aerois
	print,'ave aero isolated freh',total(Taeroisolate_num)/float(total(Tobsnum))
 
	avetau_aeroin=$
	(total(Taeroincld_tau))/total((Taeroincld_num))
;	print,'avetau_aero incld tau, weight average',total(weights*total(avetau_aeroin,1,/nan))/(dimx*total(weights))
	print,'ave tau incld num weighted tau',avetau_aeroin
	print,'ave aero incld fre',total(Taeroincld_num)/float(total(Tobsnum))

    avetau_aeroall=(total(Taeroincld_tau)+total(Taeroisolate_tau)+total(Taeroonly_tau))/$
		(total(Taeroincld_num)+total(Taeroisolate_num)+total(Taeroonly_num))
	print,'ave tau all sky',avetau_aeroall
	print,'ave fre all sky',(total(Taeroincld_num)+total(Taeroisolate_num)+total(Taeroonly_num))/float(total(Tobsnum))


	;========== dealing with pdf
	Total_aeroonly_taupdf_1=total(total(Taeroonly_taupdf,1),1)
	Total_aerocld_taupdf= total(Taeroisolate_taupdf,4) + total(Taeroincld_taupdf,4)
	Total_aerocld_taupdf_1=total(total(Total_aerocld_taupdf,1),1)

	aeroonly_taupdf_2 = Total_aeroonly_taupdf_1/float(total(Total_aeroonly_taupdf_1))
    aerocld_taupdf_2  = Total_aerocld_taupdf_1/float(total(Total_aerocld_taupdf_1))

	tau_interval=findgen(Ntau)*0.01-4
	tau_interval=10^tau_interval
	;for tau
	xrange=[-3,1]
	yrange=[0,1.5]
	xtitle='$log10(\tau)$'
	ytitle='Frequency (%)'

	pdf_aeroonly_mean= total(aeroonly_taupdf_2*tau_interval)
    pdf_aerocld_mean = total(aerocld_taupdf_2*tau_interval)

	pdf_aeroonly_std= sqrt(total(aeroonly_taupdf_2*((tau_interval-pdf_aeroonly_mean)^2.0)))
    pdf_aerocld_std = sqrt(total(aerocld_taupdf_2*((tau_interval-pdf_aerocld_mean)^2.0)))

	n1=total(Total_aeroonly_taupdf_1)
	s1=pdf_aeroonly_std^2.0
	n2=total(Total_aerocld_taupdf_1)
	s2=pdf_aerocld_std^2.0

	SE=sqrt(s1/n1+s2/n2)
	DF=SE*SE/(((s1/n1)^2.0/(n1-1))+((s2/n2)^2.0/(n2-1)))
	t=(pdf_aeroonly_mean-pdf_aerocld_mean)/se

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

stop
end
