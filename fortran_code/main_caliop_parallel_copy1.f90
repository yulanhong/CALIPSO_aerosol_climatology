        !============ comments ========================
        !objectives: 1-obtain the global aerosol distribution
        !2- aerosol number in lon,lat,height,categories 
        !3- aerosol backscatter in lon,lat,height,categories
        !4- aod and backscatter pdf   
        !==============================================

	module itial_sendback
	!******** initialzied back data================
	! Nodes == numnodes , have to be input correctly
	use global,only : dimx,dimy,dimh,Ntau,Ndep,Nsca,Nincld,Nisolate,&
	Nlidratio,Ncolratio

	implicit none
        
      !  integer (kind=2), allocatable :: aero_only_colratio(:,:,:)
             !   isolate_aero_colratio(:,:,Ncolratio,Nisolate),&
              !  incld_aeroall_colratio(dimx,dimy,Ncolratio,Nincld)
!        integer (kind=2), allocatable :: total_aero_only_colratio(:,:,:)


	integer (kind=4), allocatable :: back_obsnumh(:,:,:),&
    back_obsnumv(:,:,:,:),&
	back_opaquecld_numh(:,:,:),&
	back_nocld_noaero_numh(:,:,:),&
	back_cld_noaero_numh(:,:,:),&
	back_isolate_aero_numh(:,:,:,:),&
	back_isolate_aero_numv_abvcld(:,:,:,:),&
	back_isolate_aero_numv_belcld(:,:,:,:),&
	back_isolate_aero_numv_other(:,:,:,:),&
	back_isolate_aerotau1_numh(:,:,:,:),&
    back_incld_aero_numh(:,:,:,:),&
    back_incld_aero_numv_one(:,:,:,:),&
    back_incld_aero_numv_abvcld(:,:,:,:),&
    back_incld_aero_numv_belcld(:,:,:,:),&
    back_incld_aero_numv_other(:,:,:,:),&
    back_incld_aerotau1_numh(:,:,:,:),&
	back_aero_only_numh(:,:,:),&
	back_aero_only_numv(:,:,:,:),&
	back_aerotau1_only_numh(:,:,:),&
	back_filtercad_num(:,:,:),&
	back_filter_aod_num(:,:,:),&
	back_filterci_num(:,:,:),&
	back_filter_extqc_num(:,:,:),&
	back_filter_allnum(:,:,:)

    real (kind=4), allocatable :: &
         back_aero_only_beta_profile(:,:,:,:),&
         back_isolate_aero_beta_profile_abvcld(:,:,:,:),&
         back_isolate_aero_beta_profile_belcld(:,:,:,:),&
         back_isolate_aero_beta_profile_other(:,:,:,:),&
         back_incld_aero_beta_profile_one(:,:,:,:),&
         back_incld_aero_beta_profile_abvcld(:,:,:,:),&
         back_incld_aero_beta_profile_belcld(:,:,:,:),&
         back_incld_aero_beta_profile_other(:,:,:,:)

!   integer (kind=4), allocatable :: &
!         back_aero_only_pdf_beta_profile(:,:,:,:,:),&
!         back_isolate_aero_pdf_beta_profile_abvcld(:,:,:,:,:),&
!         back_isolate_aero_pdf_beta_profile_belcld(:,:,:,:,:),&
!         back_isolate_aero_pdf_beta_profile_other(:,:,:,:,:),&
!         back_incld_aero_pdf_beta_profile_one(:,:,:,:,:),&
!         back_incld_aero_pdf_beta_profile_abvcld(:,:,:,:,:),&
!         back_incld_aero_pdf_beta_profile_belcld(:,:,:,:,:),&
!         back_incld_aero_pdf_beta_profile_other(:,:,:,:,:)


	integer (kind=4), allocatable :: backpdf_aero_only_tau(:,:,:,:)

	integer (kind=4), allocatable :: backpdf_isolate_aero_tau(:,:,:,:,:)

	integer (kind=4), allocatable :: backpdf_incld_aero_tau(:,:,:,:,:)

        !==== for 2D PDF of backscatter vs. deporalization ratio; and lidar ratio
    integer (kind=4) :: & ! send_aero_only_scatdep(:,:,:,:),&
        send_aero_only_scatdep(dimx,dimy,Nsca,Ndep),&
        send_incld_aero_scatdep_one(dimx,dimy,Nsca,Ndep),&
		send_incld_aero_scatdep_belcld(dimx,dimy,Nsca,Ndep),&
		send_incld_aero_scatdep_abvcld(dimx,dimy,Nsca,Ndep),&
		send_incld_aero_scatdep_other(dimx,dimy,Nsca,Ndep),&
		send_isolate_aero_scatdep_belcld(dimx,dimy,Nsca,Ndep),&
		send_isolate_aero_scatdep_abvcld(dimx,dimy,Nsca,Ndep),&
		send_isolate_aero_scatdep_other(dimx,dimy,Nsca,Ndep)

    integer (kind=4), allocatable :: back_aero_only_scatdep(:,:,:,:,:),&
        back_incld_aero_scatdep_one(:,:,:,:,:),&
        back_incld_aero_scatdep_belcld(:,:,:,:,:),&
        back_incld_aero_scatdep_abvcld(:,:,:,:,:),&
        back_incld_aero_scatdep_other(:,:,:,:,:),&
        back_isolate_aero_scatdep_belcld(:,:,:,:,:),&
        back_isolate_aero_scatdep_abvcld(:,:,:,:,:),&
        back_isolate_aero_scatdep_other(:,:,:,:,:)

    integer (kind=4), allocatable :: back_aero_only_lidcol(:,:,:,:,:),&
		back_incld_aero_lidcol_one(:,:,:,:,:),&
		back_incld_aero_lidcol_abvcld(:,:,:,:,:),&
		back_incld_aero_lidcol_belcld(:,:,:,:,:),&
		back_incld_aero_lidcol_other(:,:,:,:,:),&
		back_isolate_aero_lidcol_abvcld(:,:,:,:,:),&
		back_isolate_aero_lidcol_belcld(:,:,:,:,:),&
		back_isolate_aero_lidcol_other(:,:,:,:,:)
    ! for color ratio 


        !==========================================================================

        real(kind=4), allocatable ::back_isolate_aero_tau(:,:,:,:),&
		  back_isolate_aerotau_uncer(:,:,:,:),&
          back_aero_only_tau(:,:,:),&
		  back_aero_onlytau_uncer(:,:,:),&
		  back_incld_aero_tau(:,:,:,:),&
		  back_incld_aerotau_uncer(:,:,:,:)	 
	
        real (kind=4) :: send_aero_only_beta_profile(dimx,dimy,dimh),&
                send_isolate_aero_beta_profile_belcld(dimx,dimy,dimh),&
                send_isolate_aero_beta_profile_abvcld(dimx,dimy,dimh),&
                send_isolate_aero_beta_profile_other(dimx,dimy,dimh),&
                send_incld_aero_beta_profile_one(dimx,dimy,dimh),&
                send_incld_aero_beta_profile_belcld(dimx,dimy,dimh),&
                send_incld_aero_beta_profile_abvcld(dimx,dimy,dimh),&
                send_incld_aero_beta_profile_other(dimx,dimy,dimh)

!        integer (kind=4) :: send_aero_only_pdf_beta_profile(dimx,dimy,dimh,Nsca),&
!                send_isolate_aero_pdf_beta_profile_belcld(dimx,dimy,dimh,Nsca),&
!                send_isolate_aero_pdf_beta_profile_abvcld(dimx,dimy,dimh,Nsca),&
!                send_isolate_aero_pdf_beta_profile_other(dimx,dimy,dimh,Nsca),&
!                send_incld_aero_pdf_beta_profile_one(dimx,dimy,dimh,Nsca),&
!                send_incld_aero_pdf_beta_profile_belcld(dimx,dimy,dimh,Nsca),&
!                send_incld_aero_pdf_beta_profile_abvcld(dimx,dimy,dimh,Nsca),&
!                send_incld_aero_pdf_beta_profile_other(dimx,dimy,dimh,Nsca)


         integer (kind=4) :: send_obsnumh(dimx,dimy),&
         send_obsnumv(dimx,dimy,dimh),&
         send_opaquecld_numh(dimx,dimy),&
		 send_nocld_noaero_numh(dimx,dimy),&
		 send_cld_noaero_numh(dimx,dimy),&
         !for aerosol and cloud overlap, both have CAD score > 50
         send_isolate_aero_numh(dimx,dimy,Nisolate),&
         send_isolate_aero_numv_abvcld(dimx,dimy,dimh),&
         send_isolate_aero_numv_belcld(dimx,dimy,dimh),&
         send_isolate_aero_numv_other(dimx,dimy,dimh),&
         send_isolate_aerotau1_numh(dimx,dimy,Nisolate),&
         send_incld_aero_numh(dimx,dimy,Nincld),&
         send_incld_aero_numv_one(dimx,dimy,dimh),&
         send_incld_aero_numv_abvcld(dimx,dimy,dimh),&
         send_incld_aero_numv_belcld(dimx,dimy,dimh),&
         send_incld_aero_numv_other(dimx,dimy,dimh),&
         send_incld_aerotau1_numh(dimx,dimy,Nincld),&
         send_aero_only_numh(dimx,dimy),&
         send_aero_only_numv(dimx,dimy,dimh),&
         send_aerotau1_only_numh(dimx,dimy),&
		 send_filtercad_num(dimx,dimy),&
		 send_filter_aod_num(dimx,dimy),&
		 send_filterci_num(dimx,dimy),&
		 send_filter_extqc_num(dimx,dimy),&
		 send_filter_allnum(dimx,dimy)

        integer (kind=4) :: sendpdf_aero_only_tau(dimx,dimy,Ntau) ! last dimesion for lsflag

        integer (kind=4) :: sendpdf_isolate_aero_tau(dimx,dimy,Ntau,Nisolate)

        integer (kind=4) :: sendpdf_incld_aero_tau(dimx,dimy,Ntau,Nincld)


    integer (kind=4) :: send_aero_only_lidcol(dimx,dimy,Nlidratio,Ncolratio),&
		send_incld_aero_lidcol_one(dimx,dimy,Nlidratio,Ncolratio),&
		send_incld_aero_lidcol_abvcld(dimx,dimy,Nlidratio,Ncolratio),&
		send_incld_aero_lidcol_belcld(dimx,dimy,Nlidratio,Ncolratio),&
		send_incld_aero_lidcol_other(dimx,dimy,Nlidratio,Ncolratio),&
		send_isolate_aero_lidcol_abvcld(dimx,dimy,Nlidratio,Ncolratio),&
		send_isolate_aero_lidcol_belcld(dimx,dimy,Nlidratio,Ncolratio),&
		send_isolate_aero_lidcol_other(dimx,dimy,Nlidratio,Ncolratio)

        !===============================================================

        real(kind=4) ::send_isolate_aero_tau(dimx,dimy,Nisolate),&
		 send_isolate_aerotau_uncer(dimx,dimy,Nisolate),&
         send_incld_aero_tau(dimx,dimy,Nincld),&
		 send_incld_aerotau_uncer(dimx,dimy,Nincld),&
         send_aero_only_tau(dimx,dimy),&
		 send_aero_onlytau_uncer(dimx,dimy)

        end module itial_sendback

        program main_caliop_parallel_copy1

        use global 
        use itial_sendback

	implicit none
	include 'mpif.h'
	!***********************************************************
	integer :: values(8),status,ierr!,fstatus
	character (len=200) :: datadir,filestr,ftemp,fname,pfname,wfname
	logical :: layflag,proflag
	character (len=13), allocatable :: file_mmdd(:)
	character (len=13) myday,tpfname
	character (len=4) :: strmm,strdd
	character (len=6) cld_date

	real :: areal1,areal2
	integer :: hi


	!********* initialize for mpi *******************
    integer :: mpi_err, numnodes, myid, Nodes
    integer, parameter :: my_root=0

    call MPI_INIT( mpi_err )
    call MPI_COMM_SIZE( MPI_COMM_WORLD, numnodes, mpi_err )
    call MPI_Comm_rank(MPI_COMM_WORLD, myid, mpi_err)
    !***************************************************

	IF (myid == my_root) THEN
	call date_and_time(values=values)
     	print *,'starting time', values
       
	read(*,*) cld_date
	print *, cld_date
         
	call system("ls fname"//cld_date//"* > inputfile"//cld_date,status)
	call system("cat inputfile"//cld_date//" | wc -l > count"//cld_date//".txt")
   
     	open(100,file="count"//cld_date//".txt")
        read(100,*) Nodes
        close(100)

        allocate(file_mmdd(Nodes))
        open(200,file="inputfile"//cld_date)
        read(200,fmt="(a13)",iostat=status) file_mmdd
        close(200)
       

        allocate(total_aero_only_beta_profile(dimx,dimy,dimh))
        allocate(total_isolate_aero_beta_profile_belcld(dimx,dimy,dimh))
        allocate(total_isolate_aero_beta_profile_abvcld(dimx,dimy,dimh))
        allocate(total_isolate_aero_beta_profile_other(dimx,dimy,dimh))
        allocate(total_isolate_aero_numv_belcld(dimx,dimy,dimh))
        allocate(total_isolate_aero_numv_abvcld(dimx,dimy,dimh))
        allocate(total_isolate_aero_numv_other(dimx,dimy,dimh))


!        allocate(total_aero_only_pdf_beta_profile(dimx,dimy,dimh,Nsca))
!        allocate(total_isolate_aero_pdf_beta_profile_belcld(dimx,dimy,dimh,Nsca))
!        allocate(total_isolate_aero_pdf_beta_profile_abvcld(dimx,dimy,dimh,Nsca))
!        allocate(total_isolate_aero_pdf_beta_profile_other(dimx,dimy,dimh,Nsca))


        allocate(total_incld_aero_beta_profile_one(dimx,dimy,dimh))
        allocate(total_incld_aero_beta_profile_belcld(dimx,dimy,dimh))
        allocate(total_incld_aero_beta_profile_abvcld(dimx,dimy,dimh))
        allocate(total_incld_aero_beta_profile_other(dimx,dimy,dimh))
        allocate(total_incld_aero_numv_one(dimx,dimy,dimh))
        allocate(total_incld_aero_numv_belcld(dimx,dimy,dimh))
        allocate(total_incld_aero_numv_abvcld(dimx,dimy,dimh))
        allocate(total_incld_aero_numv_other(dimx,dimy,dimh))


!        allocate(total_incld_aero_pdf_beta_profile_one(dimx,dimy,dimh,Nsca))
!        allocate(total_incld_aero_pdf_beta_profile_belcld(dimx,dimy,dimh,Nsca))
!        allocate(total_incld_aero_pdf_beta_profile_abvcld(dimx,dimy,dimh,Nsca))
!        allocate(total_incld_aero_pdf_beta_profile_other(dimx,dimy,dimh,Nsca))



		allocate(total_aero_only_scatdep(dimx,dimy,Nsca,Ndep))
		allocate(total_incld_aero_scatdep_one(dimx,dimy,Nsca,Ndep))
		allocate(total_incld_aero_scatdep_belcld(dimx,dimy,Nsca,Ndep))
		allocate(total_incld_aero_scatdep_abvcld(dimx,dimy,Nsca,Ndep))
		allocate(total_incld_aero_scatdep_other(dimx,dimy,Nsca,Ndep))
		allocate(total_isolate_aero_scatdep_belcld(dimx,dimy,Nsca,Ndep))
		allocate(total_isolate_aero_scatdep_abvcld(dimx,dimy,Nsca,Ndep))
		allocate(total_isolate_aero_scatdep_other(dimx,dimy,Nsca,Ndep))

		allocate(total_aero_only_lidcol(dimx,dimy,Nlidratio,Ncolratio))
		allocate(total_incld_aero_lidcol_one(dimx,dimy,Nlidratio,Ncolratio)) 
		allocate(total_incld_aero_lidcol_abvcld(dimx,dimy,Nlidratio,Ncolratio)) 
		allocate(total_incld_aero_lidcol_belcld(dimx,dimy,Nlidratio,Ncolratio)) 
		allocate(total_incld_aero_lidcol_other(dimx,dimy,Nlidratio,Ncolratio)) 
		allocate(totalpdf_incld_aero_tau(dimx,dimy,Ntau,Nincld))
		allocate(total_isolate_aero_lidcol_abvcld(dimx,dimy,Nlidratio,Ncolratio)) 
		allocate(total_isolate_aero_lidcol_belcld(dimx,dimy,Nlidratio,Ncolratio)) 
		allocate(total_isolate_aero_lidcol_other(dimx,dimy,Nlidratio,Ncolratio)) 

		allocate(back_filtercad_num(dimx,dimy,Nodes))
!		allocate(back_filter_aod_num(dimx,dimy,Nodes))
		allocate(back_filterci_num(dimx,dimy,Nodes))
		allocate(back_filter_extqc_num(dimx,dimy,Nodes))
		allocate(back_filter_allnum(dimx,dimy,Nodes))
        allocate(back_obsnumh(dimx,dimy,Nodes))
 		allocate(back_obsnumv(dimx,dimy,dimh,Nodes))
 		allocate(back_opaquecld_numh(dimx,dimy,Nodes))
		allocate(back_nocld_noaero_numh(dimx,dimy,Nodes))
		allocate(back_cld_noaero_numh(dimx,dimy,Nodes))
		allocate(back_isolate_aero_numh(dimx,dimy,Nisolate,Nodes))
		allocate(back_isolate_aero_numv_belcld(dimx,dimy,dimh,Nodes))
		allocate(back_isolate_aero_numv_abvcld(dimx,dimy,dimh,Nodes))
		allocate(back_isolate_aero_numv_other(dimx,dimy,dimh,Nodes))
		allocate(back_isolate_aerotau1_numh(dimx,dimy,Nisolate,Nodes))
        allocate(back_incld_aero_numh(dimx,dimy,Nincld,Nodes))
        allocate(back_incld_aero_numv_one(dimx,dimy,dimh,Nodes))
        allocate(back_incld_aero_numv_abvcld(dimx,dimy,dimh,Nodes))
        allocate(back_incld_aero_numv_belcld(dimx,dimy,dimh,Nodes))
        allocate(back_incld_aero_numv_other(dimx,dimy,dimh,Nodes))
        allocate(back_incld_aerotau1_numh(dimx,dimy,Nincld,Nodes))
		allocate(back_aero_only_numh(dimx,dimy,Nodes))
        allocate(back_aero_only_tau(dimx,dimy,Nodes))
        allocate(back_aero_onlytau_uncer(dimx,dimy,Nodes))

		allocate(back_aero_only_numv(dimx,dimy,dimh,Nodes))
		allocate(back_aerotau1_only_numh(dimx,dimy,Nodes),stat=status)
       ! print *,'aertau1 status',status,maxval(back_aerotau1_only_numh)
        allocate(back_aero_only_beta_profile(dimx,dimy,dimh,Nodes))
        allocate(back_isolate_aero_beta_profile_belcld(dimx,dimy,dimh,Nodes))
        allocate(back_isolate_aero_beta_profile_abvcld(dimx,dimy,dimh,Nodes))
        allocate(back_isolate_aero_beta_profile_other(dimx,dimy,dimh,Nodes))
        allocate(back_incld_aero_beta_profile_one(dimx,dimy,dimh,Nodes))
        allocate(back_incld_aero_beta_profile_belcld(dimx,dimy,dimh,Nodes))
        allocate(back_incld_aero_beta_profile_abvcld(dimx,dimy,dimh,Nodes))
        allocate(back_incld_aero_beta_profile_other(dimx,dimy,dimh,Nodes))

!        allocate(back_incld_aero_pdf_beta_profile_one(dimx,dimy,dimh,Nsca,Nodes))
!        allocate(back_incld_aero_pdf_beta_profile_belcld(dimx,dimy,dimh,Nsca,Nodes))
!        allocate(back_incld_aero_pdf_beta_profile_abvcld(dimx,dimy,dimh,Nsca,Nodes))
!        allocate(back_incld_aero_pdf_beta_profile_other(dimx,dimy,dimh,Nsca,Nodes))
!        allocate(back_aero_only_pdf_beta_profile(dimx,dimy,dimh,Nsca,Nodes))
!        allocate(back_isolate_aero_pdf_beta_profile_belcld(dimx,dimy,dimh,Nsca,Nodes))
!        allocate(back_isolate_aero_pdf_beta_profile_abvcld(dimx,dimy,dimh,Nsca,Nodes))
!        allocate(back_isolate_aero_pdf_beta_profile_other(dimx,dimy,dimh,Nsca,Nodes))


        allocate(back_isolate_aero_tau(dimx,dimy,Nisolate,Nodes))
        allocate(back_isolate_aerotau_uncer(dimx,dimy,Nisolate,Nodes))
       ! allocate(back_isolate_aero_depratio(dimx,dimy,Nisolate,Nodes))
       ! allocate(back_isolate_aero_backscatt(dimx,dimy,Nisolate,Nodes))
        allocate(back_incld_aero_tau(dimx,dimy,Nincld,Nodes))
        allocate(back_incld_aerotau_uncer(dimx,dimy,Nincld,Nodes))

 		allocate(backpdf_aero_only_tau(dimx,dimy,Ntau,Nodes))

		allocate(backpdf_isolate_aero_tau(dimx,dimy,Ntau,Nisolate,Nodes))

		allocate(backpdf_incld_aero_tau(dimx,dimy,Ntau,Nincld,Nodes))

    	allocate(back_aero_only_scatdep(dimx,dimy,Nsca,Ndep,Nodes))

        allocate(back_incld_aero_scatdep_one(dimx,dimy,Nsca,Ndep,Nodes))
        allocate(back_incld_aero_scatdep_belcld(dimx,dimy,Nsca,Ndep,Nodes))
        allocate(back_incld_aero_scatdep_abvcld(dimx,dimy,Nsca,Ndep,Nodes))
        allocate(back_incld_aero_scatdep_other(dimx,dimy,Nsca,Ndep,Nodes))
        allocate(back_isolate_aero_scatdep_belcld(dimx,dimy,Nsca,Ndep,Nodes))
        allocate(back_isolate_aero_scatdep_abvcld(dimx,dimy,Nsca,Ndep,Nodes))
        allocate(back_isolate_aero_scatdep_other(dimx,dimy,Nsca,Ndep,Nodes))

        allocate(back_aero_only_lidcol(dimx,dimy,Nlidratio,Ncolratio,Nodes))
        allocate(back_incld_aero_lidcol_one(dimx,dimy,Nlidratio,Ncolratio,Nodes))
        allocate(back_incld_aero_lidcol_abvcld(dimx,dimy,Nlidratio,Ncolratio,Nodes))
        allocate(back_incld_aero_lidcol_belcld(dimx,dimy,Nlidratio,Ncolratio,Nodes))
        allocate(back_incld_aero_lidcol_other(dimx,dimy,Nlidratio,Ncolratio,Nodes))
        allocate(back_isolate_aero_lidcol_abvcld(dimx,dimy,Nlidratio,Ncolratio,Nodes))
        allocate(back_isolate_aero_lidcol_belcld(dimx,dimy,Nlidratio,Ncolratio,Nodes))
        allocate(back_isolate_aero_lidcol_other(dimx,dimy,Nlidratio,Ncolratio,Nodes))

        Do hi=1,54
            prof_alt(hi)=30.1-hi*0.18
        EndDo
        Do hi=0, NCOLP-55
            prof_alt(hi+55)=20.2-hi*0.06
        EndDo
       !==================================
        
        EndIf ! end root

        !print *, file_mmdd

        call MPI_SCATTER(file_mmdd,13,MPI_CHARACTER,myday,&
        13,MPI_CHARACTER,my_root,MPI_COMM_WORLD,mpi_err)

!	datadir="/u/sciteam/yulanh/scratch/CALIOP/"//myday(6:9)//"/"
! 	filestr=myday(6:9)//'-'//myday(10:11)//'-'//myday(12:13)//'/'
!	print *, myid, myday

	open(100,file=myday)

	Do  
	   read(100,fmt="(a103)",iostat=status) ftemp
	   if (status /=0) exit
	 !  fname=trim(datadir)//trim(filestr)//trim(ftemp)
	   fname=ftemp
	   pfname=fname
	   pfname(34:37)='APro'
	   pfname(59:62)='APro'
	   inquire(file=fname,exist=layflag)
	   inquire(file=pfname,exist=proflag)

	   print *,fname,pfname,myid
!	   print *,layflag,proflag

	   IF (layflag .and. proflag) Then
	   call inquire_info(fname)
	   call read_caliop(fname)
	   call read_caliop_prof(pfname)
	   call calculate_core(myid)

		send_filtercad_num=send_filtercad_num+filtercad_num
!		send_filter_aod_num=send_filter_aod_num+filter_aod_num
		send_filterci_num=send_filterci_num+filterci_num
		send_filter_extqc_num=send_filter_extqc_num+filter_extqc_num
		send_filter_allnum=send_filter_allnum+filter_allnum

        send_obsnumh=send_obsnumh+obsnumh
        send_obsnumv=send_obsnumv+obsnumv
        send_opaquecld_numh=send_opaquecld_numh+opaquecld_numh
        send_nocld_noaero_numh=send_nocld_noaero_numh+nocld_noaero_numh
        send_cld_noaero_numh=send_cld_noaero_numh+cld_noaero_numh

        send_aero_only_numh=send_aero_only_numh + aero_only_numh
        send_aero_only_numv=send_aero_only_numv + aero_only_numv

        send_aero_only_tau=send_aero_only_tau + aero_only_tau
        send_aero_onlytau_uncer=send_aero_onlytau_uncer + aero_onlytau_uncer

        send_aerotau1_only_numh=send_aerotau1_only_numh + aerotau1_only_numh
        sendpdf_aero_only_tau=sendpdf_aero_only_tau+pdf_aero_only_tau
        send_aero_only_scatdep=send_aero_only_scatdep+aero_only_scatdep
        send_aero_only_lidcol=send_aero_only_lidcol+aero_only_lidcol

        send_aero_only_beta_profile = send_aero_only_beta_profile+ &
                aero_only_beta_profile
!        send_aero_only_pdf_beta_profile = send_aero_only_pdf_beta_profile+ &
!                aero_only_pdf_beta_profile

        send_isolate_aero_tau = send_isolate_aero_tau + isolate_aero_tau
        send_isolate_aerotau_uncer = send_isolate_aerotau_uncer + isolate_aerotau_uncer

        send_isolate_aerotau1_numh=send_isolate_aerotau1_numh+isolate_aerotau1_numh
        send_isolate_aero_numh=send_isolate_aero_numh+isolate_aero_numh
        send_isolate_aero_numv_belcld=send_isolate_aero_numv_belcld+isolate_aero_numv_belcld
        send_isolate_aero_beta_profile_belcld = send_isolate_aero_beta_profile_belcld+ &
                isolate_aero_beta_profile_belcld
!        send_isolate_aero_pdf_beta_profile_belcld = send_isolate_aero_pdf_beta_profile_belcld+ &
!                isolate_aero_pdf_beta_profile_belcld
        send_isolate_aero_numv_abvcld=send_isolate_aero_numv_abvcld+isolate_aero_numv_abvcld
        send_isolate_aero_beta_profile_abvcld = send_isolate_aero_beta_profile_abvcld+ &
                isolate_aero_beta_profile_abvcld
!        send_isolate_aero_pdf_beta_profile_abvcld = send_isolate_aero_pdf_beta_profile_abvcld+ &
!                isolate_aero_pdf_beta_profile_abvcld
        send_isolate_aero_numv_other=send_isolate_aero_numv_other+isolate_aero_numv_other
        send_isolate_aero_beta_profile_other = send_isolate_aero_beta_profile_other+ &
                isolate_aero_beta_profile_other
!        send_isolate_aero_pdf_beta_profile_other = send_isolate_aero_pdf_beta_profile_other+ &
!                isolate_aero_pdf_beta_profile_other
   
        sendpdf_isolate_aero_tau=sendpdf_isolate_aero_tau+pdf_isolate_aero_tau
        send_isolate_aero_scatdep_belcld=send_isolate_aero_scatdep_belcld + isolate_aero_scatdep_belcld
        send_isolate_aero_scatdep_abvcld=send_isolate_aero_scatdep_abvcld + isolate_aero_scatdep_abvcld
        send_isolate_aero_scatdep_other=send_isolate_aero_scatdep_other + isolate_aero_scatdep_other
		send_isolate_aero_lidcol_belcld =send_isolate_aero_lidcol_belcld  + isolate_aero_lidcol_belcld
		send_isolate_aero_lidcol_abvcld =send_isolate_aero_lidcol_abvcld  + isolate_aero_lidcol_abvcld
		send_isolate_aero_lidcol_other =send_isolate_aero_lidcol_other  + isolate_aero_lidcol_other

        send_incld_aero_numh=send_incld_aero_numh+incld_aero_numh
        send_incld_aero_numv_one=send_incld_aero_numv_one+incld_aero_numv_one
        send_incld_aero_numv_abvcld=send_incld_aero_numv_abvcld+incld_aero_numv_abvcld
        send_incld_aero_numv_belcld=send_incld_aero_numv_belcld+incld_aero_numv_belcld
        send_incld_aero_numv_other=send_incld_aero_numv_other+incld_aero_numv_other

        send_incld_aerotau1_numh=send_incld_aerotau1_numh+incld_aerotau1_numh
        send_incld_aero_tau =  send_incld_aero_tau + incld_aero_tau
	    send_incld_aerotau_uncer=send_incld_aerotau_uncer+incld_aerotau_uncer	

        sendpdf_incld_aero_tau=sendpdf_incld_aero_tau+pdf_incld_aero_tau
        send_incld_aero_beta_profile_one = send_incld_aero_beta_profile_one+ &
                incld_aero_beta_profile_one
        send_incld_aero_beta_profile_belcld = send_incld_aero_beta_profile_belcld+ &
                incld_aero_beta_profile_belcld
        send_incld_aero_beta_profile_abvcld = send_incld_aero_beta_profile_abvcld+ &
                incld_aero_beta_profile_abvcld
        send_incld_aero_beta_profile_other = send_incld_aero_beta_profile_other+ &
                incld_aero_beta_profile_other

 !       send_incld_aero_pdf_beta_profile_one = send_incld_aero_pdf_beta_profile_one+ &
 !               incld_aero_pdf_beta_profile_one
 !       send_incld_aero_pdf_beta_profile_belcld = send_incld_aero_pdf_beta_profile_belcld+ &
 !               incld_aero_pdf_beta_profile_belcld
 !       send_incld_aero_pdf_beta_profile_abvcld = send_incld_aero_pdf_beta_profile_abvcld+ &
 !               incld_aero_pdf_beta_profile_abvcld
 !       send_incld_aero_pdf_beta_profile_other = send_incld_aero_pdf_beta_profile_other+ &
 !               incld_aero_pdf_beta_profile_other

        send_incld_aero_scatdep_one=send_incld_aero_scatdep_one + incld_aero_scatdep_one
        send_incld_aero_scatdep_belcld=send_incld_aero_scatdep_belcld + incld_aero_scatdep_belcld
        send_incld_aero_scatdep_abvcld=send_incld_aero_scatdep_abvcld + incld_aero_scatdep_abvcld
        send_incld_aero_scatdep_other=send_incld_aero_scatdep_other + incld_aero_scatdep_other
		send_incld_aero_lidcol_one =send_incld_aero_lidcol_one  + incld_aero_lidcol_one
		send_incld_aero_lidcol_belcld =send_incld_aero_lidcol_belcld  + incld_aero_lidcol_belcld
		send_incld_aero_lidcol_abvcld =send_incld_aero_lidcol_abvcld  + incld_aero_lidcol_abvcld
		send_incld_aero_lidcol_other =send_incld_aero_lidcol_other  + incld_aero_lidcol_other

		include 'deallocate_dynamic.file' 
        include 'deallocate.file'
        EndIf ! end if both Mlay and APro exist
!	print *,'finish ',myid,pfname	
        EndDo
        close(100)

        !====================== observedd number =============================
	call MPI_Gather(send_filter_allnum,dimx*dimy,MPI_INTEGER,back_filter_allnum,dimx*dimy,&
            MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(send_filtercad_num,dimx*dimy,MPI_INTEGER,back_filtercad_num,dimx*dimy,&
            MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(send_filterci_num,dimx*dimy,MPI_INTEGER,back_filterci_num,dimx*dimy,&
            MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(send_filter_extqc_num,dimx*dimy,MPI_INTEGER,back_filter_extqc_num,dimx*dimy,&
            MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

!	call MPI_Gather(send_filter_aod_num,dimx*dimy,MPI_INTEGER,back_filter_aod_num,dimx*dimy,&
 !           MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(send_obsnumh,dimx*dimy,MPI_INTEGER,back_obsnumh,dimx*dimy,&
            MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	!print *,'obsnumh',maxval(send_obsnumh),maxval(back_obsnumh),mpi_err

	call MPI_Gather(send_obsnumv,dimx*dimy*dimh,MPI_INTEGER,back_obsnumv,dimx*dimy*dimh,&
            MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	!print *,'obsnumv',maxval(send_obsnumv),maxval(back_obsnumv)

	call MPI_Gather(send_opaquecld_numh,dimx*dimy,MPI_INTEGER,back_opaquecld_numh,dimx*dimy,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(send_nocld_noaero_numh,dimx*dimy,MPI_INTEGER,back_nocld_noaero_numh,dimx*dimy,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(send_cld_noaero_numh,dimx*dimy,MPI_INTEGER,back_cld_noaero_numh,dimx*dimy,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	!print *,'opaquecld',maxval(send_opaquecld_numh),maxval(back_opaquecld_numh)
        !==== for aerosol only
        !======================================================================
        call MPI_Gather(send_aerotau1_only_numh,dimx*dimy,MPI_INTEGER,&
             back_aerotau1_only_numh,dimx*dimy,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

        call MPI_Gather(send_aero_only_numh,dimx*dimy,MPI_INTEGER,back_aero_only_numh,dimx*dimy,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

        call MPI_Gather(send_aero_only_numv,dimx*dimy*dimh,MPI_INTEGER,back_aero_only_numv,dimx*dimy*dimh,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

        call MPI_Gather(send_aero_only_tau,dimx*dimy,MPI_REAL,back_aero_only_tau,dimx*dimy,&
             MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
        call MPI_Gather(send_aero_onlytau_uncer,dimx*dimy,MPI_REAL,back_aero_onlytau_uncer,dimx*dimy,&
             MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

        call MPI_Gather(send_aero_only_beta_profile,dimx*dimy*dimh,MPI_REAL,back_aero_only_beta_profile,&
                dimx*dimy*dimh,MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
!        call MPI_Gather(send_aero_only_pdf_beta_profile,dimx*dimy*dimh*Nsca,MPI_INTEGER,back_aero_only_pdf_beta_profile,&
!                dimx*dimy*dimh*Nsca,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

       call MPI_Gather(sendpdf_aero_only_tau,dimx*dimy*Ntau,MPI_INTEGER,backpdf_aero_only_tau,dimx*dimy*Ntau,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

        call MPI_Gather(send_aero_only_scatdep,dimx*dimy*Nsca*Ndep,MPI_INTEGER,back_aero_only_scatdep,&
                dimx*dimy*Nsca*Ndep,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
		!print *,maxval(send_aero_only_scatdep),maxval(back_aero_only_scatdep)

        call MPI_Gather(send_aero_only_lidcol,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,&
                back_aero_only_lidcol,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

        call MPI_Gather(sendpdf_isolate_aero_tau,dimx*dimy*Ntau*Nisolate,MPI_INTEGER,backpdf_isolate_aero_tau,&
                dimx*dimy*Ntau*Nisolate,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
		!print *,maxval(sendpdf_isolate_aero_tau),maxval(backpdf_isolate_aero_tau)

        call MPI_Gather(send_isolate_aero_scatdep_abvcld,dimx*dimy*Nsca*Ndep,MPI_INTEGER,&
			 back_isolate_aero_scatdep_abvcld,dimx*dimy*Nsca*Ndep,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
		!print *,maxval(send_isolate_aero_scatdep_abvcld),maxval(back_isolate_aero_scatdep_abvcld)

        call MPI_Gather(send_isolate_aero_scatdep_belcld,dimx*dimy*Nsca*Ndep,MPI_INTEGER,&
			 back_isolate_aero_scatdep_belcld,dimx*dimy*Nsca*Ndep,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

        call MPI_Gather(send_isolate_aero_scatdep_other,dimx*dimy*Nsca*Ndep,MPI_INTEGER,&
			 back_isolate_aero_scatdep_other,dimx*dimy*Nsca*Ndep,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)


	call MPI_Gather(send_isolate_aero_numh,dimx*dimy*Nisolate,MPI_INTEGER,back_isolate_aero_numh,dimx*dimy*Nisolate,&
            MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(send_isolate_aero_numv_belcld,dimx*dimy*dimh,MPI_INTEGER,back_isolate_aero_numv_belcld,dimx*dimy*dimh,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(send_isolate_aero_numv_abvcld,dimx*dimy*dimh,MPI_INTEGER,back_isolate_aero_numv_abvcld,dimx*dimy*dimh,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(send_isolate_aero_numv_other,dimx*dimy*dimh,MPI_INTEGER,back_isolate_aero_numv_other,dimx*dimy*dimh,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

    call MPI_Gather(send_isolate_aero_beta_profile_belcld,dimx*dimy*dimh,MPI_REAL,back_isolate_aero_beta_profile_belcld,&
             dimx*dimy*dimh,MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
    call MPI_Gather(send_isolate_aero_beta_profile_abvcld,dimx*dimy*dimh,MPI_REAL,back_isolate_aero_beta_profile_abvcld,&
             dimx*dimy*dimh,MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
    call MPI_Gather(send_isolate_aero_beta_profile_other,dimx*dimy*dimh,MPI_REAL,back_isolate_aero_beta_profile_other,&
             dimx*dimy*dimh,MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

!    call MPI_Gather(send_isolate_aero_pdf_beta_profile_belcld,dimx*dimy*dimh*Nsca,MPI_INTEGER,&
!				back_isolate_aero_pdf_beta_profile_belcld,dimx*dimy*dimh*Nsca,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
!    call MPI_Gather(send_isolate_aero_pdf_beta_profile_abvcld,dimx*dimy*dimh*Nsca,MPI_INTEGER,&
!				back_isolate_aero_pdf_beta_profile_abvcld,dimx*dimy*dimh*Nsca,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
!    call MPI_Gather(send_isolate_aero_pdf_beta_profile_other,dimx*dimy*dimh*Nsca,MPI_INTEGER,&
!				back_isolate_aero_pdf_beta_profile_other,dimx*dimy*dimh*Nsca,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)


	call MPI_Gather(send_isolate_aerotau1_numh,dimx*dimy*Nisolate,MPI_INTEGER,back_isolate_aerotau1_numh,dimx*dimy*Nisolate,&
            MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(send_isolate_aero_tau,dimx*dimy*Nisolate,MPI_REAL,back_isolate_aero_tau,dimx*dimy*Nisolate,&
             MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(send_isolate_aerotau_uncer,dimx*dimy*Nisolate,MPI_REAL,back_isolate_aerotau_uncer,dimx*dimy*Nisolate,&
             MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

    call MPI_Gather(send_isolate_aero_lidcol_abvcld,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,&
                back_isolate_aero_lidcol_abvcld,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

    call MPI_Gather(send_isolate_aero_lidcol_belcld,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,&
                back_isolate_aero_lidcol_belcld,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

    call MPI_Gather(send_isolate_aero_lidcol_other,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,&
                back_isolate_aero_lidcol_other,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)


	call MPI_Gather(send_incld_aero_numh,dimx*dimy*Nincld,MPI_INTEGER,back_incld_aero_numh,dimx*dimy*Nincld,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(send_incld_aero_numv_one,dimx*dimy*dimh,MPI_INTEGER,back_incld_aero_numv_one,dimx*dimy*dimh,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(send_incld_aero_numv_abvcld,dimx*dimy*dimh,MPI_INTEGER,back_incld_aero_numv_abvcld,dimx*dimy*dimh,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(send_incld_aero_numv_belcld,dimx*dimy*dimh,MPI_INTEGER,back_incld_aero_numv_belcld,dimx*dimy*dimh,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(send_incld_aero_numv_other,dimx*dimy*dimh,MPI_INTEGER,back_incld_aero_numv_other,dimx*dimy*dimh,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)


	call MPI_Gather(send_incld_aerotau1_numh,dimx*dimy*Nincld,MPI_INTEGER,back_incld_aerotau1_numh,dimx*dimy*Nincld,&
             MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(send_incld_aero_tau,dimx*dimy*Nincld,MPI_REAL,back_incld_aero_tau,dimx*dimy*Nincld,&
             MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(send_incld_aerotau_uncer,dimx*dimy*Nincld,MPI_REAL,back_incld_aerotau_uncer,dimx*dimy*Nincld,&
             MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
  
    call MPI_Gather(send_incld_aero_scatdep_one,dimx*dimy*Nsca*Ndep,MPI_INTEGER,back_incld_aero_scatdep_one,&
			 dimx*dimy*Nsca*Ndep,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
    call MPI_Gather(send_incld_aero_scatdep_belcld,dimx*dimy*Nsca*Ndep,MPI_INTEGER,back_incld_aero_scatdep_belcld,&
			 dimx*dimy*Nsca*Ndep,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
    call MPI_Gather(send_incld_aero_scatdep_abvcld,dimx*dimy*Nsca*Ndep,MPI_INTEGER,back_incld_aero_scatdep_abvcld,&
			 dimx*dimy*Nsca*Ndep,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
    call MPI_Gather(send_incld_aero_scatdep_other,dimx*dimy*Nsca*Ndep,MPI_INTEGER,back_incld_aero_scatdep_other,&
			 dimx*dimy*Nsca*Ndep,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

    call MPI_Gather(sendpdf_incld_aero_tau,dimx*dimy*Ntau*Nincld,MPI_INTEGER,backpdf_incld_aero_tau,&
    	     dimx*dimy*Ntau*Nincld,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

    call MPI_Gather(send_incld_aero_beta_profile_one,dimx*dimy*dimh,MPI_REAL,back_incld_aero_beta_profile_one,&
             dimx*dimy*dimh,MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
    call MPI_Gather(send_incld_aero_beta_profile_belcld,dimx*dimy*dimh,MPI_REAL,back_incld_aero_beta_profile_belcld,&
             dimx*dimy*dimh,MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
    call MPI_Gather(send_incld_aero_beta_profile_abvcld,dimx*dimy*dimh,MPI_REAL,back_incld_aero_beta_profile_abvcld,&
             dimx*dimy*dimh,MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
    call MPI_Gather(send_incld_aero_beta_profile_other,dimx*dimy*dimh,MPI_REAL,back_incld_aero_beta_profile_other,&
             dimx*dimy*dimh,MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

!    call MPI_Gather(send_incld_aero_pdf_beta_profile_one,dimx*dimy*dimh*Nsca,MPI_INTEGER,&
!			back_incld_aero_pdf_beta_profile_one,dimx*dimy*dimh*Nsca,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
!    call MPI_Gather(send_incld_aero_pdf_beta_profile_belcld,dimx*dimy*dimh*Nsca,MPI_INTEGER,&
!			back_incld_aero_pdf_beta_profile_belcld,dimx*dimy*dimh*Nsca,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
!    call MPI_Gather(send_incld_aero_pdf_beta_profile_abvcld,dimx*dimy*dimh*Nsca,MPI_INTEGER,&
!			back_incld_aero_pdf_beta_profile_abvcld,dimx*dimy*dimh*Nsca,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
!    call MPI_Gather(send_incld_aero_pdf_beta_profile_other,dimx*dimy*dimh*Nsca,MPI_INTEGER,&
!			back_incld_aero_pdf_beta_profile_other,dimx*dimy*dimh*Nsca,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)


    call MPI_Gather(send_incld_aero_lidcol_one,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,&
                back_incld_aero_lidcol_one,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

    call MPI_Gather(send_incld_aero_lidcol_abvcld,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,&
                back_incld_aero_lidcol_abvcld,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

    call MPI_Gather(send_incld_aero_lidcol_belcld,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,&
                back_incld_aero_lidcol_belcld,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

    call MPI_Gather(send_incld_aero_lidcol_other,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,&
                back_incld_aero_lidcol_other,dimx*dimy*Nlidratio*Ncolratio,MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	!========================================================


	IF (myid == my_root) Then
				total_filtercad_num=sum(back_filtercad_num,3)
!				total_filter_aod_num=sum(back_filter_aod_num,3)
				total_filterci_num=sum(back_filterci_num,3)
				total_filter_extqc_num=sum(back_filter_extqc_num,3)
				total_filter_allnum=sum(back_filter_allnum,3)

                total_obsnumh=sum(back_obsnumh,3)
                total_obsnumv=sum(back_obsnumv,4)
                total_opaquecld_numh=sum(back_opaquecld_numh,3)
				total_nocld_noaero_numh=sum(back_nocld_noaero_numh,3)
				total_cld_noaero_numh=sum(back_cld_noaero_numh,3)

                !==== for aerosol only ========================
                total_aero_only_numh=sum(back_aero_only_numh,3)
                total_aero_only_numv=sum(back_aero_only_numv,4)
                total_aero_only_beta_profile=sum(back_aero_only_beta_profile,4)
                total_aerotau1_only_numh=sum(back_aerotau1_only_numh,3)
                total_aero_only_tau=sum(back_aero_only_tau,3)
                total_aero_onlytau_uncer=sum(back_aero_onlytau_uncer,3)
                totalpdf_aero_only_tau=sum(backpdf_aero_only_tau,4)
                total_aero_only_scatdep=sum(back_aero_only_scatdep,5)
				!print *,maxval(total_aero_only_scatdep),maxval(back_aero_only_scatdep)
                total_aero_only_lidcol=sum(back_aero_only_lidcol,5)
       
				total_incld_aero_numh=sum(back_incld_aero_numh,4)
				total_incld_aero_numv_one=sum(back_incld_aero_numv_one,4)
				total_incld_aero_numv_belcld=sum(back_incld_aero_numv_belcld,4)
				total_incld_aero_numv_abvcld=sum(back_incld_aero_numv_abvcld,4)
				total_incld_aero_numv_other=sum(back_incld_aero_numv_other,4)
				!print *,maxval(total_incld_aero_numv),maxval(back_incld_aero_numv)

                total_incld_aero_beta_profile_one=sum(back_incld_aero_beta_profile_one,4)
                total_incld_aero_beta_profile_belcld=sum(back_incld_aero_beta_profile_belcld,4)
                total_incld_aero_beta_profile_abvcld=sum(back_incld_aero_beta_profile_abvcld,4)
                total_incld_aero_beta_profile_other=sum(back_incld_aero_beta_profile_other,4)
				total_incld_aerotau1_numh=sum(back_incld_aerotau1_numh,4)
				total_incld_aero_tau=sum(back_incld_aero_tau,4)
				total_incld_aerotau_uncer=sum(back_incld_aerotau_uncer,4)
				totalpdf_incld_aero_tau=sum(backpdf_incld_aero_tau,5)
				total_incld_aero_scatdep_one=sum(back_incld_aero_scatdep_one,5)
				total_incld_aero_scatdep_belcld=sum(back_incld_aero_scatdep_belcld,5)
				total_incld_aero_scatdep_abvcld=sum(back_incld_aero_scatdep_abvcld,5)
				total_incld_aero_scatdep_other=sum(back_incld_aero_scatdep_other,5)

				total_incld_aero_lidcol_one=sum(back_incld_aero_lidcol_one,5)
				total_incld_aero_lidcol_abvcld=sum(back_incld_aero_lidcol_abvcld,5)
				total_incld_aero_lidcol_belcld=sum(back_incld_aero_lidcol_belcld,5)
				total_incld_aero_lidcol_other=sum(back_incld_aero_lidcol_other,5)
				
				total_isolate_aero_numh=sum(back_isolate_aero_numh,4)
				total_isolate_aerotau1_numh=sum(back_isolate_aerotau1_numh,4)
				total_isolate_aero_tau=sum(back_isolate_aero_tau,4)
				total_isolate_aerotau_uncer=sum(back_isolate_aerotau_uncer,4)
				totalpdf_isolate_aero_tau=sum(backpdf_isolate_aero_tau,5)
				total_isolate_aero_numv_belcld=sum(back_isolate_aero_numv_belcld,4)
				total_isolate_aero_numv_abvcld=sum(back_isolate_aero_numv_abvcld,4)
				total_isolate_aero_numv_other=sum(back_isolate_aero_numv_other,4)
				total_isolate_aero_beta_profile_belcld=sum(back_isolate_aero_beta_profile_belcld,4)
				total_isolate_aero_beta_profile_abvcld=sum(back_isolate_aero_beta_profile_abvcld,4)
				total_isolate_aero_beta_profile_other=sum(back_isolate_aero_beta_profile_other,4)
				!print *,maxval(total_isolate_aero_beta_profile_belcld)

				total_isolate_aero_scatdep_belcld=sum(back_isolate_aero_scatdep_belcld,5)
				total_isolate_aero_scatdep_abvcld=sum(back_isolate_aero_scatdep_abvcld,5)
				total_isolate_aero_scatdep_other=sum(back_isolate_aero_scatdep_other,5)

				print *, maxval(total_isolate_aero_scatdep_belcld)

				total_isolate_aero_lidcol_other=sum(back_isolate_aero_lidcol_other,5)
				total_isolate_aero_lidcol_abvcld=sum(back_isolate_aero_lidcol_abvcld,5)
				total_isolate_aero_lidcol_belcld=sum(back_isolate_aero_lidcol_belcld,5)

!		total_isolate_aero_scatdep=sum(back_isolate_aero_scatdep,4)

!		total_isolate_aero_lidratio=sum(back_isolate_aero_lidratio,4)

!		total_isolate_aero_colratio = sum(back_isolate_aero_colratio,5)
!		total_incld_aeroall_colratio = sum(back_incld_aeroall_colratio,5)

                tpfname=file_mmdd(1)
                wfname='caliop_cldclimatology_cad20_aerocld_'//tpfname(6:11)//'_noci.hdf'
                print *,wfname

                call write_caliop(wfname)!,total_aero_only_scatdep,&
                        !total_aero_only_beta_profile)!,&
                      !  total_aero_only_lidcol,&
                       ! total_aero_only_colratio)
                print *,'finished wirting'

	call date_and_time(values=values)
        print *,'finish time', values

	EndIF ! end root id

!	IF ((myid == my_root) .and. (.not. fstatus)) Then
!	print*,'parrent id receive message from id for doing nothing =',back_no_result
!	EndIf
   	call MPI_FINALIZE(mpi_err)

	end program
