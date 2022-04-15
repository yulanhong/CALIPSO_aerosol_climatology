
pro  plot_annual_aerocld_property_region

	print,systime()

	lidfname=file_search('/u/sciteam/yulanh/scratch/CALIOP/output','*.hdf')

    fnamelen=strlen(lidfname)

    ind=where(fnamelen eq 86)

    fname=lidfname[ind]

  	Nf=n_elements(fname)

    region=['global','center_atlantic','indonesia','africa','europe','india','east_asia','west_us', 'east_us'] 


    for ri=0,n_elements(region)-1 do begin

	aerocldflag=region[ri]

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


    latres=5
    lonres=6
    dimx=360/lonres
	dimy=180/latres
 
    dimh=399

    hgt=fltarr(dimh)
    hgt[0:53]=29.92-findgen(54)*0.18
    hgt[54:253]=20.2-findgen(200)*0.06
    hgt[254:398]=8.2-findgen(145)*0.06


    Taero_only_numv=Ulonarr(dimx,dimy,dimh)
    Taero_only_beta=Dblarr(dimx,dimy,dimh)
   
	Taero_incld_beta=dblarr(dimx,dimy,dimh)
	Taero_incld_numv=Ulonarr(dimx,dimy,dimh)

 	Taero_isolate_numv=Ulonarr(dimx,dimy,dimh)  
    Taero_isolate_beta=dblarr(dimx,dimy,dimh)

    Taero_cld_numv=Ulonarr(dimx,dimy,dimh)
    Taero_cld_beta=Dblarr(dimx,dimy,dimh)


    for fi=0,Nf-1 do begin

		IF (strlen(fname[fi]) eq 86) Then Begin

		read_dardar,fname[fi],'longitude',lon
		read_dardar,fname[fi],'latitude',lat

		read_dardar,fname[fi],'aero_only_backscatter_profile',aeroonly_beta
		read_dardar,fname[fi],'aero_only_numv',aero_only_numv
	    ind=where(aero_only_numv eq 0)
        aeroonly_beta[ind]=0.0
        Taero_only_numv=Taero_only_numv+aero_only_numv
        Taero_only_beta=Taero_only_beta+aeroonly_beta*aero_only_numv
	 
		
        read_dardar,fname[fi],'isolate_aero_numv_belcld',aero_isolate_numv_belcld
        read_dardar,fname[fi],'isolate_aero_backscatter_profile_belcld',aero_isolate_beta_belcld
	    ind=where(aero_isolate_numv_belcld eq 0)
		aero_isolate_beta_belcld[ind]=0.0

        read_dardar,fname[fi],'isolate_aero_numv_abvcld',aero_isolate_numv_abvcld
        read_dardar,fname[fi],'isolate_aero_backscatter_profile_abvcld',aero_isolate_beta_abvcld
        ind=where(aero_isolate_numv_abvcld eq 0)
        aero_isolate_beta_abvcld[ind]=0.0

;        Taero_isolate_numv_abvcld=Taero_isolate_numv_abvcld+total(aero_isolate_numv_abvcld,1)
;        Taero_isolate_beta_abvcld=Taero_isolate_beta_abvcld+total(aero_isolate_beta_abvcld*aero_isolate_numv_abvcld,1)
        read_dardar,fname[fi],'isolate_aero_numv_other',aero_isolate_numv_other
        read_dardar,fname[fi],'isolate_aero_backscatter_profile_other',aero_isolate_beta_other
        ind=where(aero_isolate_numv_other eq 0)
        aero_isolate_beta_other[ind]=0.0

	    Taero_isolate_numv= Taero_isolate_numv + aero_isolate_numv_abvcld + aero_isolate_numv_belcld + aero_isolate_numv_other
	    Taero_isolate_beta= Taero_isolate_beta + aero_isolate_beta_abvcld*aero_isolate_numv_abvcld + $
							 aero_isolate_beta_belcld*aero_isolate_numv_belcld + aero_isolate_beta_other*aero_isolate_numv_other
;        Taero_isolate_numv_abvcld=Taero_isolate_numv_abvcld+total(aero_isolate_numv_abvcld,1)

		
	    read_dardar,fname[fi],'incld_aero_numv_one',aero_incld_numv_one
     	read_dardar,fname[fi],'incld_aero_backscatter_profile_one',aero_incld_beta_one
     	ind=where(aero_incld_numv_one eq 0)
     	aero_incld_beta_one[ind]=0.0

     	read_dardar,fname[fi],'incld_aero_numv_belcld',aero_incld_numv_belcld
     	read_dardar,fname[fi],'incld_aero_backscatter_profile_belcld',aero_incld_beta_belcld
     	ind=where(aero_incld_numv_belcld eq 0)
     	aero_incld_beta_belcld[ind]=0.0

     	read_dardar,fname[fi],'incld_aero_numv_abvcld',aero_incld_numv_abvcld
     	read_dardar,fname[fi],'incld_aero_backscatter_profile_abvcld',aero_incld_beta_abvcld
     	ind=where(aero_incld_numv_abvcld eq 0)
     	aero_incld_beta_abvcld[ind]=0.0

     	read_dardar,fname[fi],'incld_aero_numv_other',aero_incld_numv_other
     	read_dardar,fname[fi],'incld_aero_backscatter_profile_other',aero_incld_beta_other
     	ind=where(aero_incld_numv_other eq 0)
     	aero_incld_beta_other[ind]=0.0


		Taero_incld_numv = Taero_incld_numv + aero_incld_numv_one + aero_incld_numv_belcld +$
					aero_incld_numv_abvcld + aero_incld_numv_other

		Taero_incld_beta = Taero_incld_beta + aero_incld_beta_one*aero_incld_numv_one + $
							aero_incld_beta_belcld*aero_incld_Numv_belcld + $
						 	aero_incld_beta_abvcld*aero_incld_numv_abvcld + $
							aero_incld_beta_other*aero_incld_Numv_other
		EndIf
	endfor

	;===========================================================
	lonind=where(lon ge maplimit[1] and lon le maplimit[3])
	Taero_only_numv_1 = Taero_only_numv[lonind,*,*]
	Taero_only_beta_1 = Taero_only_beta[lonind,*,*]
	Taero_isolate_numv_1 = Taero_isolate_numv[lonind,*,*]
	Taero_isolate_beta_1 = Taero_isolate_beta[lonind,*,*]
	Taero_incld_numv_1 = Taero_incld_numv[lonind,*,*]
	Taero_incld_beta_1 = taero_incld_beta[lonind,*,*]

	latind=where(lat ge maplimit[0] and lat le maplimit[2])
	Taero_only_numv_2 = Taero_only_numv_1[*,latind,*]
	Taero_only_beta_2 = Taero_only_beta_1[*,latind,*]
	Taero_isolate_numv_2 = Taero_isolate_numv_1[*,latind,*]
	Taero_isolate_beta_2 = Taero_isolate_beta_1[*,latind,*]
	Taero_incld_numv_2 = Taero_incld_numv_1[*,latind,*]
	Taero_incld_beta_2 = taero_incld_beta_1[*,latind,*]


	aveaero_only_beta = total(total(Taero_only_beta_2,1),1)/total(total(Taero_only_numv_2,1),1)
    aveaero_isolate_beta = total(total(Taero_isolate_beta_2,1),1)/total(total(Taero_isolate_numv_2,1),1)
	aveaero_incld_beta = total(total(Taero_incld_beta_2,1),1)/total(total(Taero_incld_numv_2,1),1)
	aveaero_cld_beta = total(total(Taero_isolate_beta_2+Taero_incld_beta_2,1),1)/total(total(Taero_incld_numv_2+Taero_isolate_numv_2,1),1)

    save,aveaero_only_beta,aveaero_isolate_beta,aveaero_incld_beta,aveaero_cld_beta,hgt,filename=aerocldflag+'_beta_profile.sav'

	endfor; end regions
	print,systime()
 stop
end
