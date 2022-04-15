
pro lidlayer_phase_timeseries
print,systime()

;   lidfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/','*.hdf')
;   lidfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1','*2006*')
	lidfname=file_search('/u/sciteam/yulanh/scratch/CALIOP/output','*.hdf')
    fnamelen=strlen(lidfname)

    ind=where(fnamelen eq 86)
    lidfname_1=lidfname[ind]

   Nf=n_elements(lidfname_1)
   Nmon=Nf ;5-10
   month=intarr(Nmon)
   wyear=dblarr(Nmon)
   
	aero_flag=1 ;0--calculate cloud number without aerosol, 1- add number with aerosol
 ;  aerocldflag='midchina'   
	aerocldflag='amazon'

   latres=2
   lonres=5
   dimx=360/lonres
   dimy=180/latres
   dimh=101 

;   minlat=-10
;   maxlat=35
;   minlon=60
;   maxlon=135
;  global [-90,-180,90,180]	
;  philipine region [-10,105,20,130]
; east asia [30,110,45,125]
; westafrica [-15,0,0,20]
; india [10,75,23,90]
; amazon[-20,-65,0,-45]
; Borneo[-3,105,2,115]
; South Phillipine[5,120,9,130]
; in a target domain SouthEastSea [0,110,20,130]
; midchina [35,105,42,112]
; nwindia [20,70,30,80]
   minlat=-20
   maxlat=0
   minlon=-65
   maxlon=-45

   maplimit=[minlat,minlon,maxlat,maxlon]

   Tobsnumh=Ulonarr(dimx,dimy,Nmon)
   Ticenumh=Ulonarr(dimx,dimy,Nmon)
   Twatnumh=Ulonarr(dimx,dimy,Nmon)
   Tuncernumh=Ulonarr(dimx,dimy,Nmon)
   Ticewatnumh=Ulonarr(dimx,dimy,Nmon)
   Ticeuncernumh=Ulonarr(dimx,dimy,Nmon)
   Twatuncernumh=Ulonarr(dimx,dimy,Nmon)
   Tlowconfnumh=Ulonarr(dimx,dimy,Nmon)

   Taero_only_numh=Ulonarr(dimx,dimy,Nmon)
   Taero_all_tau=Dblarr(dimx,dimy,Nmon)
   Taero_only_tau=Dblarr(dimx,dimy,Nmon)
   Taero_cld_tau=Dblarr(dimx,dimy,6,Nmon) 
   temp_aerocld_tau=Dblarr(dimx,dimy,6)
    
   for i=0,Nf-1 do begin
	fname=lidfname_1[i]
	year=strmid(fname,9,4,/rev)

	IF (strlen(fname) eq 86 and year ne '2006') Then Begin; and year ne '2017') Then Begin

 	print,fname

	mon=strmid(fname,5,2,/rev)
	monind=fix(mon)
	month[i]=monind
	wyear[i]= fix(year)

	read_dardar,fname,'latitude',lat 
	read_dardar,fname,'longitude',lon
	;read_dardar,fname,'height',hgt

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
	read_dardar,fname,'aerosol_cloud_tau',aero_cld_tau
	read_dardar,fname,'aerosol_only_numh',aero_only_numh
	read_dardar,fname,'aerosol_only_tau',aero_only_tau
		
	ind=i
	;print,monind,ind,i

	IF (aero_flag eq 0) then begin

   	Tobsnumh[*,*,ind]=Tobsnumh[*,*,ind]+obsnumh
  	Ticenumh[*,*,ind]=Ticenumh[*,*,ind]+icenumh
   	Twatnumh[*,*,ind]=Twatnumh[*,*,ind]+watnumh
   	Tuncernumh[*,*,ind]=Tuncernumh[*,*,ind]+uncernumh
   	Ticewatnumh[*,*,ind]=Ticewatnumh[*,*,ind]+icewatnumh
   	Ticeuncernumh[*,*,ind]=Ticeuncernumh[*,*,ind]+iceuncernumh
   	Twatuncernumh[*,*,ind]=Twatuncernumh[*,*,ind]+watuncernumh
   	Tlowconfnumh[*,*,ind]= Tlowconfnumh[*,*,ind] + lowconfnumh

	EndIf

	IF (aero_flag eq 1) then begin

   	Tobsnumh[*,*,ind]=Tobsnumh[*,*,ind]+obsnumh
  	Ticenumh[*,*,ind]=Ticenumh[*,*,ind]+aeroicenumh
   	Twatnumh[*,*,ind]=Twatnumh[*,*,ind]+aerowatnumh
   	Tuncernumh[*,*,ind]=Tuncernumh[*,*,ind]+aerouncernumh
   	Ticewatnumh[*,*,ind]=Ticewatnumh[*,*,ind]+aeroicewatnumh
   	Ticeuncernumh[*,*,ind]=Ticeuncernumh[*,*,ind]+aeroiceuncernumh
   	Twatuncernumh[*,*,ind]=Twatuncernumh[*,*,ind]+aerowatuncernumh

   	Taero_only_numh[*,*,ind] = Taero_only_numh[*,*,ind]+ aero_only_numh
	aeroind=where(finite(aero_only_tau) eq 0)
	If (aeroind[0] ne -1) then aero_only_tau[aeroind]=0.0
   	Taero_only_tau[*,*,ind]=Taero_only_tau[*,*,ind]+aero_only_tau*aero_only_numh
	
	aeroind=where(finite(aero_cld_tau) eq 0)
        temp_aerocld_tau=Dblarr(dimx,dimy,6)
	If(aeroind[0] ne -1) then aero_cld_tau[aeroind]=0.0
		temp_aerocld_tau[*,*,0]=aero_cld_tau[*,*,0]*aeroicenumh
		temp_aerocld_tau[*,*,1]=aero_cld_tau[*,*,1]*aerouncernumh
		temp_aerocld_tau[*,*,2]=aero_cld_tau[*,*,2]*aerowatnumh
		temp_aerocld_tau[*,*,3]=aero_cld_tau[*,*,3]*aeroicewatnumh
		temp_aerocld_tau[*,*,4]=aero_cld_tau[*,*,4]*aeroiceuncernumh
		temp_aerocld_tau[*,*,5]=aero_cld_tau[*,*,5]*aerowatuncernumh

   	Taero_cld_tau[*,*,*,ind]= Taero_cld_tau[*,*,*,ind]+ temp_aerocld_tau
   	;Tlowconfnumv[*,*,*,ind]= Tlowconfnumv[*,*,*,ind] + aerolowconfnumv

	;for all aerosols 
	Taero_all_tau[*,*,ind]=Taero_all_tau[*,*,ind]+aero_only_tau*aero_only_numh+total(temp_aerocld_tau,3)
	
	EndIf ; endif aeroflag=1

	EndIf; endif strlen(fname)	
   endfor
 
   indlat=where(lat ge minlat and lat le maxlat)
   lat1=lat[indlat]
   Tobsnumh_1=Tobsnumh[*,indlat,*]
   Ticenumh_1=Ticenumh[*,indlat,*]
   Twatnumh_1=Twatnumh[*,indlat,*]
   Tuncernumh_1=Tuncernumh[*,indlat,*]
   Ticewatnumh_1=Ticewatnumh[*,indlat,*]
   Ticeuncernumh_1=Ticeuncernumh[*,indlat,*]
   Twatuncernumh_1=Twatuncernumh[*,indlat,*]
   Tlowconfnumh_1=Tlowconfnumh[*,indlat,*]

   Taero_all_tau_1=Taero_all_tau[*,indlat,*]
   Taero_only_numh_1=Taero_only_numh[*,indlat,*]
   Taero_only_tau_1=Taero_only_tau[*,indlat,*]
   Taero_cld_tau_1=Taero_cld_tau[*,indlat,*,*] 

   indlon=where(lon ge minlon and lon le maxlon)
   lon1=lon[indlon]
   Tobsnumh_2=Tobsnumh_1[indlon,*,*]
   Ticenumh_2=Ticenumh_1[indlon,*,*]
   Twatnumh_2=Twatnumh_1[indlon,*,*]
   Tuncernumh_2=Tuncernumh_1[indlon,*,*]
   Ticewatnumh_2=Ticewatnumh_1[indlon,*,*]
   Ticeuncernumh_2=Ticeuncernumh_1[indlon,*,*]
   Twatuncernumh_2=Twatuncernumh_1[indlon,*,*]
   Tlowconfnumh_2=Tlowconfnumh_1[indlon,*,*]

   Taero_all_tau_2=Taero_all_tau_1[indlon,*,*]
   Taero_only_numh_2=Taero_only_numh_1[indlon,*,*]
   Taero_only_tau_2=Taero_only_tau_1[indlon,*,*]
   Taero_cld_tau_2=Taero_cld_tau_1[indlon,*,*,*] 

   ;========== average to get time series
   mind=where(month gt 0, count)
   aero_all_tau_series=fltarr(count) 
   aero_all_fre_series=fltarr(count) 
   aero_only_tau_series=fltarr(count)
   aero_only_fre_series=fltarr(count)
   aero_cld_tau_series=fltarr(count,7)
   aero_cld_fre_series=fltarr(count,7)
   aero_allcld_tau_series=fltarr(count)
   aero_allcld_fre_series=fltarr(count)

   month=month[mind]
   wyear=wyear[mind]

   Tobsnumh_3=total(Tobsnumh_2,1)
   Taero_only_tau_3=total(Taero_only_tau_2,1)
   Taero_only_numh_3=total(Taero_only_numh_2,1) 
   Taero_all_tau_3=total(Taero_all_tau_2,1)
   Taero_cld_tau_3=total(Taero_cld_tau_2,1)
   Taero_cld_tau_all=total(Taero_cld_tau_3,2)
   Ticenumh_3=total(Ticenumh_2,1)
   Tuncernumh_3=total(Tuncernumh_2,1)
   Twatnumh_3=total(Twatnumh_2,1)
   Ticewatnumh_3=total(Ticewatnumh_2,1)
   Ticeuncernumh_3=total(Ticeuncernumh_2,1)
   Twatuncernumh_3=total(Twatuncernumh_2,1)

   allcldnumh=Ticenumh_2+Twatnumh_2+Tuncernumh_2+$
	Ticewatnumh_2+Ticeuncernumh_2+Twatuncernumh_2
   Tallcldnumh=total(allcldnumh,1)

   latarg=lat1*!pi/180.
   latwgt=1;cos(latarg)
   ; to gain the mean by weighting cos(lat)
   for si=0 ,count-1 do begin
	i=mind[si]
	aero_only_tau_series[si]=total(Taero_only_tau_3[*,i]*latwgt)/total(Taero_only_numh_3[*,i]*latwgt)
	aero_only_fre_series[si]=total(Taero_only_numh_3[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_cld_tau_series[si,0]=total(Taero_cld_tau_all[*,i]*latwgt)/total(Tallcldnumh[*,i]*latwgt)
	aero_cld_tau_series[si,1]=total(reform(Taero_cld_tau_3[*,0,i])*latwgt)/total(Ticenumh_3[*,i]*latwgt)
	aero_cld_tau_series[si,2]=total(reform(Taero_cld_tau_3[*,1,i])*latwgt)/total(Tuncernumh_3[*,i]*latwgt)
	aero_cld_tau_series[si,3]=total(reform(Taero_cld_tau_3[*,2,i])*latwgt)/total(Twatnumh_3[*,i]*latwgt)
	aero_cld_tau_series[si,4]=total(reform(Taero_cld_tau_3[*,3,i])*latwgt)/total(Ticewatnumh_3[*,i]*latwgt)
	aero_cld_tau_series[si,5]=total(reform(Taero_cld_tau_3[*,4,i])*latwgt)/total(Ticeuncernumh_3[*,i]*latwgt)
	aero_cld_tau_series[si,6]=total(reform(Taero_cld_tau_3[*,5,i])*latwgt)/total(Twatuncernumh_3[*,i]*latwgt)
        
	aero_cld_fre_series[si,0]=total(Tallcldnumh[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_cld_fre_series[si,1]=total(Ticenumh_3[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_cld_fre_series[si,2]=total(Tuncernumh_3[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_cld_fre_series[si,3]=total(Twatnumh_3[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_cld_fre_series[si,4]=total(Ticewatnumh_3[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_cld_fre_series[si,5]=total(Ticeuncernumh_3[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_cld_fre_series[si,6]=total(Twatuncernumh_3[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
 
	aero_all_tau_series[si]=total(Taero_all_tau_3[*,i]*latwgt)/(total(Taero_only_numh_3[*,i]*latwgt)+total(Tallcldnumh[*,i]*latwgt))
	aero_all_fre_series[si]=(total(Taero_only_numh_3[*,i]*latwgt)+total(Tallcldnumh[*,i]*latwgt))/total(Tobsnumh_3[*,i]*latwgt)
  
    Taero_allcld_tau_3 = total(Taero_cld_tau_3,2) 
    aero_allcld_tau_series[si]=total(Taero_allcld_tau_3[*,i]*latwgt)/total(Tallcldnumh[*,i]*latwgt)
    aero_allcld_fre_series[si]=total(Tallcldnumh[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)

  endfor

   openw,u,aerocldflag+'_aerosol_fre_aod.txt',/get_lun
   
   for fi=0,n_elements(month)-1 do begin
		printf,u,wyear[fi],month[fi],aero_only_tau_series[fi],aero_only_fre_series[fi],$
			aero_allcld_tau_series[fi],aero_allcld_fre_series[fi],aero_all_tau_series[fi],$
			aero_all_fre_series[fi],format='(i4,i2,6(2x,f8.5))'
   endfor

   free_lun,u
   save,aero_all_tau_series,filename=aerocldflag+'_aero_allsky_tau_series.sav'
   save,aero_all_fre_series,filename=aerocldflag+'_aero_allsky_fre_series.sav'
   save,aero_only_tau_series,filename=aerocldflag+'_aero_only_tau_series.sav'
   save,aero_only_fre_series,filename=aerocldflag+'_aero_only_fre_series.sav'
   save,aero_cld_tau_series,filename=aerocldflag+'_aero_cld_tau_series.sav'
   save,aero_cld_fre_series,filename=aerocldflag+'_aero_cld_fre_series.sav'
   save,month,filename='time.sav'
print,systime()

stop
end
