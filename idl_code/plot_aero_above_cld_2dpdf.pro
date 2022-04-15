
pro plot_aero_above_cld_2dpdf

	fname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap/','*.hdf')

	Nf=n_elements(fname)
	Ntau=601
	tau_interval=findgen(Ntau)*0.01-4

	Toneaero_2pdf=0L
	Tmulaero_2pdf=0L
	Toneaero_tau=0.0
	Tmulaero_tau=0.0

	Taeroonly_2pdf=0L
	Taeroonly_tau=0.0

	fontsz=11

	for fi=0,Nf-1 do begin
	    read_dardar,fname[fi],'cldaero_gap_2dpdf_oneaero',oneaero_2pdf
		Toneaero_2pdf=Toneaero_2pdf+oneaero_2pdf 	   
	    read_dardar,fname[fi],'cldaero_gap_meantau_oneaero',oneaero_tau
		Toneaero_tau=Toneaero_tau+oneaero_tau

	    read_dardar,fname[fi],'cldaero_gap_2dpdf_multiaero',mulaero_2pdf
		Tmulaero_2pdf=Tmulaero_2pdf+mulaero_2pdf 	   
	    read_dardar,fname[fi],'cldaero_gap_meantau_multiaero',mulaero_tau
		Tmulaero_tau=Tmulaero_tau+mulaero_tau 	   

		read_dardar,fname[fi],'top_base_2dpdf_aeroonly',aeroonly_2pdf
		Taeroonly_2pdf=Taeroonly_2pdf+aeroonly_2pdf
		read_dardar,fname[fi],'top_base_meantau_aeroonly',aeroonly_tau
		Taeroonly_tau=Taeroonly_tau+aeroonly_tau

	endfor
	;======== to obtain median value =====================

	aac_num=reform(Toneaero_2pdf[*,*,*,0])+reform(Tmulaero_2pdf[*,*,*,0])
	include_median,aac_num,tau_interval,mediandata_aac
	ind=where(mediandata_aac eq 1)
	mediandata_aac[ind]=!values.f_nan

	abc_num=reform(Toneaero_2pdf[*,*,*,1])+reform(Tmulaero_2pdf[*,*,*,1])
	include_median,abc_num,tau_interval,mediandata_abc
	ind=where(mediandata_abc eq 1)
	mediandata_abc[ind]=!values.f_nan
	
	include_median,Taeroonly_2pdf,tau_interval,mediandata_aeroonly
	ind=where(mediandata_aeroonly eq 1)
	mediandata_aeroonly[ind]=!values.f_nan

	nsize=size(Taeroonly_2pdf)
	dimx=nsize[1]
	dimy=nsize[2]
	xvalue=findgen(dimx)*0.1
	yvalue=findgen(dimy)*0.1
	pos1=[0.10,0.73,0.45,0.96]
	pos2=[0.55,0.73,0.90,0.96]
	pos3=[0.10,0.42,0.45,0.65]
	pos4=[0.55,0.42,0.90,0.65]
	pos5=[0.10,0.11,0.45,0.34]
	pos6=[0.55,0.11,0.90,0.34]
	
 	xtickv=[0,50,100,150]
	xname=['0','5','10','15']

	minvalue1=0.0
	maxvalue1=0.5

	sc1=1.1
	sc2=0.8
	tbn=20
	data=total(Taeroonly_2pdf,3)
	data=reverse(data)
	c=image(total(Taeroonly_2pdf,3),rgb_table=tbn,min_value=minvalue,max_value=4000000L,font_size=fontsz,$
		position=pos1,dim=[600,800],xrange=[-10,100],yrange=[0,100])
	xaxis=axis('X',location=0,target=c,tickdir=0,textpos=0,minor=4,tickvalues=[0,50,100],tickname=['0','5','10'],title='Base (km)')
	yaxis=axis('Y',location=-10,target=c,tickdir=0,textpos=0,minor=4,tickvalues=[0,50,100],tickname=['0','5','10'],title='Top (km)')
	c.scale,sc1,sc2
	barpos=[pos1[0],pos1[1]-0.05,pos1[2],pos1[1]-0.03]
	ct=colorbar(target=c,title='Number',taper=1,major=4,$
            border=1,font_size=fontsz-1,orientation=0,position=barpos)
	t1=text(pos1[0]+0.05,pos1[3]-0.05,'a) Cloud-free aerosol')
	c1=image(mediandata_aeroonly,rgb_table=tbn,min_value=minvalue1,max_value=maxvalue1,font_size=fontsz,$
		position=pos2,/current,xrange=[-10,100],yrange=[0,100])
	xaxis=axis('X',location=0,target=c1,tickdir=0,textpos=0,minor=4,tickvalues=[0,50,100],tickname=['0','5','10'],title='Base (km)')
	yaxis=axis('Y',location=-10,target=c1,tickdir=0,textpos=0,minor=4,tickvalues=[0,50,100],tickname=['0','5','10'],title='Top (km)')
	c1.scale,sc1,sc2
	barpos=[pos2[0],pos2[1]-0.05,pos2[2],pos2[1]-0.03]
	ct=colorbar(target=c1,title='AOD',taper=1,$
            border=1,font_size=fontsz-1,orientation=0,position=barpos)
	t2=text(pos2[0]+0.05,pos2[3]-0.05,'b) Cloud-free aerosol')
	

	c2=image(total(aac_num,3),rgb_table=tbn,min_value=minvalue,max_value=maxvalue,font_size=fontsz,$
		position=pos3,/current,xrange=[0,150],yrange=[0,150])
	xaxis=axis('X',location=0,target=c2,tickdir=0,textpos=0,minor=4,tickvalues=xtickv,tickname=xname,title='Cloud top (km)')
	yaxis=axis('Y',location=0,target=c2,tickdir=0,textpos=0,minor=4,tickvalues=xtickv,tickname=xname,title='Gap (km)')
	c2.scale,sc1,sc2
	barpos=[pos3[0],pos3[1]-0.05,pos3[2],pos3[1]-0.03]
	ct=colorbar(target=c2,title='Number',taper=1,$
            border=1,font_size=fontsz-1,orientation=0,position=barpos)
	t3=text(pos3[0]+0.05,pos3[3]-0.05,'c) Above-cloud aerosol')

	c3=image(mediandata_aac,rgb_table=tbn,min_value=minvalue1,max_value=maxvalue1/10.0,font_size=fontsz,$
		position=pos4,/current,xrange=[0,150],yrange=[0,150])

	xaxis=axis('X',location=0,target=c3,tickdir=0,textpos=0,minor=4,tickvalues=xtickv,tickname=xname,title='Cloud top (km)')
	yaxis=axis('Y',location=0,target=c3,tickdir=0,textpos=0,minor=4,tickvalues=xtickv,tickname=xname,title='Gap (km)')
	c3.scale,sc1,sc2
	barpos=[pos4[0],pos4[1]-0.05,pos4[2],pos4[1]-0.03]
	ct=colorbar(target=c3,title='AOD',taper=1,$
            border=1,font_size=fontsz-1,orientation=0,position=barpos)
	t4=text(pos4[0]+0.05,pos4[3]-0.05,'d) Above-cloud aerosol')

	c4=image(total(abc_num,3),rgb_table=tbn,min_value=minvalue,max_value=maxvalue,font_size=fontsz,$
		position=pos5,/current,xrange=[0,180],yrange=[0,180])
	xaxis=axis('X',location=0,target=c4,tickdir=0,textpos=0,minor=4,tickvalues=xtickv,tickname=xname,title='Cloud base (km)')
	yaxis=axis('Y',location=0,target=c4,tickdir=0,textpos=0,minor=4,tickvalues=xtickv,tickname=xname,title='Gap (km)')
	c4.scale,sc1,sc2
	barpos=[pos5[0],pos5[1]-0.05,pos5[2],pos5[1]-0.03]
	ct=colorbar(target=c4,title='Number',taper=1,$
            border=1,font_size=fontsz-1,orientation=0,position=barpos,major=4)
	t5=text(pos5[0]+0.05,pos5[3]-0.05,'e) Below-cloud aerosol')

	c5=image(mediandata_abc,rgb_table=tbn,min_value=minvalue1,max_value=maxvalue1,font_size=fontsz,$
		position=pos6,/current,xrange=[0,180],yrange=[0,180])

	xaxis=axis('X',location=0,target=c5,tickdir=0,textpos=0,minor=4,tickvalues=xtickv,tickname=xname,title='Cloud base (km)')
	yaxis=axis('Y',location=0,target=c5,tickdir=0,textpos=0,minor=4,tickvalues=xtickv,tickname=xname,title='Gap (km)')
	c5.scale,sc1,sc2
	barpos=[pos6[0],pos6[1]-0.05,pos6[2],pos6[1]-0.03]
	ct=colorbar(target=c5,title='AOD',taper=1,$
            border=1,font_size=fontsz-1,orientation=0,position=barpos)
	t6=text(pos6[0]+0.05,pos6[3]-0.05,'f) Below-cloud aerosol')
	c.save,'aerosol_only_cloud_2dpdf.png'

	stop	
end
