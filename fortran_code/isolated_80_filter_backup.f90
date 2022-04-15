
	 subroutine isolated_80_filter(filter80,tpaerotop_p1,tpaerobase_p1,tpaerores_p1,&
		tpaerotop_m1,tpaerobase_m1,tpaerores_m1,tpaerotop,tpaerobase,tpaerores)

	use global, only : NCOL,dimh
	integer :: filter80
	integer :: Nh,hi
	integer :: aerolev_flag(dimh),aerolev_flag_p1(dimh),aerolev_flag_m1(dimh)
	integer :: top_scp, base_scp
	real :: tpaerotop_p1,tpaerobase_p1,tpaerores_p1,tpaerotop_m1,tpaerobase_m1,tpaerores_m1,&
		tpaerotop,tpaerobase,tpaerores

	real :: neighboor_gap=0.0

	 Nh=count(tpaerotop .gt. 0)

	 aerolev_flag=0
	 aerolev_flag_p1=0
	 aerolev_flag_m1=0

	 

	 IF (Nh==1) Then
		IF (tpaerores(1) == 80) then
        	IF (si /= NROW) then ! judge boundary conditions, not eq 80 and in touch with the 80km layer
             Do hi=1, count(tpaerores_p1 > 0)
             	IF (tpaerobase_p1(hi) > tpaerotop(1)) neighboor_gap=&
                	abs(tpaerobase_p1(hi)-tpaerotop(1))
                	IF (tpaerotop_p1(hi) > tpaerotop(1) .and. tpaerobase_p1(hi) <= tpaerotop(1)) &
                         neighboor_gap=0.0
                   	IF (tpaerotop_p1(hi) <= tpaerotop(1) .and. tpaerotop_p1(hi) >= tpaerobase(1)) &
                         neighboor_gap=0.0
                    IF (tpaerotop_p1(hi) < tpaerobase(1)) &
                        neighboor_gap=tpaerobase(1)-tpaerotop_p1(hi)

                  	IF (tpaerores_p1(hi) /=80 .and. neighboor_gap <=gap_threshold) filter80=0
         	EndDo
		    print *,si, neighboor_gap,filter80
           EndIf
		EndIf ! end res==80
	EndIf ! end one layer
!
!                    IF (si /= 1) then ! judge boundary conditions, not eq 80 and in touch with the 80km layer
!                     Do hi=1, count(tpaerores_m1 > 0)
!                           IF (tpaerobase_m1(hi) > tpaerotop(1)) neighboor_gap=&
!                            tpaerobase_m1(hi)-tpaerotop(1)
!                             IF (tpaerotop_m1(hi) > tpaerotop(1) .and. tpaerobase_m1(hi) <= tpaerotop(1)) neighboor_gap=0.0
!                            IF (tpaerotop_m1(hi) <= tpaerotop(1) .and. tpaerotop_m1(hi) > tpaerobase(1)) neighboor_gap=0.0
!                            IF (tpaerotop_m1(hi) < tpaerobase(1)) neighboor_gap=&
!                            tpaerobase(1)-tpaerotop_m1(hi)
!                            IF (tpaerores_m1(hi) /=80 .and. neighboor_gap <=gap_threshold .and. filter80==1) filter80=0
!                        EndDo
!                        print *,si,neighboor_gap,filter80
!                    EndIf
!                 ! end boundary judgement   
!                EndIf ! end layer res=80
!
end
