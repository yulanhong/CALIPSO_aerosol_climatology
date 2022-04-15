	subroutine cirrus_filter(filterci,tpaerobase,tpaerotop,tpcldtop,tpcldbase,&
                tpcldtop_p1,tpcldbase_p1,tpcldtop_m1,tpcldbase_m1,&
                tpciflag,tpciflag_p1,tpciflag_m1)
                !,filterci_toppos,&
		!filterci_basepos)

	use global, only : NCOL, dimh_tp

        real :: tpaerobase(NCOL),tpaerotop(NCOL),&
                tpcldtop(NCOL),tpcldbase(NCOL),&
                tpcldbase_p1(NCOL),tpcldtop_p1(NCOL),&
                tpcldbase_m1(NCOL),tpcldtop_m1(NCOL)
	integer :: tpciflag(NCOL),tpciflag_p1(NCOL),&
                tpciflag_m1(NCOL)
	
	integer :: Nh,hi,ji,filterci,top_scp,base_scp
	integer :: aerolev_flag(dimh_tp),cldlev_flag(dimh_tp),&
                cldlev_flag_p1(dimh_tp),cldlev_flag_m1(dimh_tp),&
                connect(dimh_tp),connect_p1(dimh_tp),connect_m1(dimh_tp)

!	integer :: filterci_toppos(NCOL),filterci_basepos(NCOL)

	!judge cirrus filter: altitude gt 4 km and in contact with ice clouds

        cldlev_flag=0
        cldlev_flag_p1=0
        cldlev_flag_m1=0

	Do ji=1, NCOL
		IF (tpciflag(ji) > 0) Then
		top_scp=nint((30-tpcldtop(ji))/0.01)
                if (top_scp < 1) top_scp=1
		if (tpcldbase(ji) < 0.0) tpcldbase(ji)=0.0
		base_scp=nint((30-tpcldbase(ji))/0.01)
		cldlev_flag(top_scp:base_scp)=1
!		print *,'p0',top_scp,base_scp
		EndIF 

		IF (tpciflag_p1(ji) > 0) Then
		top_scp=nint((30-tpcldtop_p1(ji))/0.01)
                if (top_scp < 1) top_scp=1
		if (tpcldbase_p1(ji) < 0.0) tpcldbase_p1(ji)=0.0
		base_scp=nint((30-tpcldbase_p1(ji))/0.01)
		cldlev_flag_p1(top_scp:base_scp)=1
!		print *,'p1',top_scp,base_scp
		EndIF 

		IF (tpciflag_m1(ji) > 0) Then
		top_scp=nint((30-tpcldtop_m1(ji))/0.01)
                if (top_scp <1 ) top_scp=1
		if (tpcldbase_m1(ji) < 0.0) tpcldbase_m1(ji)=0.0
		base_scp=nint((30-tpcldbase_m1(ji))/0.01)
		cldlev_flag_m1(top_scp:base_scp)=1
!		print *,'m1',top_scp,base_scp
		EndIF 
	EndDo ! end record cirrus cloud level

	Nh=count(tpaerotop > 0)
	Do hi=1,Nh ! have to check each aerosol layers, whether they are connected to cirrus
	aerolev_flag=0
	connect=0
	connect_p1=0
	connect_m1=0
	top_scp=0
	base_scp=0

	IF (tpaerobase(hi) >= 4.0) Then
		top_scp=nint((30-tpaerotop(hi))/0.01)
                if (top_scp < 1) top_scp=1
		if (tpaerobase(hi) < 0.0) tpaerobase(hi)=0.0
		base_scp=nint((30-tpaerobase(hi))/0.01)
		aerolev_flag(top_scp:base_scp)=1
!			print *,'4',tpaerotop(hi),tpaerobase(hi),top_scp,base_scp
	EndIF

	WHERE(aerolev_flag > 0 .and. cldlev_flag > 0) connect=1
	WHERE(aerolev_flag > 0 .and. cldlev_flag_p1 > 0) connect_p1=1
	WHERE(aerolev_flag > 0 .and. cldlev_flag_m1 > 0) connect_m1=1

	IF (sum(aerolev_flag) > 0.0 .and. sum(connect+connect_p1+connect_m1) ==0) filterci=0
	IF (sum(aerolev_flag) > 0.0 .and. sum(connect+connect_p1+connect_m1) > 0) Then
		filterci=1
!		filterci_toppos(hi)=top_scp
!		filterci_basepos(hi)=base_scp
!			print *,top_scp,base_scp,sum(cldlev_flag),sum(cldlev_flag_p1),sum(cldlev_flag_m1)
!			stop
        EndIF
		
	EndDo ! end scan each aerosol layer

 	end
