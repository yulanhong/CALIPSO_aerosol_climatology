
pro plot_median_beta_profile

 dir='/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_region'

 region = ['global','west_us','east_us','center_atlantic','africa','europe','india','east_asia','indonesia','amazon']


 for ri=0,n_elements(region)-1 do begin

 fname=file_search(dir,region[ri]+'_*')
 print,region[ri]
 nf=n_elements(fname)

 dimh=399
 dimy=840
  
 Tobsnum=0L
 Taeroonly=ulonarr(dimh,dimy)
 Tincld_one=ulonarr(dimh,dimy)
 Tincld_abvcld=ulonarr(dimh,dimy)
 Tincld_belcld=ulonarr(dimh,dimy)
 Tincld_other=ulonarr(dimh,dimy)
 Tisolate_abvcld=ulonarr(dimh,dimy)
 Tisolate_belcld=ulonarr(dimh,dimy)
 Tisolate_other=ulonarr(dimh,dimy)
 Tincld=ulonarr(dimh,dimy)
 Tisolate=ulonarr(dimh,dimy)

 Taeroonly_profile=fltarr(dimh,3) ;0-0.25, 0.5, 0.75
 Tincld_profile=fltarr(dimh,3) ;0-0.25, 0.5, 0.75
 Tisolate_profile=fltarr(dimh,3) ;0-0.25, 0.5, 0.75
 Tcloud_profile=fltarr(dimh,3) ;0-0.25, 0.5, 0.75

 for fi=0,Nf-1 do begin
    read_dardar,fname[fi],'obsnum_profile',obsnum
	read_dardar,fname[fi],'aero_only_pdf_backscatter_profile',aero_only_beta
	read_dardar,fname[fi],'incld_aero_pdf_backscatter_profile_one',incld_one_aero_beta
	read_dardar,fname[fi],'incld_aero_pdf_backscatter_profile_abvcld',incld_abvcld_aero_beta
	read_dardar,fname[fi],'incld_aero_pdf_backscatter_profile_belcld',incld_belcld_aero_beta
	read_dardar,fname[fi],'incld_aero_pdf_backscatter_profile_other',incld_other_aero_beta
	read_dardar,fname[fi],'isolate_aero_pdf_backscatter_profile_abvcld',isolate_abvcld_aero_beta
	read_dardar,fname[fi],'isolate_aero_pdf_backscatter_profile_belcld',isolate_belcld_aero_beta
	read_dardar,fname[fi],'isolate_aero_pdf_backscatter_profile_other',isolate_other_aero_beta

    Tobsnum=Tobsnum+obsnum

    Taeroonly=Taeroonly+aero_only_beta
	Tincld_one=Tincld_one+incld_one_aero_beta
	Tincld_abvcld=Tincld_abvcld+incld_abvcld_aero_beta
	Tincld_belcld=Tincld_belcld+incld_belcld_aero_beta
	Tincld_other=Tincld_other+incld_other_aero_beta
    

	Tisolate_abvcld=Tisolate_abvcld+isolate_abvcld_aero_beta
	Tisolate_belcld=Tisolate_belcld+isolate_belcld_aero_beta
	Tisolate_other=Tisolate_other+isolate_other_aero_beta

 endfor
	Tincld = Tincld_one+Tincld_abvcld +Tincld_belcld + Tincld_other
	Tisolate = Tisolate_abvcld + Tisolate_belcld + Tisolate_other 
	Tcloud = Tincld + Tisolate

 hgt=fltarr(dimh)
 hgt[0:53]=29.92-findgen(54)*0.18
 hgt[54:253]=20.2-findgen(200)*0.06
 hgt[254:398]=8.2-findgen(145)*0.06
 

; save the frequency
aeroonly_fre=total(Taeroonly,2)/float(Tobsnum)
incld_fre=total(Tincld,2)/float(Tobsnum)
isolate_fre=total(Tisolate,2)/float(Tobsnum)
cloud_fre=total(Tcloud,2)/float(Tobsnum)

save,hgt,aeroonly_fre,incld_fre,isolate_fre,cloud_fre,Tobsnum,filename=region[ri]+'_aero_verfre_profile.sav'


 x=findgen(dimy)*0.005-5.5
 xout=[0.25,0.5,0.75]

 for hi=0,dimh-1 do begin
	tpaero_pdf=reform(Taeroonly[hi,*])
	pdf2cdf,tpaero_pdf,tpaero_cdf
	tpaero_cdf=tpaero_cdf/float(tpaero_cdf[dimy-1])
	res=interpol(x,tpaero_cdf,xout)
	Taeroonly_profile[hi,0]=res[0]
	Taeroonly_profile[hi,1]=res[1]
	Taeroonly_profile[hi,2]=res[2]

	tpincld_pdf=reform(Tincld[hi,*])
	pdf2cdf,tpincld_pdf,tpincld_cdf
	tpincld_cdf=tpincld_cdf/float(tpincld_cdf[dimy-1])
	res=interpol(x,tpincld_cdf,xout)
	Tincld_profile[hi,0]=res[0]
	Tincld_profile[hi,1]=res[1]
	Tincld_profile[hi,2]=res[2]

	tpisolate_pdf=reform(Tisolate[hi,*])
	pdf2cdf,tpisolate_pdf,tpisolate_cdf
	tpisolate_cdf=tpisolate_cdf/float(tpisolate_cdf[dimy-1])
	res=interpol(x,tpisolate_cdf,xout)
	Tisolate_profile[hi,0]=res[0]
	Tisolate_profile[hi,1]=res[1]
	Tisolate_profile[hi,2]=res[2]

	tpcloud_pdf=reform(Tcloud[hi,*])
	pdf2cdf,tpcloud_pdf,tpcloud_cdf
	tpcloud_cdf=tpcloud_cdf/float(tpcloud_cdf[dimy-1])
	res=interpol(x,tpcloud_cdf,xout)
	Tcloud_profile[hi,0]=res[0]
	Tcloud_profile[hi,1]=res[1]
	Tcloud_profile[hi,2]=res[2]

	
 endfor ;enddimh

  save,hgt,Taeroonly_profile,Tincld_profile,Tisolate_profile,Tcloud_profile,filename=region[ri]+'_median_beta_profile.sav'

 endfor ; end region
 
  stop


end
