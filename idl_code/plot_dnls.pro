
; to get global average frequency and tau for day night, land sea
pro plot_dnls
 
print,systime()

   lidfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap','*cad50*')

   Nf=n_elements(lidfname)
   Nmon=Nf ;5-10
   month=intarr(Nmon)
   wyear=dblarr(Nmon)
   
   latres=2
   lonres=5
   dimx=360/lonres
   dimy=180/latres
   dimh=101 
    pos1=[0.05,0.55,0.35,0.90]
    pos2=[0.40,0.55,0.70,0.90]
    pos3=[0.05,0.10,0.35,0.45]
    pos4=[0.40,0.10,0.70,0.45]
	barpos1=[0.78,0.54,0.80,0.91]
	barpos2=[0.78,0.09,0.80,0.46]
	ppos1=[0.89,0.57,0.98,0.92]
	ppos2=[0.89,0.10,0.98,0.45]
	fontsz=11
    lnthick=2

   Tobsnumh=Ulonarr(dimx,dimy,2)

   Taero_only_numh=Ulonarr(dimx,dimy,2)
   Taero_only_tau=Dblarr(dimx,dimy,2)
   Taeroonly_tau0_numh=Ulonarr(dimx,dimy,2)
   Taero_only_tauerr=Dblarr(dimx,dimy,2)

   Taero_cld_numh=Ulonarr(dimx,dimy,2)
   Taero_cld_tau=Dblarr(dimx,dimy,2) 
   Taero_cldtau0_numh=Ulonarr(dimx,dimy,2)
   Taero_cld_tauerr=Dblarr(dimx,dimy,2)

   Taero_incld_tau=Dblarr(dimx,dimy,2) 
   Taero_incld_numh=Ulonarr(dimx,dimy,2)
   Taero_incldtau0_numh=Ulonarr(dimx,dimy,2)
   Taero_incld_tauerr=Dblarr(dimx,dimy,2)

   Taero_iscld_tau=Dblarr(dimx,dimy,2)
   Taero_iscld_numh=Ulonarr(dimx,dimy,2)
   Taero_iscldtau0_numh=Ulonarr(dimx,dimy,2)
   Taero_iscld_tauerr=Dblarr(dimx,dimy,2)

   Taero_all_tau=Dblarr(dimx,dimy,2)
   Taero_all_numh=Ulonarr(dimx,dimy,2)
   Taero_alltau0_numh=Ulonarr(dimx,dimy,2)
   Taero_all_tauerr=Dblarr(dimx,dimy,2)

   for i=0,Nf-1 do begin
	fname=lidfname[i]

	IF (strlen(fname) eq 136) Then Begin
 	print,fname

	read_dardar,fname,'latitude',lat 
	read_dardar,fname,'longitude',lon
	read_dardar,fname,'obs_numh',obsnumh ;1-ocean, 2-land
	
    ;********** with aerosols ********************	
	read_dardar,fname,'aerosol_only_tau',aero_only_tau
	read_dardar,fname,'aerosol_only_numh',aero_only_numh
	read_dardar,fname,'aerosol_only_negativetau_numh',aeroonly_tau0_numh
	read_dardar,fname,'aerosol_only_tau_uncer',aero_only_tauerr

    ind=where(aero_only_numh eq 0)
	aero_only_tau[ind]=0.0
	aero_only_tauerr[ind]=0.0
	Taero_only_tau=Taero_only_tau+total(aero_only_tau*(aero_only_numh-aeroonly_tau0_numh),3)
	Taero_only_tauerr=Taero_only_tauerr+total(aero_only_tauerr*(aero_only_numh-aeroonly_tau0_numh),3)
	Taero_only_numh=Taero_only_numh+total(aero_only_numh-aeroonly_tau0_numh,3)

	read_dardar,fname,'isolate_aerosol_tau',aero_isolate_tau
	read_dardar,fname,'isolate_aerosol_num',aero_isolate_numh
	read_dardar,fname,'isolate_aerosol_negativetau_num',aero_isolate_tau0_numh
    read_dardar,fname,'isolate_aerosol_tau_uncer',aero_isolate_tauerr

	ind=where(aero_isolate_numh eq 0)
	aero_isolate_tau[ind]=0.0
	aero_isolate_tauerr[ind]=0.0
	Taero_iscld_numh=Taero_iscld_numh+total(aero_isolate_numh-aero_isolate_tau0_numh,3)
	Taero_iscld_tau = Taero_iscld_tau +total(aero_isolate_tau*(aero_isolate_numh-aero_isolate_tau0_numh),3)		
	Taero_iscld_tauerr = Taero_iscld_tauerr+total(aero_isolate_tauerr*(aero_isolate_numh-aero_isolate_tau0_numh),3)		

	read_dardar,fname,'incloud_aerosol_tau',aero_incloud_tau
	read_dardar,fname,'incloud_aerosol_num',aero_incloud_numh
	read_dardar,fname,'incloud_aerosol_negativetau_num',aero_incloud_tau0_numh
    read_dardar,fname,'incloud_aerosol_tau_uncer',aero_incloud_tauerr
	
	ind=where(aero_incloud_numh eq 0)
	aero_incloud_tau[ind]=0.0
	aero_incloud_tauerr[ind]=0.0
	Taero_incld_numh=Taero_incld_numh+total(aero_incloud_numh-aero_incloud_tau0_numh,3)
	Taero_incld_tau =Taero_incld_tau +total(aero_incloud_tau*(aero_incloud_numh-aero_incloud_tau0_numh),3)		
	Taero_incld_tauerr =Taero_incld_tauerr +total(aero_incloud_tauerr*(aero_incloud_numh-aero_incloud_tau0_numh),3)		


	Tobsnumh=Tobsnumh+obsnumh
	
	EndIf
   endfor

	Taero_cld_tau = Taero_iscld_tau + Taero_incld_tau
	Taero_cld_tauerr = Taero_iscld_tauerr + Taero_incld_tauerr
	Taero_cld_numh = Taero_iscld_numh + Taero_incld_numh		

	name=['sea','land']
    time='night'

   for i=0,1 do begin

	aveaero_only_tau = Taero_only_tau[*,*,i]/Taero_only_numh[*,*,i]
	aveaero_only_tauerr = Taero_only_tauerr[*,*,i]/Taero_only_numh[*,*,i]
	aero_only_fre = Taero_only_numh[*,*,i]/float(Tobsnumh[*,*,i])
	a=image(aveaero_only_tau,rgb_table=33,max_value=1.0,title=time+' aero only '+name[i])
	a.scale,5,3
	; area weighted averages
	Tobsnumh1=total(reform(Tobsnumh[*,*,i]),1)
	weights=cos(lat*!pi/180)
	ind=where(Tobsnumh1 eq 0)
	weights[ind]=0.0
	Nlonfw=intarr(90)
	;=== get the total weighted number along longitude ===
	for lati=0,89 do begin
		for loni=0,71 do begin
			If (Tobsnumh[loni,lati,i] gt 0) then Nlonfw[lati]=Nlonfw[lati]+1
		endfor
	endfor	

;	area_weighted_mean,weights,aero_only_fre
    print,'aerosol only weighted fre '+name[i],total(weights*total(aero_only_fre,1,/nan))/(total(Nlonfw*weights))

	ind=where(reform(Taero_only_numh[*,*,i]) eq 0)
	aveaero_only_tau[ind]=0.0
	aveaero_only_tauerr[ind]=0.0
	print,'aerosol only weighted tau '+name[i],total(weights*total(aveaero_only_tau,1))/(total(Nlonfw*weights))
	print,'aerosol only weighted tauerr '+name[i],total(weights*total(aveaero_only_tauerr,1))/(total(Nlonfw*weights))

    aveaero_allcld_tau = Taero_cld_tau[*,*,i]/Taero_cld_numh[*,*,i]
    aveaero_allcld_tauerr = Taero_cld_tauerr[*,*,i]/Taero_cld_numh[*,*,i]
	aero_allcld_fre=Taero_cld_numh[*,*,i]/float(Tobsnumh[*,*,i])
	a=image(aveaero_allcld_tau,rgb_table=33,max_value=1.0,title =time+' cld aero '+name[i])
	a.scale,5,3

	;globally weighted average
    print,'aerosol-cloud weighted fre '+name[i],total(weights*total(aero_allcld_fre,1,/nan))/(total(Nlonfw*weights))
	ind=where(reform(Taero_cld_numh[*,*,i]) eq 0)
	aveaero_allcld_tau[ind]=0.0
	aveaero_allcld_tauerr[ind]=0.0
    print,'aerosol-cloud weighted tau '+name[i],total(weights*total(aveaero_allcld_tau,1))/(total(Nlonfw*weights))
    print,'aerosol-cloud weighted tauerr '+name[i],total(weights*total(aveaero_allcld_tauerr,1))/(total(Nlonfw*weights))

;   for total aerosols
	allaero_num=Taero_only_numh[*,*,i]+Taero_cld_numh[*,*,i]
	allaero_tau=Taero_only_tau[*,*,i]+Taero_cld_tau[*,*,i]
	allaero_tauerr=Taero_only_tauerr[*,*,i]+Taero_cld_tauerr[*,*,i]
	allaero_fre=allaero_num/float(Tobsnumh[*,*,i])
	allaero_avetau=allaero_tau/allaero_num
	allaero_avetauerr=allaero_tauerr/allaero_num

	print,'all sky aerosol weighted fre '+name[i],total(weights*total(allaero_fre,1,/nan))/(total(Nlonfw*weights))
	ind=where(allaero_num eq 0)
	allaero_avetau[ind]=0.0
	allaero_avetauerr[ind]=0.0
	print,'all sky aero weighted ave tau '+name[i],total(weights*total(allaero_avetau,1,/nan))/(total(Nlonfw*weights))
	print,'all sky aero weighted ave tauerr '+name[i],total(weights*total(allaero_avetauerr,1,/nan))/(total(Nlonfw*weights))
	a=image(allaero_avetau,rgb_table=33,max_value=1.0,title =time+' all aero '+name[i])
	a.scale,5,3
	
;   for incloud aerosols
	inaero_num=Taero_incld_numh[*,*,i]
	inaero_tau=Taero_incld_tau[*,*,i]
	inaero_tauerr=Taero_incld_tauerr[*,*,i]
	inaero_fre=inaero_num/float(Tobsnumh[*,*,i])
	inaero_avetau=inaero_tau/inaero_num
	inaero_avetauerr=inaero_tauerr/inaero_num
	ind=where(inaero_num eq 0)
	inaero_avetau[ind]=0.0
	inaero_avetauerr[ind]=0.0
	print,'incloud aerosol weighted fre '+name[i],total(weights*total(inaero_fre,1,/nan))/(total(Nlonfw*weights))
	print,'incloud aero weighted ave tau '+name[i],total(weights*total(inaero_avetau,1,/nan))/(total(Nlonfw*weights))
	print,'incloud aero weighted ave tauerr'+name[i],total(weights*total(inaero_avetauerr,1,/nan))/(total(Nlonfw*weights))
	
;   for iscloud aerosols
	isaero_num=Taero_iscld_numh[*,*,i]
	isaero_tau=Taero_iscld_tau[*,*,i]
	isaero_tauerr=Taero_iscld_tauerr[*,*,i]
	isaero_fre=isaero_num/float(Tobsnumh[*,*,i])
	isaero_avetau=isaero_tau/isaero_num
	isaero_avetauerr=isaero_tauerr/isaero_num
	print,'iscloud aerosol weighted fre '+name[i],total(weights*total(isaero_fre,1,/nan))/(total(Nlonfw*weights))
	ind=where(isaero_num eq 0)
	isaero_avetau[ind]=0.0
	isaero_avetauerr[ind]=0.0
	print,'iscloud aero weighted ave tau '+name[i],total(weights*total(isaero_avetau,1,/nan))/(total(Nlonfw*weights))
	print,'iscloud aero weighted ave tauerr '+name[i],total(weights*total(isaero_avetauerr,1,/nan))/(total(Nlonfw*weights))

    endfor ; endfor land-sea
stop
end
