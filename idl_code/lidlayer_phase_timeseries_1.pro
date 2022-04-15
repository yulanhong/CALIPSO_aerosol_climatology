; to calcuate the time series 
; to calculate the mean aod, frequency for each cloud group
pro lidlayer_phase_timeseries_1

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
   
 ;  aerocldflag='midchina'   
;	aerocldflag='africa';'center_atlantic';'indonesia';'africa';'europe';'india';'east_asia';'global' west_us, east_us, global
	region=['global','west_us','east_us','center_atlantic','africa','europe','india','east_asia','indonesia','amazon']

    for ri=0,n_elements(region)-1 do begin
	aerocldflag=region[ri]

   latres=5
   lonres=6
   dimx=360/lonres
   dimy=180/latres
   dimh=101 

;   minlat=-10
;   maxlat=35
;   minlon=60
;   maxlon=135
;  global [-90,-180,90,180]	
; east asia [20,105,40,120]
; india [10,70,25,85]
; europe [44,-10,55,30]
; africa [-15,5,0,30]
; east_us [25,-90, 45, -75]
; west_us [30,-125,45,-80]
; indonesia [-10,95,10,150]
; center atlantic [5,-45,25,-18]
; Borneo[-3,105,2,115]
; South Phillipine[5,120,9,130]
; in a target domain SouthEastSea [0,110,20,130]
; midchina [35,105,42,112]
; nwindia [20,70,30,80]

   if aerocldflag eq 'amazon' then begin
   minlat=-20
   maxlat=0
   minlon=-65
   maxlon=-45
   endif



   if aerocldflag eq 'center_atlantic' then begin
   minlat=5
   maxlat=25
   minlon=-45
   maxlon=-18
   endif


   if aerocldflag eq 'indonesia' then begin
   minlat=-10
   maxlat=10
   minlon=95
   maxlon=150
   endif

   if aerocldflag eq 'africa' then begin
   minlat=-20
   maxlat=-5
   minlon=-5
   maxlon=20
   endif

   if aerocldflag eq 'europe' then begin
   minlat=44
   maxlat=55
   minlon=-10
   maxlon=30
   endif

   if aerocldflag eq 'india' then begin
   minlat=10
   maxlat=25
   minlon=70
   maxlon=85
   endif

   if aerocldflag eq 'east_asia' then begin
   minlat=20
   maxlat=40
   minlon=105
   maxlon=120
   endif

   if aerocldflag eq 'west_us' then begin
   minlat=30
   maxlat=45
   minlon=-140
   maxlon=-125
   endif

   if aerocldflag eq 'east_us' then begin
   minlat=25
   maxlat=45
   minlon=-90
   maxlon=-75
   endif

   if aerocldflag eq 'global' then begin
   minlat=-90
   maxlat=90
   minlon=-180
   maxlon=180
   endif

   maplimit=[minlat,minlon,maxlat,maxlon]

   Tobsnumh=Ulonarr(dimx,dimy,Nmon)

   Taero_only_numh=Ulonarr(dimx,dimy,Nmon)
   Taero_all_tau=Dblarr(dimx,dimy,Nmon)
   Taero_only_tau=Dblarr(dimx,dimy,Nmon)
   Taero_only_tauerr=Dblarr(dimx,dimy,Nmon)
   Taero_cld_tau=Dblarr(dimx,dimy,Nmon) 
   Taero_cld_tauerr=Dblarr(dimx,dimy,Nmon) 
    
   Taero_incld_numh=Ulonarr(dimx,dimy,Nmon,6)
   Taero_isolate_numh=Ulonarr(dimx,dimy,Nmon,9)

   Taero_incld_tau=Dblarr(dimx,dimy,Nmon,6)
   Taero_isolate_tau=Dblarr(dimx,dimy,Nmon,9)

   Taero_incld_tauerr=Dblarr(dimx,dimy,Nmon,6)
   Taero_isolate_tauerr=Dblarr(dimx,dimy,Nmon,9)
   
   Tfilter_all=Ulonarr(dimx,dimy,Nmon)


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

	read_dardar,fname,'obs_numh',obsnumh
	read_dardar,fname,'all_filter',all_filter
;    if year eq '2013' then im=image(obsnumh,rgb_table=33,min_value=20,max_value=1500,title=string(i))

	read_dardar,fname,'aero_only_tau',aero_only_tau
	read_dardar,fname,'aero_only_numh',aero_only_numh
	read_dardar,fname,'aero_onlytau_uncer',aero_only_tauerr
	ind=where(aero_only_numh eq 0)
	if ind[0] ne 0 then begin
		aero_only_tau[ind]=0.0
		aero_only_tauerr[ind]=0.0
	endif

    read_dardar,fname,'incld_aero_numh',aero_incld_numh
    read_dardar,fname,'incld_aero_tau',aero_incld_tau
	read_dardar,fname,'incld_aerotau_uncer',aero_incld_tauerr
	ind=where(aero_incld_numh eq 0)
    if ind[0] ne 0 then begin
	 	aero_incld_tau[ind]=0.0
		aero_incld_tauerr[ind]=0.0
	endif

	read_dardar,fname,'isolate_aero_numh',aero_isolate_numh
    read_dardar,fname,'isolate_aero_tau',aero_isolate_tau
	read_dardar,fname,'isolate_aerotau_uncer',aero_isolate_tauerr
	ind=where(aero_isolate_numh eq 0)
    if ind[0] ne 0 then begin
		aero_isolate_tau[ind]=0.0
		aero_isolate_tauerr[ind]=0.0
	endif

   	Tobsnumh[*,*,i]=Tobsnumh[*,*,i]+obsnumh
	Tfilter_all[*,*,i]=Tfilter_all[*,*,i]+all_filter

   	Taero_only_numh[*,*,i] = Taero_only_numh[*,*,i]+ aero_only_numh
	aeroind=where(finite(aero_only_tau) eq 0)
	If (aeroind[0] ne -1) then aero_only_tau[aeroind]=0.0
   	Taero_only_tau[*,*,i]=Taero_only_tau[*,*,i]+aero_only_tau*aero_only_numh

	aeroind=where(finite(aero_only_tauerr) eq 0)
	If (aeroind[0] ne -1) then aero_only_tauerr[aeroind]=0.0
   	Taero_only_tauerr[*,*,i]=Taero_only_tauerr[*,*,i]+aero_only_tauerr*aero_only_numh
	
    Taero_incld_numh[*,*,i,*]=Taero_incld_numh[*,*,i,*] + aero_incld_numh   
	aeroind=where(finite(aero_incld_tau) eq 0)
	if (aeroind[0] ne -1) then aero_incld_tau[aeroind]=0.0
	Taero_incld_tau[*,*,i,*] =Taero_incld_tau[*,*,i,*]  + aero_incld_numh*aero_incld_tau
	aeroind=where(finite(aero_incld_tauerr) eq 0)
	if (aeroind[0] ne -1) then aero_incld_tauerr[aeroind]=0.0
	Taero_incld_tauerr[*,*,i,*] =Taero_incld_tauerr[*,*,i,*]  + aero_incld_numh*aero_incld_tauerr

    Taero_isolate_numh[*,*,i,*]=Taero_isolate_numh[*,*,i,*] + aero_isolate_numh   
	aeroind=where(finite(aero_isolate_tau) eq 0)
	if (aeroind[0] ne -1) then aero_isolate_tau[aeroind]=0.0
    Taero_isolate_tau[*,*,i,*] =Taero_isolate_tau[*,*,i,*] + aero_isolate_numh*aero_isolate_tau
	aeroind=where(finite(aero_isolate_tauerr) eq 0)
	if (aeroind[0] ne -1) then aero_isolate_tauerr[aeroind]=0.0
    Taero_isolate_tauerr[*,*,i,*] =Taero_isolate_tauerr[*,*,i,*] + aero_isolate_numh*aero_isolate_tauerr

    temp_aerocld_tau=total(aero_incld_numh*aero_incld_tau,3) + total(aero_isolate_numh*aero_isolate_tau,3)
   	Taero_cld_tau[*,*,i]= Taero_cld_tau[*,*,i]+ temp_aerocld_tau
    temp_aerocld_tauerr=total(aero_incld_numh*aero_incld_tauerr,3) + total(aero_isolate_numh*aero_isolate_tauerr,3)
   	Taero_cld_tauerr[*,*,i]= Taero_cld_tauerr[*,*,i]+ temp_aerocld_tauerr

	;for all aerosols 
	Taero_all_tau[*,*,i]=Taero_all_tau[*,*,i]+aero_only_tau*aero_only_numh + temp_aerocld_tau

	EndIf; endif strlen(fname)	
   endfor
 
   indlat=where(lat ge minlat and lat le maxlat)
   lat1=lat[indlat]
   Tobsnumh_1=Tobsnumh[*,indlat,*]
   Tfilter_all_1=Tfilter_all[*,indlat,*]	

   Taero_all_tau_1=Taero_all_tau[*,indlat,*]
   Taero_only_numh_1=Taero_only_numh[*,indlat,*]
   Taero_only_tau_1=Taero_only_tau[*,indlat,*]
   Taero_only_tauerr_1=Taero_only_tauerr[*,indlat,*]
   Taero_cld_tau_1=Taero_cld_tau[*,indlat,*] 
   Taero_incld_tau_1=Taero_incld_tau[*,indlat,*,*]
   Taero_incld_tauerr_1=Taero_incld_tauerr[*,indlat,*,*]
   Taero_isolate_tau_1=Taero_isolate_tau[*,indlat,*,*]
   Taero_isolate_tauerr_1=Taero_isolate_tauerr[*,indlat,*,*]
   Taero_incld_numh_1=Taero_incld_numh[*,indlat,*,*]
   Taero_isolate_numh_1=Taero_isolate_numh[*,indlat,*,*]



   indlon=where(lon ge minlon and lon le maxlon)
   lon1=lon[indlon]
   Tobsnumh_2=Tobsnumh_1[indlon,*,*]
   Tfilter_all_2=Tfilter_all_1[indlon,*,*]

   Taero_all_tau_2=Taero_all_tau_1[indlon,*,*]
   Taero_only_numh_2=Taero_only_numh_1[indlon,*,*]
   Taero_only_tau_2=Taero_only_tau_1[indlon,*,*]
   Taero_only_tauerr_2=Taero_only_tauerr_1[indlon,*,*]
   Taero_cld_tau_2=Taero_cld_tau_1[indlon,*,*] 
   Taero_incld_tau_2=Taero_incld_tau_1[indlon,*,*,*]
   Taero_incld_tauerr_2=Taero_incld_tauerr_1[indlon,*,*,*]
   Taero_isolate_tau_2=Taero_isolate_tau_1[indlon,*,*,*]
   Taero_isolate_tauerr_2=Taero_isolate_tauerr_1[indlon,*,*,*]
   Taero_incld_numh_2=Taero_incld_numh_1[indlon,*,*,*]
   Taero_isolate_numh_2=Taero_isolate_numh_1[indlon,*,*,*]

   ;========== to get average for diffrent cloud group ====
   ;======= segregate into two seasons
  season=['warm','cold']
  for i=0,1 do begin
    if i eq 0 then ind=where(month ge 4 and month le 9)
	if i eq 1 then ind=where( month eq 1 or month eq 2 or month eq 3 or month eq 10 or month eq 11 or month eq 12)  	

   print,aerocldflag+season[i]+'_mean_aeroonly_aod,uncertain',total(Taero_only_tau_2[*,*,ind])/total(Taero_only_numh_2[*,*,ind]),$
		total(Taero_only_tauerr_2[*,*,ind])/total(Taero_only_numh_2[*,*,ind])
   print,aerocldflag+season[i]+'_mean_aeroonly_Fre',total(Taero_only_numh_2[*,*,ind])/total(Tobsnumh_2[*,*,ind]-Tfilter_all_2[*,*,ind])
   print,aerocldflag+season[i]+'_mean_mergeonly_aod,uncertain',total(Taero_incld_tau_2[*,*,ind,0])/total(Taero_incld_numh_2[*,*,ind,0]),$
		total(Taero_incld_tauerr_2[*,*,ind,0])/total(Taero_incld_numh_2[*,*,ind,0]) 
   print,aerocldflag+season[i]+'_mean_mergeonly_fre',total(Taero_incld_numh_2[*,*,ind,0])/total(Tobsnumh_2[*,*,ind]-Tfilter_all_2[*,*,ind]) 
   print,aerocldflag+season[i]+'_mean_mergebc_aod,uncertain',total(Taero_incld_tau_2[*,*,ind,1])/total(Taero_incld_numh_2[*,*,ind,1]),$
		total(Taero_incld_tauerr_2[*,*,ind,1])/total(Taero_incld_numh_2[*,*,ind,1])
   print,aerocldflag+season[i]+'_mean_mergebc_fre',total(Taero_incld_numh_2[*,*,ind,1])/total(Tobsnumh_2[*,*,ind]-Tfilter_all_2[*,*,ind]) 
   print,aerocldflag+season[i]+'_mean_mergeac_aod,uncertain',total(Taero_incld_tau_2[*,*,ind,2]+Taero_incld_tau_2[*,*,ind,3])/total(Taero_incld_numh_2[*,*,ind,2]+Taero_incld_numh_2[*,*,ind,3]),$
		total(Taero_incld_tauerr_2[*,*,ind,2]+Taero_incld_tauerr_2[*,*,ind,3])/total(Taero_incld_numh_2[*,*,ind,2]+Taero_incld_numh_2[*,*,ind,3]) 
   print,aerocldflag+season[i]+'_mean_mergeac_fre',total(Taero_incld_numh_2[*,*,ind,2]+Taero_incld_numh_2[*,*,ind,3])/total(Tobsnumh_2[*,*,ind]-Tfilter_all_2[*,*,ind]) 
   print,aerocldflag+season[i]+'_mean_mergeot_aod,uncertain',total(Taero_incld_tau_2[*,*,ind,4]+Taero_incld_tau_2[*,*,ind,5])/total(Taero_incld_numh_2[*,*,ind,4]+Taero_incld_numh_2[*,*,ind,5]),$
			total(Taero_incld_tauerr_2[*,*,ind,4]+Taero_incld_tauerr_2[*,*,ind,5])/total(Taero_incld_numh_2[*,*,ind,4]+Taero_incld_numh_2[*,*,ind,5]) 
   print,aerocldflag+season[i]+'_mean_mergeot_fre',total(Taero_incld_numh_2[*,*,ind,4]+Taero_incld_numh_2[*,*,ind,5])/total(Tobsnumh_2[*,*,ind]-Tfilter_all_2[*,*,ind]) 

   print,aerocldflag+season[i]+'_mean_isolatebc_aod,uncertain',total(Taero_isolate_tau_2[*,*,ind,0]+Taero_isolate_tau_2[*,*,ind,3]+Taero_isolate_tau_2[*,*,ind,7])/$
		total(Taero_isolate_numh_2[*,*,ind,0]+Taero_isolate_numh_2[*,*,ind,3]+Taero_isolate_numh_2[*,*,ind,7]),$
		total(Taero_isolate_tauerr_2[*,*,ind,0]+Taero_isolate_tauerr_2[*,*,ind,3]+Taero_isolate_tauerr_2[*,*,ind,7])/$
		 total(Taero_isolate_numh_2[*,*,ind,0]+Taero_isolate_numh_2[*,*,ind,3]+Taero_isolate_numh_2[*,*,ind,7])
 
	print,aerocldflag+season[i]+'_mean_isolatebc_fre',$
	total(Taero_isolate_numh_2[*,*,ind,0]+Taero_isolate_numh_2[*,*,ind,3]+Taero_isolate_numh_2[*,*,ind,7])/total(Tobsnumh_2[*,*,ind]-Tfilter_all_2[*,*,ind]) 
   print,aerocldflag+season[i]+'_mean_isolateac_aod,uncertain',total(Taero_isolate_tau_2[*,*,ind,1]+Taero_isolate_tau_2[*,*,ind,4]+Taero_isolate_tau_2[*,*,ind,6])/$
		total(Taero_isolate_numh_2[*,*,ind,1]+Taero_isolate_numh_2[*,*,ind,4]+Taero_isolate_numh_2[*,*,ind,6]),$
		total(Taero_isolate_tauerr_2[*,*,ind,1]+Taero_isolate_tauerr_2[*,*,ind,4]+Taero_isolate_tauerr_2[*,*,ind,6])/$
		total(Taero_isolate_numh_2[*,*,ind,1]+Taero_isolate_numh_2[*,*,ind,4]+Taero_isolate_numh_2[*,*,ind,6]) 

	print,aerocldflag+season[i]+'_mean_isolateac_fre',$
	total(Taero_isolate_numh_2[*,*,ind,1]+Taero_isolate_numh_2[*,*,ind,4]+Taero_isolate_numh_2[*,*,ind,6])/total(Tobsnumh_2[*,*,ind]-Tfilter_all_2[*,*,ind]) 
   print,aerocldflag+season[i]+'_mean_isolateot_aod,uncertain',total(Taero_isolate_tau_2[*,*,ind,2]+Taero_isolate_tau_2[*,*,ind,5]+Taero_isolate_tau_2[*,*,ind,8])/$
		total(Taero_isolate_numh_2[*,*,ind,2]+Taero_isolate_numh_2[*,*,ind,5]+Taero_isolate_numh_2[*,*,ind,8]),$
		total(Taero_isolate_tauerr_2[*,*,ind,2]+Taero_isolate_tauerr_2[*,*,ind,5]+Taero_isolate_tauerr_2[*,*,ind,8])/$
		total(Taero_isolate_numh_2[*,*,ind,2]+Taero_isolate_numh_2[*,*,ind,5]+Taero_isolate_numh_2[*,*,ind,8])
 
	print,aerocldflag+season[i]+'_mean_isolateot_fre',$
	total(Taero_isolate_numh_2[*,*,ind,2]+Taero_isolate_numh_2[*,*,ind,5]+Taero_isolate_numh_2[*,*,ind,8])/total(Tobsnumh_2[*,*,ind]-Tfilter_all_2[*,*,ind]) 

 endfor

   ;========== average to get time series
   mind=where(month gt 0, count)
   aero_all_tau_series=fltarr(count) 
   aero_all_fre_series=fltarr(count) 
   aero_all_fra_series=fltarr(count) 
   aero_only_tau_series=fltarr(count)
   aero_only_fre_series=fltarr(count)
   aero_only_fra_series=fltarr(count)
   aero_cld_tau_series=fltarr(count)
   aero_cld_fre_series=fltarr(count)
   aero_cld_fra_series=fltarr(count)
   aero_allcld_tau_series=fltarr(count)
   aero_allcld_fre_series=fltarr(count)
   aero_allcld_fra_series=fltarr(count)
   aero_incld_tau_series=fltarr(count)
   aero_incld_fre_series=fltarr(count)
   aero_incld_fra_series=fltarr(count)
   aero_isolate_tau_series=fltarr(count)
   aero_isolate_fre_series=fltarr(count)
   aero_isolate_fra_series=fltarr(count)

   month=month[mind]
   wyear=wyear[mind]

   Tobsnumh_3=total(Tobsnumh_2,1) - total(Tfilter_all_2,1)
   Taero_only_tau_3=total(Taero_only_tau_2,1)
   Taero_only_numh_3=total(Taero_only_numh_2,1) 
   Taero_incld_tau_3=total(total(Taero_incld_tau_2,4),1)
   Taero_incld_numh_3=total(total(Taero_incld_numh_2,4),1)
   Taero_isolate_tau_3=total(total(Taero_isolate_tau_2,4),1)
   Taero_isolate_numh_3=total(total(Taero_isolate_numh_2,4),1)  
   Taero_cld_tau_3=total(Taero_cld_tau_2,1)
   Taero_all_tau_3=total(Taero_all_tau_2,1)

   Tallaero_numh=Taero_only_numh_3+Taero_incld_numh_3+Taero_isolate_numh_3

   latarg=lat1*!pi/180.
   latwgt=1;cos(latarg)
   ; to gain the mean by weighting cos(lat)
   for si=0 ,count-1 do begin
	i=mind[si]
	aero_only_tau_series[si]=total(Taero_only_tau_3[*,i]*latwgt)/total(Taero_only_numh_3[*,i]*latwgt)
	aero_only_fre_series[si]=total(Taero_only_numh_3[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_only_fra_series[si]=total(Taero_only_numh_3[*,i]*latwgt)/total(Tallaero_numh[*,i]*latwgt)
	aero_cld_tau_series[si]=total(Taero_cld_tau_3[*,i]*latwgt)/total((Taero_incld_numh_3[*,i]+Taero_isolate_numh_3[*,i])*latwgt)
	aero_cld_fre_series[si]=total((Taero_incld_numh_3[*,i]+Taero_isolate_numh_3[*,i])*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_cld_fra_series[si]=total((Taero_incld_numh_3[*,i]+Taero_isolate_numh_3[*,i])*latwgt)/total(Tallaero_numh[*,i]*latwgt)
 
	aero_all_tau_series[si]=total(Taero_all_tau_3[*,i]*latwgt)/(total(Taero_only_numh_3[*,i]*latwgt)+total((Taero_incld_numh_3[*,i]+Taero_isolate_numh_3[*,i])*latwgt))
	aero_all_fre_series[si]=total(Taero_only_numh_3[*,i]*latwgt+ (Taero_incld_numh_3[*,i]+Taero_isolate_numh_3[*,i])*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_all_fra_series[si]=total(Taero_only_numh_3[*,i]*latwgt+ (Taero_incld_numh_3[*,i]+Taero_isolate_numh_3[*,i])*latwgt)/total(Tallaero_numh[*,i]*latwgt)
  
	aero_incld_tau_series[si]=total(Taero_incld_tau_3[*,i]*latwgt)/total(Taero_incld_numh_3[*,i]*latwgt)
	aero_incld_fre_series[si]=total(Taero_incld_numh_3[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_incld_fra_series[si]=total(Taero_incld_numh_3[*,i]*latwgt)/total(Tallaero_numh[*,i]*latwgt)

	aero_isolate_tau_series[si]=total(Taero_isolate_tau_3[*,i]*latwgt)/total(Taero_isolate_numh_3[*,i]*latwgt)
	aero_isolate_fre_series[si]=total(Taero_isolate_numh_3[*,i]*latwgt)/total(Tobsnumh_3[*,i]*latwgt)
	aero_isolate_fra_series[si]=total(Taero_isolate_numh_3[*,i]*latwgt)/total(Tallaero_numh[*,i]*latwgt)

  endfor

;   openw,u,aerocldflag+'_aerosol_fre_aod.txt',/get_lun
   
;   for fi=0,n_elements(month)-1 do begin
;		printf,u,wyear[fi],month[fi],aero_only_tau_series[fi],aero_only_fre_series[fi],$
;			aero_allcld_tau_series[fi],aero_allcld_fre_series[fi],aero_all_tau_series[fi],$
;			aero_all_fre_series[fi],format='(i4,i2,6(2x,f8.5))'
;   endfor

;   free_lun,u
   save,aero_all_tau_series,filename=aerocldflag+'_aero_allsky_tau_series.sav'
   save,aero_all_fre_series,filename=aerocldflag+'_aero_allsky_fre_series.sav'
   save,aero_all_fra_series,filename=aerocldflag+'_aero_allsky_fra_series.sav'
   save,aero_only_tau_series,filename=aerocldflag+'_aero_only_tau_series.sav'
   save,aero_only_fre_series,filename=aerocldflag+'_aero_only_fre_series.sav'
   save,aero_only_fra_series,filename=aerocldflag+'_aero_only_fra_series.sav'
   save,aero_cld_tau_series,filename=aerocldflag+'_aero_cld_tau_series.sav'
   save,aero_cld_fre_series,filename=aerocldflag+'_aero_cld_fre_series.sav'
   save,aero_cld_fra_series,filename=aerocldflag+'_aero_cld_fra_series.sav'
   save,aero_incld_tau_series,filename=aerocldflag+'_aero_incld_tau_series.sav'
   save,aero_incld_fre_series,filename=aerocldflag+'_aero_incld_fre_series.sav'
   save,aero_incld_fra_series,filename=aerocldflag+'_aero_incld_fra_series.sav'
   save,aero_isolate_tau_series,filename=aerocldflag+'_aero_isolate_tau_series.sav'
   save,aero_isolate_fre_series,filename=aerocldflag+'_aero_isolate_fre_series.sav'
   save,aero_isolate_fra_series,filename=aerocldflag+'_aero_isolate_fra_series.sav'

   save,month,filename='time.sav'

   endfor ;end region 

print,systime()

stop
end
