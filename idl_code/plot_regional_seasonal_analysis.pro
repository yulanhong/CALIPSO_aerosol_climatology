pro plot_regional_seasonal_analysis

  fname=$
  file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen_2','*.hdf')

 latres=5
 lonres=6
 dimx=360/lonres
 dimy=180/latres
 dimh=399
 hgt=fltarr(dimh)
 hgt[0:53]=29.92-findgen(54)*0.18
 hgt[54:253]=20.2-findgen(200)*0.06
 hgt[254:398]=8.2-findgen(145)*0.06

 Nmon=n_elements(fname) 
; global
;minlat=-90
;maxlat=90
;minlon=-180
;maxlon=180

;Indonesia region
 minlat=5
 maxlat=22.5
 minlon=115
 maxlon=130
;south east atlantic region
; minlat=-25
; maxlat=-5
; minlon=-7.5
 ;maxlon=15

; north pacific 
;minlat=7.5
;maxlat=25
;minlon=-175
;maxlon=-120
;region='North_pacific'
region='Indonesia'
; region='Global'
;region='Southeast_Atlantic'
 maplimit=[minlat,minlon,maxlat,maxlon]

; philipine region [-10,105,20,130]
; east asia [30,110,45,125]
;westafrica [-15,0,0,20]
;india [10,75,23,90]
;indonesia[-10,100,10,125]  
Tobsnumh=Ulonarr(12)
Tobsnumv=Ulonarr(12,dimh)
Taero_only_numh=Ulonarr(12)
Taero_only_numv=Ulonarr(12,dimh)
Taero_only_beta=Dblarr(12,dimh)

Tisolate_aero_numh=Ulonarr(12,9)
Tincld_aero_numh=Ulonarr(12,6)

Taero_only_tau=dblarr(12)
Tisolate_aero_tau=dblarr(12,9)
Tincld_aero_tau=dblarr(12,6)
Taero_only_tauerr=dblarr(12)
Tisolate_aero_tauerr=dblarr(12,9)
Tincld_aero_tauerr=dblarr(12,6)

Tisolate_aero_numv_belcld=Ulonarr(12,dimh)
Tisolate_aero_numv_abvcld=Ulonarr(12,dimh)
Tisolate_aero_numv_other=Ulonarr(12,dimh)
Tisolate_aero_beta_belcld=dblarr(12,dimh)
Tisolate_aero_beta_abvcld=dblarr(12,dimh)
Tisolate_aero_beta_other=dblarr(12,dimh)

Tincld_aero_numv_one=Ulonarr(12,dimh)
Tincld_aero_numv_belcld=Ulonarr(12,dimh)
Tincld_aero_numv_abvcld=Ulonarr(12,dimh)
Tincld_aero_numv_other=Ulonarr(12,dimh)
Tincld_aero_beta_one=dblarr(12,dimh)
Tincld_aero_beta_belcld=dblarr(12,dimh)
Tincld_aero_beta_abvcld=dblarr(12,dimh)
Tincld_aero_beta_other=dblarr(12,dimh)

; for lidratio-colratio
Taero_only_lrcr=Ulonarr(12,70,121)
Tisolate_aero_belcld_lrcr=Ulonarr(12,70,121)
Tisolate_aero_abvcld_lrcr=Ulonarr(12,70,121)
Tisolate_aero_other_lrcr=Ulonarr(12,70,121)
Tincld_aero_one_lrcr=Ulonarr(12,70,121)
Tincld_aero_belcld_lrcr=Ulonarr(12,70,121)
Tincld_aero_abvcld_lrcr=Ulonarr(12,70,121)
Tincld_aero_other_lrcr=Ulonarr(12,70,121)
;for bd-depratio
Taero_only_bd=Ulonarr(12,91,21)
Tisolate_aero_belcld_bd=Ulonarr(12,91,21)
Tisolate_aero_abvcld_bd=Ulonarr(12,91,21)
Tisolate_aero_other_bd=Ulonarr(12,91,21)
Tincld_aero_one_bd=Ulonarr(12,91,21)
Tincld_aero_belcld_bd=Ulonarr(12,91,21)
Tincld_aero_abvcld_bd=Ulonarr(12,91,21)
Tincld_aero_other_bd=Ulonarr(12,91,21)

for fi=0,Nmon-1 do begin
	tpfname=fname[fi]
	if (strlen(tpfname) eq 139) then begin
	print,tpfname
	month=strmid(tpfname,5,2,/rev)
;	month=strmid(tpfname,19,2,/rev)
	monscp=fix(month)-1


	read_dardar,tpfname,'latitude',lat
	read_dardar,tpfname,'longitude',lon
	read_dardar,tpfname,'obs_numh',obsnumh
	read_dardar,tpfname,'obs_numv',obsnumv	

	indlon=where(lon ge minlon and lon le maxlon)	
    indlat=where(lat ge minlat and lat le maxlat)
	obsnumh1=obsnumh[indlon,*]
	obsnumh2=obsnumh1[*,indlat]
	obsnumv1=obsnumv[indlon,*,*]
	obsnumv2=obsnumv1[*,indlat,*]

	Tobsnumh[monscp]=Tobsnumh[monscp]+total(obsnumh2)
	Tobsnumv[monscp,*]=Tobsnumv[monscp,*]+total(total(obsnumv2,1),1)

	read_dardar,tpfname,'aero_only_tau',aero_only_tau
	read_dardar,tpfname,'aero_onlytau_uncer',aero_only_tauerr
	read_dardar,tpfname,'aero_only_numh',aero_only_numh
	read_dardar,tpfname,'aero_only_numv',aero_only_numv
	read_dardar,tpfname,'aero_only_backscatter_profile',aero_only_beta
	aero_only_numh1=aero_only_numh[indlon,*]
	aero_only_numh2=aero_only_numh1[*,indlat]
	aero_only_tau1=aero_only_tau[indlon,*]
	aero_only_tau2=aero_only_tau1[*,indlat]
	aero_only_tauerr1=aero_only_tauerr[indlon,*]
	aero_only_tauerr2=aero_only_tauerr1[*,indlat]

	Taero_only_numh[monscp]=Taero_only_numh[monscp]+total(aero_only_numh2)

	ind=where(aero_only_numh2 eq 0)
	aero_only_tau2[ind]=0.0
	aero_only_tauerr2[ind]=0.0
	Taero_only_tau[monscp]=Taero_only_tau[monscp]+total(aero_only_numh2*aero_only_tau2)
	Taero_only_tauerr[monscp]=Taero_only_tauerr[monscp]+total(aero_only_numh2*aero_only_tauerr2)

	aero_only_numv1=aero_only_numv[indlon,*,*]
	aero_only_numv2=aero_only_numv1[*,indlat,*]
	aero_only_beta1=aero_only_beta[indlon,*,*]
	aero_only_beta2=aero_only_beta1[*,indlat,*]	
	ind=where(aero_only_numv2 eq 0)
	aero_only_beta2[ind]=0.0
	Taero_only_numv[monscp,*]=Taero_only_numv[monscp,*]+total(total(aero_only_numv2,1),1)
	Taero_only_beta[monscp,*]=Taero_only_beta[monscp,*]+total(total(aero_only_beta2*aero_only_numv2,1),1)

	read_dardar,tpfname,'isolate_aero_numh',isolate_aero_numh
	read_dardar,tpfname,'isolate_aero_tau',isolate_aero_tau
	read_dardar,tpfname,'isolate_aerotau_uncer',isolate_aero_tauerr
	isolate_aero_numh1=isolate_aero_numh[indlon,*,*]
	isolate_aero_tau1=isolate_aero_tau[indlon,*,*]
	isolate_aero_numh2=isolate_aero_numh1[*,indlat,*]
	isolate_aero_tau2=isolate_aero_tau1[*,indlat,*]
	isolate_aero_tauerr1=isolate_aero_tauerr[indlon,*,*]
	isolate_aero_tauerr2=isolate_aero_tauerr1[*,indlat,*]

	ind=where(isolate_aero_numh2 eq 0)
	isolate_aero_tau2[ind]=0.0
	isolate_aero_tauerr2[ind]=0.0
	Tisolate_aero_numh[monscp,*]=Tisolate_aero_numh[monscp,*]+total(total(isolate_aero_numh2,1),1)
	Tisolate_aero_tau[monscp,*]=Tisolate_aero_tau[monscp,*]+$
		total(total(isolate_aero_numh2*isolate_aero_tau2,1),1)
	Tisolate_aero_tauerr[monscp,*]=Tisolate_aero_tauerr[monscp,*]+$
		total(total(isolate_aero_numh2*isolate_aero_tauerr2,1),1)


	read_dardar,tpfname,'isolate_aero_numv_belcld',isolate_aero_numv_belcld
	read_dardar,tpfname,'isolate_aero_numv_abvcld',isolate_aero_numv_abvcld
	read_dardar,tpfname,'isolate_aero_numv_other',isolate_aero_numv_other
	isolate_aero_numv_belcld1=isolate_aero_numv_belcld[indlon,*,*]
	isolate_aero_numv_belcld2=isolate_aero_numv_belcld1[*,indlat,*]
	isolate_aero_numv_abvcld1=isolate_aero_numv_abvcld[indlon,*,*]
	isolate_aero_numv_abvcld2=isolate_aero_numv_abvcld1[*,indlat,*]
	isolate_aero_numv_other1=isolate_aero_numv_other[indlon,*,*]
	isolate_aero_numv_other2=isolate_aero_numv_other1[*,indlat,*]

	read_dardar,tpfname,'isolate_aero_backscatter_profile_belcld',isolate_aero_beta_belcld
	read_dardar,tpfname,'isolate_aero_backscatter_profile_abvcld',isolate_aero_beta_abvcld
	read_dardar,tpfname,'isolate_aero_backscatter_profile_other',isolate_aero_beta_other
	isolate_aero_beta_belcld1=isolate_aero_beta_belcld[indlon,*,*]
	isolate_aero_beta_belcld2=isolate_aero_beta_belcld1[*,indlat,*]
	isolate_aero_beta_abvcld1=isolate_aero_beta_abvcld[indlon,*,*]
	isolate_aero_beta_abvcld2=isolate_aero_beta_abvcld1[*,indlat,*]
	isolate_aero_beta_other1=isolate_aero_beta_other[indlon,*,*]
	isolate_aero_beta_other2=isolate_aero_beta_other1[*,indlat,*]

	ind=where(isolate_aero_numv_belcld2 eq 0)
	isolate_aero_beta_belcld2[ind]=0.0
	Tisolate_aero_numv_belcld[monscp,*]=Tisolate_aero_numv_belcld[monscp,*]+$
		total(total(isolate_aero_numv_belcld2,1),1)
	Tisolate_aero_beta_belcld[monscp,*]=Tisolate_aero_beta_belcld[monscp,*]+$
		total(total(isolate_aero_numv_belcld2*isolate_aero_beta_belcld2,1),1)
	
	ind=where(isolate_aero_numv_abvcld2 eq 0)
	isolate_aero_beta_abvcld2[ind]=0.0
	Tisolate_aero_numv_abvcld[monscp,*]=Tisolate_aero_numv_abvcld[monscp,*]+$
		total(total(isolate_aero_numv_abvcld2,1),1)
	Tisolate_aero_beta_abvcld[monscp,*]=Tisolate_aero_beta_abvcld[monscp,*]+$
		total(total(isolate_aero_numv_abvcld2*isolate_aero_beta_abvcld2,1),1)
	
	ind=where(isolate_aero_numv_other2 eq 0)
	isolate_aero_beta_other2[ind]=0.0
	Tisolate_aero_numv_other[monscp,*]=Tisolate_aero_numv_other[monscp,*]+$
		total(total(isolate_aero_numv_other2,1),1)

	Tisolate_aero_beta_other[monscp,*]=Tisolate_aero_beta_other[monscp,*]+$
		total(total(isolate_aero_numv_other2*isolate_aero_beta_other2,1),1)

	read_dardar,tpfname,'aero_only_backscat_depratio',aero_only_bd
	aero_only_bd1=aero_only_bd[indlon,*,*,*]
	aero_only_bd2=aero_only_bd1[*,indlat,*,*]
	Taero_only_bd[monscp,*,*]=Taero_only_bd[monscp,*,*]+total(total(aero_only_bd2,1),1)

	read_dardar,tpfname,'isolate_aero_backscat_depratio_belcld',isolate_aero_belcld_bd
	read_dardar,tpfname,'isolate_aero_backscat_depratio_abvcld',isolate_aero_abvcld_bd
	read_dardar,tpfname,'isolate_aero_backscat_depratio_other',isolate_aero_other_bd
	isolate_aero_belcld_bd1=isolate_aero_belcld_bd[indlon,*,*,*]
	isolate_aero_belcld_bd2=isolate_aero_belcld_bd1[*,indlat,*,*]
	Tisolate_aero_belcld_bd[monscp,*,*]=Tisolate_aero_belcld_bd[monscp,*,*]+total(total(isolate_aero_belcld_bd2,1),1)

	isolate_aero_abvcld_bd1=isolate_aero_abvcld_bd[indlon,*,*,*]
	isolate_aero_abvcld_bd2=isolate_aero_abvcld_bd1[*,indlat,*,*]
	Tisolate_aero_abvcld_bd[monscp,*,*]=Tisolate_aero_abvcld_bd[monscp,*,*]+total(total(isolate_aero_abvcld_bd2,1),1)

	isolate_aero_other_bd1=isolate_aero_other_bd[indlon,*,*,*]
	isolate_aero_other_bd2=isolate_aero_other_bd1[*,indlat,*,*]
	Tisolate_aero_other_bd[monscp,*,*]=Tisolate_aero_other_bd[monscp,*,*]+total(total(isolate_aero_other_bd2,1),1)

	read_dardar,tpfname,'aero_only_lidratio_colratio',aero_only_lrcr
	read_dardar,tpfname,'isolate_aero_lidratio_colratio_belcld',isolate_aero_belcld_lrcr
	read_dardar,tpfname,'isolate_aero_lidratio_colratio_abvcld',isolate_aero_abvcld_lrcr
	read_dardar,tpfname,'isolate_aero_lidratio_colratio_other',isolate_aero_other_lrcr
	aero_only_lrcr1=aero_only_lrcr[indlon,*,*,*]
	aero_only_lrcr2=aero_only_lrcr[*,indlat,*,*]
	Taero_only_lrcr[monscp,*,*]=Taero_only_lrcr[monscp,*,*]+total(total(aero_only_lrcr2,1),1)

	isolate_aero_belcld_lrcr1=isolate_aero_belcld_lrcr[indlon,*,*,*]
	isolate_aero_belcld_lrcr2=isolate_aero_belcld_lrcr1[*,indlat,*,*]
	Tisolate_aero_belcld_lrcr[monscp,*,*]=total(total(isolate_aero_belcld_lrcr2,1),1)
	isolate_aero_abvcld_lrcr1=isolate_aero_abvcld_lrcr[indlon,*,*,*]
	isolate_aero_abvcld_lrcr2=isolate_aero_abvcld_lrcr1[*,indlat,*,*]
	Tisolate_aero_abvcld_lrcr[monscp,*,*]=total(total(isolate_aero_abvcld_lrcr2,1),1)
	isolate_aero_other_lrcr1=isolate_aero_other_lrcr[indlon,*,*,*]
	isolate_aero_other_lrcr2=isolate_aero_other_lrcr1[*,indlat,*,*]
	Tisolate_aero_other_lrcr[monscp,*,*]=total(total(isolate_aero_other_lrcr2,1),1)

	read_dardar,tpfname,'incld_aero_numh',incld_aero_numh
	read_dardar,tpfname,'incld_aero_tau',incld_aero_tau
	read_dardar,tpfname,'incld_aerotau_uncer',incld_aero_tauerr
	incld_aero_numh1=incld_aero_numh[indlon,*,*]
	incld_aero_tau1=incld_aero_tau[indlon,*,*]
	incld_aero_numh2=incld_aero_numh1[*,indlat,*]
	incld_aero_tau2=incld_aero_tau1[*,indlat,*]
	incld_aero_tauerr1=incld_aero_tauerr[indlon,*,*]
	incld_aero_tauerr2=incld_aero_tauerr1[*,indlat,*]

	ind=where(incld_aero_numh2 eq 0)
	incld_aero_tau2[ind]=0.0
	incld_aero_tauerr2[ind]=0.0
	Tincld_aero_numh[monscp,*]=Tincld_aero_numh[monscp,*]+total(total(incld_aero_numh2,1),1)
	Tincld_aero_tau[monscp,*]=Tincld_aero_tau[monscp,*]+$
		total(total(incld_aero_numh2*incld_aero_tau2,1),1)
	Tincld_aero_tauerr[monscp,*]=Tincld_aero_tauerr[monscp,*]+$
		total(total(incld_aero_numh2*incld_aero_tauerr2,1),1)

	read_dardar,tpfname,'incld_aero_numv_one',incld_aero_numv_one
	read_dardar,tpfname,'incld_aero_numv_belcld',incld_aero_numv_belcld
	read_dardar,tpfname,'incld_aero_numv_abvcld',incld_aero_numv_abvcld
	read_dardar,tpfname,'incld_aero_numv_other',incld_aero_numv_other

	incld_aero_numv_one1=incld_aero_numv_one[indlon,*,*]
	incld_aero_numv_one2=incld_aero_numv_one1[*,indlat,*]
	incld_aero_numv_belcld1=incld_aero_numv_belcld[indlon,*,*]
	incld_aero_numv_belcld2=incld_aero_numv_belcld1[*,indlat,*]
	incld_aero_numv_abvcld1=incld_aero_numv_abvcld[indlon,*,*]
	incld_aero_numv_abvcld2=incld_aero_numv_abvcld1[*,indlat,*]
	incld_aero_numv_other1=incld_aero_numv_other[indlon,*,*]
	incld_aero_numv_other2=incld_aero_numv_other1[*,indlat,*]

	read_dardar,tpfname,'incld_aero_backscatter_profile_one',incld_aero_beta_one
	read_dardar,tpfname,'incld_aero_backscatter_profile_belcld',incld_aero_beta_belcld
	read_dardar,tpfname,'incld_aero_backscatter_profile_abvcld',incld_aero_beta_abvcld
	read_dardar,tpfname,'incld_aero_backscatter_profile_other',incld_aero_beta_other
	incld_aero_beta_one1=incld_aero_beta_one[indlon,*,*]
	incld_aero_beta_one2=incld_aero_beta_one1[*,indlat,*]
	incld_aero_beta_belcld1=incld_aero_beta_belcld[indlon,*,*]
	incld_aero_beta_belcld2=incld_aero_beta_belcld1[*,indlat,*]
	incld_aero_beta_abvcld1=incld_aero_beta_abvcld[indlon,*,*]
	incld_aero_beta_abvcld2=incld_aero_beta_abvcld1[*,indlat,*]
	incld_aero_beta_other1=incld_aero_beta_other[indlon,*,*]
	incld_aero_beta_other2=incld_aero_beta_other1[*,indlat,*]


	ind=where(incld_aero_numv_one2 eq 0)
	incld_aero_beta_one2[ind]=0.0
	Tincld_aero_numv_one[monscp,*]=Tincld_aero_numv_one[monscp,*]+$
		total(total(incld_aero_numv_one2,1),1)
	Tincld_aero_beta_one[monscp,*]=Tincld_aero_beta_one[monscp,*]+$
		total(total(incld_aero_numv_one2*incld_aero_beta_one2,1),1)

	ind=where(incld_aero_numv_belcld2 eq 0)
	incld_aero_beta_belcld2[ind]=0.0
	Tincld_aero_numv_belcld[monscp,*]=Tincld_aero_numv_belcld[monscp,*]+$
		total(total(incld_aero_numv_belcld2,1),1)
	Tincld_aero_beta_belcld[monscp,*]=Tincld_aero_beta_belcld[monscp,*]+$
		total(total(incld_aero_numv_belcld2*incld_aero_beta_belcld2,1),1)
	
	ind=where(incld_aero_numv_abvcld2 eq 0)
	incld_aero_beta_abvcld2[ind]=0.0
	Tincld_aero_numv_abvcld[monscp,*]=Tincld_aero_numv_abvcld[monscp,*]+$
		total(total(incld_aero_numv_abvcld2,1),1)
	Tincld_aero_beta_abvcld[monscp,*]=Tincld_aero_beta_abvcld[monscp,*]+$
		total(total(incld_aero_numv_abvcld2*incld_aero_beta_abvcld2,1),1)
	
	ind=where(incld_aero_numv_other2 eq 0)
	incld_aero_beta_other2[ind]=0.0
	Tincld_aero_numv_other[monscp,*]=Tincld_aero_numv_other[monscp,*]+$
		total(total(incld_aero_numv_other2,1),1)

	Tincld_aero_beta_other[monscp,*]=Tincld_aero_beta_other[monscp,*]+$
		total(total(incld_aero_numv_other2*incld_aero_beta_other2,1),1)

	read_dardar,tpfname,'incld_aero_backscat_depratio_one',incld_aero_one_bd
	read_dardar,tpfname,'incld_aero_backscat_depratio_belcld',incld_aero_belcld_bd
	read_dardar,tpfname,'incld_aero_backscat_depratio_abvcld',incld_aero_abvcld_bd
	read_dardar,tpfname,'incld_aero_backscat_depratio_other',incld_aero_other_bd
	incld_aero_one_bd1=incld_aero_one_bd[indlon,*,*,*]
	incld_aero_one_bd2=incld_aero_one_bd1[*,indlat,*,*]
	Tincld_aero_one_bd[monscp,*,*]=total(total(incld_aero_one_bd2,1),1)
	incld_aero_belcld_bd1=incld_aero_belcld_bd[indlon,*,*,*]
	incld_aero_belcld_bd2=incld_aero_belcld_bd1[*,indlat,*,*]
	Tincld_aero_belcld_bd[monscp,*,*]=total(total(incld_aero_belcld_bd2,1),1)
	incld_aero_abvcld_bd1=incld_aero_abvcld_bd[indlon,*,*,*]
	incld_aero_abvcld_bd2=incld_aero_abvcld_bd1[*,indlat,*,*]
	Tincld_aero_abvcld_bd[monscp,*,*]=total(total(incld_aero_abvcld_bd2,1),1)
	incld_aero_other_bd1=incld_aero_other_bd[indlon,*,*,*]
	incld_aero_other_bd2=incld_aero_other_bd1[*,indlat,*,*]
	Tincld_aero_other_bd[monscp,*,*]=total(total(incld_aero_other_bd2,1),1)

	read_dardar,tpfname,'incld_aero_lidratio_colratio_one',incld_aero_one_lrcr
	read_dardar,tpfname,'incld_aero_lidratio_colratio_belcld',incld_aero_belcld_lrcr
	read_dardar,tpfname,'incld_aero_lidratio_colratio_abvcld',incld_aero_abvcld_lrcr
	read_dardar,tpfname,'incld_aero_lidratio_colratio_other',incld_aero_other_lrcr
	incld_aero_one_lrcr1=incld_aero_one_lrcr[indlon,*,*,*]
	incld_aero_one_lrcr2=incld_aero_one_lrcr1[*,indlat,*,*]
	Tincld_aero_one_lrcr[monscp,*,*]=total(total(incld_aero_one_lrcr2,1),1)
	incld_aero_belcld_lrcr1=incld_aero_belcld_lrcr[indlon,*,*,*]
	incld_aero_belcld_lrcr2=incld_aero_belcld_lrcr1[*,indlat,*,*]
	Tincld_aero_belcld_lrcr[monscp,*,*]=total(total(incld_aero_belcld_lrcr2,1),1)
	incld_aero_abvcld_lrcr1=incld_aero_abvcld_lrcr[indlon,*,*,*]
	incld_aero_abvcld_lrcr2=incld_aero_abvcld_lrcr1[*,indlat,*,*]
	Tincld_aero_abvcld_lrcr[monscp,*,*]=total(total(incld_aero_abvcld_lrcr2,1),1)
	incld_aero_other_lrcr1=incld_aero_other_lrcr[indlon,*,*,*]
	incld_aero_other_lrcr2=incld_aero_other_lrcr1[*,indlat,*,*]
	Tincld_aero_other_lrcr[monscp,*,*]=total(total(incld_aero_other_lrcr2,1),1)
	endif
endfor

 aero_only_fre=Taero_only_numh/float(Tobsnumh)
 aerobelow_isolate_fre=$
	reform(Tisolate_aero_numh[*,0]+Tisolate_aero_numh[*,3]+Tisolate_aero_numh[*,7])/$
	float(Tobsnumh)
 aeroabove_isolate_fre=$
	reform(Tisolate_aero_numh[*,1]+Tisolate_aero_numh[*,4]+Tisolate_aero_numh[*,6])/$
	float(Tobsnumh)
 aeroother_isolate_fre=$
	reform(Tisolate_aero_numh[*,2]+Tisolate_aero_numh[*,5]+Tisolate_aero_numh[*,8])/$
	float(Tobsnumh)

aeroone_incld_fre=reform(Tincld_aero_numh[*,0])/float(Tobsnumh)
aerobelow_incld_fre=reform(Tincld_aero_numh[*,1])/float(Tobsnumh)
aeroabove_incld_fre=reform(Tincld_aero_numh[*,2]+Tincld_aero_numh[*,3])/float(Tobsnumh)
aeroother_incld_fre=reform(Tincld_aero_numh[*,4]+Tincld_aero_numh[*,5])/float(Tobsnumh)
allaero_fre=reform(Taero_only_numh+total(Tisolate_aero_numh,2)+total(Tincld_aero_numh,2))/float(Tobsnumh)

save,allaero_fre,filename=region+'_allaero_frequency.sav'
save,aero_only_fre,filename=region+'_aeroonly_frequency.sav'
save,aerobelow_isolate_fre,filename=region+'_aerobelow_isolate_frequency.sav'
save,aeroabove_isolate_fre,filename=region+'_aeroabove_isolate_frequency.sav'
merge_layer_incld=aeroone_incld_fre;+aerobelow_incld_fre
save,merge_layer_incld,filename=region+'_merge_layer_only_below_cloud_frequency.sav'

lnthick=2
x=findgen(12)+1
p=plot(x,aero_only_fre,dim=[800,400],xrange=[0,13],xtitle='Month',ytitle='Frequency',thick=lnthick,symbol='circle',sym_filled=1)
p1=plot(x,aerobelow_isolate_fre,overplot=p,color='r',name='Below-cloud aerosol',thick=lnthick,symbol='circle',sym_filled=1)
p2=plot(x,allaero_fre,overplot=p,color='purple',name='All aerosol',thick=lnthick,symbol='circle',sym_filled=1)
;p2=plot(x,aeroabove_isolate_fre,overplot=p,color='pink',name='Above-cloud aerosol',thick=lnthick,symbol='circle',sym_filled=1) ;do not plot due to low frequency
;p3=plot(x,aeroother_isolate_fre,overplot=p,color='grey',name='Others',thick=lnthick,symbol='circle',sym_filled=1)

p4=plot(x,aeroone_incld_fre+aerobelow_incld_fre,overplot=p,color='g',name='Merged layer only+below cloud',thick=lnthick,symbol='circle',sym_filled=1)
;p5=plot(x,aerobelow_incld_fre,overplot=p,color='cyan',name='Merged layer below',thick=lnthick,symbol='circle',sym_filled=1)
;p6=plot(x,aeroabove_incld_fre,overplot=p,color='purple',name='Merged layer above',thick=lnthick,symbol='circle',sym_filled=1)
;p7=plot(x,aeroother_incld_fre,overplot=p,color='blue',name='Other merged layers',thick=lnthick,symbol='circle',sym_filled=1)

;=========== plot optical depth ======
 aero_only_avetau=Taero_only_tau/float(Taero_only_numh)
 aero_only_avetauerr=Taero_only_tauerr/float(Taero_only_numh)

 aerobelow_isolate_avetau=$
	reform(Tisolate_aero_tau[*,0]+Tisolate_aero_tau[*,3]+Tisolate_aero_tau[*,7])/$
	reform(Tisolate_aero_numh[*,0]+Tisolate_aero_numh[*,3]+Tisolate_aero_numh[*,7])
 aerobelow_isolate_avetauerr=$
	reform(Tisolate_aero_tauerr[*,0]+Tisolate_aero_tauerr[*,3]+Tisolate_aero_tauerr[*,7])/$
	reform(Tisolate_aero_numh[*,0]+Tisolate_aero_numh[*,3]+Tisolate_aero_numh[*,7])

 aeroabove_isolate_avetau=$
	reform(Tisolate_aero_tau[*,1]+Tisolate_aero_tau[*,4]+Tisolate_aero_tau[*,6])/$
	reform(Tisolate_aero_numh[*,1]+Tisolate_aero_numh[*,4]+Tisolate_aero_numh[*,6])
 aeroabove_isolate_avetauerr=$
	reform(Tisolate_aero_tauerr[*,1]+Tisolate_aero_tauerr[*,4]+Tisolate_aero_tauerr[*,6])/$
	reform(Tisolate_aero_numh[*,1]+Tisolate_aero_numh[*,4]+Tisolate_aero_numh[*,6])

 aeroother_isolate_avetau=$
	reform(Tisolate_aero_tau[*,2]+Tisolate_aero_tau[*,5]+Tisolate_aero_tau[*,8])/$
	reform(Tisolate_aero_numh[*,2]+Tisolate_aero_numh[*,5]+Tisolate_aero_numh[*,8])
 aeroother_isolate_avetauerr=$
	reform(Tisolate_aero_tauerr[*,2]+Tisolate_aero_tauerr[*,5]+Tisolate_aero_tauerr[*,8])/$
	reform(Tisolate_aero_numh[*,2]+Tisolate_aero_numh[*,5]+Tisolate_aero_numh[*,8])

aeroone_incld_avetau=reform(Tincld_aero_tau[*,0])/reform(Tincld_aero_numh[*,0])
aeroone_incld_avetauerr=reform(Tincld_aero_tauerr[*,0])/reform(Tincld_aero_numh[*,0])
aerobelow_incld_avetau=reform(Tincld_aero_tau[*,1])/reform(Tincld_aero_numh[*,1])
aerobelow_incld_avetauerr=reform(Tincld_aero_tauerr[*,1])/reform(Tincld_aero_numh[*,1])
aeroabove_incld_avetau=reform(Tincld_aero_tau[*,2]+Tincld_aero_tau[*,3])/reform(Tincld_aero_numh[*,2]+Tincld_aero_numh[*,3])
aeroabove_incld_avetauerr=reform(Tincld_aero_tauerr[*,2]+Tincld_aero_tauerr[*,3])/reform(Tincld_aero_numh[*,2]+Tincld_aero_numh[*,3])
aeroother_incld_avetau=reform(Tincld_aero_tau[*,4]+Tincld_aero_tau[*,5])/reform(Tincld_aero_numh[*,4]+Tincld_aero_numh[*,5])
aeroother_incld_avetauerr=reform(Tincld_aero_tauerr[*,4]+Tincld_aero_tauerr[*,5])/reform(Tincld_aero_numh[*,4]+Tincld_aero_numh[*,5])
aeroincld_mergelowtau=reform(Tincld_aero_tau[*,0]+Tincld_aero_tau[*,1])/reform(Tincld_aero_numh[*,0]+Tincld_aero_numh[*,1])
aeroincld_mergelowtauerr=reform(Tincld_aero_tauerr[*,0]+Tincld_aero_tauerr[*,1])/reform(Tincld_aero_numh[*,0]+Tincld_aero_numh[*,1])
aeroincld_nocirrus_tau=reform(Tincld_aero_tau[*,0]+Tincld_aero_tau[*,1]+Tincld_aero_tau[*,5])/reform(Tincld_aero_numh[*,0]+$
		Tincld_aero_numh[*,1]+Tincld_aero_numh[*,5])
aeroincld_nocirrus_tauerr=reform(Tincld_aero_tauerr[*,0]+Tincld_aero_tauerr[*,1]+Tincld_aero_tauerr[*,5])/reform(Tincld_aero_numh[*,0]+$
		Tincld_aero_numh[*,1]+Tincld_aero_numh[*,5])

allaero_avetau=reform(Taero_only_tau+total(Tisolate_aero_tau,2)+total(Tincld_aero_tau,2))/$
	reform(Taero_only_numh+total(Tisolate_aero_numh,2)+total(Tincld_aero_numh,2))
allaero_avetauerr=reform(Taero_only_tauerr+total(Tisolate_aero_tauerr,2)+total(Tincld_aero_tauerr,2))/$
	reform(Taero_only_numh+total(Tisolate_aero_numh,2)+total(Tincld_aero_numh,2))

save,allaero_avetau,allaero_avetauerr,filename=region+'_allaero_avetau.sav'
save,aero_only_avetau,aero_only_avetauerr,filename=region+'_aero_only_avetau.sav'
save,aerobelow_isolate_avetau,aerobelow_isolate_avetauerr,filename=region+'_aerobelow_isolate_avetau.sav'
save,aeroabove_isolate_avetau,aeroabove_isolate_avetauerr,filename=region+'_aeroabove_isolate_avetau.sav'
save,aeroincld_mergelowtau,aeroincld_mergelowtauerr,filename=region+'_aeromergeonlybelowcld_incld_avetau.sav'
save,aeroincld_nocirrus_tau,aeroincld_nocirrus_tauerr,filename=region+'_aeromergenocirrus_avetau.sav'
save,aerobelow_incld_avetau,aerobelow_incld_avetauerr,filename=region+'_incldbelowcloud_avetau.sav'

p=plot(x,aero_only_avetau,dim=[800,400],xrange=[0,13],xtitle='Month',ytitle='AOD',thick=lnthick,symbol='circle',sym_filled=1)
p1=plot(x,aerobelow_isolate_avetau,overplot=p,color='r',name='Below-cloud aerosol',thick=lnthick,symbol='circle',sym_filled=1)
p2=plot(x,allaero_avetau,overplot=p,color='purple',name='All aerosol',thick=lnthick,symbol='circle',sym_filled=1)
;p2=plot(x,aeroabove_isolate_avetau,overplot=p,color='pink',name='Above-cloud aerosol',thick=lnthick) ;do not plot due to low avetauquency
;p3=plot(x,aeroother_isolate_avetau,overplot=p,color='grey',name='Others',thick=lnthick)

p4=plot(x,aeroincld_mergelowtau,overplot=p,color='g',name='Merged layer only+below cloud',thick=lnthick,symbol='circle',sym_filled=1)
;p5=plot(x,aerobelow_incld_avetau,overplot=p,color='cyan',name='Merged layer below',thick=lnthick)
;p6=plot(x,aeroabove_incld_avetau,overplot=p,color='purple',name='Merged layer above',thick=lnthick)
;p7=plot(x,aeroother_incld_avetau,overplot=p,color='blue',name='Other merged layers',thick=lnthick)

; to get mean lidratio-colratio
 coloratio=findgen(121)*0.01
 lidaratio=findgen(70)+10
 lr_mean=fltarr(4)
 cr_mean=fltarr(4)
 lr_std=fltarr(4)
 cr_std=fltarr(4)

 lr_median=fltarr(4)
 cr_median=fltarr(4)
 lr_p10=fltarr(4)
 lr_p90=fltarr(4)
 cr_p10=fltarr(4)
 cr_p90=fltarr(4)

 data=reform(Taero_only_lrcr[8,*,*]);total(Taero_only_lrcr,1)
 calculate_2mean_2st_2pdf,lidaratio,coloratio,data,mean_valuex,std_valuex,mean_valuey,std_valuey
 lr_mean[0]=mean_valuex
 cr_mean[0]=mean_valuey
 lr_std[0]=std_valuex
 cr_std[0]=std_valuey 
 calculate_2median_95_2pdf,lidaratio,coloratio,data,median_valuex,p10_valuex,p90_valuex,median_valuey,p10_valuey,p90_valuey
 lr_median[0]=median_valuex
 cr_median[0]=median_valuey
 lr_p10[0]=p10_valuex
 cr_p10[0]=p10_valuey
 lr_p90[0]=p90_valuex
 cr_p90[0]=p90_valuey


 data=reform(Tisolate_aero_belcld_lrcr[8,*,*]);total(Tisolate_aero_belcld_lrcr,1)
 calculate_2mean_2st_2pdf,lidaratio,coloratio,data,mean_valuex,std_valuex,mean_valuey,std_valuey
 lr_mean[1]=mean_valuex
 cr_mean[1]=mean_valuey
 lr_std[1]=std_valuex
 cr_std[1]=std_valuey 
 calculate_2median_95_2pdf,lidaratio,coloratio,data,median_valuex,p10_valuex,p90_valuex,median_valuey,p10_valuey,p90_valuey
 lr_median[1]=median_valuex
 cr_median[1]=median_valuey
 lr_p10[1]=p10_valuex
 cr_p10[1]=p10_valuey
 lr_p90[1]=p90_valuex
 cr_p90[1]=p90_valuey

 data=reform(Tincld_aero_one_lrcr[8,*,*]+Tincld_aero_belcld_lrcr[8,*,*])
 calculate_2mean_2st_2pdf,lidaratio,coloratio,data,mean_valuex,std_valuex,mean_valuey,std_valuey
 lr_mean[2]=mean_valuex
 cr_mean[2]=mean_valuey
 lr_std[2]=std_valuex
 cr_std[2]=std_valuey 
 calculate_2median_95_2pdf,lidaratio,coloratio,data,median_valuex,p10_valuex,p90_valuex,median_valuey,p10_valuey,p90_valuey
 lr_median[2]=median_valuex
 cr_median[2]=median_valuey
 lr_p10[2]=p10_valuex
 cr_p10[2]=p10_valuey
 lr_p90[2]=p90_valuex
 cr_p90[2]=p90_valuey

 data=reform(Tisolate_aero_abvcld_lrcr[8,*,*])
 calculate_2mean_2st_2pdf,lidaratio,coloratio,data,mean_valuex,std_valuex,mean_valuey,std_valuey
 lr_mean[3]=mean_valuex
 cr_mean[3]=mean_valuey
 lr_std[3]=std_valuex
 cr_std[3]=std_valuey 
 calculate_2median_95_2pdf,lidaratio,coloratio,data,median_valuex,p10_valuex,p90_valuex,median_valuey,p10_valuey,p90_valuey
 lr_median[3]=median_valuex
 cr_median[3]=median_valuey
 lr_p10[3]=p10_valuex
 cr_p10[3]=p10_valuey
 lr_p90[3]=p90_valuex
 cr_p90[3]=p90_valuey

 save,lr_mean,cr_mean,lr_std,cr_std,filename=region+'_lrcr_mean_std_aeroonly_aerobelcld_incldmergeonly_belcld.sav'
 save,lr_median,cr_median,lr_p10,lr_p90,cr_p10,cr_p90,filename=region+'_lrcr_median_75th_aeroonly_aerobelcld_incldmergeonly_belcld.sav'

 p03=errorplot(lr_mean,cr_mean,lr_std,cr_std)

 backscat=findgen(91)*0.05-4.5
 depratio=findgen(21)+0.005
 back_mean=fltarr(4)
 dep_mean=fltarr(4)
 back_std=fltarr(4)
 dep_std=fltarr(4)

 back_median=fltarr(4)
 dep_median=fltarr(4)
 back_p10=fltarr(4)
 back_p90=fltarr(4)
 dep_p10=fltarr(4)
 dep_p90=fltarr(4) 

 data=reform(Taero_only_bd[8,*,*])
 calculate_2mean_2st_2pdf,backscat,depratio,data,mean_valuex,std_valuex,mean_valuey,std_valuey
 back_mean[0]=mean_valuex
 dep_mean[0]=mean_valuey
 back_std[0]=std_valuex
 dep_std[0]=std_valuey 
 calculate_2median_95_2pdf,backscat,depratio,data,median_valuex,p10_valuex,p90_valuex,median_valuey,p10_valuey,p90_valuey
 back_median[0]=median_valuex
 dep_median[0]=median_valuey
 back_p10[0]=p10_valuex
 dep_p10[0]=p10_valuey
 back_p90[0]=p90_valuex
 dep_p90[0]=p90_valuey
 
 data=reform(Tisolate_aero_belcld_bd[8,*,*])
 calculate_2mean_2st_2pdf,backscat,depratio,data,mean_valuex,std_valuex,mean_valuey,std_valuey
 back_mean[1]=mean_valuex
 dep_mean[1]=mean_valuey
 back_std[1]=std_valuex
 dep_std[1]=std_valuey 
 calculate_2median_95_2pdf,backscat,depratio,data,median_valuex,p10_valuex,p90_valuex,median_valuey,p10_valuey,p90_valuey
 back_median[1]=median_valuex
 dep_median[1]=median_valuey
 back_p10[1]=p10_valuex
 dep_p10[1]=p10_valuey
 back_p90[1]=p90_valuex
 dep_p90[1]=p90_valuey


 data=reform(Tincld_aero_one_bd[8,*,*]+Tincld_aero_belcld_bd[8,*,*])
 calculate_2mean_2st_2pdf,backscat,depratio,data,mean_valuex,std_valuex,mean_valuey,std_valuey
 back_mean[2]=mean_valuex
 dep_mean[2]=mean_valuey
 back_std[2]=std_valuex
 dep_std[2]=std_valuey 
 calculate_2median_95_2pdf,backscat,depratio,data,median_valuex,p10_valuex,p90_valuex,median_valuey,p10_valuey,p90_valuey
 back_median[2]=median_valuex
 dep_median[2]=median_valuey
 back_p10[2]=p10_valuex
 dep_p10[2]=p10_valuey
 back_p90[2]=p90_valuex
 dep_p90[2]=p90_valuey
 
 data=reform(Tisolate_aero_abvcld_bd[8,*,*])
 calculate_2mean_2st_2pdf,backscat,depratio,data,mean_valuex,std_valuex,mean_valuey,std_valuey
 back_mean[3]=mean_valuex
 dep_mean[3]=mean_valuey
 back_std[3]=std_valuex
 dep_std[3]=std_valuey 
 calculate_2median_95_2pdf,backscat,depratio,data,median_valuex,p10_valuex,p90_valuex,median_valuey,p10_valuey,p90_valuey
 back_median[3]=median_valuex
 dep_median[3]=median_valuey
 back_p10[3]=p10_valuex
 dep_p10[3]=p10_valuey
 back_p90[3]=p90_valuex
 dep_p90[3]=p90_valuey

 p04=errorplot(back_mean,dep_mean,back_std,dep_std)
 save,back_mean,dep_mean,back_std,dep_std,filename=region+'_bd_mean_std_aeroonly_aerobelcld_incldmergeonly_belcld.sav'
 save,back_median,dep_median,back_p90,dep_p90,back_p10,dep_p10,filename=region+'_bd_median_75th_aeroonly_aerobelcld_incldmergeonly_belcld.sav'

stop

;==== for vertical backscatter
aveisolate_aero_beta_belcld=total(Tisolate_aero_beta_belcld,1)/total(Tisolate_aero_numv_belcld,1)
aveincld_aero_beta=total((Tincld_aero_beta_one+Tincld_aero_beta_belcld),1)/$
	total((Tincld_aero_numv_one+Tincld_aero_numv_belcld),1)
aveaero_only_beta=total(Taero_only_beta,1)/total(Taero_only_numv,1)

p05=plot(aveisolate_aero_beta_belcld,hgt,color='r',name='Isolate-cloud aerosol',xtitle='$\beta$',ytitle='Altitude')
p051=plot(aveincld_aero_beta,hgt,color='r',name='cloudy sky ',xtitle='$\beta$',ytitle='Altitude',yrange=[0,8])
p052=plot(aveaero_only_beta,hgt,color='black',name='Clear sky',overplot=p051)
ld=legend(target=[p051,p052])
save,aveisolate_aero_beta_belcld,aveincld_aero_beta,aveaero_only_beta,filename=region+'_beta_profile.sav'

stop
end

