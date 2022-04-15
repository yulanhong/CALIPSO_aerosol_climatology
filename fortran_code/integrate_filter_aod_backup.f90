	subroutine integrate_filter_aod(si,tp_tau)

	use global, only : NCOLP, ext_prof, ext_prof_uncer, CAD_prof, ext_prof_qc

	real :: tp_tau
	integer :: si,hi
 	real :: tpext_prof(NCOLP),tpext_prof_uncer(NCOLP)
    integer :: tpCAD_prof(NCOLP),tpAVD_prof(NCOLP),tpext_prof_qc(NCOLP)
		

	tp_tau=0.0
	tpext_prof=ext_prof(:,si)
    tpext_prof_uncer=ext_prof_uncer(:,si)
    tpext_prof_qc=ext_prof_qc(1,:,si)
    tpCAD_prof=CAD_prof(1,:,si)
	
    Do hi=1, NCOLP
	    IF (tpext_prof(hi) > 0.0 .and. &
            tpext_prof_uncer(hi) > 0.0 .and. &
            tpext_prof_uncer(hi) /= 99.99 .and. &
            tpCAD_prof(hi) >= -100 .and. &
            tpCAD_prof(hi) <= CAD_threshold) Then
            IF (tpext_prof_qc(hi) == 0 .or. &
                tpext_prof_qc(hi) == 1 .or. &
                tpext_prof_qc(hi) == 16 .or. &
                tpext_prof_qc(hi) == 18) Then
   			           
				if (hi .le. 53) tp_tau=tp_tau+tpext_prof(hi)*0.18
				if (hi .gt. 53) tp_tau=tp_tau+tpext_prof(hi)*0.06

			EndIf !extiction_qc filter
         EndIf ! uncertainty and cad filter
    EndDo
	
	end
