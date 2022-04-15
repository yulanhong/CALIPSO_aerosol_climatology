;cloud category

;inncloud
;1-aerosol-cloud merge in one layer
;2- cloud layers above aero-cld, 
;3- cloud layers below aero-cld,
;4- clouds above and below aero-cld layer
;5- multiple aerosols, one merged layer, the merged-layer can be above/below aerosol layers 
;6- multiple layers of clouds and multiple layers of aerosols 

;isoalte cloud
;1-cloud above aero
; 59         !2-aero above cloud
; 60         !3-aero inbetween cloud
; 61         !4--multi-layer aero,onelayer cloud,cloud is above all aerosols
; 62         !5--multi-layer aero,one layer cloud,cloud is below all aerosols
; 63         !6--multi-layer aero,one layer cloud,cloud is inbetween aerosols
; 64         !7--multi-layer aero and multi-layer cld,aerosol above cloud
; 65         !8--multi-layer aero and multi-layer cld,aerosol below cloud
; 66         !9--multi-layer aero and multi-layer cloud, others

pro plot_cases

    plotmodisflag=0
    mod02fname='MYD021KM.A2019009.1315.061.2019010174657.hdf'
    mod03fname='MYD03.A2016264.1315.061.2018060144441.hdf'

;  for calipso data
; 	lidfname='/u/sciteam/yulanh/scratch/CALIOP/V4-10/CAL_LID_L1-Standard-V4-10.2016-09-18T13-13-48ZD_Subset.hdf'
;    lidfname='/u/sciteam/yulanh/scratch/CALIOP/V4-10/CAL_LID_L1-Standard-V4-10.2016-09-20T13-01-09ZD_Subset.hdf'
;	dir='/u/sciteam/yulanh/scratch/CALIOP/MLay/2019/'
;	dir1='/u/sciteam/yulanh/scratch/CALIOP/APro/2019/'
;	lidaerocld_flag='cloud_aerosol_category_20190915.txt'
	dir='/u/sciteam/yulanh/scratch/CALIOP/MLay/2019/'
	dir1='/u/sciteam/yulanh/scratch/CALIOP/APro/2019/'
	lidaerocld_flag='cloud_aerosol_category_201907240323.txt'

	flagdata=read_ascii(lidaerocld_flag)
	flagdata=flagdata.(0)
	mmyy=strmid(lidaerocld_flag,11,8,/rev)

	;for 20160920
;	lonrange1=8
;	lonrange2=12
;	latrange1=-35
;	latrange2=-16
;
;	for 20190915
;	lonrange1=125
;	lonrange2=133
;	latrange1=-13
;	latrange2=12

	;for 20190724
	lonrange1=-25
	lonrange2=-20
	latrange1=12
	latrange2=29
	

	Nh=399
	alt=fltarr(Nh)
 	alt[0:53]=29.92-findgen(54)*0.18
 	alt[54:253]=20.2-findgen(200)*0.06
 	alt[254:398]=8.2-findgen(145)*0.06

	
;	lidfname1=dir+'CAL_LID_L2_05kmMLay-Standard-V4-20.2019-09-15T04-46-55ZD.hdf'
;	lidfname2=dir1+'CAL_LID_L2_05kmAPro-Standard-V4-20.2019-09-15T04-46-55ZD.hdf'
;	lidfname1=dir+'CAL_LID_L2_05kmMLay-Standard-V4-20.2016-09-18T13-13-48ZD.hdf'
;	lidfname2=dir1+'CAL_LID_L2_05kmAPro-Standard-V4-20.2016-09-18T13-13-48ZD.hdf'
	lidfname1=dir+'CAL_LID_L2_05kmMLay-Standard-V4-20.2019-07-24T03-23-12ZN.hdf'
	lidfname2=dir1+'CAL_LID_L2_05kmAPro-Standard-V4-20.2019-07-24T03-23-12ZN.hdf'

;	read_dardar,lidfname,'Latitude',lidlat
;	read_dardar,lidfname,'Longitude',lidlon
;	read_dardar,lidfname,'Profile_UTC_Time',lidtime
;	read_dardar,lidfname,'Total_Attenuated_Backscatter_532',lidbsc

	read_dardar,lidfname1,'Column_Optical_Depth_Tropospheric_Aerosols_532',lidaot
	read_dardar,lidfname1,'Latitude',lidlatm
	read_dardar,lidfname1,'Longitude',lidlonm
	read_dardar,lidfname1,'Layer_Top_Altitude',lidtop
	read_dardar,lidfname1,'Layer_Base_Altitude',lidbase
	read_dardar,lidfname1,'CAD_Score',lidcad_score
	read_dardar,lidfname1,'Horizontal_Averaging',horizon_res	
	read_dardar,lidfname1,'Profile_UTC_Time',lidtime

	read_dardar,lidfname2,'Total_Backscatter_Coefficient_532',lidbsc
	read_dardar,lidfname2,'Extinction_Coefficient_532',lidext


    lidlonm=reform(lidlonm[1,*])
    lidlatm=reform(lidlatm[1,*])
	lidaot=reform(lidaot)
	lidtime=reform(lidtime[1,*])
	lidtime=24.0*(reform(lidtime)-floor(lidtime[0])) ;utchour


	ind=where(lidlonm ge lonrange1 and lidlonm le lonrange2)
	lidlonm1=lidlonm[ind]
	lidlatm1=lidlatm[ind]
	lidtop1=lidtop[*,ind]
	lidbase1=lidbase[*,ind]
	lidcad_score1=lidcad_score[*,ind]
	horizon_res1=horizon_res[*,ind]
	lidtime1=lidtime[ind]
	lidbsc1=lidbsc[*,ind]
	lidext1=lidext[*,ind]
	lidaot1=lidaot[ind]	
	flagdata1=flagdata[*,ind]


	latind=where(lidlatm1 ge latrange1 and lidlatm1 le latrange2)
	lidlonm2=lidlonm1[latind]
	lidlatm2=lidlatm1[latind]
	lidtop2=lidtop1[*,latind]
	lidbase2=lidbase1[*,latind]
	lidcad_score2=lidcad_score1[*,latind]
	horizon_res2=horizon_res1[*,latind]
	lidtime2=lidtime1[latind]
	lidbsc2=lidbsc1[*,latind]
	lidext2=lidext1[*,latind]
	lidaot2=lidaot1[latind]
	flagdata2=flagdata1[*,latind]


   	layer2profile,alt,lidtop2,lidbase2,lidcad_score2,prof_data
   	layer2profile,alt,lidtop2,lidbase2,horizon_res2,horizon_data


	;=====================================
	; plot to check
	plotcheck=1

	fontsz=9
	IF (plotcheck eq 1) Then Begin
	 maplimit=[latrange1-5,lonrange1-5,latrange2+5,lonrange2+10]
	 mp=map('Geographic',limit=maplimit,transparency=50,fill_color='light blue')
	 grid=mp.mapgrid
     grid.linestyle='dotted'
     grid.grid_latitude=5
     grid.grid_longitude=5
     grid.label_show=1
     grid.label_angle=0
     grid.font_size=fontsz
     grid.label_position=0
  
    ; title=strmid(hsrlfname,13,11,/rev)
     mc=mapcontinents(/continents,fill_color='white')
     p=plot(lidlonm2,lidlatm2,overplot=mp,thick=3,color='r',title=title)
;     p1=plot(lidlonm3,lidlatm3,overplot=mp,thick=3,color='g')
     p.scale,0.8,0.9
;     p.save,title+'_colocate.png'


	EndIf

	;================================================
	; plot backscattering
	minvalue=1.0e-4
	maxvalue=1.0e-1
	level=[1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,100,$
		200,300,400,500,600,700,800,900,1000]*0.0001

;	xtickv=[0,100,200,300,400,500]
;	xname=['-13.18','-14.96','-16.73','-18.54','-20.35','-22.14']
;	xtickv=[0,100,200,300,400]
;	xname=['-14.00','-15.77','-17.56','-19.37','-21.18']
;	xtickv=[0,100,200,300]
;	xname=['-10.71','-12.49','-14.27','-16.04']
;	xaxis=axis('X',location=0,target=c,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,title='Latitude (degree)')
;	ct=colorbar(target=c)
;	c=contour(bsc1,/fill,rgb_table=33,c_value=level)			
;	c1=contour(lidbsc3,/fill,rgb_table=33,c_value=level)			

	;===== to plot aot =====================================
	yrange=[0,10]
;	p=plot(lidlatm2,lidaot2,name='CALIPSO',thick=1.3,xtitle='Latitude (degree)',ytitle='AOD',$
;		xrange=[latrange1,latrange2])

	find=where(flagdata2 eq 0)
	flagdata2[find]=!values.f_nan

;	p2=plot(lidlatm2,flagdata2[0,*],linestyle='',symbol='*',color='purple',$
;		xrange=[latrange1,latrange2],xtitle='Latitude (degree)',yrange=yrange)
;	p21=plot(lidlatm2,flagdata2[1,*],linestyle='',symbol='*',overplot=p2,color='g')
;	p22=plot(lidlatm2,flagdata2[2,*],linestyle='',symbol='*',overplot=p2,color='b')
	
	;=== plot aerosol cloud mask ====
	ytickv=[390,307,224,141,57]
	ytickv=alt[ytickv]
	yname=['0','5','10','15','20']
    	ms=image(prof_data,lidlatm2,alt,rgb_table=70,dim=[700,500])
;c	xtickv=[2,50,90,129]
;	xname=['-16.40','-14.25','-12.41','-10.07']
;	xtickv=[21,61,102,137,181]
	xtickv=reverse([0,100,200,300,400])
	xtickv=lidlatm2[xtickv]
	xname=strmid(strcompress(string(xtickv),/rem),0,5)
	xaxis=axis('X',location=0,target=ms,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,title='Latitude (degree)',subticklen=0.1,ticklen=0.02)
	ct=colorbar(target=ms,title='CAD score')
	ms.scale,1.5,0.7

;    mh=image(horizon_data,lidlatm2,alt,rgb_table=64,dim=[700,500])
;	yaxis=axis('Y',location=min(lidlatm2),target=mh,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='Atitude (km)',subticklen=0.1,ticklen=0.02)

;	xaxis=axis('X',location=0,target=mh,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,title='Latitude (degree)',subticklen=0.1,ticklen=0.02)
;	ct=colorbar(target=mh)
;	mh.scale,1.5,0.7	

	;overplot aerosol flag
	y=fltarr(n_elements(lidlatm2))
	y[*]=20
    symsz=0.9
	print,'aero only'
    p=plot(lidlatm2,y*flagdata2[0,*],linestyle='',symbol='circle',color='black',sym_filled=1,sym_size=symsz,overplot=ms,axis_style=0) 	

	merge_only=fltarr(n_elements(lidlatm2))
	merge_only[*]=!values.f_nan
    	ind=where(flagdata2[1,*] eq 1)
	if ind[0] ne -1 then begin
	print,'merge only'
		merge_only[ind]=1
        p1=plot(lidlatm2,y*merge_only,linestyle='',symbol='circle',color='green',sym_filled=1,sym_size=symsz,overplot=ms,axis_style=0) 	
	endif	
	merge_bc=fltarr(n_elements(lidlatm2))
	merge_bc[*]=!values.f_nan
	ind=where(flagdata2[1,*] eq 2)
	if ind[0] ne -1 then begin
		merge_bc[ind]=1
        p1=plot(lidlatm2,y*merge_bc,linestyle='',symbol='circle',color='blue',sym_filled=1,sym_size=symsz,overplot=ms,axis_style=0) 	
	endif	
	merge_ac=fltarr(n_elements(lidlatm2))
	merge_ac[*]=!values.f_nan
	ind=where(flagdata2[1,*] eq 3 or flagdata2[1,*] eq 4)
	if ind[0] ne -1 then begin
	print,'merge ac' 
		merge_ac[ind]=1
        p1=plot(lidlatm2,y*merge_ac,linestyle='',symbol='circle',color='cyan',sym_filled=1,sym_size=symsz,overplot=ms,axis_style=0) 	
	endif	
	merge_ot=fltarr(n_elements(lidlatm2))
	merge_ot[*]=!values.f_nan
	ind=where(flagdata2[1,*] eq 5 or flagdata2[1,*] eq 6)
	if ind[0] ne -1 then begin
	print,'merge ot' 
		merge_ot[ind]=1
        p1=plot(lidlatm2,y*merge_ot,linestyle='',symbol='circle',color='purple',sym_filled=1,sym_size=symsz,overplot=ms,axis_style=0) 	
	endif	

	isolate_bc=fltarr(n_elements(lidlatm2))
	isolate_bc[*]=!values.f_nan
	ind=where(flagdata2[2,*] eq 1 or flagdata2[2,*] eq 4 or flagdata2[2,*] eq 8)
	if ind[0] ne -1 then begin
	print,'isoalte bc' 
		isolate_bc[ind]=1
        p1=plot(lidlatm2,y*isolate_bc,linestyle='',symbol='circle',color='red',sym_filled=1,sym_size=symsz,overplot=ms,axis_style=0) 	
	endif	
	isolate_ac=fltarr(n_elements(lidlatm2))
	isolate_ac[*]=!values.f_nan
	ind=where(flagdata2[2,*] eq 2 or flagdata2[2,*] eq 5 or flagdata2[2,*] eq 7)
	if ind[0] ne -1 then begin
	print,'isolate ac' 
		isolate_ac[ind]=1
        p1=plot(lidlatm2,y*isolate_ac,linestyle='',symbol='circle',color='pink',sym_filled=1,sym_size=symsz,overplot=ms,axis_style=0) 	
	endif	
	isolate_ot=fltarr(n_elements(lidlatm2))
	isolate_ot[*]=!values.f_nan
	ind=where(flagdata2[2,*] eq 3 or flagdata2[2,*] eq 6 or flagdata2[2,*] eq 9)
	if ind[0] ne -1 then begin
	print,'isolate ot' 
		isolate_ot[ind]=1
        p1=plot(lidlatm2,y*isolate_ot,linestyle='',symbol='circle',color='orange',sym_filled=1,sym_size=symsz,overplot=ms,axis_style=0) 	
	endif	
	yaxis=axis('Y',location=min(lidlatm2),target=ms,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='Atitude (km)',subticklen=0.1,ticklen=0.02)

  ;=== for modis =====
   if (plotmodisflag eq 1) then begin

    fid=hdf_sd_start(mod02fname,/read)

    sds_index=hdf_sd_nametoindex(fid,'EV_250_Aggr1km_RefSB')
    nid=hdf_sd_select(fid,sds_index)
    hdf_sd_getdata,nid,modis_250
    scale_ind=hdf_sd_attrfind(nid,'reflectance_scales')
    hdf_sd_attrinfo,nid,scale_ind,data=scale
    scale_ind=hdf_sd_attrfind(nid,'reflectance_offsets')
    hdf_sd_attrinfo,nid,scale_ind,data=offset
    rad_062=scale[0]*(modis_250[*,*,0]-offset[0]) ; band 0 0.62um

    sds_index=hdf_sd_nametoindex(fid,'EV_500_Aggr1km_RefSB')
    nid=hdf_sd_select(fid,sds_index)
    hdf_sd_getdata,nid,modis_500
    scale_ind=hdf_sd_attrfind(nid,'reflectance_scales')
    hdf_sd_attrinfo,nid,scale_ind,data=scale
    scale_ind=hdf_sd_attrfind(nid,'reflectance_offsets')
    hdf_sd_attrinfo,nid,scale_ind,data=offset
    rad_45=scale[0]*(modis_500[*,*,0]-offset[0]) ;band 3 0.47um
    rad_55=scale[1]*(modis_500[*,*,1]-offset[1]) ;band 4 0.55um

    hdf_sd_end,fid

	read_modis_1,mod03fname,'Latitude',modlat
    read_modis_1,mod03fname,'Longitude',modlon

    ind=where(modlon ge lonrange1 and modlon le lonrange2 and modlat ge latrange1 and modlat le latrange2)
	res=array_indices(modlon,ind)
	
	modscp1=res[0,*]
	modscp2=res[1,*]
    tpmodlon=modlon[min(modscp1):max(modscp1),min(modscp2):max(modscp2)]
    tpmodlat=modlat[min(modscp1):max(modscp1),min(modscp2):max(modscp2)]
	tprad_062=rad_062[min(modscp1):max(modscp1),min(modscp2):max(modscp2)]
	tprad_45 =rad_45[min(modscp1):max(modscp1),min(modscp2):max(modscp2)]
	tprad_55 =rad_55[min(modscp1):max(modscp1),min(modscp2):max(modscp2)]

	nsize=size(tpmodlon)
    nx=nsize[1]
	ny=nsize[2]
    data=fltarr(nx,ny,3)
	data[*,*,0]=tprad_062
	data[*,*,1]=tprad_55
	data[*,*,2]=tprad_45	
	
     im=image(data) 
	stop
 endif

 	stop

end
