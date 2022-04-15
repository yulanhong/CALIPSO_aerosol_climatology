
	subroutine write_caliop_1(wfname)

	use global_1
!	use final_array_global

	implicit none

	!******* Function declaration.**************************************
        integer sfstart,sfcreate, sfsnatt, sfwdata, sfendacc, sfend, &
                sfsattr
	!**** Variable declaration *******************************************

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

        real :: wlon(dimx), wlat(dimy),height(dimh)

	FORALL (i=1:dimx) wlon(i)=(i-1)*bin_res-180+bin_res/2.0
        FORALL (j=1:dimy) wlat(j)=(j-1)*bin_res-90+bin_res/2.0
	FORALL (i=1:dimh) height(i)=25-i*0.25

        !print *,FILE_NAME
	!print *,wlat,wlon
	!Open the file and initialize the SD interface.
        fid = sfstart( wfname, DFACC_CREATE )
        IF (fid==-1) then
                print *,'process stop at writing file: ',wfname
                stop
        ENDIF


	RANK=1

	dim_sizes(1) = dimh
        start  ( 1 ) = 0
        edges  ( 1 ) = dimh
        stride ( 1 ) = 1

        factor=1.0
        offset=0.0
        SDS_NAME='height'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, height)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,6,&
                'height')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,1,'km')
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)
        datarange(1)=0.0
        datarange(2)=25
        status=sfsnatt(sds_id,'range',DFNT_FLOAT32,2,datarange)
	status = sfendacc ( sds_id )

	dim_sizes(1) = dimx
        edges  ( 1 ) = dimx

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
	status = sfendacc ( sds_id )

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
	SDS_NAME="obs_numh"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_obsnumh)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average observation number')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="ice_numh"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_icenumh)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average iceonly number')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="water_numh"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_watnumh)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average liquidonly number')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="undetermined_numh"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_uncernumh)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average undetermined number')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="ice-water_numh"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_icewatnumh)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average ice-liquid in the profile')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="ice-undetermined_numh"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_iceuncernumh)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average ice-undetermined in the profile')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="water-undetermined_numh"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,total_watuncernumh)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average liquid-undetermined in the profile')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="lowcad_numh"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,total_lowconf_numh)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average liquid-undetermined in the profile')
	status = sfendacc ( sds_id )


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
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
	print *,sds_id,shape(total_obsnumv)
        status=sfwdata (sds_id, start, stride, edges,total_obsnumv)
	print *, status
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average observation number')
	print *, status
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="ice_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_icenumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average iceonly number')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="water_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_watnumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average liquidonly number')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="undetermined_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_uncernumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average undetermined number')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="ice-water_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_icewatnumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average ice-liquid in the profile')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="ice-undetermined_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,total_iceuncernumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average ice-undetermined in the profile')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ')
	status = sfendacc ( sds_id )

	SDS_NAME="water-undetermined_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,total_watuncernumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average liquid-undetermined in the profile')
	status = sfendacc ( sds_id )

	SDS_NAME="lowcad_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,total_lowconf_numv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average liquid-undetermined cloud top height')
	status = sfendacc ( sds_id )

			
	SDS_NAME="ice_top_temperature"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,total_icetop_temp/total_icenumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly cloud top temperature-iceonly')
	status = sfendacc ( sds_id )

	SDS_NAME="water_top_temperature"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,total_wctop_temp/total_watnumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly cloud top temperature-liquidonly')
	status = sfendacc ( sds_id )

	SDS_NAME="undetermined_top_temperature"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,total_uncertop_temp/total_uncernumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly cloud top temperature-liquidonly')
	status = sfendacc ( sds_id )

	SDS_NAME="ice-water_top_temperature"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,total_wctop_temp_iceup/total_icewatnumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly cloud top temperature-ice-liquid')
	status = sfendacc ( sds_id )

	SDS_NAME="ice-undetermined_top_temperature"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,total_uncertop_temp_iceup/total_iceuncernumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly cloud top temperature-ice-undetermine')
	status = sfendacc ( sds_id )

	SDS_NAME="water-undetermined_top_temperature"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,total_watuncertop_temp/total_watuncernumv)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly cloud top temperature-ice-undetermine')
	status = sfendacc ( sds_id )

	status = sfend ( fid )

	end
