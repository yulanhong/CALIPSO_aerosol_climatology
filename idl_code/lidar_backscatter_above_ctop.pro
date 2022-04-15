

pro lidar_backscatter_above_ctop

	fname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_region','africa_caliop*')

	Nf=n_elements(fname)

	dimh=399
	Ncldtop=51
	Npdf=840
	
	Tobsnum=ulonarr(dimh)
	Tbeta_clr=dblarr(dimh)
	Tbeta_clrnum=ulonarr(dimh)
	Tbeta_cldtop=dblarr(Ncldtop,dimh)
	Tbeta_cldtop_num=ulonarr(Ncldtop,dimh)
	Tbeta_cldtop_pdf=ulonarr(Ncldtop,dimh,Npdf)
	Tbeta_aeroonly=ulonarr(dimh,Npdf)


	for fi=0,Nf-1 do begin
		read_dardar,fname[fi],'obsnum_profile',obsnum
		Tobsnum=Tobsnum+obsnum
		read_dardar,fname[fi],'incld_aero_mean_backscatter_clear',beta_clr
		read_dardar,fname[fi],'incld_aero_num_backscatter_clear',beta_clr_num
		ind=where(beta_clr_num eq 0)
		if ind[0] ne -1 then beta_clr[ind]=0.0
		Tbeta_clrnum=Tbeta_clrnum+beta_clr_num
		Tbeta_clr = Tbeta_clr + beta_clr*beta_clr_num
		read_dardar,fname[fi],'incld_aero_mean_backscatter_cldtoplt3km',beta_cldtoplt3km
		read_dardar,fname[fi],'incld_aero_num_backscatter_cldtoplt3km',beta_cldtoplt3km_num
		ind=where(beta_cldtoplt3km_num eq 0)
		if ind[0] ne -1 then beta_cldtoplt3km[ind]=0.0
		Tbeta_cldtop=Tbeta_cldtop+beta_cldtoplt3km*beta_cldtoplt3km_num
		Tbeta_cldtop_num=Tbeta_cldtop_num+beta_cldtoplt3km_num

		read_dardar,fname[fi],'incld_aero_pdf_backscatter_cldtoplt3km',beta_cldtoplt3km_pdf
		Tbeta_cldtop_pdf=Tbeta_cldtop_pdf+beta_cldtoplt3km_pdf

		 read_dardar,fname[fi],'aero_only_pdf_backscatter_profile',aero_only_beta
		Tbeta_aeroonly=Tbeta_aeroonly+aero_only_beta

	endfor	

	
    hgt=fltarr(dimh)
    hgt[0:53]=29.92-findgen(54)*0.18
    hgt[54:253]=20.2-findgen(200)*0.06
    hgt[254:398]=8.2-findgen(145)*0.06

	cldtop=findgen(Ncldtop)*0.06
	ave_beta_clr=Tbeta_clr/Tbeta_clrnum

	ave_cldtoplt3km=Tbeta_cldtop/Tbeta_cldtop_num

	median_cldtoplt3km=fltarr(Ncldtop,dimh)
	median_aeroonly=fltarr(dimh)

 	x=findgen(Npdf)*0.005-5.5
    xout=[0.25,0.5,0.75]


	for hi=0,dimh-1 do begin
		for ci=0,Ncldtop-1 do begin
		tpaero_pdf=reform(Tbeta_cldtop_pdf[ci,hi,*])
		pdf2cdf,tpaero_pdf,tpaero_cdf
		tpaero_cdf=tpaero_cdf/float(tpaero_cdf[Npdf-1])
		res=interpol(x,tpaero_cdf,xout)
		median_cldtoplt3km[ci,hi]=res[1]
	endfor
		tpaero_pdf=reform(Tbeta_aeroonly[hi,*])
		pdf2cdf,tpaero_pdf,tpaero_cdf
		tpaero_cdf=tpaero_cdf/float(tpaero_cdf[Npdf-1])
		res=interpol(x,tpaero_cdf,xout)
		median_aeroonly[hi]=res[1]

	endfor

	diff_ave=fltarr(Ncldtop,dimh)
	diff_median=fltarr(Ncldtop,dimh)
	new_cldtopnum=ulonarr(Ncldtop,dimh)

	for ci=0,Ncldtop-1 do begin	
		tpdata=reform(ave_cldtoplt3km[ci,*])	
		ind=where(hgt ge cldtop[ci])
		diff_ave[ci,ind]=alog10(reform(ave_cldtoplt3km[ci,ind]))-alog10(ave_beta_clr[ind])
		
		diff_median[ci,ind]=reform(median_cldtoplt3km[ci,ind])-median_aeroonly[ind]

		new_cldtopnum[ci,ind]=Tbeta_cldtop_num[ci,ind]
	endfor

		ind=where(diff_ave eq 0)
		diff_ave[ind]=!values.f_nan

		ind=where(diff_median eq 0)
		diff_median[ind]=!values.f_nan

		newrgb=colortable(70,/reverse)
		xvalue=[0.6,1.2,1.8,2.4,3]
		xname=['0.6','1.2','1.8','2.4','3.0']
		yvalue=[1.0,3.0,6.0,9.0]
		yname=['1.0','3.0','6.0','9.0']

		im1=image(diff_ave,cldtop,hgt,rgb_table=newrgb,max_value=0.25,min_value=-0.25,yrange=[0,10],$
			xtitle='Cloud Top',ytitle='Alt.')
		xaxis=axis('X',location=0,target=im1,tickdir=0,textpos=0,minor=4,$
     	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
	    yaxis=axis('Y',location=0,target=im1,tickdir=0,textpos=0,minor=4,$
	    tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
		im1.scale,15,2
		ct=colorbar(target=im1)

		im2=image(diff_median,cldtop,hgt,rgb_table=newrgb,max_value=0.25,min_value=-0.25,yrange=[0,10],$
			xtitle='Cloud Top',ytitle='Alt.')
		xaxis=axis('X',location=0,target=im2,tickdir=0,textpos=0,minor=4,$
     	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
	    yaxis=axis('Y',location=0,target=im2,tickdir=0,textpos=0,minor=4,$
	    tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
		im2.scale,15,2
		ct=colorbar(target=im2)

		im3=image(new_cldtopnum,cldtop,hgt,yrange=[0,10],rgb_table=33,xtitle='Cloud Top',ytitle='Alt')
		xaxis=axis('X',location=0,target=im3,tickdir=0,textpos=0,minor=4,$
     	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
	    yaxis=axis('Y',location=0,target=im3,tickdir=0,textpos=0,minor=4,$
	    tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
		im3.scale,15,2
		ct=colorbar(target=im3)

	stop

end
