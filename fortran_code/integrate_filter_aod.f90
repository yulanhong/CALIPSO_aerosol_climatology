	subroutine integrate_filter_aod(si,tp_tau,filter80,filter80_toppos,filter80_basepos,&
		filterci,filterci_toppos,filterci_basepos,new_aerotop,new_aerobase)

	use global, only : NCOLP,NCOL,prof_alt, ext_prof, ext_prof_uncer, CAD_prof, ext_prof_qc

	real :: tp_tau,new_aerotop,new_aerobase
	integer :: si,hi
 	real :: tpext_prof(NCOLP),tpext_prof_uncer(NCOLP)
    integer :: tpCAD_prof(NCOLP),tpAVD_prof(NCOLP),tpext_prof_qc(NCOLP)
		
	real :: minpos(NCOLP)

	integer :: filter80,filter80_toppos(NCOL),filter80_basepos(NCOL)
	integer :: filterci,filterci_toppos(NCOL),filterci_basepos(NCOL)
	
	real :: top_alt,base_alt
	integer :: toploc(1),baseloc(1) ! location at the profile	

	tp_tau=0.0
	new_aerotop=0.0
	new_aerobase=0.0

	tpext_prof=ext_prof(:,si)
    tpext_prof_uncer=ext_prof_uncer(:,si)
    tpext_prof_qc=ext_prof_qc(1,:,si)
    tpCAD_prof=CAD_prof(1,:,si)
	
	IF (filter80 > 0) Then
		Do hi=1,count(filter80_toppos > 0)
			top_alt=30-filter80_toppos(hi)*0.01
			minpos=abs(top_alt-prof_alt)
			toploc=minloc(minpos)
			base_alt=30-filter80_basepos(hi)*0.01
			minpos=abs(base_alt-prof_alt)
			baseloc=minloc(minpos)
			tpext_prof(toploc(1):baseloc(1))=0.0
		EndDo
	EndIf ! END IF filter80 
	IF (filterci > 0) Then
		Do hi=1,count(filterci_toppos > 0)
			top_alt=30-filterci_toppos(hi)*0.01
			minpos=abs(top_alt-prof_alt)
			toploc=minloc(minpos)
			base_alt=30-filterci_basepos(hi)*0.01
			minpos=abs(base_alt-prof_alt)
			baseloc=minloc(minpos)
			tpext_prof(toploc(1):baseloc(1))=0.0
		EndDo
	EndIf

    Do hi=1, NCOLP
	    IF (tpext_prof(hi) > 0.0 .and. &
            tpext_prof_uncer(hi) > 0.0 .and. &
            tpext_prof_uncer(hi) /= 99.99 .and. &
            tpCAD_prof(hi) >= -100 .and. &
            tpCAD_prof(hi) <= 0-CAD_threshold) Then
            IF (tpext_prof_qc(hi) == 0 .or. &
                tpext_prof_qc(hi) == 1 .or. &
                tpext_prof_qc(hi) == 16 .or. &
                tpext_prof_qc(hi) == 18) Then
				if (hi .le. 54) tp_tau=tp_tau+tpext_prof(hi)*0.18
				if (hi .gt. 54) tp_tau=tp_tau+tpext_prof(hi)*0.06
				!print *,hi,prof_alt(hi)
				if (new_aerotop ==0) new_aerotop=prof_alt(hi)   			           
			 	new_aerobase=prof_alt(hi) 			  
			EndIf !extiction_qc filter

         EndIf ! uncertainty and cad filter
    EndDo

	!print *,new_aerotop,new_aerobase
	end
