
	subroutine vfm_feature_flag(val,feature_type,cloud_phase,horizontal_averaging)

	implicit none
	integer (kind=4) :: val
	integer ::  feature_type,feature_type_qa,&
		ice_water_phase,ice_water_phase_qa,&
		feature_subtype,cloud_aerosol_psc_type_qa,&
		horizontal_averaging

	integer :: bi,cloud_phase

	feature_type=0
	feature_type_qa=0	
	ice_water_phase=0
	ice_water_phase_qa=0
	feature_subtype=0
	cloud_aerosol_psc_type_qa=0
	horizontal_averaging=0

!	print *,val
	Do bi=1, 16
	   If(iand(val, 2**(bi-1)) .ne. 0) Then
		!print *,'bit set: ',bi
		selectcase(bi)
		case(1) 
		  feature_type = feature_type + 1
    		case(2)
		  feature_type = feature_type + 2
    		case(3)
		  feature_type = feature_type + 4
    		case(4)
		  feature_type_qa = feature_type_qa + 1
    		case(5)
		  feature_type_qa = feature_type_qa + 2
    		case(6)
		  ice_water_phase = ice_water_phase + 1
    		case(7)
		  ice_water_phase = ice_water_phase + 2
    		case(8)
		  ice_water_phase_qa = ice_water_phase_qa + 1
    		case(9) 
		  ice_water_phase_qa = ice_water_phase_qa + 2
    		case(10)
		  feature_subtype = feature_subtype + 1
    		case(11)
 		  feature_subtype = feature_subtype + 2
    		case(12)
		  feature_subtype = feature_subtype + 4
    		case(13)
		  cloud_aerosol_psc_type_qa = cloud_aerosol_psc_type_qa + 1
    		case(14)
		  horizontal_averaging = horizontal_averaging + 1
    		case(15)
		  horizontal_averaging = horizontal_averaging + 2
    		case(16)
		  horizontal_averaging = horizontal_averaging + 4
		case default
		  print *,'select wrong place'
		end select
	   EndIf
		 
	EndDo
	cloud_phase=ice_water_phase
!	   print *,'vfm value',val
!	   print *,'cloud phase ',ice_water_phase
!	   print *,'cloud aerosol',feature_type
!	   print *,'subtype', feature_subtype
!	   vfm_feature_flag=ice_water_phase
!	stop 
!	   return
	end
