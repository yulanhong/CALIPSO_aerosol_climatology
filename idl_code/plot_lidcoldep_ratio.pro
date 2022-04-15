
pro plot_lidcoldep_ratio
	
	dir='/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap/'
	fname=file_search(dir,'*cad50*')

	Nf=n_elements(fname)
	Taeroonly_mcol=0.0D
	Taeroonly_mcol2=0.0D
	Taeroonly_lidcol_2dpdf=0L

	Taeroonly_mlid=0.0D
	Taeroonly_mlid2=0.0D
	Taeroonly_lid_pdf=0L
	
	Taeroonly_mdep=0.0D
	Taeroonly_mdep2=0.0D
	Taeroonly_dep_pdf=0L

	Taeroisolate_mcol=0.0D
	Taeroisolate_mcol2=0.0D
	Taeroisolate_lidcol_2dpdf=0L

	Taeroisolate_mlid=0.0D
	Taeroisolate_mlid2=0.0D
	Taeroisolate_lid_pdf=0L
	
	Taeroisolate_mdep=0.0D
	Taeroisolate_mdep2=0.0D
	Taeroisolate_dep_pdf=0L

	Taeroincld_mcol=0.0D
	Taeroincld_mcol2=0.0D
	Taeroincld_lidcol_2dpdf=0L

	Taeroincld_mlid=0.0D
	Taeroincld_mlid2=0.0D
	Taeroincld_lid_pdf=0L
	
	Taeroincld_mdep=0.0D
	Taeroincld_mdep2=0.0D
	Taeroincld_dep_pdf=0L

	Nf=1


	for fi=0,Nf-1 do begin
	   if (strlen(fname[fi]) eq 130) then begin
		read_dardar,fname[fi],'mean_aeroonly_colratio',aeroonly_mcol ;0-aeroonly_flag,1-lsflag
		read_dardar,fname[fi],'mean2_aeroonly_colratio',aeroonly_mcol2
		read_dardar,fname[fi],'aeroonly_lidvscol_ratio',aeroonly_lidcol_2dpdf
		Taeroonly_mcol=Taeroonly_mcol+aeroonly_mcol
		Taeroonly_mcol2=Taeroonly_mcol2+aeroonly_mcol2
		Taeroonly_lidcol_2dpdf=Taeroonly_lidcol_2dpdf+aeroonly_lidcol_2dpdf

		read_dardar,fname[fi],'mean_aeroonly_lidratio',aeroonly_mlid ;0-aeroonly_flag,1-lsflag
		read_dardar,fname[fi],'mean2_aeroonly_lidratio',aeroonly_mlid2
		read_dardar,fname[fi],'aero_only_lidar_ratio',aeroonly_lid_pdf
		Taeroonly_mlid=Taeroonly_mlid+aeroonly_mlid
		Taeroonly_mlid2=Taeroonly_mlid2+aeroonly_mlid2
		Taeroonly_lid_pdf=Taeroonly_lid_pdf+aeroonly_lid_pdf
	
		read_dardar,fname[fi],'mean_aeroonly_depratio',aeroonly_mdep ;0-aeroonly_flag,1-lsflag
		read_dardar,fname[fi],'mean2_aeroonly_depratio',aeroonly_mdep2
		read_dardar,fname[fi],'pdf_aero_only_depratio',aeroonly_dep_pdf
		Taeroonly_mdep=Taeroonly_mdep+aeroonly_mdep
		Taeroonly_mdep2=Taeroonly_mdep2+aeroonly_mdep2
		Taeroonly_dep_pdf=Taeroonly_dep_pdf+aeroonly_dep_pdf

		;====== isolate aerosol-cloud =====
		read_dardar,fname[fi],'mean_aeroisolate_colratio',aeroisolate_mcol ;0-aeroisolate_flag,1-lsflag
		read_dardar,fname[fi],'mean2_aeroisolate_colratio',aeroisolate_mcol2
		read_dardar,fname[fi],'isolate_aero_lidvscol_ratio',aeroisolate_lidcol_2dpdf
		Taeroisolate_mcol=Taeroisolate_mcol+aeroisolate_mcol
		Taeroisolate_mcol2=Taeroisolate_mcol2+aeroisolate_mcol2
		Taeroisolate_lidcol_2dpdf=Taeroisolate_lidcol_2dpdf+aeroisolate_lidcol_2dpdf

		read_dardar,fname[fi],'mean_aeroisolate_lidratio',aeroisolate_mlid ;0-aeroisolate_flag,1-lsflag
		read_dardar,fname[fi],'mean2_aeroisolate_lidratio',aeroisolate_mlid2
		read_dardar,fname[fi],'isolate_aero_lidar_ratio',aeroisolate_lid_pdf
		Taeroisolate_mlid=Taeroisolate_mlid+aeroisolate_mlid
		Taeroisolate_mlid2=Taeroisolate_mlid2+aeroisolate_mlid2
		Taeroisolate_lid_pdf=Taeroisolate_lid_pdf+aeroisolate_lid_pdf
	
		read_dardar,fname[fi],'mean_aeroisolate_depratio',aeroisolate_mdep ;0-aeroisolate_flag,1-lsflag
		read_dardar,fname[fi],'mean2_aeroisolate_depratio',aeroisolate_mdep2
		read_dardar,fname[fi],'pdf_isolate_aero_depratio',aeroisolate_dep_pdf
		Taeroisolate_mdep=Taeroisolate_mdep+aeroisolate_mdep
		Taeroisolate_mdep2=Taeroisolate_mdep2+aeroisolate_mdep2
		Taeroisolate_dep_pdf=Taeroisolate_dep_pdf+aeroisolate_dep_pdf

		;===== incloud aerosol
		read_dardar,fname[fi],'mean_aeroincld_colratio',aeroincld_mcol ;0-aeroincld_flag,1-lsflag
		read_dardar,fname[fi],'mean2_aeroincld_colratio',aeroincld_mcol2
		read_dardar,fname[fi],'incld_aero_lidvscol_ratio',aeroincld_lidcol_2dpdf
		Taeroincld_mcol=Taeroincld_mcol+aeroincld_mcol
		Taeroincld_mcol2=Taeroincld_mcol2+aeroincld_mcol2
		Taeroincld_lidcol_2dpdf=Taeroincld_lidcol_2dpdf+aeroincld_lidcol_2dpdf

		read_dardar,fname[fi],'mean_aeroincld_lidratio',aeroincld_mlid ;0-aeroincld_flag,1-lsflag
		read_dardar,fname[fi],'mean2_aeroincld_lidratio',aeroincld_mlid2
		read_dardar,fname[fi],'incld_aero_lidar_ratio',aeroincld_lid_pdf
		Taeroincld_mlid=Taeroincld_mlid+aeroincld_mlid
		Taeroincld_mlid2=Taeroincld_mlid2+aeroincld_mlid2
		Taeroincld_lid_pdf=Taeroincld_lid_pdf+aeroincld_lid_pdf
	
		read_dardar,fname[fi],'mean_aeroincld_depratio',aeroincld_mdep ;0-aeroincld_flag,1-lsflag
		read_dardar,fname[fi],'mean2_aeroincld_depratio',aeroincld_mdep2
		read_dardar,fname[fi],'pdf_incld_aero_depratio',aeroincld_dep_pdf
		Taeroincld_mdep=Taeroincld_mdep+aeroincld_mdep
		Taeroincld_mdep2=Taeroincld_mdep2+aeroincld_mdep2
		Taeroincld_dep_pdf=Taeroincld_dep_pdf+aeroincld_dep_pdf
	
	   endif
	endfor

	pos1=[0.10,0.15,0.49,0.9]
    pos2=[0.59,0.15,0.98,0.9]
	smysz=1
	xrange=[-1,2]
	fontsz=12
	;=== get the mean and std====
	; aerosol only ====
	Taeroonly_colnum1=total(Taeroonly_lidcol_2dpdf,1)
	Taeroonly_colnum2=total(Taeroonly_colnum1,1)
	Taeroonly_colnum=total(Taeroonly_colnum2,1)
	ave_aeroonly_mcol=total(Taeroonly_mcol,1)/Taeroonly_colnum
	ave_aeroonly_mcol2=total(Taeroonly_mcol2,1)/Taeroonly_colnum
	std_aeroonly_col=sqrt(ave_aeroonly_mcol2-ave_aeroonly_mcol*ave_aeroonly_mcol)

	x=findgen(2)
	xtickv=[0,1]
	xname=['Ocean','Land']

	b01=plot(x,ave_aeroonly_mcol,dim=[650,300],position=pos1,xticklen=0.02,yticklen=0.02,$
     ytitle='Color ratio',yrange=[0,1],xrange=xrange,symbol='Circle',sym_filled=1,$
     sym_size=smysz,linestyle='none',name='Cloud-free aerosol',xtickname=xname,xtickvalue=xtickv)
	b02=plot(x,ave_aeroonly_mcol,/current,position=pos2,xticklen=0.02,yticklen=0.02,$
     ytitle='Color ratio',yrange=[0,1],xrange=xrange,symbol='Circle',sym_filled=1,$
     sym_size=smysz,linestyle='none',name='Cloud-free aerosol',xtickname=xname,xtickvalue=xtickv)
	
	Taeroonly_lidnum1=total(Taeroonly_lid_pdf,1)
	Taeroonly_lidnum2=total(Taeroonly_lidnum1,1)
	Taeroonly_lidnum=total(Taeroonly_lidnum2,1)
	ave_aeroonly_mlid=total(Taeroonly_mlid,1)/Taeroonly_lidnum
	ave_aeroonly_mlid2=total(Taeroonly_mlid2,1)/Taeroonly_lidnum
	std_aeroonly_lid=sqrt(ave_aeroonly_mlid2-ave_aeroonly_mlid*ave_aeroonly_mlid)

	Taeroonly_depnum1=total(Taeroonly_dep_pdf,1)
	Taeroonly_depnum2=total(Taeroonly_depnum1,1)
	Taeroonly_depnum=total(Taeroonly_depnum2,1)
	ave_aeroonly_mdep=total(Taeroonly_mdep,1)/Taeroonly_depnum
	ave_aeroonly_mdep2=total(Taeroonly_mdep2,1)/Taeroonly_depnum
	std_aeroonly_dep=sqrt(ave_aeroonly_mdep2-ave_aeroonly_mdep*ave_aeroonly_mdep)

	; for aerosol-cloud isolated case
	;=== cloud above aerosol ====
	caa_mcol= reform(Taeroisolate_mcol[0,*]+Taeroisolate_mcol[3,*]+Taeroisolate_mcol[7,*])
	caa_mcol2= reform(Taeroisolate_mcol2[0,*]+Taeroisolate_mcol2[3,*]+Taeroisolate_mcol2[7,*])
	caa_mcolnum=total(total(reform(Taeroisolate_lidcol_2dpdf[*,*,0,*]+Taeroisolate_lidcol_2dpdf[*,*,3,*]+Taeroisolate_lidcol_2dpdf[*,*,7,*]),1),1)
	caa_avecol=caa_mcol/caa_mcolnum
	caa_avecol2=caa_mcol2/caa_mcolnum
	caa_stdcol=sqrt(caa_avecol2-caa_avecol*caa_avecol)
	
    c1=plot(x,caa_avecol,color='r',name='Below-cloud aerosol',overplot=b02,symbol='Triangle',sym_filled=1,$
    sym_size=smysz,linestyle='none')	

	;=== cloud below aerosol ====	
	cba_mcol= reform(Taeroisolate_mcol[1,*]+Taeroisolate_mcol[4,*]+Taeroisolate_mcol[6,*])
	cba_mcol2= reform(Taeroisolate_mcol2[1,*]+Taeroisolate_mcol2[4,*]+Taeroisolate_mcol2[6,*])
	cba_mcolnum=total(total(reform(Taeroisolate_lidcol_2dpdf[*,*,1,*]+Taeroisolate_lidcol_2dpdf[*,*,4,*]+Taeroisolate_lidcol_2dpdf[*,*,6,*]),1),1)
	cba_avecol=cba_mcol/cba_mcolnum
	cba_avecol2=cba_mcol2/cba_mcolnum
	cba_stdcol=sqrt(cba_avecol2-cba_avecol*cba_avecol)

	c2=plot(x,cba_avecol,color='g',name='Above-cloud aerosol',overplot=b02,symbol='Square',sym_filled=1,$
    sym_size=smysz,linestyle='none')


	;===== for others ===========
	coa_mcol= reform(Taeroisolate_mcol[2,*]+Taeroisolate_mcol[5,*]+Taeroisolate_mcol[8,*])
	coa_mcol2= reform(Taeroisolate_mcol2[2,*]+Taeroisolate_mcol2[5,*]+Taeroisolate_mcol2[8,*])
	coa_mcolnum=total(total(reform(Taeroisolate_lidcol_2dpdf[*,*,2,*]+Taeroisolate_lidcol_2dpdf[*,*,5,*]+Taeroisolate_lidcol_2dpdf[*,*,8,*]),1),1)
	coa_avecol=coa_mcol/coa_mcolnum
	coa_avecol2=coa_mcol2/coa_mcolnum
	coa_stdcol=sqrt(coa_avecol2-coa_avecol*coa_avecol)

	c3=plot(x,coa_avecol,color='cyan',name='Other isolated-cloud aerosol',overplot=b02,symbol='Star',sym_filled=1,$
    sym_size=smysz,linestyle='none')

 	ld1=legend(target=[b02,c1,c2,c3],position=[pos2[0]+0.11,pos2[3]-0.01],transparency=100,horizontal_alignment=0,$
        vertical_spacing=0.01,sample_width=0,font_size=fontsz-2)

	;==== for aerosol in cloud cases========
	;=== merge-layer only aerosol ====
	incldo_mcol= reform(Taeroincld_mcol[0,*])
	incldo_mcol2= reform(Taeroincld_mcol2[0,*])
	incldo_mcolnum=total(total(reform(Taeroincld_lidcol_2dpdf[*,*,0,*]),1),1)
	incldo_avecol=incldo_mcol/incldo_mcolnum
	incldo_avecol2=incldo_mcol2/incldo_mcolnum
	incldo_stdcol=sqrt(incldo_avecol2-incldo_avecol*incldo_avecol)

	d1=plot(x,incldo_avecol,color='pink',name='Merged layer only',overplot=b01,symbol='Circle',sym_filled=1,$
     sym_size=smysz,linestyle='none')

	;=== merge-layer below cloud  ====	
	incldb_mcol= reform(Taeroincld_mcol[1,*])
	incldb_mcol2= reform(Taeroincld_mcol2[1,*])
	incldb_mcolnum=total(total(reform(Taeroincld_lidcol_2dpdf[*,*,1,*]),1),1)
	incldb_avecol=incldb_mcol/incldb_mcolnum
	incldb_avecol2=incldb_mcol2/incldb_mcolnum
	incldb_stdcol=sqrt(incldb_avecol2-incldb_avecol*incldb_avecol)
	
	d2=plot(x,incldb_avecol,color='r',name='Merged layer below cloud',overplot=b01,symbol='Triangle',sym_filled=1,$
     sym_size=smysz,linestyle='none')

	;=== merge-layer above cloud  ====	
	inclda_mcol= reform(Taeroincld_mcol[2,*]+Taeroincld_mcol[3,*])
	inclda_mcol2= reform(Taeroincld_mcol2[2,*]+Taeroincld_mcol2[3,*])
	inclda_mcolnum=total(total(reform(Taeroincld_lidcol_2dpdf[*,*,2,*]+Taeroincld_lidcol_2dpdf[*,*,3,*]),1),1)
	inclda_avecol=inclda_mcol/inclda_mcolnum
	inclda_avecol2=inclda_mcol2/inclda_mcolnum
	inclda_stdcol=sqrt(inclda_avecol2-inclda_avecol*inclda_avecol)
	d3=plot(x,inclda_avecol,color='g',name='Merged layer above cloud',overplot=b01,symbol='Square',sym_filled=1,$
     sym_size=smysz,linestyle='none')

	;===== for others ===========
	incldot_mcol= reform(Taeroincld_mcol[4,*]+Taeroincld_mcol[5,*])
	incldot_mcol2= reform(Taeroincld_mcol2[4,*]+Taeroincld_mcol2[5,*])
	incldot_mcolnum=total(total(reform(Taeroincld_lidcol_2dpdf[*,*,4,*]+Taeroincld_lidcol_2dpdf[*,*,5,*]),1),1)
	incldot_avecol=incldot_mcol/incldot_mcolnum
	incldot_avecol2=incldot_mcol2/incldot_mcolnum
	incldot_stdcol=sqrt(incldot_avecol2-incldot_avecol*incldot_avecol)
	
	d4=plot(x,incldot_avecol,color='cyan',name='Other in-cloud aerosol',overplot=b01,symbol='Star',sym_filled=1,$
     sym_size=smysz,linestyle='none')
    ld=legend(target=[b01,d1,d2,d3,d4],position=[pos1[0]+0.11,pos1[3]-0.01],transparency=100,horizontal_alignment=0,$
          vertical_spacing=0.01,sample_width=0,font_size=fontsz-2)

	b01.save,'aerosol_coloratio_cad50.png'

	stop
end
