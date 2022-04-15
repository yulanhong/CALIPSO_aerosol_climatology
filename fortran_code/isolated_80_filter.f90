    subroutine isolated_80_filter(filter80,tpaerotop_p1,tpaerobase_p1,tpaerores_p1,&
		tpaerotop_m1,tpaerobase_m1,tpaerores_m1,tpaerotop,tpaerobase,tpaerores)
!		filter80_toppos,filter80_basepos)

	use global, only : NCOL,dimh_tp
	integer :: filter80
	integer :: Nh,hi,ji
	integer :: aerolev_flag(dimh_tp),aerolev_flag_p0(dimh_tp),&
	        aerolev_flag_p1(dimh_tp),aerolev_flag_m1(dimh_tp),&
	        connect_p1(dimh_tp),connect_m1(dimh_tp),connect_p0(dimh_tp)
	integer :: top_scp, base_scp
	real :: tpaerotop_p1(NCOL),tpaerobase_p1(NCOL),&
		tpaerotop_m1(NCOL),tpaerobase_m1(NCOL),&
		tpaerotop(NCOL),tpaerobase(NCOL)
	integer :: tpaerores(NCOL),tpaerores_p1(NCOL),tpaerores_m1(NCOL)
!	integer :: filter80_toppos(NCOL),filter80_basepos(NCOL)

	 Nh=count(tpaerotop .gt. 0)

	 aerolev_flag_p1=0
	 aerolev_flag_m1=0
	 aerolev_flag_p0=0

	 Do ji=1, NCOL
		IF (tpaerotop_p1(ji) > 0.0 .and. tpaerores_p1(ji) > 0 .and. tpaerores_p1(ji) /=80) then
			top_scp=nint((30-tpaerotop_p1(ji))/0.01)
                        if (top_scp < 1) top_scp=1
			if (tpaerobase_p1(ji) < 0.0) tpaerobase_p1(ji)=0
		   	base_scp=nint((30-tpaerobase_p1(ji))/0.01)
            
			aerolev_flag_p1(top_scp:base_scp)=1
		!	print *,'p1 ',top_scp,base_scp
		EndIf

		IF (tpaerotop_m1(ji) > 0.0 .and. tpaerores_m1(ji) > 0 .and. tpaerores_m1(ji) /=80) then
			top_scp=nint((30-tpaerotop_m1(ji))/0.01)
                        if (top_scp < 1) top_scp=1
			if (tpaerobase_m1(ji) < 0.0) tpaerobase_m1(ji)=0
		   	base_scp=nint((30-tpaerobase_m1(ji))/0.01)
			aerolev_flag_m1(top_scp:base_scp)=1
		!	print *,'m1 ',top_scp,base_scp
		EndIf

		IF (tpaerotop(ji) > 0.0 .and. tpaerores(ji) > 0 .and. tpaerores(ji) /=80) then
			top_scp=nint((30-tpaerotop(ji))/0.01)
                        if (top_scp < 1) top_scp=1
			if (tpaerobase(ji) < 0.0) tpaerobase(ji)=0
		   	base_scp=nint((30-tpaerobase(ji))/0.01)
			aerolev_flag_p0(top_scp:base_scp)=1
		!	print *,'p0 ',top_scp,base_scp
		EndIf
	EndDo ! end check adjunct condition

	 Do hi=1, Nh ! have to check each layer
	 aerolev_flag=0
	 connect_p1=0
	 connect_m1=0
	 connect_p0=0
	 top_scp=0
	 base_scp=0

        IF (tpaerotop(hi) > 0.0 .and. tpaerores(hi) == 80) then
        top_scp=nint((30-tpaerotop(hi))/0.01)
        if (top_scp < 1) top_scp=1
        if (tpaerobase(hi) < 0.0) tpaerobase(hi)=0
                base_scp=nint((30-tpaerobase(hi))/0.01)
                aerolev_flag(top_scp:base_scp)=1
        !	print *,'p80 ',top_scp,base_scp
        EndIf

	 WHERE(aerolev_flag > 0 .and. aerolev_flag_p1 > 0) connect_p1=1
	 WhERE(aerolev_flag > 0 .and. aerolev_flag_m1 > 0) connect_m1=1
	 WhERE(aerolev_flag > 0 .and. aerolev_flag_p0 > 0) connect_p0=1

	IF (sum(aerolev_flag) >=1 .and. sum(connect_p1+connect_m1+connect_p0) >= 1) then 
		filter80=0
	Else IF (sum(aerolev_flag) >=1 .and. sum(connect_p1+connect_m1+connect_p0)==0) Then 
		filter80=1
!		filter80_toppos(hi)=top_scp
!		filter80_basepos(hi)=base_scp
	EndIf

	EndDo ! end the layer of profile being checked?
	
	end
