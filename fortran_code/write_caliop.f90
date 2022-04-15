
        subroutine write_caliop(wfname)!,total_aero_only_scatdep,&
               ! total_aero_only_beta_profile)!,&
!                total_aero_only_lidcol,&
                !total_aero_only_colratio)

        use global, only : total_aero_only_scatdep,total_aero_only_beta_profile,&
        total_aero_only_numv,&
        Nsca,Ndep,Ntau,dimh,dimx,dimy,latbin_res,lonbin_res,Ncolratio,Nlidratio,&
		Nincld,Nisolate,&
        total_aero_only_numh,total_aero_only_tau,total_aero_onlytau_uncer,&
        total_aerotau1_only_numh,total_obsnumh,total_obsnumv,&
        total_opaquecld_numh,&
		total_nocld_noaero_numh,&
		total_cld_noaero_numh,&
        totalpdf_aero_only_tau,&
		total_aero_only_lidcol,&
		total_incld_aero_numh,&
		total_incld_aero_numv_one,&
		total_incld_aero_numv_belcld,&
		total_incld_aero_numv_abvcld,&
		total_incld_aero_numv_other,&
		total_incld_aero_beta_profile_one,&
		total_incld_aero_beta_profile_belcld,&
		total_incld_aero_beta_profile_abvcld,&
		total_incld_aero_beta_profile_other,&
		total_incld_aerotau1_numh,&
		total_incld_aero_tau,total_incld_aerotau_uncer,&
		totalpdf_incld_aero_tau,&
		total_incld_aero_scatdep_one,&
		total_incld_aero_scatdep_belcld,&
		total_incld_aero_scatdep_abvcld,&
		total_incld_aero_scatdep_other,&
		total_incld_aero_lidcol_one,&
		total_incld_aero_lidcol_belcld,&
		total_incld_aero_lidcol_abvcld,&
		total_incld_aero_lidcol_other,&
		total_isolate_aero_numh,&
		total_isolate_aerotau1_numh,&
		total_isolate_aero_tau,&
		total_isolate_aerotau_uncer,&
		totalpdf_isolate_aero_tau,&
		total_isolate_aero_numv_abvcld,&
		total_isolate_aero_numv_belcld,&
		total_isolate_aero_numv_other,&
		total_isolate_aero_beta_profile_abvcld,&		
		total_isolate_aero_beta_profile_belcld,&		
		total_isolate_aero_beta_profile_other,&		
		total_isolate_aero_scatdep_belcld,&
		total_isolate_aero_scatdep_abvcld,&
		total_isolate_aero_scatdep_other,&
		total_isolate_aero_lidcol_belcld,&
		total_isolate_aero_lidcol_abvcld,&
		total_isolate_aero_lidcol_other,&
		total_filtercad_num,&
!		total_filter_aod_num,&
		total_filterci_num,&
		total_filter_extqc_num,&
		total_filter_allnum

        implicit none

        !******* Function declaration.**************************************
    integer sfstart,sfcreate, sfsnatt, sfwdata, sfendacc, sfend, &
            sfsattr

    character(len=200) :: wfname 
    character(len=50) :: SDS_NAME

    integer  ::  RANK
    integer :: parameter,DFACC_CREATE=4,DFNT_INT16=22,&
          DFNT_INT32=24,&
          DFNT_FLOAT32=5,DFNT_CHAR8=4,DFNT_FLOAT=5,DFNT_INT8=21
    integer :: fid, sds_id, status
    integer :: start ( 4 ), edges ( 4 ), stride ( 4 ),dim_sizes(4)
    integer :: i, j,k
    real :: miss_value,offset,factor,datarange(2)

    real :: wlon(dimx), wlat(dimy),height(dimh), ave_aero_cld_tau(dimx,dimy,6)

	FORALL (i=1:dimx) wlon(i)=(i-1)*lonbin_res-180
        FORALL (j=1:dimy) wlat(j)=(j-1)*latbin_res-90
	FORALL (i=1:dimh) height(i)=25-i*0.25

    fid = sfstart( wfname, DFACC_CREATE )
    IF (fid==-1) then
         print *,'process stop at writing file: ',wfname
         stop
    ENDIF

    RANK=1

    dim_sizes(1) = dimx
    edges  ( 1 ) = dimx
    start(1)=0
    stride(1)=1

    SDS_NAME="longitude"
    dim_sizes(1)=dimx
    edges  ( 1 ) = dimx
    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    factor=1.0
    offset=0.0
    status=sfwdata ( sds_id, start, stride, edges, wlon )
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,9,'longitude')
    status=sfsattr(sds_id,'units',DFNT_CHAR8,6,'degree')
    status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
    status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)
    datarange(1)=-180.0
    datarange(2)=180.0
    status=sfsnatt(sds_id,'range',DFNT_FLOAT32,2,datarange)
    status = sfendacc ( sds_id )

    dim_sizes(1)=dimy
    edges  ( 1 ) = dimy
    SDS_NAME="latitude"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    factor=1.0
    offset=0.0
    status=sfwdata ( sds_id, start, stride, edges, wlat )
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,8,'latitude')
    status=sfsattr(sds_id,'units',DFNT_CHAR8,6,'degree')
    status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
    status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)
    datarange(1)=-90.0
    datarange(2)=90.0
    status=sfsnatt(sds_id,'range',DFNT_FLOAT32,2,datarange)
    status = sfendacc(sds_id)

    RANK=2
    dim_sizes(1)=dimx
    dim_sizes(2)=dimy
    edges(1)=dimx
    edges(2)=dimy
    start(1)=0
    start(2)=0
    stride(1)=1
    stride(2)=1

    factor=0.0
    miss_value=-99.0
    offset=0.0


	SDS_NAME='all_filter'
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_filter_allnum)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly number of aerosol profiles excluded number, one profile cloud include two filters')
    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
    status = sfendacc ( sds_id )


	SDS_NAME='Lowcad_filter'
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_filtercad_num)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly number of aerosol lowcadnumber')
    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
    status = sfendacc ( sds_id )

	SDS_NAME='qcext_filter'
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_filter_extqc_num)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly number of qcext')
    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
    status = sfendacc ( sds_id )

!	SDS_NAME='largeaod_filter'
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges,total_filter_aod_num)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
!             'Monthly number of potential cloud')
!    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
!    status = sfendacc ( sds_id )

	SDS_NAME='cirrus_filter'
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_filterci_num)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly number of potential cirrus cloud')
    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
    status = sfendacc ( sds_id )

    SDS_NAME="opaque_cloud_numh"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_opaquecld_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly number of opaque cloud, no aerosol detected')
    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
    status = sfendacc ( sds_id )

    SDS_NAME="nocloud_noaero_numh"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_nocld_noaero_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly number of no cloud, no aerosol detected')
    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
    status = sfendacc ( sds_id )

    SDS_NAME="cloud_noaero_numh"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_cld_noaero_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly number of cloud, no aerosol detected')
    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
    status = sfendacc ( sds_id )


    SDS_NAME="obs_numh"
    sds_id=sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_obsnumh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average observation number')
    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
    status = sfendacc ( sds_id )

    SDS_NAME="aero_only_numh"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_aero_only_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol only number')
    status = sfendacc ( sds_id )


    SDS_NAME="aero_only_taugt1_numh"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_aerotau1_only_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'number of aerosol with tau >1, merge single and multi-lay aerosol')
    status = sfendacc ( sds_id )

    SDS_NAME="aero_only_tau"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_aero_only_tau/total_aero_only_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol only tau')
    status = sfendacc ( sds_id )

	SDS_NAME="aero_onlytau_uncer"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_aero_onlytau_uncer/total_aero_only_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol only tau uncertainty')
	status = sfendacc ( sds_id )

!=================================================================
    RANK=3
    dim_sizes(1)=dimx
    dim_sizes(2)=dimy
    dim_sizes(3)=dimh
    edges(1)=dimx
    edges(2)=dimy
    edges(3)=dimh
    start(1)=0
    start(2)=0
    start(3)=0
    stride(1)=1
    stride(2)=1
    stride(3)=1

    SDS_NAME="obs_numv"
    sds_id=sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_obsnumv)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average observation number')
    status = sfendacc ( sds_id )

    SDS_NAME="aero_only_numv"
    sds_id=sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_aero_only_numv)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aero_only number quanlity')
    status = sfendacc ( sds_id )

    SDS_NAME="aero_only_backscatter_profile"
    sds_id =sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_aero_only_beta_profile/total_aero_only_numv)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol only backscatter profile (km-1 sr-1)')
    status = sfendacc ( sds_id )

    SDS_NAME="incld_aero_numv_one"
    sds_id=sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aero_numv_one)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aero_incld number quanlity')
    status = sfendacc ( sds_id )
	
    SDS_NAME="incld_aero_numv_belcld"
    sds_id=sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aero_numv_belcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aero_incld number quanlity')
    status = sfendacc ( sds_id )

    SDS_NAME="incld_aero_numv_abvcld"
    sds_id=sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aero_numv_abvcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aero_incld number quanlity')
    status = sfendacc ( sds_id )

    SDS_NAME="incld_aero_numv_other"
    sds_id=sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aero_numv_other)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aero_incld number quanlity')
    status = sfendacc ( sds_id )

    SDS_NAME="incld_aero_backscatter_profile_one"
    sds_id =sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aero_beta_profile_one/total_incld_aero_numv_one)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol backscatter profile (km-1 sr-1)')
    status = sfendacc ( sds_id )

    SDS_NAME="incld_aero_backscatter_profile_abvcld"
    sds_id =sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aero_beta_profile_abvcld/total_incld_aero_numv_abvcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol backscatter profile (km-1 sr-1)')
    status = sfendacc ( sds_id )

    SDS_NAME="incld_aero_backscatter_profile_belcld"
    sds_id =sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aero_beta_profile_belcld/total_incld_aero_numv_belcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol backscatter profile (km-1 sr-1)')
    status = sfendacc ( sds_id )

    SDS_NAME="incld_aero_backscatter_profile_other"
    sds_id =sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aero_beta_profile_other/total_incld_aero_numv_other)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol backscatter profile (km-1 sr-1)')
    status = sfendacc ( sds_id )


    SDS_NAME="isolate_aero_numv_belcld"
    sds_id=sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_isolate_aero_numv_belcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aero_only number quanlity')
    status = sfendacc ( sds_id )

    SDS_NAME="isolate_aero_numv_abvcld"
    sds_id=sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_isolate_aero_numv_abvcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aero_only number quanlity')
    status = sfendacc ( sds_id )

    SDS_NAME="isolate_aero_numv_other"
    sds_id=sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_isolate_aero_numv_other)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aero_only number quanlity')
    status = sfendacc ( sds_id )

    SDS_NAME="isolate_aero_backscatter_profile_belcld"
    sds_id =sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_isolate_aero_beta_profile_belcld/total_isolate_aero_numv_belcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol only backscatter profile (km-1 sr-1)')
    status = sfendacc ( sds_id )

    SDS_NAME="isolate_aero_backscatter_profile_abvcld"
    sds_id =sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_isolate_aero_beta_profile_abvcld/total_isolate_aero_numv_abvcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol only backscatter profile (km-1 sr-1)')
    status = sfendacc ( sds_id )

    SDS_NAME="isolate_aero_backscatter_profile_other"
    sds_id =sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_isolate_aero_beta_profile_other/total_isolate_aero_numv_other)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol only backscatter profile (km-1 sr-1)')
    status = sfendacc ( sds_id )

    dim_sizes(3)=Ntau
    edges  ( 3 )=Ntau
    SDS_NAME="pdf_aero_only_tau"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges, totalpdf_aero_only_tau )
    status = sfendacc ( sds_id )

    dim_sizes(3)=Nincld
    edges  ( 3 )=Nincld
    SDS_NAME="incld_aero_numh"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aero_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,220,&
             '1-onelayer,2-cloud above aero-cld,3-cloud below aero-cld,&
			4-aero-cld between cloud,5-multi aero, one merge layer,&
			6-mult aero, multi aero')
    status = sfendacc ( sds_id )

    SDS_NAME="incld_aero_taugt1_numh"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aerotau1_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'number of aerosol with tau >1')
    status = sfendacc ( sds_id )

    SDS_NAME="incld_aero_tau"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_incld_aero_tau/total_incld_aero_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol only tau')
    status = sfendacc ( sds_id )

	SDS_NAME="incld_aerotau_uncer"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata(sds_id,start,stride,edges,total_incld_aerotau_uncer/total_incld_aero_numh)
	status = sfendacc (sds_id)

    dim_sizes(3)=Nisolate
    edges  ( 3 )=Nisolate
    SDS_NAME="isolate_aero_numh"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_isolate_aero_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,220,&
             '1-cld above aero, 2-aero above cloud, 3-aero inbetween cld,&
			4-one cld above multi aero, 5-one cld below multi aeor,&
			6-one cld between multi aero, 7-multi aero above multi cld,&
			8-multi aero below multi cld, 9-multi aero and multi cloud,other')
    status = sfendacc (sds_id)

    SDS_NAME="isolate_aero_taugt1_numh"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges,total_isolate_aerotau1_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'number of aerosol with tau >1')
    status = sfendacc ( sds_id )

    SDS_NAME="isolate_aero_tau"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_isolate_aero_tau/total_isolate_aero_numh)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly aerosol only tau')
    status = sfendacc ( sds_id )

	SDS_NAME="isolate_aerotau_uncer"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
    status=sfwdata(sds_id,start,stride,edges,total_isolate_aerotau_uncer/total_isolate_aero_numh)
	status = sfendacc (sds_id)
	!======================================================

    RANK=4    
    dim_sizes(3)=Nsca
    dim_sizes(4)=Ndep
    edges(3)=Nsca
    edges(4)=Ndep
    start(1)=0
    start(2)=0
    start(3)=0
    start(4)=0
    stride(1)=1
    stride(2)=1
    stride(3)=1
    stride(4)=1

    SDS_NAME="aero_only_backscat_depratio"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_aero_only_scatdep)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'backscatter vs depolarization ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="incld_aero_backscat_depratio_one"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_incld_aero_scatdep_one)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'onelayer aero-cld backscatter vs depolarization ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="incld_aero_backscat_depratio_belcld"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_incld_aero_scatdep_belcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'belowcld aero-cld backscatter vs depolarization ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="incld_aero_backscat_depratio_abvcld"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_incld_aero_scatdep_abvcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'abovecld aero-cld backscatter vs depolarization ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="incld_aero_backscat_depratio_other"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_incld_aero_scatdep_other)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'other aero-cld backscatter vs depolarization ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="isolate_aero_backscat_depratio_belcld"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_isolate_aero_scatdep_belcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'belowcld aero-cld backscatter vs depolarization ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="isolate_aero_backscat_depratio_abvcld"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_isolate_aero_scatdep_abvcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'abovecld aero-cld backscatter vs depolarization ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="isolate_aero_backscat_depratio_other"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_isolate_aero_scatdep_other)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'other aero-cld backscatter vs depolarization ratio')
    status=sfendacc ( sds_id )

    dim_sizes(3)=Nlidratio
    dim_sizes(4)=Ncolratio
    edges(3)=Nlidratio
    edges(4)=Ncolratio

    SDS_NAME="aero_only_lidratio_colratio"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_aero_only_lidcol)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'lidar ratio vs color ratio')
    status=sfendacc (sds_id)

    SDS_NAME="incld_aero_lidratio_colratio_one"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_incld_aero_lidcol_one)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'lidar ratio vs color ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="incld_aero_lidratio_colratio_belcld"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_incld_aero_lidcol_belcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'lidar ratio vs color ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="incld_aero_lidratio_colratio_abvcld"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_incld_aero_lidcol_abvcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'lidar ratio vs color ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="incld_aero_lidratio_colratio_other"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_incld_aero_lidcol_other)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'lidar ratio vs color ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="isolate_aero_lidratio_colratio_belcld"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_isolate_aero_lidcol_belcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'lidar ratio vs color ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="isolate_aero_lidratio_colratio_abvcld"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_isolate_aero_lidcol_abvcld)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'lidar ratio vs color ratio')
    status=sfendacc ( sds_id )

    SDS_NAME="isolate_aero_lidratio_colratio_other"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata(sds_id, start, stride, edges,total_isolate_aero_lidcol_other)
    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'lidar ratio vs color ratio')
    status=sfendacc ( sds_id )


    dim_sizes(3)=Ntau
    dim_sizes(4)=Nincld
    edges(3)=Ntau
    edges(4)=Nincld
    SDS_NAME="pdf_incld_aero_tau"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges, totalpdf_incld_aero_tau )
    status = sfendacc ( sds_id )

    dim_sizes(3)=Ntau
    dim_sizes(4)=Nisolate
    edges(3)=Ntau
    edges(4)=Nisolate

    SDS_NAME="pdf_isolate_aero_tau"
    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
    status=sfwdata (sds_id, start, stride, edges, totalpdf_isolate_aero_tau )
    status = sfendacc ( sds_id )

    !=======================================================================


!    SDS_NAME="isolate_aerosol_taugt1_num"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id,start,stride,edges,total_isolate_aerotau1_numh)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,150,&
!             'Numbers for aerosol with tau >= 1')
!	status = sfendacc ( sds_id )
!
!
!!	SDS_NAME="isolate_aerosol_depratio"
!!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!!    status=sfwdata(sds_id,start,stride,edges,total_isolate_aero_depratio/total_isolate_aero_numh)
!!	status = sfendacc (sds_id)
!
!!	SDS_NAME="isolate_aerosol_backscatt"
!!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!!    status=sfwdata(sds_id,start,stride,edges,total_isolate_aero_backscatt/total_isolate_aero_numh)
!!	status = sfendacc (sds_id)
!
!    dim_sizes(3)=Nincld
!    edges(3) = Nincld
!
!	SDS_NAME="incloud_aerosol_taugt1_num"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id,start,stride,edges,total_incld_aerotau1_numh)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,150,&
!             'number of aerosols with tau >= 1') 
!	status = sfendacc ( sds_id )
!
!
!!	SDS_NAME="incloud_aerosol_depratio"
!!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!!    status=sfwdata(sds_id,start,stride,edges,total_incld_aero_depratio/total_incld_aero_numh)
!!	status = sfendacc (sds_id)
!
!!	SDS_NAME="incloud_aerosol_backscatt"
!!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!!    status=sfwdata(sds_id,start,stride,edges,total_incld_aero_backscatt/total_incld_aero_numh)
!!	status = sfendacc(sds_id)
!
!	
!!	SDS_NAME="aerosol_only_depratio"
!!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!!    status=sfwdata (sds_id, start, stride, edges,total_aero_only_depratio/total_aero_only_numh)
!!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
!!             'Monthly aerosol only tau')
!!	status = sfendacc ( sds_id )
!
!!	SDS_NAME="aerosol_only_backscatt"
!!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!!    status=sfwdata (sds_id, start, stride, edges,total_aero_only_backscatt/total_aero_only_numh)
!!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
!!             'Monthly aerosol only tau')
!!	status = sfendacc ( sds_id )
!
!    dim_sizes(1)=Ntop
!	dim_sizes(2)=Ntop
!    dim_sizes(3)=Ntau
!    edges(1)=Ntop
!    edges(2)=Ntop
!    edges(3)=Ntau
!
!    SDS_NAME="top_base_2dpdf_aeroonly"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata (sds_id, start, stride, edges,total_aero_only_2dpdf)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'aero base vs top for aero only, including all layers')
!	status = sfendacc ( sds_id )
!
!	dim_sizes(2)=Ngap
!	dim_sizes(3)=2
!    edges  ( 2 )=Ngap
!    edges  ( 3 )=2
!    SDS_NAME="cldaero_gap_meantau_oneaero"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata ( sds_id, start, stride, edges,total_isolate_aerogap1_meantau)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,250,'for single-layer aero: 1.cloudtop vs aero-cloud gap(aero above);&
!		2 cloudbase vs aero-cloud gap (aero below) ')
!	status = sfendacc ( sds_id )
!
!    SDS_NAME="cldaero_gap_meantau_multiaero"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata (sds_id, start, stride, edges,total_isolate_aerogapn_meantau)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,250,'for single-layer aero: 1.cloudtop vs aero-cloud gap(aero above);&
!		2 cloudbase vs aero-cloud gap (aero below) ')
!	status = sfendacc (sds_id)
!
!
!    dim_sizes(3)=Nisolate
!    edges(3)=Nisolate
!    SDS_NAME="isolate_aero_backscat_depratio"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges,total_isolate_aero_scatdep)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'for 9 groups of aerosols')
!	status=sfendacc ( sds_id )
!
!    dim_sizes(3)=Nincld
!    edges(3)=Nincld
!    SDS_NAME="incld_aero_backscat_depratio"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges,total_incld_aeroall_scatdep)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'for 6 groups of aerosols,includ all aerosol in the column')
!	status=sfendacc ( sds_id )
!
!	dim_sizes(1)=Ntau
!    edges  ( 1 )=Ntau
!	dim_sizes(2)=Nisolate
!    edges  ( 2 )=Nisolate
!	dim_sizes(3)=2
!    edges  ( 3 )=2 ! for lsflag
!
!    SDS_NAME="pdf_isolate_aero_tau"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata ( sds_id, start, stride, edges, totalpdf_isolate_aero_tau)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,60,'1-oean,2-land')
!	status = sfendacc ( sds_id )
!
!    SDS_NAME="isolate_aero_tauvsuncer"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges, totaluncer_isolate_aerotau)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,160,'1-oean,2-land,divided by pdf to get ave')
!	status = sfendacc ( sds_id )
!
!    SDS_NAME="isolate_cldtau_vsaerotau"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges, total_isolate_cldtau)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,160,'1-oean,2-land,divided by pdf to get ave')
!	status = sfendacc ( sds_id )
!
!    SDS_NAME="isolate_cldtauerr_vsaerotau"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges, total_uncer_isolate_cldtau)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,160,'1-oean,2-land,divided by pdf to get ave')
!	status = sfendacc ( sds_id )
!
!	dim_sizes(1)=Ndep
!    edges  ( 1 )=Ndep
!    SDS_NAME="pdf_isolate_aero_depratio"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata ( sds_id, start, stride, edges, totalpdf_isolate_aero_depratio)
!	status = sfendacc ( sds_id )
!
!	dim_sizes(1)=Nsca
!    edges  ( 1 )=Nsca
!    SDS_NAME="pdf_isolate_aero_backscatt"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata ( sds_id, start, stride, edges, totalpdf_isolate_aero_backscatt)
!	status = sfendacc ( sds_id )
!
!	dim_sizes(1)=Ntau
!    edges  ( 1 )=Ntau
!	dim_sizes(2)=Nincld
!    edges  ( 2 )=Nincld
!    SDS_NAME="pdf_incld_aero_tau"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges, totalpdf_incld_aero_tau)
!	status = sfendacc (sds_id)
!
!    SDS_NAME="incld_aero_tauvsuncer"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges, totaluncer_incld_aerotau)
!	status = sfendacc ( sds_id )
!
!    SDS_NAME="incld_cldtau_vsaerotau"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges, total_incld_cldtau)
!	status = sfendacc ( sds_id )
!
!    SDS_NAME="incld_cldtauerr_vsaerotau"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges, total_uncer_incld_cldtau)
!	status = sfendacc ( sds_id )
!
!	dim_sizes(1)=Ndep
!    edges  ( 1 )=Ndep
!    SDS_NAME="pdf_incld_aero_depratio"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata ( sds_id, start, stride, edges, totalpdf_incld_aero_depratio)
!	status = sfendacc ( sds_id )
!
!	dim_sizes(1)=Nsca
!    edges  ( 1 )=Nsca
!    SDS_NAME="pdf_incld_aero_backscatt"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata ( sds_id, start, stride, edges, totalpdf_incld_aero_backscatt)
!	status = sfendacc ( sds_id )
!
!
!    SDS_NAME="aero_only_tauvsuncer"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges, totaluncer_aero_only_tau )
!	status = sfendacc(sds_id)
!
!	dim_sizes(1)=Ndep
!    edges  ( 1 )=Ndep
!    SDS_NAME="pdf_aero_only_depratio"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata ( sds_id, start, stride, edges, totalpdf_aero_only_depratio)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,'number at last bin for negative deporalization ratio')
!	status = sfendacc ( sds_id )
!
!
!
!	dim_sizes(2)=Nisolate
!    edges  (2)=Nisolate
!    SDS_NAME="isolate_aero_lidar_ratio"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata ( sds_id, start, stride, edges, total_isolate_aero_lidratio)
!	status = sfendacc ( sds_id )
!	
!	dim_sizes(2)=Nincld
!    edges  (2)=Nincld
!    SDS_NAME="incld_aero_lidar_ratio"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata (sds_id, start, stride, edges, total_incld_aeroall_lidratio)
!	status = sfendacc (sds_id )
!
! 	RANK=4
!	dim_sizes(1)= Nlidratio
!    edges  ( 1 )= Nlidratio
!	dim_sizes(2)= Ncolratio
!    edges  ( 2 )= Ncolratio
!	dim_sizes(3)= 2
!    edges  ( 3 )= 2
!	dim_sizes(4)= 2
!    start(1)=0
!    start(2)=0
!    start(3)=0
!    start(4)=0
!    stride(1)=1
!    stride(2)=1
!    stride(3)=1
!    stride(4)=1
!    edges  ( 4 )= 2
!
!	dim_sizes(1)= Nlidratio
!    edges  ( 1 )= Nlidratio
!	dim_sizes(2)= Ncolratio
!    edges  ( 2 )= Ncolratio
!	dim_sizes(3)= Nisolate 
!    edges  ( 3 )= Nisolate
!	dim_sizes(4)= 2
!    edges  ( 4 )= 2
!    SDS_NAME="isolate_aero_lidvscol_ratio"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges, total_isolate_aero_colratio)
!	status = sfendacc(sds_id)
!
!	dim_sizes(3)= Nincld 
!    edges  ( 3 )= Nincld
!	dim_sizes(4)= 2
!    edges  ( 4 )= 2
!    SDS_NAME="incld_aero_lidvscol_ratio"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges, total_incld_aeroall_colratio)
!	status = sfendacc(sds_id)
!
!	!===========================================================
!    dim_sizes(1)=dimx
!    dim_sizes(2)=dimy
!    dim_sizes(3)=7
!    dim_sizes(4)=Nincld
!    edges(1)=dimx
!    edges(2)=dimy
!    edges(3)=7
!    edges(4)=Nincld
!
!	SDS_NAME="incloud_aerosol_cloudphase_num"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id,start,stride,edges,total_incld_aero_cldphase_numh)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,250,&
!             '1-iceonly,2-undetermined, 3-wateronly,4-ice-water,5-ice-under case,6-water-under,7,ice-water-under ')
!    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
!	status = sfendacc ( sds_id )
!
!	dim_sizes(4)=Nisolate
!	edges(4)=Nisolate
!	SDS_NAME="isolate_aerosol_cloudphase_num"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id,start,stride,edges,total_isolate_aero_cldphase_numh)
!	status = sfendacc ( sds_id )
!
!    dim_sizes(1)=Ntop
!    dim_sizes(2)=Ngap
!    dim_sizes(3)=Ntau
!    dim_sizes(4)=2
!    edges(1)=Ntop
!    edges(2)=Ngap
!    edges(3)=Ntau
!    edges(4)=2
!
!    SDS_NAME="cldaero_gap_2dpdf_oneaero"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id, start, stride, edges,total_isolate_aerogap1_2dpdf)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,250,'for single-layer aero: 1.cloudtop vs aero-cloud gap(aero above);&
!		2 cloudbase vs aero-cloud gap (aero below) ')
!	status = sfendacc (sds_id)
!
!    SDS_NAME="cldaero_gap_2dpdf_multiaero"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata (sds_id, start, stride, edges,total_isolate_aerogapn_2dpdf)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,250,'for multi-layer aero: 1.cloudtop vs aero-cloud gap(aero above);&
!		2 cloudbase vs aero-cloud gap (aero below) ')
!	status = sfendacc ( sds_id )
!
!
!    dim_sizes(1)=dimx
!    dim_sizes(2)=dimy
!    dim_sizes(3)=Nisolate
!    dim_sizes(4)=2
!    edges(1)=dimx
!    edges(2)=dimy
!    edges(3)=Nisolate
!    edges(4)=2
!	SDS_NAME="isolate_aerosol_num"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id,start,stride,edges,total_isolate_aero_numh)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,350,&
!        '1-cld above sig-aero,2-cld below sig-aero, &
!		 3-sig-aero between cloud,&
!		 4,mult-aero,one-cld above,5-multaero,one-cld below,&
!		 6,mult-aero,one-cld inbetween,7,mulaero,mulcldd,aeroabove,&
!		 8,multaero,multcld,aerobelow,9,multaero,multicld,others')
!    status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
!	status = sfendacc ( sds_id )
!
!	SDS_NAME="isolate_aerosol_negativetau_num"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id,start,stride,edges,totalisolate_negativetau_numh)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,250,&
!             'total isolate num minus negative tau to calculate ave tau')
!	status=sfendacc ( sds_id )
!
!	SDS_NAME="isolate_aerosol_tau"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata(sds_id,start,stride,edges,total_isolate_aero_tau/total_isolate_aero_numh)
!	status = sfendacc (sds_id)
!
!
!    dim_sizes(3)=Nincld
!    edges(3)=Nincld
!	SDS_NAME="incloud_aerosol_num"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id,start,stride,edges,total_incld_aero_numh)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,250,&
!             '1-aero-cld,2-cld above aero-cld, &
!	3-cld below aero-cld,4-aero-cld between cld,5-multiple-aero,1merged,6mutlcld,multiaero')
!	status = sfendacc (sds_id)
!
!	SDS_NAME="incloud_aerosol_negativetau_num"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata(sds_id,start,stride,edges,totalincld_negativetau_numh)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,250,&
!             'total incloud num minus negativetau num to calculate avetau ')
!	status = sfendacc ( sds_id )
!
!	SDS_NAME="incloud_aerosol_tau"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
!    status=sfwdata(sds_id,start,stride,edges,total_incld_aero_tau/total_incld_aero_numh)
!	status = sfendacc (sds_id)
!
!
!    dim_sizes(3)= 2
!    edges(3) = 2 
!
!
!	SDS_NAME="aerosol_only_negativetau_numh"
!    sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!    status=sfwdata (sds_id, start, stride, edges,totalaero_only_negativetau_numh)
!    status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
!             'total aeroonly num minus negativetau num to obtain ave tau')
!	status = sfendacc ( sds_id )
!
!	print *,'write status 10',status
	status = sfend ( fid )
	!print *,'write status 11',status

	end
