
	subroutine inquire_info(file_name)

	use global, only : NROW,NCOL

	implicit none

	integer DFACC_READ, DFNT_INT32
        parameter(DFACC_READ = 1, DFNT_INT32 = 24)

	integer sfstart, sfn2index, sfselect, sfginfo, sfrdata
        integer sfendacc, sfend

        character*100 sds_name,name
        character*200 file_name
        integer values(8)
        integer sd_id, sds_id, sds_index,astat, status
        integer rank, data_type, n_attrs
        integer dim_sizes(32), start(32), edges(32), stride(32)


	sd_id=sfstart(file_name,DFACC_READ)
	if (sd_id .eq. -1) then
                print *,'CANNOT OPEN DARDAR FILE: ',file_name
                stop
        endif

	sds_name="CAD_Score"
	sds_index=sfn2index(sd_id,sds_name)
        sds_id=sfselect(sd_id,sds_index)
	status=sfginfo(sds_id,name,rank,dim_sizes,data_type,n_attrs)
	status=sfendacc(sds_id)
	status=sfend(sd_id)

	NCOL=dim_sizes(1)

	NROW=dim_sizes(2)

!	print *,dim_sizes
!	print *,name
	end subroutine
