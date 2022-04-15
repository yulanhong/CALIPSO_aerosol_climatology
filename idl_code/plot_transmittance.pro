
pro plot_transmittance
	dir='/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap'
	
	fname=file_search(dir,'*.hdf')
	Nf=n_elements(fname)

	Trans=0.0
	Trans_err=0.0
	Trans_num=0

	for fi=0, Nf-1 do begin
		IF (strlen(fname[fi]) eq 130) Then Begin
		read_dardar,fname[fi],'transmittance_aerotau',trans_aerotau
		read_dardar,fname[fi],'transmittance_aerotau_err',transerr_aerotau
		read_dardar,fname[fi],'transmittance_aerotau_num',transnum_aerotau
		Trans=Trans+trans_aerotau
		Trans_err=Trans_err+transerr_aerotau	
		Trans_num=Trans_num+transnum_aerotau
		EndIf
	endfor

	; only consider below-cloud aerosols
	Ntau=601
    fontsz=12
    xdata=findgen(Ntau)*0.01-4
	xdata=10.0^xdata
	xrange=[0.001,4.0]
    yrange=[0,1.0]
    xtitle='Aerosol $\tau$'
    ytitle='Cloud Transmittance'
 
    xtickv=[0.001,0.01,0.1,1.0]
    xtickname=['$10^{-3}$','$10^{-2}$','$10^{-1}$','$10^{0}$']
	lnthk=2

	avetrans=(Trans[*,0]+Trans[*,3]+Trans[*,7])/(Trans_num[*,0]+Trans_num[*,3]+Trans_num[*,7])
	p=plot(xdata,avetrans,color='black',xrange=xrange,yrange=yrange,thick=lnthk,$
     xtitle=xtitle,title='Below-cloud aerosol',xticklen=0.02,yticklen=0.02,$
     ytitle=ytitle,font_size=fontsz,xlog=1,/current,$ 
     xtickvalues=xtickv,xtickname=xtickname,ytickvalues=ytickv,ytickname=ytickname)

	avetrans_err=(Trans_err[*,0]+Trans_err[*,3]+Trans_err[*,7])/$
		(Trans_num[*,0]+Trans_num[*,3]+Trans_num[*,7])
;	plot,avetrans_err
	stop	

end
