
pro plot_aero_2D_month

   print,systime()

   month='Aug.'  
   lidfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*08.hdf')
;   lidfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*2006*')

   Nf=n_elements(lidfname)

   aero_flag=1 ;0 for cloud only, 1 for aerosol
   aerocldflag='Philippine_all_'

   Nmon=1

   lonres=5
   latres=2
   dimx=360/lonres
   dimy=180/latres
   dimh=101 

   minlat=-20
   maxlat=30
   minlon=80
   maxlon=150	

   fontsz=12
   barpos=[0.935,0.2,0.96,0.8]
   pos=[0.12,0.15,0.83,0.89]
;   minlat=-90
;   maxlat=90
;   minlon=-180
;   maxlon=180	

   maplimit=[minlat,minlon,maxlat,maxlon]

   Tobsnumh=Ulonarr(dimx,dimy,Nmon)
   Ticenumh=Ulonarr(dimx,dimy,Nmon)
   Twatnumh=Ulonarr(dimx,dimy,Nmon)
   Tuncernumh=Ulonarr(dimx,dimy,Nmon)
   Ticewatnumh=Ulonarr(dimx,dimy,Nmon)
   Ticeuncernumh=Ulonarr(dimx,dimy,Nmon)
   Twatuncernumh=Ulonarr(dimx,dimy,Nmon)
   Tlowconfnumh=Ulonarr(dimx,dimy,Nmon)
   
   Tobsnumv=Ulonarr(dimx,dimy,dimh,Nmon)
   Ticenumv=Ulonarr(dimx,dimy,dimh,Nmon)
   Twatnumv=Ulonarr(dimx,dimy,dimh,Nmon)
   Tuncernumv=Ulonarr(dimx,dimy,dimh,Nmon)
   Ticewatnumv=Ulonarr(dimx,dimy,dimh,Nmon)
   Ticeuncernumv=Ulonarr(dimx,dimy,dimh,Nmon)
   Twatuncernumv=Ulonarr(dimx,dimy,dimh,Nmon)
   Tlowconfnumv=Ulonarr(dimx,dimy,dimh,Nmon)

   Taero_gene_numh=Ulonarr(dimx,dimy)
   Taero_gene_numv=Ulonarr(dimx,dimy,dimh)
   Taero_only_numh=Ulonarr(dimx,dimy)
   Taero_only_numv=Ulonarr(dimx,dimy,dimh)
   Taero_only_tau=Dblarr(dimx,dimy,Nmon)
   Taero_cld_tau=Dblarr(dimx,dimy,6,Nmon) 
   temp_aerocld_tau=Dblarr(dimx,dimy,6)
 
   for i=0,Nf-1 do begin

	IF strlen(lidfname[i]) eq 101 Then Begin 

	fname=lidfname[i]

;	mon=strmid(fname,5,2,/rev)
	mon=strsplit(fname,'_',/ext)
	mon=strmid(mon[5],4,2)
	monind=fix(mon)

;	print,monind
	
	read_dardar,fname,'latitude',lat 
	read_dardar,fname,'longitude',lon
	read_dardar,fname,'height',hgt
	
	;********* without aerosol***************
	read_dardar,fname,'obs_numh',obsnumh
	read_dardar,fname,'ice_numh',icenumh
	read_dardar,fname,'water_numh',watnumh
	read_dardar,fname,'undetermined_numh',uncernumh
	read_dardar,fname,'ice-water_numh',icewatnumh
	read_dardar,fname,'ice-undetermined_numh',iceuncernumh
	read_dardar,fname,'water-undetermined_numh',watuncernumh
	read_dardar,fname,'lowcad_numh',lowconfnumh

	;********** with aerosols ********************	
	read_dardar,fname,'aerosol_ice_numh',aeroicenumh
	read_dardar,fname,'aerosol_water_numh',aerowatnumh
	read_dardar,fname,'aerosol_uncer_numh',aerouncernumh
	read_dardar,fname,'aerosol_icewat_numh',aeroicewatnumh
	read_dardar,fname,'aerosol_iceuncer_numh',aeroiceuncernumh
	read_dardar,fname,'aerosol_watuncer_numh',aerowatuncernumh
	read_dardar,fname,'aerosol_only_numv',aero_only_numv
	read_dardar,fname,'aerosol_cloud_tau',aero_cld_tau
	read_dardar,fname,'aerosol_only_numh',aero_only_numh
	read_dardar,fname,'aerosol_only_tau',aero_only_tau
	read_dardar,fname,'aerosol_all_numh',aero_all_numh
	read_dardar,fname,'aerosol_all_numv',aero_all_numv
	
	read_dardar,fname,'obs_numv',obsnumv
	read_dardar,fname,'ice_numv',icenumv
	read_dardar,fname,'water_numv',watnumv
	read_dardar,fname,'undetermined_numv',uncernumv
	read_dardar,fname,'ice-water_numv',icewatnumv
	read_dardar,fname,'ice-undetermined_numv',iceuncernumv
	read_dardar,fname,'water-undetermined_numv',watuncernumv
	read_dardar,fname,'lowcad_numv',lowconfnumv

	read_dardar,fname,'aerosol_ice_numv',aeroicenumv
	read_dardar,fname,'aerosol_water_numv',aerowatnumv
	read_dardar,fname,'aerosol_uncer_numv',aerouncernumv
	read_dardar,fname,'aerosol_icewat_numv',aeroicewatnumv
	read_dardar,fname,'aerosol_iceuncer_numv',aeroiceuncernumv
	read_dardar,fname,'aerosol_watuncer_numv',aerowatuncernumv
	
	IF (aero_flag eq 0) then begin

   	Tobsnumh=Tobsnumh+obsnumh
  	Ticenumh=Ticenumh+icenumh
   	Twatnumh=Twatnumh+watnumh
   	Tuncernumh=Tuncernumh+uncernumh
   	Ticewatnumh=Ticewatnumh+icewatnumh
   	Ticeuncernumh=Ticeuncernumh+iceuncernumh
   	Twatuncernumh=Twatuncernumh+watuncernumh
   	Tlowconfnumh= Tlowconfnumh + lowconfnumh

   	Tobsnumv=Tobsnumv+obsnumv
  	Ticenumv=Ticenumv+icenumv
   	Twatnumv=Twatnumv+watnumv
   	Tuncernumv=Tuncernumv+uncernumv
   	Ticewatnumv=Ticewatnumv+icewatnumv
   	Ticeuncernumv=Ticeuncernumv+iceuncernumv
   	Twatuncernumv=Twatuncernumv+watuncernumv
   	Tlowconfnumv= Tlowconfnumv + lowconfnumv
	EndIf

	IF (aero_flag eq 1) then begin

   	Tobsnumh=Tobsnumh+obsnumh
  	Ticenumh=Ticenumh+aeroicenumh
   	Twatnumh=Twatnumh+aerowatnumh
   	Tuncernumh=Tuncernumh+aerouncernumh
   	Ticewatnumh=Ticewatnumh+aeroicewatnumh
   	Ticeuncernumh=Ticeuncernumh+aeroiceuncernumh
   	Twatuncernumh=Twatuncernumh+aerowatuncernumh

   	Tobsnumv=Tobsnumv+obsnumv
  	Ticenumv=Ticenumv+aeroicenumv
   	Twatnumv=Twatnumv+aerowatnumv
   	Tuncernumv=Tuncernumv+aerouncernumv
   	Ticewatnumv=Ticewatnumv+aeroicewatnumv
   	Ticeuncernumv=Ticeuncernumv+aeroiceuncernumv
   	Twatuncernumv=Twatuncernumv+aerowatuncernumv


   	Taero_gene_numh = Taero_gene_numh+ aero_all_numh
   	Taero_gene_numv = Taero_gene_numv + aero_all_numv

   	Taero_only_numh = Taero_only_numh+ aero_only_numh
   	Taero_only_numv = Taero_only_numv + aero_only_numv
	aeroind=where(finite(aero_only_tau) eq 0)
	If (aeroind[0] ne -1) then aero_only_tau[aeroind]=0.0
   	Taero_only_tau=Taero_only_tau+aero_only_tau*aero_only_numh

	; to calculate average AOD	
	aeroind=where(finite(aero_cld_tau) eq 0)
        temp_aerocld_tau=Dblarr(dimx,dimy,6)

	If(aeroind[0] ne -1) then aero_cld_tau[aeroind]=0.0
		temp_aerocld_tau[*,*,0]=aero_cld_tau[*,*,0]*aeroicenumh
		temp_aerocld_tau[*,*,1]=aero_cld_tau[*,*,1]*aerouncernumh
		temp_aerocld_tau[*,*,2]=aero_cld_tau[*,*,2]*aerowatnumh
		temp_aerocld_tau[*,*,3]=aero_cld_tau[*,*,3]*aeroicewatnumh
		temp_aerocld_tau[*,*,4]=aero_cld_tau[*,*,4]*aeroiceuncernumh
		temp_aerocld_tau[*,*,5]=aero_cld_tau[*,*,5]*aerowatuncernumh

   	Taero_cld_tau = Taero_cld_tau + temp_aerocld_tau
   	;Tlowconfnumv[*,*,*,ind]= Tlowconfnumv[*,*,*,ind] + aerolowconfnumv
	EndIf ; endif aeroflag=1

	EndIF ; end if filename length = 94	
   endfor
 
   indlat=where(lat ge minlat and lat le maxlat)
   lat1=lat[indlat]
   Tobsnumh_1=Tobsnumh[*,indlat]
   Ticenumh_1=Ticenumh[*,indlat]
   Twatnumh_1=Twatnumh[*,indlat]
   Tuncernumh_1=Tuncernumh[*,indlat]
   Ticewatnumh_1=Ticewatnumh[*,indlat]
   Ticeuncernumh_1=Ticeuncernumh[*,indlat]
   Twatuncernumh_1=Twatuncernumh[*,indlat]
   Tlowconfnumh_1=Tlowconfnumh[*,indlat]

   Taero_only_numh_1=Taero_only_numh[*,indlat]
   Taero_only_tau_1=Taero_only_tau[*,indlat]
   Taero_only_numv_1=Taero_only_numv[*,indlat,*]
   Taero_cld_tau_1=Taero_cld_tau[*,indlat,*] 

   Taero_gene_numh_1=Taero_gene_numh[*,indlat]
   Taero_gene_numv_1=Taero_gene_numv[*,indlat,*]


   Tobsnumv_1=Tobsnumv[*,indlat,*]
   Ticenumv_1=Ticenumv[*,indlat,*]
   Twatnumv_1=Twatnumv[*,indlat,*]
   Tuncernumv_1=Tuncernumv[*,indlat,*]
   Ticewatnumv_1=Ticewatnumv[*,indlat,*]
   Ticeuncernumv_1=Ticeuncernumv[*,indlat,*]
   Twatuncernumv_1=Twatuncernumv[*,indlat,*]
   Tlowconfnumv_1=Tlowconfnumv[*,indlat,*]

   indlon=where(lon ge minlon and lon le maxlon)
   lon1=lon[indlon]
   Tobsnumh_2=Tobsnumh_1[indlon,*]
   Ticenumh_2=Ticenumh_1[indlon,*]
   Twatnumh_2=Twatnumh_1[indlon,*]
   Tuncernumh_2=Tuncernumh_1[indlon,*]
   Ticewatnumh_2=Ticewatnumh_1[indlon,*]
   Ticeuncernumh_2=Ticeuncernumh_1[indlon,*]
   Twatuncernumh_2=Twatuncernumh_1[indlon,*]
   Tlowconfnumh_2=Tlowconfnumh_1[indlon,*]

   Tobsnumv_2=Tobsnumv_1[indlon,*,*]
   Ticenumv_2=Ticenumv_1[indlon,*,*]
   Twatnumv_2=Twatnumv_1[indlon,*,*]
   Tuncernumv_2=Tuncernumv_1[indlon,*,*]
   Ticewatnumv_2=Ticewatnumv_1[indlon,*,*]
   Ticeuncernumv_2=Ticeuncernumv_1[indlon,*,*]
   Twatuncernumv_2=Twatuncernumv_1[indlon,*,*]
   Tlowconfnumv_2=Tlowconfnumv_1[indlon,*,*]


   Taero_gene_numh_2=Taero_gene_numh_1[indlon,*]
   Taero_gene_numv_2=Taero_gene_numv_1[indlon,*,*]

   Taero_only_numh_2=Taero_only_numh_1[indlon,*]
   Taero_only_tau_2=Taero_only_tau_1[indlon,*]
   Taero_only_numv_2=Taero_only_numv_1[indlon,*,*]
   Taero_cld_tau_2=Taero_cld_tau_1[indlon,*,*] 

   ave_aero_only_tau=Taero_only_tau_2/Taero_only_numh_2  
   ave_aero_cld_tau=fltarr(n_elements(indlon),n_elements(indlat),6,6)
   ave_aero_cld_tau[*,*,0]=reform(Taero_cld_tau_2[*,*,0])/Ticenumh_2
   ave_aero_cld_tau[*,*,1]=reform(Taero_cld_tau_2[*,*,1])/Tuncernumh_2
   ave_aero_cld_tau[*,*,2]=reform(Taero_cld_tau_2[*,*,2])/Twatnumh_2
   ave_aero_cld_tau[*,*,3]=reform(Taero_cld_tau_2[*,*,3])/Ticewatnumh_2
   ave_aero_cld_tau[*,*,4]=reform(Taero_cld_tau_2[*,*,4])/Ticeuncernumh_2
   ave_aero_cld_tau[*,*,5]=reform(Taero_cld_tau_2[*,*,5])/Twatuncernumh_2

   allcldnumh=Ticenumh+Twatnumh+Tuncernumh+$
	Ticewatnumh+Ticeuncernumh+Twatuncernumh
   allcldnumv=Ticenumv_2+Twatnumv_2+Tuncernumv_2+$
	Ticewatnumv_2+Ticeuncernumv_2+Twatuncernumv_2

 ;   plot_allcld_twoseason,allcldnumh,Tobsnumh_2 ,allcldnumv,Tobsnumv_2,lat1,lon1
 ;   plot_allcld_twoseason,Tlowconfnumh_2,Tobsnumh_2 ,Tlowconfnumv_2,Tobsnumv_2,lat1,lon1
;========== aerosol only======================================
;zonal_obsnumv=total(Tobsnumv_2,1)
;zonal_obsnumv=total(zonal_obsnumv,3)
;zonal_aeronumv=total(Taero_only_numv_2,1)
;zonal_aeronumv=total(zonal_aeronumv,3)

dimx=n_elements(lon1)
dimy=n_elements(lat1)
dimz=n_elements(height)
data=fltarr(dimx,dimy,101)

height=25-findgen(101)*0.25
aero_fre=Taero_gene_numv_2/float(Tobsnumv_2)
aero_fre=reverse(aero_fre,3)
aero_freh=(Taero_only_numh+allcldnumh)/float(Tobsnumh)

data[1,*,*]=reform(aero_fre[1,*,*])
data[5,*,*]=reform(aero_fre[5,*,*])
data[9,*,*]=reform(aero_fre[9,*,*])

;ztickv=[0,20,40,60,80]
;zname=['0','5','10','15','20']
ztickv=[0,8,16,24]
zname=['0','2','4','6']

;save,aero_fre,filename='aerosol_all_frev'+month+'.sav'

im=image(aero_freh,lon,lat,max_value=1.0,min_value=0,rgb_table=33,position=pos)
mp=map('Geographic',limit=maplimit,transparency=30,overplot=im,position=pos,font_size=fontsz)
grid=mp.MAPGRID
grid.label_position=0
grid.linestyle='dotted'
mc=mapcontinents(/continents,transparency=30)

t=text(0.3,0.9,month) 
ct=colorbar(target=im,title='Aerosol Frequency',taper=1,border=1,$
	orientation=1,position=barpos,font_size=fontsz)
im.save,'aerosol_freqeuncy_'+month+'.png'

aero_tau=(Taero_only_tau+total(Taero_cld_tau,3))/(Taero_only_numh+allcldnumh)
im1=image(aero_tau,lon,lat,max_value=1.0,min_value=0,rgb_table=33,position=pos)
mp1=map('Geographic',limit=maplimit,transparency=30,overplot=im1,position=pos,font_size=fontsz)
grid=mp1.MAPGRID
grid.label_position=0
grid.linestyle='dotted'
mc=mapcontinents(/continents,transparency=30)

ct=colorbar(target=im1,title='AOD',taper=1,border=1,$
	orientation=1,position=barpos,font_size=fontsz)
t=text(0.3,0.9,month) 
im1.save,'aerosol_aod_'+month+'.png'

stop
;save,zonal_obsnumv,filename=aerocldflag+'_zonal_obsnumv.sav'
;save,zonal_aeronumv,filename=aerocldflag+'_zonal_aeroonly_numv.sav'
;ave_aeroonly_tau=total(Taero_only_tau_2,3)/total(Taero_only_numh_2,3)
;save,ave_aeroonly_tau,filename=aerocldflag+'_ave_aeroonly_tau.sav'

;hor_obsnumh=total(Tobsnumh_2,3)
;save,hor_obsnumh,filename=aerocldflag+'_hor_obsnumh.sav'
;aeroonly_numh=total(Taero_only_numh_2,3)
;save,aeroonly_numh,filename=aerocldflag+'_aeroonly_numh.sav'

; plot_aerosol_only_image,total(Tobsnumh_2,3),total(Taero_only_numh_2,3),total(Taero_only_tau_2,3)/total(Taero_only_numh_2,3),zonal_obsnumv,Zonal_aeronumv,lat1,lon1,maplimit,$
	;'aerosol_climato_nocloud.png'
; ============ aerosol with cloud overlapped ===================
;ave_allaero_cld_tau=total(total(Taero_cld_tau_2,3),3)/total((Ticenumh_2+Tuncernumh_2+Twatnumh_2+Ticewatnumh_2+Ticeuncernumh_2+Twatuncernumh_2),3)

;zonal_cldnumv=total(allcldnumv,1)
;zonal_cldnumv=total(zonal_cldnumv,3)
;save,zonal_cldnumv,filename=aerocldflag+'_zonal_aerocld_numv.sav'
;save,ave_allaero_cld_tau,filename=aerocldflag+'_ave_allaero_cld_tau.sav'
;aerocld_numh=total(allcldnumh,3)
;save,aerocld_numh,filename=aerocldflag+'_aerocld_numh.sav'

;allicenumh=total(Ticenumh_2,3)
;allwatnumh=total(Twatnumh_2,3)
;save,allicenumh,filename=aerocldflag+'_icenumh.sav'
;save,allwatnumh,filename=aerocldflag+'_watnumh.sav'
; plot_aerosol_only_image,total(Tobsnumh_2,3),total(allcldnumh,3),ave_allaero_cld_tau,zonal_obsnumv,zonal_cldnumv,lat1,lon1,maplimit,'aerosol_climato_cloud.png'

print,systime()

;  plot_hor_8p,allcldnumh,Tlowconfnumh_2,Ticenumh_2,Twatnumh_2,Tuncernumh_2,Ticewatnumh_2,Ticeuncernumh_2,$
;	Twatuncernumh_2,Tobsnumh_2,lon1,lat1,maplimit 
;   plot_ver_8p,allcldnumv,Tlowconfnumv_2,Ticenumv_2,Twatnumv_2,Tuncernumv_2,Ticewatnumv_2,Ticeuncernumv_2,$
;	Twatuncernumv_2,Tobsnumv_2,lon1,lat1    
stop

end
