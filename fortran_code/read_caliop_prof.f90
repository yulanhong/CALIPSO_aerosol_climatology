
        subroutine read_caliop_prof(file_name)

        use global, only : NROW,NCOLP,back_prof!ext_prof,ext_prof_uncer,CAD_Prof,AVD_Prof

        implicit none

    integer DFACC_READ, DFNT_INT32
    parameter(DFACC_READ = 1, DFNT_INT32 = 24)

    integer sfstart, sfn2index, sfselect, sfginfo, sfrdata
    integer sfendacc, sfend

    character*100 sds_name
    character*200 file_name
    integer values(8)
    integer sd_id, sds_id, sds_index,astat, status
    integer rank, data_type, n_attrs,i
    integer dim_sizes(32), start(32), edges(32), stride(32)

!	allocate(ext_prof(NCOLP,NROW))
	allocate(back_prof(NCOLP,NROW))
!	allocate(ext_prof_uncer(NCOLP,NROW))
!	allocate(CAD_prof(2,NCOLP,NROW))
!	allocate(AVD_prof(2,NCOLP,NROW))

	sd_id=sfstart(file_name,DFACC_READ)
	if (sd_id .eq. -1) then
            print *,'CANNOT OPEN CALIOP FILE',file_name
            stop
    endif

	start(1)=0
	start(2)=0
    edges(1)=NCOLP
    edges(2)=NROW
    STRIDE(1)=1
    STRIDE(2)=1

	sds_name="Total_Backscatter_Coefficient_532"
	sds_index=sfn2index(sd_id,sds_name)
	sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,back_prof)
	status=sfendacc(sds_id)

  !      print *,back_prof(363,1)
!	sds_name="Extinction_Coefficient_532"
!	sds_index=sfn2index(sd_id,sds_name)
!	sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,ext_prof)
!	status=sfendacc(sds_id)

!	sds_name="Extinction_Coefficient_Uncertainty_532"
!	sds_index=sfn2index(sd_id,sds_name)
!	sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,ext_prof_uncer)
!	status=sfendacc(sds_id)

!	start(1)=0
!	start(2)=0
!	start(3)=0
 !   edges(1)=2
 !   edges(2)=NCOLP
 !   edges(3)=NROW
!    STRIDE(1)=1
!    STRIDE(2)=1
 !   STRIDE(3)=1

!	sds_name="Extinction_QC_Flag_532"
!	sds_index=sfn2index(sd_id,sds_name)
!	sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,ext_prof_qc)
!	status=sfendacc(sds_id)

!	sds_name="CAD_Score"
!	sds_index=sfn2index(sd_id,sds_name)
!	sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,CAD_prof)
!	status=sfendacc(sds_id)

!	sds_name="Atmospheric_Volume_Description"
!	sds_index=sfn2index(sd_id,sds_name)
!	sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,AVD_prof)
!	status=sfendacc(sds_id)
       
        end subroutine
