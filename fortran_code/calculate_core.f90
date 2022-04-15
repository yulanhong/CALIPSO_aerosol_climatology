
        subroutine calculate_core(myid)

        use global, only : gap_threshold,CAD_threshold,ratio_threshold,&
		CAD_Score,Opacity,dnf,res_layer,VFM,IGBP_surf,&
        ext_lay_qc,top_hgt,base_hgt,lat,lon,aero_tau,aerotau_uncer,depol_ratio,&
        back_scatt,lidar_ratio532,color_ratio,min_laser_energy,&
        back_prof,&
        dimx,dimy,dimh,dimh_tp,ncol,ncolp,latbin_res,lonbin_res,&
        Nlidratio,Ncolratio,Nsca,Ndep,Nrow,Ntau,Nincld,Nisolate,&
        obsnumh,obsnumv,&
		aero_only_numh,aero_only_numv,aero_only_tau,aero_onlytau_uncer,&
        aerotau1_only_numh,pdf_aero_only_tau,&
        opaquecld_numh,&
		nocld_noaero_numh,&
		cld_noaero_numh,&
        aero_only_beta_profile,aero_only_scatdep,&
		aero_only_lidcol,&
		incld_aerotau1_numh,incld_aero_numh,&
		incld_aero_numv_one,&
		incld_aero_numv_belcld,&
		incld_aero_numv_abvcld,&
		incld_aero_numv_other,&
		incld_aero_beta_profile_one,&
		incld_aero_beta_profile_belcld,&
		incld_aero_beta_profile_abvcld,&
		incld_aero_beta_profile_other,&
		incld_aero_tau,incld_aerotau_uncer,pdf_incld_aero_tau,&
		incld_aero_lidcol_one,incld_aero_lidcol_abvcld,&
		incld_aero_lidcol_belcld,incld_aero_lidcol_other,&
		incld_aero_scatdep_one,incld_aero_scatdep_abvcld,&
		incld_aero_scatdep_belcld,incld_aero_scatdep_other,&
		isolate_aero_numh,isolate_aero_tau,isolate_aerotau_uncer,&
		isolate_aerotau1_numh,&
		isolate_aero_numv_belcld,&
		isolate_aero_numv_abvcld,&
		isolate_aero_numv_other,&
		isolate_aero_beta_profile_belcld,&
		isolate_aero_beta_profile_abvcld,&
		isolate_aero_beta_profile_other,&
		pdf_isolate_aero_tau,&
		isolate_aero_scatdep_abvcld,&
		isolate_aero_scatdep_belcld,&
		isolate_aero_scatdep_other,&
		isolate_aero_lidcol_abvcld,&
		isolate_aero_lidcol_belcld,&
		isolate_aero_lidcol_other,&
		filtercad_num,&
!		filter_aod_num,&
		filterci_num,&
		filter_extqc_num,&
		filter_allnum
!		aero_only_pdf_beta_profile,&
!		isolate_aero_pdf_beta_profile_abvcld,&
! 		isolate_aero_pdf_beta_profile_belcld,&
! 		isolate_aero_pdf_beta_profile_other,&
!		incld_aero_pdf_beta_profile_one,&
! 		incld_aero_pdf_beta_profile_belcld,&
! 		incld_aero_pdf_beta_profile_abvcld,&
! 		incld_aero_pdf_beta_profile_other

        implicit none

        integer :: hi,ahi,ahi_m1,ahi_p1,chi,chi_m1,chi_p1,Nh,si,&
                lat_scp,lon_scp,top_scp,base_scp,phi
        integer :: aerotau_scp,aerodep_scp,aerosca_scp
        integer :: aerolidratio_scp,cldlidratio_scp,aerocolratio_scp
        integer :: aerocld_gapscp,cldtop_scp,cldbase_scp ! for 2dpdf
        integer :: Ncld, Naero, Ntrans ! to mark the effective cloud and aerosol layers, particular, no stratospheric aerosol
        integer :: lsflag, dnflag,myid
!		integer :: aod2aodb_ratio,aod2aodf_ratio,aodf_zero,aodb_zero
                
        real :: tplat,tplon,tptopalt(NCOL),tpbasealt(NCOL),&
        tpdepratio(NCOL),tpbackscatt(NCOL),tplidratio(NCOL),&
        tpcolratio(NCOL)

        real (kind=4) :: tp_tau,tp_tauuncer,tp_beta_prof(NCOLP)
        integer (kind=1) :: tp_beta_num(NCOLP)
		integer (kind=4) :: tpbackscat_pdf(NCOLP,Nsca)

        real :: layer_gap,layer_gap1,aerocld_gap,aerocld_mingap

        real :: tpaerotop(NCOL),tpaerotop_m1(NCOL),tpaerotop_p1(NCOL),&
              tpaerobase(NCOL),tpaerobase_m1(NCOL),tpaerobase_p1(NCOL),&
              tpaerodepratio(NCOL),tpaerobackscatt(NCOL),&
              tpaerolidratio(NCOL),tpcldlidratio(NCOL),&
              tpaerocolratio(NCOL)

        real :: tpcldtop(NCOL),tpcldtop_p1(NCOL),tpcldtop_m1(NCOL),&
               tpcldbase(NCOL),tpcldbase_p1(NCOL),tpcldbase_m1(NCOL)

        integer :: tpciflag(NCOL),tpciflag_p1(NCOL),tpciflag_m1(NCOL)

        integer :: tpaerores(NCOL),tpaerores_m1(NCOL),tpaerores_p1(NCOL)
        !========== for extincton profiles and filters =========================
        integer :: filtercad,filter80,filterci,filter_extqc
        integer :: filter80_toppos(NCOL),filter80_basepos(NCOL),&
                   filterci_toppos(NCOL),filterci_basepos(NCOL)

        integer(kind=1) :: tpcad_1,tpibgp
        integer(kind=4) :: tpvfm_1
        integer(kind=1) :: tpcad(NCOL),tpopacity(NCOL)
        integer(kind=2) :: tpvfm(NCOL)

     !   real :: new_aerotop, new_aerobase
     !   integer :: new_topscp,new_basescp

        !============================================================
        integer :: cloud_phase,feature_type,horizontal_average,&
                lowcad_flag,extqc_flag,&!reject_aod_flag,&
                uncerflag,opacity_flag,cldphase_flag,inaerocase_flag,&
                isaerocase_flag,aeroonly_flag
        integer :: &! tpfrev_cldflag(NCOL),tpfrev_aeroflag(NCOL),&
                cldalt_flag(dimh_tp),aeroalt_flag(dimh_tp),&
                cldaero_merge_flag(dimh_tp) ! for the vertical res 0.01m
        real :: up_trans,up_transerr !uncertaintiy transfer
        !======================================================================

        obsnumh=0
        obsnumv=0
        opaquecld_numh=0
		nocld_noaero_numh=0
		cld_noaero_numh=0

        isolate_aero_numh=0
        isolate_aerotau1_numh=0
		allocate(isolate_aero_numv_abvcld(dimx,dimy,dimh))
        isolate_aero_numv_abvcld=0
		allocate(isolate_aero_numv_belcld(dimx,dimy,dimh))
        isolate_aero_numv_belcld=0
		allocate(isolate_aero_numv_other(dimx,dimy,dimh))
        isolate_aero_numv_other=0

        incld_aero_numh=0
        incld_aerotau1_numh=0
		allocate(incld_aero_numv_one(dimx,dimy,dimh))
        incld_aero_numv_one=0
		allocate(incld_aero_numv_belcld(dimx,dimy,dimh))
        incld_aero_numv_belcld=0
		allocate(incld_aero_numv_abvcld(dimx,dimy,dimh))
        incld_aero_numv_abvcld=0
		allocate(incld_aero_numv_other(dimx,dimy,dimh))
        incld_aero_numv_other=0

        aero_only_numh=0
        aero_only_numv=0 !only when backscatter gt 0,numv+1
        aerotau1_only_numh=0

!		aero_only_pdf_beta_profile=0
!		isolate_aero_pdf_beta_profile_abvcld=0
! 		isolate_aero_pdf_beta_profile_belcld=0
! 		isolate_aero_pdf_beta_profile_other=0
!		incld_aero_pdf_beta_profile_one=0
! 		incld_aero_pdf_beta_profile_belcld=0
! 		incld_aero_pdf_beta_profile_abvcld=0
! 		incld_aero_pdf_beta_profile_other=0

		allocate(aero_only_beta_profile(dimx,dimy,dimh))
        aero_only_beta_profile=0.0

		allocate(isolate_aero_beta_profile_abvcld(dimx,dimy,dimh))
        isolate_aero_beta_profile_abvcld=0.0
		allocate(isolate_aero_beta_profile_belcld(dimx,dimy,dimh))
        isolate_aero_beta_profile_belcld=0.0
		allocate(isolate_aero_beta_profile_other(dimx,dimy,dimh))
        isolate_aero_beta_profile_other=0.0

		allocate(incld_aero_beta_profile_one(dimx,dimy,dimh))
        incld_aero_beta_profile_one=0.0
		allocate(incld_aero_beta_profile_belcld(dimx,dimy,dimh))
        incld_aero_beta_profile_belcld=0.0
		allocate(incld_aero_beta_profile_abvcld(dimx,dimy,dimh))
        incld_aero_beta_profile_abvcld=0.0
		allocate(incld_aero_beta_profile_other(dimx,dimy,dimh))
        incld_aero_beta_profile_other=0.0

        isolate_aero_tau=0.0
        incld_aero_tau=0.0
        aero_only_tau=0.0
        isolate_aerotau_uncer=0.0
        incld_aerotau_uncer=0.0
        aero_onlytau_uncer=0.0

        pdf_aero_only_tau=0
		allocate(pdf_incld_aero_tau(dimx,dimy,Ntau,Nincld))
        pdf_incld_aero_tau=0

        pdf_isolate_aero_tau=0

		allocate(aero_only_scatdep(dimx,dimy,Nsca,Ndep))
        aero_only_scatdep=0

		allocate(incld_aero_scatdep_one(dimx,dimy,Nsca,Ndep))
        incld_aero_scatdep_one=0
		allocate(incld_aero_scatdep_abvcld(dimx,dimy,Nsca,Ndep))
        incld_aero_scatdep_abvcld=0
		allocate(incld_aero_scatdep_belcld(dimx,dimy,Nsca,Ndep))
        incld_aero_scatdep_belcld=0
		allocate(incld_aero_scatdep_other(dimx,dimy,Nsca,Ndep))
        incld_aero_scatdep_other=0

		allocate(aero_only_lidcol(dimx,dimy,Nlidratio,Ncolratio))
        aero_only_lidcol=0
		allocate(incld_aero_lidcol_one(dimx,dimy,Nlidratio,Ncolratio))
        incld_aero_lidcol_one=0
		allocate(incld_aero_lidcol_abvcld(dimx,dimy,Nlidratio,Ncolratio))
        incld_aero_lidcol_abvcld=0
		allocate(incld_aero_lidcol_belcld(dimx,dimy,Nlidratio,Ncolratio))
        incld_aero_lidcol_belcld=0
		allocate(incld_aero_lidcol_other(dimx,dimy,Nlidratio,Ncolratio))
        incld_aero_lidcol_other=0

		allocate(isolate_aero_scatdep_abvcld(dimx,dimy,Nsca,Ndep))
        isolate_aero_scatdep_abvcld=0
		allocate(isolate_aero_scatdep_belcld(dimx,dimy,Nsca,Ndep))
        isolate_aero_scatdep_belcld=0
		allocate(isolate_aero_scatdep_other(dimx,dimy,Nsca,Ndep))
        isolate_aero_scatdep_other=0

		allocate(isolate_aero_lidcol_abvcld(dimx,dimy,Nlidratio,Ncolratio))
        isolate_aero_lidcol_abvcld=0
		allocate(isolate_aero_lidcol_belcld(dimx,dimy,Nlidratio,Ncolratio))
        isolate_aero_lidcol_belcld=0
		allocate(isolate_aero_lidcol_other(dimx,dimy,Nlidratio,Ncolratio))
        isolate_aero_lidcol_other=0

		!=== record filter number ====
		filtercad_num=0
!		filter_aod_num=0
		filterci_num=0
		filter_extqc_num=0
		filter_allnum=0

!		OPEN(1000,file='cloud_aerosol_category_201907240323.txt')

        Do si=1, NROW

        tplat=lat(2,si)
        tplon=lon(2,si)
        tptopalt=top_hgt(:,si)
        tpbasealt=base_hgt(:,si)
        tpcad=CAD_Score(:,si)
        tpopacity=Opacity(:,si)
        tpvfm=VFM(:,si)
        tpdepratio=depol_ratio(:,si)
        tpbackscatt=back_scatt(:,si)
        tplidratio=lidar_ratio532(:,si)
        tpcolratio=color_ratio(:,si)
        tpibgp=IGBP_surf(1,si)
        dnflag=dnf(1,si)
        tp_tau=aero_tau(1,si)
		tp_tauuncer=aerotau_uncer(1,si)

        tp_beta_prof=back_prof(:,si)

        IF (tpibgp == 17) Then ! water
           lsflag=1 
        Else 
           lsflag=2
        EndIf


        inaerocase_flag=0
        isaerocase_flag=0
        aeroonly_flag=0

        IF (min_laser_energy(1,si) > 80 ) Then !.and. dnflag .eq. 0 .and. lsflag .eq. 2) Then !.and. dnflag .eq. 1) Then 
		! seting day night here 1-night, 0-day, ocean and land	
		! lsflag 1-ocean, 2-land
		! dnflag 0-day, 1-night
                lat_scp=nint(1+(tplat+90-latbin_res/2.0)/latbin_res)
                lon_scp=nint(1+(tplon+180-lonbin_res/2.0)/lonbin_res)
!		print *,tplat,tplon,lon_scp,lat_scp	
                if (lat_scp < 1) lat_scp=1
                if (lon_scp < 1) lon_scp=1
                if (lat_scp > dimy) lat_scp=dimy
                if (lon_scp > dimx) lon_scp=dimx


                obsnumh(lon_scp,lat_scp)=&
                obsnumh(lon_scp,lat_scp)+1

                obsnumv(lon_scp,lat_scp,:)=&
                obsnumv(lon_scp,lat_scp,:)+1
             ! === for observaiton ==========   

                opacity_flag=0

                tpaerotop=0.0
                tpaerotop_m1=0.0
                tpaerotop_p1=0.0

                tpaerobase=0.0
                tpaerobase_m1=0.0
                tpaerobase_p1=0.0

                tpaerores=0
                tpaerores_m1=0
                tpaerores_p1=0

                tpaerodepratio=0.0
                tpaerobackscatt=0.0
                tpaerocolratio=0.0
                tpaerolidratio=0.0
                tpcldlidratio=0.0

                tpcldbase=0.0
                tpcldbase_p1=0.0
                tpcldbase_m1=0.0

                tpcldtop=0.0
                tpcldtop_p1=0.0
                tpcldtop_m1=0.0

                tpciflag=0
                tpciflag_p1=0
                tpciflag_m1=0

                !== to mark aerosol and cloud in the vertical--
             !   tpfrev_cldflag=0
             !   tpfrev_aeroflag=0
                cldalt_flag=0
                aeroalt_flag=0
                cldaero_merge_flag=0

                !WHERE (tpcad <=100 .and. tpcad >0) tpfrev_cldflag=1
                !WHERE (tpcad < 0 .and. tpcad >= -100) tpfrev_aeroflag=1

                Nh=count((tptopalt .gt. 0))

                ! first search for the vertical
                !====== for one layer cloud and one layer aerosol =====================
                layer_gap=0.0 ! doesn't consider layer CAD score
                layer_gap1=0.0
                aerocld_gap=0.0
                aerocld_mingap=0.0
                ahi=1
                ahi_m1=1
                ahi_p1=1
                chi=1
                chi_m1=1
                chi_p1=1
                top_scp=1
                base_scp=1

           	 	filter_extqc=0 ! 1 represents the profile contains 
            	filtercad=0 ! 1 represents the profile containts lowcad aerosol
				filter80=0 ! 1 represent isolated, 0 represent not isolated (connect to horizontal resolution ne 80)
				filterci=0 ! 1 represent connected to cirrus, 0 represent not connected; if mark as 1 then discard the profile

                lowcad_flag=0
                extqc_flag=0
				!reject_aod_flag=0
                ! record the layer information
                Do hi=1, NCOL
 
                   IF (tptopalt(hi) > 0.0) Then
                   tpcad_1=tpcad(hi)
                   tpvfm_1=tpvfm(hi)
                   if (tpvfm_1 .lt. 0) tpvfm_1=tpvfm_1+65536

                   call vfm_feature_flag(tpvfm_1,feature_type,cloud_phase,horizontal_average)
                   top_scp=nint((30-tptopalt(hi))/0.01)
                   if (top_scp < 1) top_scp=1
                   if (tpbasealt(hi) < 0.0) tpbasealt(hi)=0.0
                   base_scp=nint((30-tpbasealt(hi))/0.01)
                !=== to judge the layer gap
                   IF (hi >= 1 .and. hi < Nh) layer_gap=tpbasealt(hi)-tptopalt(hi+1)
                !IF (hi == 1) layer_gap1=layer_gap
                   IF (layer_gap > layer_gap1) layer_gap1=layer_gap ! record the maximum gap
                !  print *,si,hi,tpcad_1, tpbasealt(hi),tptopalt(hi+1), layer_gap,layer_gap1	
                !========for high cad_score========================   

                        IF (feature_type .eq. 2) then !for cloud
                        	cldalt_flag(top_scp:base_scp)=1
                        	tpcldtop(chi)=tptopalt(hi)
                        	tpcldbase(chi)=tpbasealt(hi)
                       	 	tpcldlidratio(chi)=tplidratio(hi)
                         chi=chi+1
                        EndIf ! end for cloud 

                        IF (feature_type .eq. 3) then ! for aerosol
                        aeroalt_flag(top_scp:base_scp)=1
                        tpaerotop(ahi)=tptopalt(hi)
                        tpaerobase(ahi)=tpbasealt(hi)
                        tpaerodepratio(ahi) = tpdepratio(hi)
                        tpaerobackscatt(ahi) = tpbackscatt(hi)
                        tpaerolidratio(ahi) = tplidratio(hi)
                        tpaerocolratio(ahi) = tpcolratio(hi)
                        tpaerores(ahi) = res_layer(hi,si)
                        ahi=ahi+1
                        EndIF ! end for aerosol

                        EndIf ! end if top gt 0
               
                !===== check the profile CAD score ===========
                    
                   IF (CAD_Score(hi,si) .ge. 0-CAD_threshold .and. &
                        CAD_Score(hi,si) .le. 0) lowcad_flag=1
             
                !===== check the extinction qc ===============
                  IF (ext_lay_qc(hi,si) .ne. 0 .and. &
                      ext_lay_qc(hi,si) .ne. 1 .and. &
                      ext_lay_qc(hi,si) .ne. 16 .and. &
                      ext_lay_qc(hi,si) .ne. 18 .and. &
					  ext_lay_qc(hi,si) .gt. 0 .and. &
					  CAD_Score(hi,si) .lt. 0)  extqc_flag=1
			
                !==== to get the neighboor aerosol and cloud information ==== 
                   IF (si .ne. NROW) Then
                        IF (CAD_Score(hi,si+1) .le. 0 &
                        .and. CAD_Score(hi,si+1) .ge. -100) then
                        tpaerotop_p1(ahi_p1)=top_hgt(hi,si+1)
                        tpaerobase_p1(ahi_p1)=base_hgt(hi,si+1)
                        tpaerores_p1(ahi_p1)=res_layer(hi,si+1)
                        ahi_p1=ahi_p1+1
                        EndIf
                        IF (CAD_Score(hi,si+1) .ge. 0 &
                        .and. CAD_Score(hi,si+1) .le. 100) then
                        tpcldtop_p1(chi_p1)=top_hgt(hi,si+1)
                        tpcldbase_p1(chi_p1)=base_hgt(hi,si+1)
                        tpvfm_1=VFM(hi,si+1)
                        if (tpvfm_1 .lt. 0) tpvfm_1=tpvfm_1+65536
                        call vfm_feature_flag(tpvfm_1,feature_type,cloud_phase,horizontal_average)
                        if (cloud_phase ==1 .or. cloud_phase ==3) tpciflag_p1(chi_p1)=1
                        chi_p1=chi_p1+1
                        EndIf
                   EndIf  ! endif si ne nrow

                !==== to get the neighboor aerosol and cloud information ==== 
                 IF (si .ne. 1) Then
                        IF (CAD_Score(hi,si-1) .le. 0-CAD_threshold &
                        .and. CAD_Score(hi,si-1) .ge. -100) then
                        tpaerotop_m1(ahi_m1)=top_hgt(hi,si-1)
                        tpaerobase_m1(ahi_m1)=base_hgt(hi,si-1)
                        tpaerores_m1(ahi_m1)=res_layer(hi,si-1)
                        ahi_m1=ahi_m1+1
                        EndIf
                        IF (CAD_Score(hi,si-1) .ge. CAD_threshold &
                        .and. CAD_Score(hi,si-1) .le. 100) then
                        tpcldtop_m1(chi_m1)=top_hgt(hi,si-1)
                        tpcldbase_m1(chi_m1)=base_hgt(hi,si-1)
                        tpvfm_1=VFM(hi,si-1)
                        if (tpvfm_1 .lt. 0) tpvfm_1=tpvfm_1+65536
                        call vfm_feature_flag(tpvfm_1,feature_type,cloud_phase,horizontal_average)
                        if (cloud_phase ==1 .or. cloud_phase ==3) tpciflag_m1(chi_m1)=1
                        chi_m1=chi_m1+1
                        EndIf
                
                EndIf ! end if si ne 1
                !==== ending obtain neighbooring  
				!========== to get the opacity ============	
				IF (tpopacity(hi) == 1) opacity_flag=opacity_flag+1

                EndDo ! end scan layers 

				!==== dealing with no aerosol situation
				IF (sum(aeroalt_flag) == 0) Then

                	IF (sum(cldalt_flag) > 0) Then
						cld_noaero_numh(lon_scp,lat_scp)=cld_noaero_numh(lon_scp,lat_scp)+1	
                		IF (opacity_flag > 0) opaquecld_numh(lon_scp,lat_scp)= &
                                opaquecld_numh(lon_scp,lat_scp)+1
                	EndIf ! end cloudy case


					IF (sum(cldalt_flag) == 0) nocld_noaero_numh(lon_scp,lat_scp) = nocld_noaero_numh(lon_scp,lat_scp)+1
					
				EndIF
                !=== end no aerosol situation ====

                !==== to filter out aerosol profile with low cad ====
                IF (lowcad_flag ==1 .and. sum(aeroalt_flag) > 0 ) Then
					filtercad=1
					filtercad_num(lon_scp,lat_scp)=filtercad_num(lon_scp,lat_scp)+1
				EndIF
	!			print *,si,sum(filtercad_num),'lowcad ',filtercad
                !=== to filter out extinction qc ======
                IF (extqc_flag ==1 .and. sum(aeroalt_flag) > 0) Then
					 filter_extqc=1
					filter_extqc_num(lon_scp,lat_scp)=filter_extqc_num(lon_scp,lat_scp)+1
				EndIf
	!			print *,sum(filter_extqc_num),'extqc ',filter_extqc

                !=== to filter out aerosol layers detected at 80km
                !horizontal resolution that are not connected to aonther
                !aerosol layer=====
				!call isolated_80_filter(filter80,tpaerotop_p1,tpaerobase_p1,tpaerores_p1,&
			!tpaerotop_m1,tpaerobase_m1,tpaerores_m1,tpaerotop,tpaerobase,tpaerores)
			!filter80_toppos,filter80_basepos)
			!print *,si,filter80
			!print *,filter80_toppos
			!print *,filter80_basepos

                !===== to filter the aerosol layers above 4 km that are
                !in contact with ice clouds =====
		call cirrus_filter(filterci,tpaerobase,tpaerotop,tpcldtop,tpcldbase,&
			tpcldtop_p1,tpcldbase_p1,tpcldtop_m1,tpcldbase_m1,&
			tpciflag,tpciflag_p1,tpciflag_m1)

		 IF(filterci .eq. 1 .and. sum(aeroalt_flag) > 0) Then
			filterci_num(lon_scp,lat_scp)=filterci_num(lon_scp,lat_scp)+1
		 EndIf

	!	print *,sum(filterci_num),'ci ',filterci
		!===== to filter isolated aod > 1 ====
	!	aod2aodf_ratio=0
	!	aod2aodb_ratio=0
	!	aodf_zero=0
	!	aodb_zero=0

	!	IF (tp_tau .ge. 1) Then 

	!	if (si == 1) then
	!		if (aero_tau(1,si+1) .gt. 0) aod2aodf_ratio=tp_tau/aero_tau(1,si+1)
	!		if (aero_tau(1,si+1) .eq. 0) aodf_zero=1
	!	endif ! endsi==1	
	!	if (si == Nrow) then
	!		if (aero_tau(1,si-1) .gt. 0) aod2aodb_ratio=tp_tau/aero_tau(1,si-1)
	!		if (aero_tau(1,si-1) .eq. 0) aodb_zero=1
	!	endif
	!	if (si .gt. 1 .and. si .lt. Nrow) then
	!		if (aero_tau(1,si+1) .gt. 0 .and. aero_tau(1,si-1) .gt. 0) then 
	!			aod2aodf_ratio=tp_tau/aero_tau(1,si+1)
	!			aod2aodb_ratio=tp_tau/aero_tau(1,si-1)
	!		endif
	!		if (aero_tau(1,si+1) .eq. 0 .and. aero_tau(1,si-1) .gt. 0) then 
	!			aod2aodb_ratio=tp_tau/aero_tau(1,si-1)
	!			aodf_zero=1
	!		endif
	!		if (aero_tau(1,si+1) .gt. 0 .and. aero_tau(1,si-1) .eq. 0) then 
	!			aod2aodf_ratio=tp_tau/aero_tau(1,si+1)
	!			aodb_zero=1
	!		endif
	!		if (aero_tau(1,si+1) .eq. 0 .and. aero_tau(1,si-1) .eq. 0) then 
	!			aodb_zero=1
	!			aodf_zero=1
	!		endif
	!	endif ! endif  si gt 1 and si lt Nrow-1
	!		if (aod2aodf_ratio .gt. ratio_threshold .and. aod2aodb_ratio .gt. ratio_threshold) reject_aod_flag=1
	!		if (aod2aodf_ratio .gt. ratio_threshold .and. aodb_zero .eq. 1) reject_aod_flag=1
	!		if (aod2aodb_ratio .gt. ratio_threshold .and. aodf_zero .eq. 1) reject_aod_flag=1
	!		if (aodb_zero .eq. 1 .and. aodf_zero .eq. 1) reject_aod_flag=1			

	!	IF (reject_aod_flag .eq. 1) Then
	!		filter_aod_num(lon_scp,lat_scp)=filter_aod_num(lon_scp,lat_scp)+1
	!   EndIF
	!	EndIf ! endif tau>=1
	!	print *,sum(filter_aod_num),'aod ',reject_aod_flag
		!=== to set the filter no effect ===
		!filter_extqc=0
		!filtercad=0
		filterci=0
		!reject_aod_flag=0

		IF ((filter_extqc+filtercad+filterci) > 0 .and. sum(aeroalt_flag) > 0) Then 
			filter_allnum(lon_scp,lat_scp)=filter_allnum(lon_scp,lat_scp)+1
		!stop ' '
		EndIF
		!print *,sum(filter_allnum),'all ',filter_extqc,filtercad,filter80,filterci,reject_aod_flag
	
		!call integrate_filter_aod(si,tp_tau,filter80,filter80_toppos,filter80_basepos,&
		!	filterci,filterci_toppos,filterci_basepos,new_aerotop,new_aerobase)
                !print *,filter_extqc,filtercad,filter80,filterci
		!============== aerosol only =====================================
		!print *,si, sum(cldalt_flag), sum(aeroalt_flag)
		IF (sum(cldalt_flag) == 0 .and. sum(aeroalt_flag) > 0 .and. &
                 (filter_extqc+filtercad+filter80+filterci)==0) Then

		IF (tp_tau > 0) Then
			aeroonly_flag=1
			aero_only_numh(lon_scp,lat_scp)= &
			aero_only_numh(lon_scp,lat_scp)+1

			aero_only_tau(lon_scp,lat_scp) = &
			aero_only_tau(lon_scp,lat_scp) + tp_tau

			aero_onlytau_uncer(lon_scp,lat_scp) = &
			aero_onlytau_uncer(lon_scp,lat_scp) + tp_tauuncer

			IF (tp_tau >= 1.0) aerotau1_only_numh(lon_scp,lat_scp)= &
                        aerotau1_only_numh(lon_scp,lat_scp)+1

                        !==== to get vertical distribution ======
                        tp_beta_num=0
                        WHERE(tp_beta_prof .gt. 0 .and. &
                                tp_beta_prof .lt.  0.05) tp_beta_num=1
                        
                        aero_only_numv(lon_scp,lat_scp,:)= &
                        aero_only_numv(lon_scp,lat_scp,:)+tp_beta_num
        
                        aero_only_beta_profile(lon_scp,lat_scp,:) = &
                        aero_only_beta_profile(lon_scp,lat_scp,:)+&
                                tp_beta_num*tp_beta_prof

						!==== to obtain the pdf of tp beta profile
						!Do phi=1, NCOLP
						!	if (tp_beta_prof(phi) > 0 .and. tp_beta_prof(phi) < 0.05) then
						!	aerosca_scp=nint((alog10(tp_beta_prof(phi))+4.5)/0.035) !-4.5--0	
			             !   IF (aerosca_scp < 1) aerosca_scp=1
					     !   IF (aerosca_scp > Nsca) aerosca_scp=Nsca	
					!		tpbackscat_pdf(phi,aerosca_scp)=tpbackscat_pdf(phi,aerosca_scp)+1
					!		endif
					!	EndDo
!						aero_only_pdf_beta_profile(lon_scp,lat_scp,:,:)=&
!						aero_only_pdf_beta_profile(lon_scp,lat_scp,:,:)+ tpbackscat_pdf			
			
                        aerotau_scp=nint((alog10(tp_tau)+4)/0.01)
                        IF (aerotau_scp < 1) aerotau_scp=1
                        IF (aerotau_scp > Ntau) aerotau_scp=Ntau
                        pdf_aero_only_tau(lon_scp,lat_scp,aerotau_scp)=&
                        pdf_aero_only_tau(lon_scp,lat_scp,aerotau_scp)+1
                    
			!=== search the layers in the column,record for each layer =====
			!=== screen out isolate_80, cirrus, extinction_uncer and QC ====
                     
			Do hi=1,count(tpaerotop > 0.0) ! keep consistent with filter80 and filterci
			
			IF (tpaerodepratio(hi) > 0.0 .and. tpaerobackscatt(hi) > 0.0) Then
				aerodep_scp=nint(tpaerodepratio(hi)/0.005) !0-0.1
				IF (aerodep_scp >= 0 .and. aerodep_scp < 1) aerodep_scp=1
				IF (aerodep_scp > Ndep) aerodep_scp=Ndep
				aerosca_scp=nint((alog10(tpaerobackscatt(hi))+4.5)/0.05) !-4.5--0
				IF (aerosca_scp < 1) aerosca_scp=1
				IF (aerosca_scp > Nsca) aerosca_scp=Nsca

				aero_only_scatdep(lon_scp,lat_scp,aerosca_scp,aerodep_scp)=&
			        aero_only_scatdep(lon_scp,lat_scp,aerosca_scp,aerodep_scp)+1
			            
				aerolidratio_scp=nint(tpaerolidratio(hi)-10)
                if (aerolidratio_scp < 1) aerolidratio_scp=1
                if (aerolidratio_scp > Nlidratio) aerolidratio_scp=Nlidratio

				IF (tpaerocolratio(hi) > 0.0) Then
				    aerocolratio_scp=nint(tpaerocolratio(hi)*100) ! 
				    if (aerocolratio_scp < 1) aerocolratio_scp=1
				    if (aerocolratio_scp > Ncolratio) aerocolratio_scp=Ncolratio
                           
                    aero_only_lidcol(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)=&
                    aero_only_lidcol(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)+1
                               
				EndIf ! end if color ratio> 0.0 

			EndIF ! end depratio and backcatter >0
			EndDo
			!=== end search the layers
			EndIf ! endif tp_tau > 0.0
		EndIf ! endif aerosol only 	

        !   !=== for cloud-aerosol cases====
		If ((sum(cldalt_flag) .gt. 0) .and. (sum(aeroalt_flag) .gt. 0) &
                 .and. (filter_extqc+filtercad+filter80+filterci) == 0) Then
	     !   !=== get the overlap location, to judge whether there is cloud-aerosol merge in the vertical
	        WHERE(aeroalt_flag > 0 .and. cldalt_flag > 0) cldaero_merge_flag=1

	     !   !========== start case judgement ====================		
	        IF (sum(cldaero_merge_flag) > 0) Then ! for aerosol-cloud merge cases,there must be tropospheric aerosols
	     !   	!case1: only one aerosol and one cloud layer
	        	IF (count(tpcldtop > 0.0) == 1 .and. count(tpaerotop > 0.0) == 1) inaerocase_flag=1
	        	IF (count(tpcldtop > 0.0) == 2 .and. count(tpaerotop > 0.0) == 1) Then
	        		IF (layer_gap1 < gap_threshold) inaerocase_flag=1
	     !   		!== cldbase > aerotop (yes) cldabove (no) cldbelow
	        		IF (layer_gap1 >= gap_threshold) Then ! gap is only between cloud and aero-cld
	     !   			!case 2: cloud layer is above the aero-cld merged layer
	        			IF (tpcldbase(1) > tpaerotop(1)) inaerocase_flag=2 
	     !   			!case 3: cloud layer is below the aero-cld merged layer
	        			IF (tpcldbase(1) < tpaerotop(1)) inaerocase_flag=3 
	        		EndIf
	        	EnDIF ! end cloud=2, aero=1	

	        	IF (count(tpcldtop > 0.0) > 2 .and. count(tpaerotop > 0.0) ==1) Then 
	        		IF (layer_gap1 < gap_threshold) inaerocase_flag=1 ! if gap is too small, consider to be one layer

	        		IF (layer_gap1 >= gap_threshold) Then
	        			IF (tpaerotop(1) >= tpcldbase(1)) inaerocase_flag=3
	        			IF (tpaerotop(1) < tpcldbase(1) .and. (tpcldbase(1) - tpaerotop(1)) < gap_threshold) inaerocase_flag=3
	        			IF (tpaerotop(1) < tpcldbase(1) .and. (tpcldbase(1) - tpaerotop(1)) >= gap_threshold) Then 
	     !   			! there is a cloud layer above, to judge whether there is a cloud below 
	        				IF ((tpcldtop(count(tpcldtop > 0.0))-tpaerobase(1) > 0-gap_threshold)) inaerocase_flag=2 ! judge the last cloud layer 
	        				IF ((tpaerobase(1)-tpcldtop(count(tpcldtop > 0.0))) >= gap_threshold) inaerocase_flag=4 
	        			EndIf !
	        	    EndIf ! layer_gap > 0.5
	     !   !print *, si, inaerocase_flag,sum(tpfrev_cldflag),sum(tpfrev_aeroflag)
	        	EndIf !end cloud > 2, aero=1
 
	     !       !=== for multiple aerosol layers ===
	        	IF (count(tpcldtop > 0.0) == 1 .and. count(tpaerotop > 0.0) > 1) then
	        		IF (layer_gap1 < gap_threshold) inaerocase_flag=1 
	        		IF (layer_gap1 >= gap_threshold) then
					 	inaerocase_flag=5 ! note that there is aerosol-cloud merged layer
					EndIF
	        	EndIf
	     !   	! end cld=1, aero>1

	        	IF (count(tpcldtop > 0.0) > 1 .and. count(tpaerotop > 0.0) > 1) Then
	        		IF (layer_gap1 < gap_threshold) inaerocase_flag=1 
	     !   			
	        		IF (layer_gap1 >= gap_threshold) inaerocase_flag=6 
	        	EndIf
	     !   	! end cld >1, aero >1
	        EndIF ! end aerosol-cloud merge cases
	     !   !=======================================================================================

	     !   !=======================================================================================
	        IF (sum(cldaero_merge_flag) == 0) Then ! for aerosol-cloud separated cases,need to exclude stratospheric cloud 

	        	IF (tpaerotop(1) .ne. 0 .and. count(tpcldtop > 0.0) == 1 .and. count(tpaerotop > 0.0) ==1) Then
	     !   		 ! exclude the stratopshere feature (if tpaerotop(1) ne 0)
	        		IF ((tpcldbase(1)-tpaerotop(1)) >= gap_threshold) isaerocase_flag=1
	    	   		IF ((tpaerobase(1)-tpcldtop(1)) >= gap_threshold) isaerocase_flag=2
	        		IF (layer_gap1 < gap_threshold) inaerocase_flag=1 !note the layer gap
	        	EndIf ! end cld=1, aero=1

	        	IF (tpaerotop(1) .ne. 0 .and. count(tpcldtop > 0.0) == 2 .and. count(tpaerotop > 0.0) ==1) Then
	        		IF (layer_gap1 < gap_threshold) inaerocase_flag = 1 
	        		IF (layer_gap1 >= gap_threshold) Then
	        			IF ((tpaerobase(1)-tpcldtop(1)) >= gap_threshold) isaerocase_flag=2
	        			IF (tpaerobase(1) >= tpcldtop(1) .and. (tpaerobase(1)-tpcldtop(1)) < gap_threshold) inaerocase_flag=3
	        			IF (tpaerobase(1) < tpcldtop(1)) Then
	        				IF ((tpcldbase(1)-tpaerotop(1)) < gap_threshold) inaerocase_flag=3 ! another layer gap must >0.5
	        				IF ((tpcldbase(1)-tpaerotop(1)) >= gap_threshold) Then ! one cloud layer above aero, judge the second cloud layer 						
								IF ((tpaerobase(1)-tpcldtop(2)) >= gap_threshold) isaerocase_flag=3   		
	        					IF ((tpaerobase(1)-tpcldtop(2)) < gap_threshold .and. tpaerobase(1) > tpcldtop(2))&
	        					inaerocase_flag=2   		
	        					IF ((tpcldbase(2)-tpaerotop(1)) < gap_threshold) inaerocase_flag=2   		
	        					IF ((tpcldbase(2)-tpaerotop(1)) >= gap_threshold) isaerocase_flag=1   		
	     !   					! note that if aerobase < cld top, aerotop will lower than cld base as well because there is a gap
	        				EndIf ! end a cloud layer above
	        			EndIf ! end aerobase < cldtop1
	        		EndIf ! end gap>0.5
	     !   		!!print *, layer_gap1,si, sum(tpfrev_cldflag), sum(tpfrev_aeroflag), inaerocase_flag,isaerocase_flag
	        	EndIf ! end two-layer clouds, one-layer aerosol

	        	IF (tpaerotop(1) .ne. 0 .and. count(tpcldtop > 0.0) > 2 .and. count(tpaerotop > 0.0) ==1) Then
	        		IF (layer_gap1 < gap_threshold) inaerocase_flag = 1 
	     !   		! no matter how many layers if the maximum gap < 0.5, regard as one layer
	        		IF (layer_gap1 >= gap_threshold) Then
	     !   		!judge if aerosol below cloud, only need to judge the last cloud layer
	        			IF (tpaerotop(1) < tpcldbase(count(tpcldtop > 0.0))) Then
	        				IF ((tpcldbase(count(tpcldtop > 0.0))-tpaerotop(1)) >= gap_threshold) isaerocase_flag=1
	        				IF ((tpcldbase(count(tpcldtop > 0.0))-tpaerotop(1)) < gap_threshold) inaerocase_flag=2
	        			EndIf 
	     !   		!judge if aerosol above cloud or in between cloud
	        			IF (tpaerotop(1) >= tpcldbase(count(tpcldtop > 0.0))) Then ! if aerotop > cldbase, aerobase > cldtop as well
	        				IF ((tpaerobase(1)-tpcldtop(count(tpcldtop > 0.0))) < gap_threshold) inaerocase_flag=2
	        				IF ((tpaerobase(1)-tpcldtop(count(tpcldtop > 0.0))) >= gap_threshold) Then ! there is a cloud layer below 
	     !   					!checking from up to down
	        					IF ((tpaerobase(1)-tpcldtop(1)) >= gap_threshold) isaerocase_flag=2
	        					IF ((tpaerobase(1)-tpcldtop(1)) < gap_threshold .and. tpaerobase(1) >= tpcldtop(1)) inaerocase_flag=3
	        					IF (tpaerotop(1) < tpcldbase(1)) Then	
	     !   					!judge if aerosol in between clouds
	        						IF ((tpcldbase(1)-tpaerotop(1)) < gap_threshold) inaerocase_flag=3
	        						IF ((tpcldbase(1)-tpaerotop(1)) >=gap_threshold) Then !there is a cloud above 
	        						Do hi=2,count(tpcldtop > 0.0)
	        							IF (tpaerobase(1) >= tpcldtop(hi)) aerocld_gap=tpaerobase(1)-tpcldtop(hi)
	        							IF (tpaerotop(1) < tpcldbase(hi)) aerocld_gap=tpcldbase(hi)-tpaerotop(1)
	        							IF (hi == 2) aerocld_mingap=aerocld_gap
	        							IF (hi > 2 .and. aerocld_gap < aerocld_mingap) aerocld_mingap=aerocld_gap

	        							IF ( aerocld_mingap < gap_threshold) Then 
	        							inaerocase_flag=4 
	        							Else
	        							isaerocase_flag=3
	        							EndIf
	        						EndDo
	        					    EndIF !end if a cloud layer above
	        					EndIf
	        			     EndIf ! endif a cloud below

	        			EndIf ! judge aerosol above at least one cloud layer
	        		EndIf ! end layer_gap1> 0.5
	     !   	!	print *, layer_gap1,si, sum(tpfrev_cldflag), sum(tpfrev_aeroflag), inaerocase_flag,isaerocase_flag
	        	EndIf ! end if cld > 2 and aero=1 

	     !   	! for multiple aerosol cases
	        	IF (count(tpcldtop > 0.0) == 1 .and. count(tpaerotop > 0.0) > 1) Then 
	        		IF (layer_gap1 < gap_threshold) inaerocase_flag=1
	        		IF (layer_gap1 >= gap_threshold) Then
	        			Naero=count(tpaerotop>0)
	        			Do hi=1, Naero
	        			IF (tpcldbase(1) > tpaerotop(hi)) aerocld_gap=tpcldbase(1)-tpaerotop(hi)
	        			IF (tpcldtop(1) < tpaerobase(hi)) aerocld_gap=tpaerobase(hi)-tpcldtop(1)
	        			IF (hi == 1) aerocld_mingap=aerocld_gap
	         			IF (hi > 1 .and. aerocld_gap < aerocld_mingap) aerocld_mingap=aerocld_gap
	        			EndDo

	        			IF (aerocld_mingap < gap_threshold) inaerocase_flag=5 !there is one-merge layer,aerosol can be above/below the merge layer
	        			IF (aerocld_mingap >= gap_threshold) Then ! aerosol and cloud is separated
	        				IF (tpcldbase(1) > tpaerotop(1)) then
	        					 if (Naero ==1) isaerocase_flag=1
	        					 if (Naero > 1) isaerocase_flag=4
	        				ElseIf (tpcldtop(1) < tpaerobase(Naero)) then 
	        					 if (Naero > 1) isaerocase_flag=5 
	        					 if (Naero ==1) isaerocase_flag=2 
	        				ElseIf (tpcldtop(1) < tpaerobase(1) .and. tpcldbase(1) > tpaerotop(Naero)) then
	        					 isaerocase_flag=6 
	        				EndIf
	        			EndIf !end aero-cld separated
	        		EndIf ! gap layer >0.5

	        	EndIf ! endif cld=1, aero>1
	     !   	
	        	IF (count(tpcldtop > 0.0) > 1 .and. count(tpaerotop > 0.0) > 1) Then 
	        		IF (layer_gap1 < gap_threshold) inaerocase_flag=1
	        		IF (layer_gap1 >=gap_threshold) Then 
	        			Naero=count(tpaerotop > 0.0)
	        			IF ((tpcldbase(count(tpcldtop > 0.0))-tpaerotop(1)) >= gap_threshold) Then
	        				isaerocase_flag=8
	        			ELSE IF ((tpaerobase(Naero)-tpcldtop(1)) >= gap_threshold) Then
	        				isaerocase_flag=7
	        			ELSE 
	        				isaerocase_flag=9
	        			EndIF
	        		EndIf ! end gap_threshold gt threshold
	        	EndIf
	     !   	!end cld > 1 & aero >1	
	        EndIF ! end aerosol-cloud separated cases

	   !===== finish cases judgement =================================================
	        IF (inaerocase_flag > 0 .and. tp_tau > 0.0) Then 
	        		incld_aero_numh(lon_scp,lat_scp,inaerocase_flag)= &
	        		incld_aero_numh(lon_scp,lat_scp,inaerocase_flag) +1

					tp_beta_num=0
					where(tp_beta_prof .gt. 0 .and. &
					tp_beta_prof .lt. 0.05) tp_beta_num=1

				!	tpbackscat_pdf=0
				!	Do phi=1, NCOLP
				!		if (tp_beta_prof(phi) > 0 .and. tp_beta_prof(phi) < 0.05) then
				!		aerosca_scp=nint((alog10(tp_beta_prof(phi))+4.5)/0.035) !-4.5--0	
			     !       IF (aerosca_scp < 1) aerosca_scp=1
				  !      IF (aerosca_scp > Nsca) aerosca_scp=Nsca	
				!		tpbackscat_pdf(phi,aerosca_scp)=tpbackscat_pdf(phi,aerosca_scp)+1
				!		endif
				!	EndDo

					
					IF (inaerocase_flag == 1) Then
					incld_aero_numv_one(lon_scp,lat_scp,:) = &
					incld_aero_numv_one(lon_scp,lat_scp,:) + tp_beta_num
					incld_aero_beta_profile_one(lon_scp,lat_scp,:)=&
					incld_aero_beta_profile_one(lon_scp,lat_scp,:)+&
					tp_beta_num*tp_beta_prof
				!	incld_aero_pdf_beta_profile_one(lon_scp,lat_scp,:,:)=&
				!	incld_aero_pdf_beta_profile_one(lon_scp,lat_scp,:,:)+ tpbackscat_pdf			
					EndIf
					IF (inaerocase_flag == 2) Then
					incld_aero_numv_belcld(lon_scp,lat_scp,:) = &
					incld_aero_numv_belcld(lon_scp,lat_scp,:) + tp_beta_num
					incld_aero_beta_profile_belcld(lon_scp,lat_scp,:)=&
					incld_aero_beta_profile_belcld(lon_scp,lat_scp,:)+&
					tp_beta_num*tp_beta_prof
				!	incld_aero_pdf_beta_profile_belcld(lon_scp,lat_scp,:,:)=&
				!	incld_aero_pdf_beta_profile_belcld(lon_scp,lat_scp,:,:)+ tpbackscat_pdf			
					EndIf
					IF (inaerocase_flag == 3 .or. inaerocase_flag == 4) Then
					incld_aero_numv_abvcld(lon_scp,lat_scp,:) = &
					incld_aero_numv_abvcld(lon_scp,lat_scp,:) + tp_beta_num
					incld_aero_beta_profile_abvcld(lon_scp,lat_scp,:)=&
					incld_aero_beta_profile_abvcld(lon_scp,lat_scp,:)+&
					tp_beta_num*tp_beta_prof
				!	incld_aero_pdf_beta_profile_abvcld(lon_scp,lat_scp,:,:)=&
				!	incld_aero_pdf_beta_profile_abvcld(lon_scp,lat_scp,:,:)+ tpbackscat_pdf			
					EndIf
					IF (inaerocase_flag == 5 .or. inaerocase_flag == 6) Then
					incld_aero_numv_other(lon_scp,lat_scp,:) = &
					incld_aero_numv_other(lon_scp,lat_scp,:) + tp_beta_num
					incld_aero_beta_profile_other(lon_scp,lat_scp,:)=&
					incld_aero_beta_profile_other(lon_scp,lat_scp,:)+&
					tp_beta_num*tp_beta_prof
				!	incld_aero_pdf_beta_profile_other(lon_scp,lat_scp,:,:)=&
				!	incld_aero_pdf_beta_profile_other(lon_scp,lat_scp,:,:)+ tpbackscat_pdf			
					EndIf
					

	        		IF (tp_tau >= 1.0) incld_aerotau1_numh(lon_scp,lat_scp,inaerocase_flag)=&
					incld_aerotau1_numh(lon_scp,lat_scp,inaerocase_flag) +1

	        		incld_aero_tau(lon_scp,lat_scp,inaerocase_flag) = &
	        		incld_aero_tau(lon_scp,lat_scp,inaerocase_flag) + tp_tau
	        		incld_aerotau_uncer(lon_scp,lat_scp,inaerocase_flag) = &
	        		incld_aerotau_uncer(lon_scp,lat_scp,inaerocase_flag) + tp_tauuncer

	     !   	
	        		aerotau_scp=nint((alog10(tp_tau)+4)/0.01)
	        		IF (aerotau_scp < 1) aerotau_scp=1
	        		IF (aerotau_scp > Ntau) aerotau_scp=Ntau
	        		pdf_incld_aero_tau(lon_scp,lat_scp,aerotau_scp,inaerocase_flag)=&
	        		pdf_incld_aero_tau(lon_scp,lat_scp,aerotau_scp,inaerocase_flag)+1

	     !   		!==== start to search the profile, filter out 80km, cirrus, extinction uncer and QC ======
	        		Naero=count(tpaerotop > 0.0) ! keep consistent with isolate80,cirrus filter
	        		Do hi=1,Naero

	        			IF (tpaerodepratio(hi) > 0.0 .and. tpaerobackscatt(hi) >0.0) then
	        			aerodep_scp=nint(tpaerodepratio(hi)/0.005)
	        			IF (aerodep_scp >= 0 .and. aerodep_scp < 1) aerodep_scp=1
	        			IF (aerodep_scp > Ndep) aerodep_scp=Ndep

	        			aerosca_scp=nint((alog10(tpaerobackscatt(hi))+4.5)/0.05)
	        			IF (aerosca_scp < 1) aerosca_scp=1
	        			IF (aerosca_scp > Nsca) aerosca_scp=Ndep

						IF (inaerocase_flag == 1) Then 
	        			incld_aero_scatdep_one(lon_scp,lat_scp,aerosca_scp,aerodep_scp)= &
	        			incld_aero_scatdep_one(lon_scp,lat_scp,aerosca_scp,aerodep_scp)+1
						EndIF
						IF (inaerocase_flag == 2) Then 
	        			incld_aero_scatdep_belcld(lon_scp,lat_scp,aerosca_scp,aerodep_scp)= &
	        			incld_aero_scatdep_belcld(lon_scp,lat_scp,aerosca_scp,aerodep_scp)+1
						EndIF
						IF (inaerocase_flag == 3 .or. inaerocase_flag ==4) Then 
	        			incld_aero_scatdep_abvcld(lon_scp,lat_scp,aerosca_scp,aerodep_scp)= &
	        			incld_aero_scatdep_abvcld(lon_scp,lat_scp,aerosca_scp,aerodep_scp)+1
						EndIF
						IF (inaerocase_flag == 5 .or. inaerocase_flag ==6) Then 
	        			incld_aero_scatdep_other(lon_scp,lat_scp,aerosca_scp,aerodep_scp)= &
	        			incld_aero_scatdep_other(lon_scp,lat_scp,aerosca_scp,aerodep_scp)+1
						EndIF

	        			aerolidratio_scp=nint(tpaerolidratio(hi)-10)
                        if (aerolidratio_scp < 1) aerolidratio_scp=1
                        if (aerolidratio_scp > Nlidratio) aerolidratio_scp=Nlidratio

	        			IF (tpaerocolratio(hi) > 0.0) Then
	        			aerocolratio_scp=nint(tpaerocolratio(hi)*100) ! 
	        			if (aerocolratio_scp < 1) aerocolratio_scp=1
	        			if (aerocolratio_scp > Ncolratio) aerocolratio_scp=Ncolratio

						IF (inaerocase_flag == 1) Then
	        			incld_aero_lidcol_one(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)=&
	        			incld_aero_lidcol_one(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)+1
						EndIF
						IF (inaerocase_flag == 2) Then
	        			incld_aero_lidcol_belcld(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)=&
	        			incld_aero_lidcol_belcld(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)+1
						EndIF
						IF (inaerocase_flag ==3 .or. inaerocase_flag ==4) Then
	        			incld_aero_lidcol_abvcld(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)=&
	        			incld_aero_lidcol_abvcld(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)+1
						EndIf
						IF (inaerocase_flag ==5 .or. inaerocase_flag ==6) Then
	        			incld_aero_lidcol_other(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)=&
	        			incld_aero_lidcol_other(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)+1
						EndIf
					
	        			EndIf ! end color ratio
	        			EndIf ! end depratio > 0, backscatt > 0
	        		EndDo ! end search the profile
	     !   		
	        EndIf ! end multiple-layer aerosol, merge-case and tp_tau > 0 

	        IF (isaerocase_flag > 0 .and. tp_tau > 0.0) Then 
	        		isolate_aero_numh(lon_scp,lat_scp,isaerocase_flag)= &
	        		isolate_aero_numh(lon_scp,lat_scp,isaerocase_flag) +1

					tp_beta_num=0
					where(tp_beta_prof .gt. 0 .and. &
					tp_beta_prof .lt. 0.05) tp_beta_num=1

				!	tpbackscat_pdf=0
				!	Do phi=1, NCOLP
				!		if (tp_beta_prof(phi) > 0 .and. tp_beta_prof(phi) < 0.05) then
				!		aerosca_scp=nint((alog10(tp_beta_prof(phi))+4.5)/0.035) !-4.5--0	
			     !       IF (aerosca_scp < 1) aerosca_scp=1
				  !      IF (aerosca_scp > Nsca) aerosca_scp=Nsca	
				!		tpbackscat_pdf(phi,aerosca_scp)=tpbackscat_pdf(phi,aerosca_scp)+1
				!		endif
				!	EndDo

					IF (isaerocase_flag == 1 .or. isaerocase_flag == 4 .or. isaerocase_flag ==8) Then
					isolate_aero_numv_belcld(lon_scp,lat_scp,:) = &
					isolate_aero_numv_belcld(lon_scp,lat_scp,:) + tp_beta_num
					isolate_aero_beta_profile_belcld(lon_scp,lat_scp,:)=&
					isolate_aero_beta_profile_belcld(lon_scp,lat_scp,:)+&
					tp_beta_num*tp_beta_prof
					
				!	isolate_aero_pdf_beta_profile_belcld(lon_scp,lat_scp,:,:)=&
				!	isolate_aero_pdf_beta_profile_belcld(lon_scp,lat_scp,:,:)+ &	
				!	tpbackscat_pdf
					EnDIf
					IF (isaerocase_flag == 2 .or. isaerocase_flag == 5 .or. isaerocase_flag ==7) Then
					isolate_aero_numv_abvcld(lon_scp,lat_scp,:) = &
					isolate_aero_numv_abvcld(lon_scp,lat_scp,:) + tp_beta_num
					isolate_aero_beta_profile_abvcld(lon_scp,lat_scp,:)=&
					isolate_aero_beta_profile_abvcld(lon_scp,lat_scp,:)+&
					tp_beta_num*tp_beta_prof

				!	isolate_aero_pdf_beta_profile_abvcld(lon_scp,lat_scp,:,:)=&
				!	isolate_aero_pdf_beta_profile_abvcld(lon_scp,lat_scp,:,:)+ &	
				!	tpbackscat_pdf

					EnDIf
					IF (isaerocase_flag == 3 .or. isaerocase_flag == 6 .or. isaerocase_flag ==9) Then
					isolate_aero_numv_other(lon_scp,lat_scp,:) = &
					isolate_aero_numv_other(lon_scp,lat_scp,:) + tp_beta_num
					isolate_aero_beta_profile_other(lon_scp,lat_scp,:)=&
					isolate_aero_beta_profile_other(lon_scp,lat_scp,:)+&
					tp_beta_num*tp_beta_prof

				
				!	isolate_aero_pdf_beta_profile_other(lon_scp,lat_scp,:,:)=&
				!	isolate_aero_pdf_beta_profile_other(lon_scp,lat_scp,:,:)+ &	
				!	tpbackscat_pdf

					EnDIf

	        		IF (tp_tau >= 1.0) Then
	        		 isolate_aerotau1_numh(lon_scp,lat_scp,isaerocase_flag)=&
					 isolate_aerotau1_numh(lon_scp,lat_scp,isaerocase_flag)+1
	        		EndIf

	        		isolate_aero_tau(lon_scp,lat_scp,isaerocase_flag) = &
	        			isolate_aero_tau(lon_scp,lat_scp,isaerocase_flag) + tp_tau
	        		isolate_aerotau_uncer(lon_scp,lat_scp,isaerocase_flag) = &
	        			isolate_aerotau_uncer(lon_scp,lat_scp,isaerocase_flag) + tp_tauuncer
	       		
	        		aerotau_scp=nint((alog10(tp_tau)+4)/0.01)
	       			IF (aerotau_scp < 1) aerotau_scp=1
	       			IF (aerotau_scp > Ntau) aerotau_scp=Ntau
	        		pdf_isolate_aero_tau(lon_scp,lat_scp,aerotau_scp,isaerocase_flag)= &
	        		pdf_isolate_aero_tau(lon_scp,lat_scp,aerotau_scp,isaerocase_flag)+1

	        		Naero=count(tpaerotop > 0.0)
	             	Do hi=1,Naero
	        
	     	   		IF (tpaerodepratio(hi) > 0.0 .and. tpaerobackscatt(hi) > 0.0) Then
	     	   		aerodep_scp=nint(tpaerodepratio(hi)/0.005)
	        		IF (aerodep_scp >= 0 .and. aerodep_scp < 1) aerodep_scp=1
	        		IF (aerodep_scp > Ndep) aerodep_scp=Ndep
	     	   		aerosca_scp=nint((alog10(tpaerobackscatt(hi))+4.5)/0.05)
	        		IF (aerosca_scp < 1) aerosca_scp=1
	       			IF (aerosca_scp > Nsca) aerosca_scp=Ndep
					IF (isaerocase_flag == 1 .or. isaerocase_flag == 4 .or. isaerocase_flag ==8) Then
	        			isolate_aero_scatdep_belcld(lon_scp,lat_scp,aerosca_scp,aerodep_scp)=&
	        			isolate_aero_scatdep_belcld(lon_scp,lat_scp,aerosca_scp,aerodep_scp)+1
					EnDIF
					IF (isaerocase_flag == 2 .or. isaerocase_flag == 5 .or. isaerocase_flag ==7) Then
	        			isolate_aero_scatdep_abvcld(lon_scp,lat_scp,aerosca_scp,aerodep_scp)=&
	        			isolate_aero_scatdep_abvcld(lon_scp,lat_scp,aerosca_scp,aerodep_scp)+1
					EnDIF
					IF (isaerocase_flag == 3 .or. isaerocase_flag == 6 .or. isaerocase_flag ==9) Then
	        			isolate_aero_scatdep_other(lon_scp,lat_scp,aerosca_scp,aerodep_scp)=&
	        			isolate_aero_scatdep_other(lon_scp,lat_scp,aerosca_scp,aerodep_scp)+1
					EnDIF

	       			aerolidratio_scp=nint(tpaerolidratio(hi)-10)
                    if (aerolidratio_scp < 1) aerolidratio_scp=1
                    if (aerolidratio_scp > Nlidratio) aerolidratio_scp=Nlidratio

	        		IF (tpaerocolratio(hi) > 0) Then
	        			aerocolratio_scp=nint(tpaerocolratio(hi)*100) ! 
	        			if (aerocolratio_scp < 1) aerocolratio_scp=1
	        			if (aerocolratio_scp > Ncolratio) aerocolratio_scp=Ncolratio

					IF (isaerocase_flag == 1 .or. isaerocase_flag == 4 .or. isaerocase_flag ==8) Then
	        			isolate_aero_lidcol_belcld(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)=&
	        			isolate_aero_lidcol_belcld(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)+1
					EndIf	        		
					IF (isaerocase_flag == 2 .or. isaerocase_flag == 5 .or. isaerocase_flag ==7) Then
	        			isolate_aero_lidcol_abvcld(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)=&
	        			isolate_aero_lidcol_abvcld(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)+1
					EndIf	        		
					IF (isaerocase_flag == 3 .or. isaerocase_flag == 6 .or. isaerocase_flag ==9) Then
	        			isolate_aero_lidcol_other(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)=&
	        			isolate_aero_lidcol_other(lon_scp,lat_scp,aerolidratio_scp,aerocolratio_scp)+1
					EndIf
					EndIf ! end colratio > 0
	        		EndIf ! end backscat > 0, depratio>0
	     	   		EndDo ! end search the profile
	     !   			
	     !   		!===== to get 2d pdf for aerosol above cloud ==================================
	     !   		cldtop_scp=nint(tpcldtop(1)/0.1)
	     !   		IF (cldtop_scp < 1) cldtop_scp=1
	     !   		IF (cldtop_scp > Ntop) cldtop_scp=Ntop

	     !   		aerocld_gapscp=nint((tpaerobase(Naero)-tpcldtop(1))/0.1)
	     !   		IF (aerocld_gapscp < 1) aerocld_gapscp=1
	     !   		IF (aerocld_gapscp > Ngap) aerocld_gapscp=Ngap
	
	     !   		
	     !   		IF (isaerocase_flag == 2 .and. tp_cldtau > 0.0) Then 
	     !   			isolate_aerogap1_2dpdf(cldtop_scp,aerocld_gapscp,aerotau_scp,1)=&
	     !   			+ isolate_aerogap1_2dpdf(cldtop_scp,aerocld_gapscp,aerotau_scp,1)+1
	     !   			isolate_aerogap1_meantau(cldtop_scp,aerocld_gapscp,1)=&
	     !   			+  isolate_aerogap1_meantau(cldtop_scp,aerocld_gapscp,1)+ tp_tau
	     !   		EndIf

	     !   		IF (isaerocase_flag == 5 .or. isaerocase_flag ==7) Then
	     !   			IF (tp_tau > 0.0 .and. tp_cldtau > 0.0) Then 
	     !   			isolate_aerogapn_2dpdf(cldtop_scp,aerocld_gapscp,aerotau_scp,1)=&
	     !   			+ isolate_aerogapn_2dpdf(cldtop_scp,aerocld_gapscp,aerotau_scp,1)+1
	     !   			isolate_aerogapn_meantau(cldtop_scp,aerocld_gapscp,1)=&
	     !   			+  isolate_aerogapn_meantau(cldtop_scp,aerocld_gapscp,1)+ tp_tau
	     !   			EndIf
	     !   		EndIf
	     !   		!======= to get aerosol below cloud  ==
	     !   		cldbase_scp=nint(tpcldbase(count(tpcldbase > 0))/0.1)
	     !   		IF (cldbase_scp < 1) cldbase_scp=1
	     !   		IF (cldbase_scp > Ntop) cldbase_scp=Ntop

	     !   		aerocld_gapscp=nint((tpcldbase(count(tpcldbase > 0))-tpaerotop(1))/0.1)
	     !   		IF (aerocld_gapscp < 1) aerocld_gapscp=1
	     !   		IF (aerocld_gapscp > Ngap) aerocld_gapscp=Ngap

	     !   		IF (isaerocase_flag == 1 .and. tp_cldtau > 0.0) Then 
	     !   			isolate_aerogap1_2dpdf(cldbase_scp,aerocld_gapscp,aerotau_scp,2)=& ! 2 FOR ABOVE CLOUD
	     !   			+ isolate_aerogap1_2dpdf(cldbase_scp,aerocld_gapscp,aerotau_scp,2)+1
	     !   			isolate_aerogap1_meantau(cldbase_scp,aerocld_gapscp,2)=&
	     !   			+  isolate_aerogap1_meantau(cldbase_scp,aerocld_gapscp,2)+ tp_tau
	     !   		EndIf	

	     !   		IF (isaerocase_flag == 4 .or. isaerocase_flag ==8 ) Then 
	     !   			IF (tp_tau > 0.0 .and. tp_cldtau > 0.0) Then
	     !   			isolate_aerogapn_2dpdf(cldbase_scp,aerocld_gapscp,aerotau_scp,2)=&
	     !   			+ isolate_aerogapn_2dpdf(cldbase_scp,aerocld_gapscp,aerotau_scp,2)+1
	     !   			isolate_aerogapn_meantau(cldbase_scp,aerocld_gapscp,2)=&
	     !   			+ isolate_aerogapn_meantau(cldbase_scp,aerocld_gapscp,2)+ tp_tau
	     !   			!print *,cldbase_scp,aerocld_gapscp,aerotau_scp
	     !   			EndIf
	     !   		EndIf	
	     !   		!=== to investigate transmittance ====
	     !   		IF (tp_cldtau > 0.0 .and. count(tptrans > 0.0) > 0) Then
	     !   			up_trans=0.0
	     !   			up_transerr=0.0
	     !   		
	     !   			Ntrans=count(tptrans > 0.0)
	     !   			Do hi=1,NCOL 
	     !   				if (tptrans(hi) > 0 .and. tptrans(hi) <= 1.0) then
	     !   					if (up_trans == 0) then
	     !   						up_trans=tptrans(hi)
	     !   						up_transerr=(tptrans_err(hi)/tptrans(hi))**2
	     !   					else
	     !   						up_trans=up_trans*tptrans(hi)

	     !   				 		up_transerr=up_transerr+(tptrans_err(hi)/tptrans(hi))**2
	     !   					endif
	     !   				endif
	     !   			EndDo
	     !   			up_transerr=sqrt(up_transerr*up_trans*up_trans)
	     !   		
	     !   			if (up_trans > 0.0) then	
	     !   			aerotau_cldtran(aerotau_scp,isaerocase_flag)=&
	     !   			aerotau_cldtran(aerotau_scp,isaerocase_flag)+up_trans
	     !   			aerotau_cldtranerr(aerotau_scp,isaerocase_flag)=&
	     !   			aerotau_cldtranerr(aerotau_scp,isaerocase_flag)+up_transerr
	     !   			aerotau_cldtran_num(aerotau_scp,isaerocase_flag)=&
	     !   			aerotau_cldtran_num(aerotau_scp,isaerocase_flag)+1
	     !   			endif
	     !   	    EndIF

	        EndIf ! end isolate_flag >0,no merge-case and tp_tau>0 

	        EndIf ! IF aerosol-cloud overlp 
	
	        EndIf ! day-night flag, energy flag, land-sea flag
!			print *, si,tp_tau,aeroonly_flag,inaerocase_flag,isaerocase_flag
			!print *,filter_extqc,filtercad,filter80,filterci
			!print *, tpcad
			!print *,min_laser_energy(1,si)
!			write(1000,*) aeroonly_flag,inaerocase_flag,isaerocase_flag
			
	        Enddo ! end swath
!			close(1000)
			
			!print *,maxval(aero_only_scatdep)
	   		!print *,myid,sum(aero_only_lidcol),'in calculate'          
	   end
