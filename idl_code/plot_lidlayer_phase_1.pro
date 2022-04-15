; to get seasonal average

pro plot_lidlayer_phase_1

print,systime()

aero_flag=0
;aerocldflag='global_withaerosol'
aerocldflag='global_noaerosol'
lonres=5
latres=2
dimx=360/lonres
dimy=180/latres
dimh=101 

;   minlat=-10
;   maxlat=35
;   minlon=60
;   maxlon=135	
 minlat=-90
 maxlat=90
 minlon=-180
 maxlon=180	
 maplimit=[minlat,minlon,maxlat,maxlon]

For mi=0,3 Do Begin
  
   if mi eq 0 then begin
   lidfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*03.hdf')
   lidfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*04.hdf')
   lidfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*05.hdf')
   seaflag='MAM'
   endif
   if mi eq 1 then begin
   lidfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*06.hdf')
   lidfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*07.hdf')
   lidfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*08.hdf')
   seaflag='JJA'
   endif
   if mi eq 2 then begin
   lidfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*09.hdf')
   lidfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*10.hdf')
   lidfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*11.hdf')
   seaflag='SON'
   endif
   if mi eq 3 then begin
   lidfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*12.hdf')
   lidfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*01.hdf')
   lidfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*02.hdf')
   seaflag='DJF'
   endif

   lidfname=[lidfname1,lidfname2,lidfname3]

   Nf=n_elements(lidfname)

   Tobsnumh=Ulonarr(dimx,dimy)
   Ticenumh=Ulonarr(dimx,dimy)
   Twatnumh=Ulonarr(dimx,dimy)
   Tuncernumh=Ulonarr(dimx,dimy)
   Ticewatnumh=Ulonarr(dimx,dimy)
   Ticeuncernumh=Ulonarr(dimx,dimy)
   Twatuncernumh=Ulonarr(dimx,dimy)
   Tlowconfnumh=Ulonarr(dimx,dimy)
   
   Tobsnumv=Ulonarr(dimx,dimy,dimh)
   Ticenumv=Ulonarr(dimx,dimy,dimh)
   Twatnumv=Ulonarr(dimx,dimy,dimh)
   Tuncernumv=Ulonarr(dimx,dimy,dimh)
   Ticewatnumv=Ulonarr(dimx,dimy,dimh)
   Ticeuncernumv=Ulonarr(dimx,dimy,dimh)
   Twatuncernumv=Ulonarr(dimx,dimy,dimh)
   Tlowconfnumv=Ulonarr(dimx,dimy,dimh)

   Taero_only_numh=Ulonarr(dimx,dimy)
   Taero_only_numv=Ulonarr(dimx,dimy,dimh)
   Taero_only_tau=Dblarr(dimx,dimy)
   Taero_cld_tau=Dblarr(dimx,dimy,6) 
   temp_aerocld_tau=Dblarr(dimx,dimy,6)

   for i=0,Nf-1 do begin
	fname=lidfname[i]
	mon=strsplit(fname,'_',/ext)
	mon=strmid(mon[5],4,2)
	monind=fix(mon)
	
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

   	Taero_only_numh = Taero_only_numh+ aero_only_numh
   	Taero_only_numv = Taero_only_numv + aero_only_numv
	aeroind=where(finite(aero_only_tau) eq 0)
	If (aeroind[0] ne -1) then aero_only_tau[aeroind]=0.0
   	Taero_only_tau=Taero_only_tau+aero_only_tau*aero_only_numh
	
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
	EndIf ; endif aeroflag=1
	
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

   Taero_only_numh_2=Taero_only_numh_1[indlon,*]
   Taero_only_tau_2=Taero_only_tau_1[indlon,*]
   Taero_only_numv_2=Taero_only_numv_1[indlon,*,*]
   Taero_cld_tau_2=Taero_cld_tau_1[indlon,*,*] 

   ave_aero_only_tau=Taero_only_tau_2/Taero_only_numh_2  
   ave_aero_cld_tau=fltarr(n_elements(indlon),n_elements(indlat),6)
   ave_aero_cld_tau[*,*,0]=reform(Taero_cld_tau_2[*,*,0])/Ticenumh_2
   ave_aero_cld_tau[*,*,1]=reform(Taero_cld_tau_2[*,*,1])/Tuncernumh_2
   ave_aero_cld_tau[*,*,2]=reform(Taero_cld_tau_2[*,*,2])/Twatnumh_2
   ave_aero_cld_tau[*,*,3]=reform(Taero_cld_tau_2[*,*,3])/Ticewatnumh_2
   ave_aero_cld_tau[*,*,4]=reform(Taero_cld_tau_2[*,*,4])/Ticeuncernumh_2
   ave_aero_cld_tau[*,*,5]=reform(Taero_cld_tau_2[*,*,5])/Twatuncernumh_2

   allcldnumh=Ticenumh_2+Twatnumh_2+Tuncernumh_2+$
	Ticewatnumh_2+Ticeuncernumh_2+Twatuncernumh_2
   allcldnumv=Ticenumv_2+Twatnumv_2+Tuncernumv_2+$
	Ticewatnumv_2+Ticeuncernumv_2+Twatuncernumv_2

 ;   plot_allcld_twoseason,Tlowconfnumh_2,Tobsnumh_2 ,Tlowconfnumv_2,Tobsnumv_2,lat1,lon1
;========== aerosol only======================================

ave_aeroonly_tau=Taero_only_tau_2/Taero_only_numh_2
save,ave_aeroonly_tau,filename=aerocldflag+seaflag+'_ave_aeroonly_tau.sav'

aeroonly_freh=Taero_only_numh_2/float(Tobsnumh_2)
save,aeroonly_freh,filename=aerocldflag+seaflag+'_aeroonly_freh.sav'

; ============ aerosol with cloud overlapped ===================
ave_allaero_cld_tau=total(Taero_cld_tau_2,3)/allcldnumh
save,ave_allaero_cld_tau,filename=aerocldflag+seaflag+'_ave_aerocld_tau.sav'

aerocld_freh=allcldnumh/float(Tobsnumh_2)
save,aerocld_freh,filename=aerocldflag+seaflag+'_aerocld_freh.sav'

Endfor ; end season

print,systime()

; plot_hor_8p,allcldnumh,Tlowconfnumh_2,Ticenumh_2,Twatnumh_2,Tuncernumh_2,Ticewatnumh_2,Ticeuncernumh_2,$
;	Twatuncernumh_2,Tobsnumh_2,lon1,lat1,maplimit 
; plot_ver_8p,allcldnumv,Tlowconfnumv_2,Ticenumv_2,Twatnumv_2,Tuncernumv_2,Ticewatnumv_2,Ticeuncernumv_2,$
;	Twatuncernumv_2,Tobsnumv_2,lon1,lat1    

end
