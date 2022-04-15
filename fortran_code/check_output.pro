
   pro check_output

	hgt=fltarr(399)
	hgt[0:53]=29.92-findgen(54)*0.18
	hgt[54:253]=20.2-findgen(200)*0.06
	hgt[254:398]=8.2-findgen(145)*0.06

	
	allfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen_1/','*.hdf')

	Ns=n_elements(allfname)

	for fi=0,Ns-1 do begin
	fname=allfname[fi]
	read_dardar,fname,'latitude',lat
	read_dardar,fname,'longitude',lon
	read_dardar,fname,'aero_only_backscatter_profile',aeroonly_beta_prof
	read_dardar,fname,'obs_numv',obsnumv
	read_dardar,fname,'obs_numh',obsnumh
	print,max(obsnumh)
	a=image(obsnumh,lon,lat,rgb_table=33)
	a.scale,5,5
	read_dardar,fname,'aero_only_numv',aeroonly_numv
	read_dardar,fname,'pdf_aero_only_tau',pdf_aeroonly_tau
	read_dardar,fname,'pdf_incld_aero_tau',pdf_aeroincld_tau
	read_dardar,fname,'pdf_isolate_aero_tau',pdf_aeroisolate_tau
	read_dardar,fname,'aero_only_backscat_depratio',aeroonly_scatdep
	read_dardar,fname,'incld_aero_backscat_depratio_one',aeroincld_scatdep_one
	read_dardar,fname,'aero_only_lidratio_colratio',aeroonly_lidcol
	read_dardar,fname,'incld_aero_lidratio_colratio_one',aeroincld_lidcol_one
	read_dardar,fname,'incld_aero_numv_one',aeroincld_numv_one
	read_dardar,fname,'isolate_aero_numv_belcld',aeroiscld_numv_belcld
	read_dardar,fname,'incld_aero_backscatter_profile_one',incldaero_beta_prof_one
	read_dardar,fname,'isolate_aero_backscatter_profile_belcld',iscldaero_beta_prof_belcld

	;===== check vertical distribution =====
	aeroonly_zonal_numv=total(aeroonly_numv,1)
	;im=image(aeroonly_zonal_numv,lat,hgt,rgb_table=33)
;	p=plot(float(total(aeroonly_zonal_numv,1))/total(total(obsnumv,1),1),hgt)
	aeroincld_zonal_numv=total(aeroincld_numv_one,1)
	aeroiscld_zonal_numv=total(aeroiscld_numv_belcld,1)

	ind=where(aeroonly_numv eq 0)
	aeroonly_beta_prof[ind]=0.0
	aeroonly_beta_prof1=total(aeroonly_beta_prof*aeroonly_numv,1)/aeroonly_zonal_numv	
	aeroonly_beta_prof2=total(total(aeroonly_beta_prof*aeroonly_numv,1),1)/total(aeroonly_zonal_numv,1)	
;	p1=plot(aeroonly_beta_prof2,hgt)
	;im=image(aeroonly_beta_prof1,lat,hgt,rgb_table=33)
	;im=image(reform(aeroonly_beta_prof[6,*,*]),lat,hgt,rgb_table=33)

	aeroonly_taupdf=total(pdf_aeroonly_tau,1)
	aeroonly_taupdf=total(aeroonly_taupdf,1)
	;p=plot(aeroonly_taupdf)
	aeroincld_taupdf=total(pdf_aeroincld_tau,1)
	aeroincld_taupdf=total(aeroincld_taupdf,1)
	aeroiscld_taupdf=total(pdf_aeroisolate_tau,1)
	aeroiscld_taupdf=total(aeroiscld_taupdf,1)

	aeroonly_scatdep1=total(aeroonly_scatdep,1)
	aeroonly_scatdep1=total(aeroonly_scatdep1,1)
	aeroincld_scatdep1=total(aeroincld_scatdep_one,1)
	aeroincld_scatdep1=total(aeroincld_scatdep1,1)
	;im=image(aeroonly_scatdep1,rgb_table=33)

	aeroonly_lidcol1=total(aeroonly_lidcol,1)
	aeroonly_lidcol1=total(aeroonly_lidcol1,1)

	aeroincld_lidcol1_one=total(aeroincld_lidcol_one,1)
	aeroincld_lidcol1_one=total(aeroincld_lidcol1_one,1)
	aeroincld_scatdep1_one=total(aeroincld_scatdep_one,1)
	aeroincld_scatdep1_one=total(aeroincld_scatdep1_one,1)
	
	endfor
	;im=image(aeroonly_lidcol1,rgb_table=33)
	stop
   end
