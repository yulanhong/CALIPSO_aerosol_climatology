	subroutine read_caliop(file_name)

	use global, only : NROW,NCOL,CAD_Score,Opacity,VFM, top_hgt,&
		 top_temp, base_hgt, base_temp, lat,lon,aero_tau,aerotau_uncer,depol_ratio,&
		 back_scatt,lidar_ratio532,dnf,IGBP_surf,&
		 color_ratio,res_layer,&
		 ext_lay_qc,min_laser_energy

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

	allocate(CAD_Score(NCOL,NROW))
	allocate(res_layer(NCOL,NROW))
	allocate(Opacity(NCOL,NROW))
	allocate(VFM(NCOL,NROW))
	allocate(top_hgt(NCOL,NROW))
	!allocate(top_temp(NCOL,NROW))
	allocate(base_hgt(NCOL,NROW))
	!allocate(base_temp(NCOL,NROW))
	allocate(depol_ratio(NCOL,NROW))
	allocate(back_scatt(NCOL,NROW))
	allocate(lon(3,NROW))
	allocate(lat(3,NROW))
	allocate(aero_tau(1,NROW))
	allocate(aerotau_uncer(1,NROW))
	allocate(dnf(1,NROW))
	allocate(IGBP_surf(1,NROW))
	allocate(lidar_ratio532(NCOL,NROW))
!	allocate(transT(NCOL,NROW))
!	allocate(transT_err(NCOL,NROW))
	allocate(color_ratio(NCOL,NROW))
!	allocate(cld_tau(1,NROW))
!        allocate(cldtau_uncer(1,NROW))
	allocate(ext_lay_qc(NCOL,NROW))
!	allocate(aerotau_lay_uncer(NCOL,NROW))
	allocate(min_laser_energy(1,NROW))

	sd_id=sfstart(file_name,DFACC_READ)
	if (sd_id .eq. -1) then
            print *,'CANNOT OPEN CALIOP FILE',file_name
            stop
    endif

	start(1)=0
	start(2)=0
    edges(1)=1
    edges(2)=NROW
    STRIDE(1)=1
    STRIDE(2)=1
	sds_name="Column_Optical_Depth_Tropospheric_Aerosols_532"
	sds_index=sfn2index(sd_id,sds_name)
	sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,aero_tau)
	status=sfendacc(sds_id)

	sds_name="Column_Optical_Depth_Tropospheric_Aerosols_Uncertainty_532"
	sds_index=sfn2index(sd_id,sds_name)
	sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,aerotau_uncer)
	status=sfendacc(sds_id)

!	sds_name="Column_Optical_Depth_Cloud_532"
!	sds_index=sfn2index(sd_id,sds_name)
!	sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,cld_tau)
!	status=sfendacc(sds_id)

!	sds_name="Column_Optical_Depth_Cloud_Uncertainty_532"
!	sds_index=sfn2index(sd_id,sds_name)
!	sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,cldtau_uncer)
!	status=sfendacc(sds_id)
	
	sds_name="Day_Night_Flag"
	sds_index=sfn2index(sd_id,sds_name)
	sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,dnf)
	status=sfendacc(sds_id)

	sds_name="IGBP_Surface_Type"
	sds_index=sfn2index(sd_id,sds_name)
	sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,IGBP_surf)
	status=sfendacc(sds_id)
	
	sds_name="Minimum_Laser_Energy_532"
	sds_index=sfn2index(sd_id,sds_name)
	sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,min_laser_energy)
	status=sfendacc(sds_id)
	min_laser_energy=min_laser_energy*1000.0
!	print *,IGBP_surf(1,1:10)

	start(1)=0
	start(2)=0
    edges(1)=NCOL
    edges(2)=NROW
    STRIDE(1)=1
    STRIDE(2)=1

	sds_name="CAD_Score"
	sds_index=sfn2index(sd_id,sds_name)
        sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,CAD_Score)
	status=sfendacc(sds_id)

	sds_name="Horizontal_Averaging"
	sds_index=sfn2index(sd_id,sds_name)
        sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,res_layer)
	status=sfendacc(sds_id)

	sds_name='Opacity_Flag'
	sds_index=sfn2index(sd_id,sds_name)
	sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,Opacity)
	status=sfendacc(sds_id)

	sds_name="Layer_Top_Altitude"
	sds_index=sfn2index(sd_id,sds_name)
    sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,top_hgt)
	status=sfendacc(sds_id)

!	sds_name="Layer_Top_Temperature"
!	sds_index=sfn2index(sd_id,sds_name)
!    sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,top_temp)
!	status=sfendacc(sds_id)

	sds_name="Layer_Base_Altitude"
    sds_index=sfn2index(sd_id,sds_name)
    sds_id=sfselect(sd_id,sds_index)
    status=sfrdata(sds_id,start,stride,edges,base_hgt)
    status=sfendacc(sds_id)

!    sds_name="Layer_Base_Temperature"
!    sds_index=sfn2index(sd_id,sds_name)
!    sds_id=sfselect(sd_id,sds_index)
!    status=sfrdata(sds_id,start,stride,edges,base_temp)
!    status=sfendacc(sds_id)

	sds_name="Feature_Classification_Flags"
	sds_index=sfn2index(sd_id,sds_name)
        sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,VFM)
	status=sfendacc(sds_id)

!	sds_name="Feature_Optical_Depth_Uncertainty_532"
!	sds_index=sfn2index(sd_id,sds_name)
!    sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,aerotau_lay_uncer)
!	status=sfendacc(sds_id)

	sds_name="ExtinctionQC_532"
	sds_index=sfn2index(sd_id,sds_name)
    sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,ext_lay_qc)
	status=sfendacc(sds_id)

	sds_name="Integrated_Attenuated_Backscatter_532"
	sds_index=sfn2index(sd_id,sds_name)
    sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,back_scatt)
	status=sfendacc(sds_id)
!		print *, back_scatt(:,1)
	
	sds_name="Integrated_Volume_Depolarization_Ratio"
	sds_index=sfn2index(sd_id,sds_name)
    sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,depol_ratio)
	status=sfendacc(sds_id)
!		print *, depol_ratio(:,1)

	sds_name="Final_532_Lidar_Ratio"
	sds_index=sfn2index(sd_id,sds_name)
    sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,lidar_ratio532)
	status=sfendacc(sds_id)
!	print *, lidar_ratio532(:,1)

!	sds_name="Measured_Two_Way_Transmittance_532"
!	sds_index=sfn2index(sd_id,sds_name)
!    sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,transT)
!	status=sfendacc(sds_id)

!	sds_name="Measured_Two_Way_Transmittance_Uncertainty_532"
!	sds_index=sfn2index(sd_id,sds_name)
!    sds_id=sfselect(sd_id,sds_index)
!	status=sfrdata(sds_id,start,stride,edges,transT_err)
!	status=sfendacc(sds_id)
!	print *,transT_err(:,3122)

	sds_name="Integrated_Attenuated_Total_Color_Ratio"
	sds_index=sfn2index(sd_id,sds_name)
        sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,color_ratio)
	status=sfendacc(sds_id)
	
!	print *, color_ratio(:,1)	
	
    edges(1)=3
	sds_name="Latitude"
	sds_index=sfn2index(sd_id,sds_name)
    sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,lat)
	status=sfendacc(sds_id)

	sds_name="Longitude"
	sds_index=sfn2index(sd_id,sds_name)
        sds_id=sfselect(sd_id,sds_index)
	status=sfrdata(sds_id,start,stride,edges,lon)
	status=sfendacc(sds_id)

	status=sfend(sd_id)
!        print *,file_name
!	print *,'lon',lon(:,1)
!	print *,'lat',lat(:,1)	
!	print *,'Cad score',CAD_Score(:,1)
!	print *,'top hgt',top_hgt(:,1)
!	print *,'top temp',top_temp(:,1)
!	print *,'vfm',vfm(:,8)
	end subroutine
