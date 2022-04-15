	
	module global

	implicit none

	!=========for reading calipso data===================
	integer :: NROW, NCOL

	integer(kind=1),allocatable :: CAD_Score(:,:),Opacity(:,:),dnf(:,:),&
	        IGBP_surf(:,:),res_layer(:,:)

	integer(kind=2),allocatable :: VFM(:,:),ext_lay_qc(:,:)

        real(kind=4),allocatable :: top_hgt(:,:),base_hgt(:,:),top_temp(:,:),base_temp(:,:),&
                lat(:,:),lon(:,:),aero_tau(:,:),depol_ratio(:,:),back_scatt(:,:),&
                lidar_ratio532(:,:),color_ratio(:,:),&!transT(:,:),transT_err(:,:),color_ratio(:,:),&
                !aerotau_lay_uncer(:,:),&
                aerotau_uncer(:,:),min_laser_energy(:,:)!cld_tau(:,:),cldtau_uncer(:,:)

	!======= for reading Apro data =======================
 	real(kind=4), allocatable :: back_prof(:,:) !ext_prof(:,:),ext_prof_uncer(:,:)
	!integer (kind=1), allocatable :: CAD_prof(:,:,:)
	!integer (kind=2), allocatable :: AVD_prof(:,:,:),ext_prof_qc(:,:,:)

	!======== for output=================================
	integer, parameter :: latbin_res=5,lonbin_res=6,dimx=360/lonbin_res,&
	 dimy=180/latbin_res,dimh=399,Ntau=501,Nsca=91,Ndep=21,&
	 Nincld=6, Nisolate=9,Nlidratio=70,Ncolratio=121,& !color ratio
 	 CAD_threshold=20, NCOLP=399,dimh_tp=3001,ratio_threshold=6.5 !90% of tau>=1
	real, parameter ::  gap_threshold=0.5
	 ! logtau -4,2(0.01); depratio 0-1(0.005), logscat,-5,0(0.01),lidar ratio 10-90(1)
	!==================================================
	real :: prof_alt(NCOLP)
	!==================================	
    real (kind=4), allocatable :: &
!                aero_only_beta_profile(dimx,dimy,dimh),&
                aero_only_beta_profile(:,:,:),&
                isolate_aero_beta_profile_abvcld(:,:,:),&
                isolate_aero_beta_profile_belcld(:,:,:),&
                isolate_aero_beta_profile_other(:,:,:),&
		incld_aero_beta_profile_one(:,:,:),&
                incld_aero_beta_profile_belcld(:,:,:),&
                incld_aero_beta_profile_abvcld(:,:,:),&
                incld_aero_beta_profile_other(:,:,:)

!	integer (kind=4) :: &
!			    incld_aero_pdf_beta_profile_one(dimx,dimy,dimh,Nsca),&
!                incld_aero_pdf_beta_profile_belcld(dimx,dimy,dimh,Nsca),&
!                incld_aero_pdf_beta_profile_abvcld(dimx,dimy,dimh,Nsca),&
!                incld_aero_pdf_beta_profile_other(dimx,dimy,dimh,Nsca),&
!                aero_only_pdf_beta_profile(dimx,dimy,dimh,Nsca),&
!                isolate_aero_pdf_beta_profile_abvcld(dimx,dimy,dimh,Nsca),&
!                isolate_aero_pdf_beta_profile_belcld(dimx,dimy,dimh,Nsca),&
!                isolate_aero_pdf_beta_profile_other(dimx,dimy,dimh,Nsca)
			

!        allocate(aero_only_beta_profile(dimx,dimy,dimh))
!        allocate(isolate_aero_beta_profile(dimx,dimy,dimh,Nisolate))
!        allocate(incld_aero_beta_profile(dimx,dimy,dimh,Nincld))  
        
	integer (kind=2) :: obsnumh(dimx,dimy),&
        obsnumv(dimx,dimy,dimh),&
		opaquecld_numh(dimx,dimy),&
		nocld_noaero_numh(dimx,dimy),&
		cld_noaero_numh(dimx,dimy),&
		!for aerosol and cloud overlap, both have CAD score > 50
		isolate_aero_numh(dimx,dimy,Nisolate),& ! for 1-land, 2-ocean
!		isolate_aero_numv(dimx,dimy,dimh,Nisolate),& ! for 1-land, 2-ocean
		isolate_aerotau1_numh(dimx,dimy,Nisolate),&  ! for tau > 1
		!1-cloud above aero
		!2-aero above cloud
		!3-aero inbetween cloud
		!4--multi-layer aero,onelayer cloud,cloud is above all aerosols
		!5--multi-layer aero,one layer cloud,cloud is below all aerosols
		!6--multi-layer aero,one layer cloud,cloud is inbetween aerosols
		!7--multi-layer aero and multi-layer cld,aerosol above cloud
		!8--multi-layer aero and multi-layer cld,aerosol below cloud
		!9--multi-layer aero and multi-layer cloud, others
		incld_aero_numh(dimx,dimy,Nincld),& ! 1-aerosol-cloud merge in one layer,&
!		incld_aero_numv(dimx,dimy,dimh,Nincld),& ! 1-aerosol-cloud merge in one layer,&
		incld_aerotau1_numh(dimx,dimy,Nincld),& ! for tau >1
		!1-aerosol-cloud merge in one layer
		!2- cloud layers above aero-cld, 
		!3- cloud layers below aero-cld,
		!4- clouds above and below aero-cld layer,
		!5- multiple aerosols, one merged layer, the merged-layer can be above/below aerosol layers 
		!6- multiple layers of clouds and multiple layers of aerosols 
		aero_only_numh(dimx,dimy),& ! 1-single layer, 2-multiple layers; 1-land,2-ocean
		aero_only_numv(dimx,dimy,dimh),& ! 1-single layer, 2-multiple layers; 1-land,2-ocean
		aerotau1_only_numh(dimx,dimy),&
		filtercad_num(dimx,dimy),&
!		filter_aod_num(dimx,dimy),&
		filterci_num(dimx,dimy),&
		filter_extqc_num(dimx,dimy),&
		filter_allnum(dimx,dimy) 

	integer (kind=2), allocatable:: &
		isolate_aero_numv_belcld(:,:,:),&
		isolate_aero_numv_abvcld(:,:,:),&
		isolate_aero_numv_other(:,:,:),&
		incld_aero_numv_one(:,:,:),&
		incld_aero_numv_belcld(:,:,:),&
		incld_aero_numv_abvcld(:,:,:),&
		incld_aero_numv_other(:,:,:)
	! for PDF
	integer (kind=2) :: pdf_aero_only_tau(dimx,dimy,Ntau)
	integer (kind=2) :: pdf_isolate_aero_tau(dimx,dimy,Ntau,Nisolate)
	integer (kind=2), allocatable :: pdf_incld_aero_tau(:,:,:,:) !pdf_incld_aero_tau(dimx,dimy,Ntau,Nincld)

	! for 2D PDF of backscatter vs. deporalization ratio	
    integer (kind=2), allocatable :: &!aero_only_scatdep(dimx,dimy,Nsca,Ndep),&
                aero_only_scatdep(:,:,:,:),&
                isolate_aero_scatdep_abvcld(:,:,:,:),&
                isolate_aero_scatdep_belcld(:,:,:,:),&
                isolate_aero_scatdep_other(:,:,:,:),&
                incld_aero_scatdep_one(:,:,:,:),&
				incld_aero_scatdep_abvcld(:,:,:,:),&
				incld_aero_scatdep_belcld(:,:,:,:),&
				incld_aero_scatdep_other(:,:,:,:)


        integer (kind=4), allocatable :: &!aero_only_lidcol(dimx,dimy,Nlidratio,Ncolratio),&
			aero_only_lidcol(:,:,:,:),&
			incld_aero_lidcol_one(:,:,:,:),&
			incld_aero_lidcol_abvcld(:,:,:,:),&
			incld_aero_lidcol_belcld(:,:,:,:),&
			incld_aero_lidcol_other(:,:,:,:),&
			isolate_aero_lidcol_abvcld(:,:,:,:),&
			isolate_aero_lidcol_belcld(:,:,:,:),&
			isolate_aero_lidcol_other(:,:,:,:)
			

        real(kind=4) :: isolate_aero_tau(dimx,dimy,Nisolate),& ! for aerosol properties, for average 
                isolate_aerotau_uncer(dimx,dimy,Nisolate),&
!		isolate_aero_depratio(dimx,dimy,Nisolate,2),&
!		isolate_aero_backscatt(dimx,dimy,Nisolate,2),&
                incld_aero_tau(dimx,dimy,Nincld),&
                incld_aerotau_uncer(dimx,dimy,Nincld),&
!		incld_aero_depratio(dimx,dimy,Nincld),&
!		incld_aero_backscatt(dimx,dimy,Nincld),&
                aero_only_tau(dimx,dimy),&
                aero_onlytau_uncer(dimx,dimy)
!		aero_only_depratio(dimx,dimy,2),&
!		aero_only_backscatt(dimx,dimy,2)

	!for isoated-cloud aerosol and its transmittance
	!real (kind=4) :: aerotau_cldtran(Ntau,Nisolate),aerotau_cldtranerr(Ntau,Nisolate)
	!integer (kind=4) :: aerotau_cldtran_num(Ntau,Nisolate)
	!=============== for writing results
	integer (kind=4) :: totalpdf_aero_only_tau(dimx,dimy,Ntau)
	integer (kind=4) :: totalpdf_isolate_aero_tau(dimx,dimy,Ntau,Nisolate)
	integer (kind=4), allocatable :: & !totalpdf_incld_aero_tau(dimx,dimy,Ntau,Nincld)
		totalpdf_incld_aero_tau(:,:,:,:)
!	        totalpdf_incld_aero_depratio(dimx,dimy,Ndep,Nincld,2),&

!	real (kind=4) :: totaluncer_aero_only_tau(Ntau,2,2),&
!		totaluncer_isolate_aerotau(Ntau,Nisolate,2),&
!		totaluncer_incld_aerotau(Ntau,Nincld,2)

!        real (kind=4) :: total_isolate_cldtau(Ntau,Nisolate,2),&
!		total_uncer_isolate_cldtau(Ntau,Nisolate,2),&
!		total_incld_cldtau(Ntau,Nincld,2),&
!		total_uncer_incld_cldtau(Ntau,Nincld,2)
        real (kind=4), allocatable :: &
     !           total_aero_only_beta_profile(dimx,dimy,dimh),&
                total_aero_only_beta_profile(:,:,:),&
                total_isolate_aero_beta_profile_abvcld(:,:,:),&
                total_isolate_aero_beta_profile_belcld(:,:,:),&
                total_isolate_aero_beta_profile_other(:,:,:),&
                total_incld_aero_beta_profile_one(:,:,:),&
                total_incld_aero_beta_profile_belcld(:,:,:),&
                total_incld_aero_beta_profile_abvcld(:,:,:),&
                total_incld_aero_beta_profile_other(:,:,:)

!	   integer (kind=4), allocatable :: &
!                total_incld_aero_pdf_beta_profile_one(:,:,:,:),&
!                total_incld_aero_pdf_beta_profile_belcld(:,:,:,:),&
!                total_incld_aero_pdf_beta_profile_abvcld(:,:,:,:),&
!                total_incld_aero_pdf_beta_profile_other(:,:,:,:),&
!                total_aero_only_pdf_beta_profile(:,:,:,:),&
!                total_isolate_aero_pdf_beta_profile_abvcld(:,:,:,:),&
!                total_isolate_aero_pdf_beta_profile_belcld(:,:,:,:),&
!                total_isolate_aero_pdf_beta_profile_other(:,:,:,:)

	integer (kind=4) :: total_obsnumh(dimx,dimy),&
                total_obsnumv(dimx,dimy,dimh),&
	        total_opaquecld_numh(dimx,dimy),&
			total_nocld_noaero_numh(dimx,dimy),&
			total_cld_noaero_numh(dimx,dimy),&
		!for aerosol and cloud overlap, both have CAD score > 50
	        total_isolate_aero_numh(dimx,dimy,Nisolate),& 
!	        total_isolate_aero_numv(dimx,dimy,dimh,Nisolate),& 
	        total_isolate_aerotau1_numh(dimx,dimy,Nisolate),& 
	        total_incld_aero_numh(dimx,dimy,Nincld),&
!	        total_incld_aero_numv(dimx,dimy,dimh,Nincld),&
	        total_incld_aerotau1_numh(dimx,dimy,Nincld),&
	        total_aero_only_numh(dimx,dimy),&
	        total_aero_only_numv(dimx,dimy,dimh),&
	        total_aerotau1_only_numh(dimx,dimy),&
			total_filtercad_num(dimx,dimy),&
!			total_filter_aod_num(dimx,dimy),&
			total_filterci_num(dimx,dimy),&
			total_filter_extqc_num(dimx,dimy),&
			total_filter_allnum(dimx,dimy)
	
	real(kind=4) :: total_isolate_aero_tau(dimx,dimy,Nisolate),&
		total_isolate_aerotau_uncer(dimx,dimy,Nisolate),&
	!	total_isolate_aero_depratio(dimx,dimy,Nisolate),&
	!	total_isolate_aero_backscatt(dimx,dimy,Nisolate),&
        total_incld_aero_tau(dimx,dimy,Nincld),&
	    total_incld_aerotau_uncer(dimx,dimy,Nincld),&
	!	total_incld_aero_depratio(dimx,dimy,Nincld),&
	!	total_incld_aero_backscatt(dimx,dimy,Nincld),&
        total_aero_only_tau(dimx,dimy),&
        total_aero_onlytau_uncer(dimx,dimy)

	!for 2D PDF of backscatter vs. deporalization ratio	
!	integer (kind=4) ::total_aero_only_scatdep(dimx,dimy,Nsca,Ndep),&
!                total_isolate_aero_scatdep(dimx,dimy,Nsca,Ndep,Nisolate),&
!              	 total_incld_aero_scatdep(dimx,dimy,Nsca,Ndep,Nincld)

!    integer (kind=4) :: total_aero_only_lidcol(dimx,dimy,Nlidratio,Ncolratio),&
!  		total_incld_aero_lidcol(dimx,dimy,Nlidratio,Ncolratio,Nincld) 
	integer (kind=4), allocatable ::& !total_aero_only_scatdep(dimx,dimy,Nsca,Ndep),&
       !         total_isolate_aero_scatdep(dimx,dimy,Nsca,Ndep,Nisolate),&
             	! total_incld_aero_scatdep(dimx,dimy,Nsca,Ndep,Nincld)
			total_aero_only_scatdep(:,:,:,:),&
			total_incld_aero_scatdep_one(:,:,:,:),&
			total_incld_aero_scatdep_belcld(:,:,:,:),&
			total_incld_aero_scatdep_abvcld(:,:,:,:),&
			total_incld_aero_scatdep_other(:,:,:,:),&
			total_isolate_aero_scatdep_belcld(:,:,:,:),&
			total_isolate_aero_scatdep_abvcld(:,:,:,:),&
			total_isolate_aero_scatdep_other(:,:,:,:)

    integer (kind=4), allocatable :: &!total_aero_only_lidcol(dimx,dimy,Nlidratio,Ncolratio),&
  	!	total_incld_aero_lidcol(dimx,dimy,Nlidratio,Ncolratio,Nincld) 
		total_aero_only_lidcol(:,:,:,:),&
		total_incld_aero_lidcol_one(:,:,:,:),&
		total_incld_aero_lidcol_belcld(:,:,:,:),&
		total_incld_aero_lidcol_abvcld(:,:,:,:),&
		total_incld_aero_lidcol_other(:,:,:,:),&
		total_isolate_aero_lidcol_belcld(:,:,:,:),&
		total_isolate_aero_lidcol_abvcld(:,:,:,:),&
		total_isolate_aero_lidcol_other(:,:,:,:)

	integer (kind=4), allocatable:: &
		total_isolate_aero_numv_belcld(:,:,:),&
		total_isolate_aero_numv_abvcld(:,:,:),&
		total_isolate_aero_numv_other(:,:,:),&
		total_incld_aero_numv_one(:,:,:),&
		total_incld_aero_numv_belcld(:,:,:),&
		total_incld_aero_numv_abvcld(:,:,:),&
		total_incld_aero_numv_other(:,:,:)

	end module 

