
	program main_caliop_parallel
	
	use global

	implicit none
	include 'mpif.h'
	!***********************************************************
	integer :: values(8),status,ierr,Nfname!,fstatus
	character (len=200) :: datadir,filestr,ftemp,fname,wfname
	character (len=13), allocatable :: file_mmdd(:)
	character (len=13) myday,tpfname
	character (len=4) :: strmm,strdd
	real :: areal1,areal2

	!********* initialize for mpi *******************
        integer :: mpi_err, numnodes, myid
        integer, parameter :: my_root=0

        call MPI_INIT(mpi_err)
        call MPI_COMM_SIZE( MPI_COMM_WORLD, numnodes, mpi_err )
        call MPI_Comm_rank(MPI_COMM_WORLD, myid, mpi_err)
        !***************************************************
	myday=''

	IF (myid == my_root) THEN
	call date_and_time(values=values)
        print *,'starting time', values

	call system("ls fname* > inputfile",status)
	call system("cat inputfile | wc -l > count.txt")
   
     	open(100,file="count.txt")
        read(100,*) Nfname
        close(100)
	
	print *,'total file',Nfname

	allocate(file_mmdd(Nfname))
	open(200,file="inputfile")
        read(200,fmt="(a13)",iostat=status) file_mmdd
        close(200)
!	print *,file_mmdd
!	stop	
	EndIf ! end root

	call MPI_SCATTER(file_mmdd,13,MPI_CHARACTER,myday,&
        13,MPI_CHARACTER,my_root,MPI_COMM_WORLD,mpi_err)
	!print *, file_mmdd
	!stop

	!IF (myday .ne. '') Then 
 	print *,'myid= ',myid,' date= ',myday

!	datadir="/u/sciteam/yulanh/scratch/CALIOP/"//myday(6:9)//"/"
! 	filestr=myday(6:9)//'-'//myday(10:11)//'-'//myday(12:13)//'/'

	open(300,file= myday,iostat=status)
!	print *,'open status',status
	Do 
!	   print *,'process file myid',myid 
	   read(300,fmt="(a105)",iostat=status) ftemp
	 !  print *,'status',status,ftemp
	   if (status /=0) exit
	 !  fname=trim(datadir)//trim(filestr)//trim(ftemp)
	  fname=ftemp
	  ! print *,'myid',myid,fname
	   call inquire_info(fname)
	   call read_caliop(fname)
	   call calculate_core()	

	   total_obsnumh=total_obsnumh+obsnumh
	 	
	   !print *,'sum of obsnumh for each file',sum(obsnumh)
	   total_icenumh=total_icenumh+icenumh
	   total_watnumh=total_watnumh+watnumh
	   total_uncernumh=total_uncernumh+uncernumh
	   total_icewatnumh=total_icewatnumh+icewatnumh
	   total_iceuncernumh=total_iceuncernumh+iceuncernumh
	   total_watuncernumh=total_watuncernumh+watuncernumh
	   total_lowconf_numh=total_lowconf_numh+lowconf_numh
!	   print *,obsnumh(2,:)	
	   total_obsnumv=total_obsnumv+obsnumv
	   total_icenumv=total_icenumv+icenumv
	   total_watnumv=total_watnumv+watnumv
	   total_uncernumv=total_uncernumv+uncernumv
	   total_icewatnumv=total_icewatnumv+icewatnumv
	   total_iceuncernumv=total_iceuncernumv+iceuncernumv
	   total_watuncernumv=total_watuncernumv+watuncernumv
	   total_lowconf_numv=total_lowconf_numv+lowconf_numv

	   total_aero_nocld_numh= total_aero_nocld_numh+aero_nocld_numh
           total_aero_nocld_numv= total_aero_nocld_numv+aero_nocld_numv
           total_aerowatnumh = total_aerowatnumh + aerowatnumh
           total_aerowat_numv= total_aerowat_numv+ aerowat_numv
           total_aeroicenumh= total_aeroicenumh + aeroicenumh
           total_aeroice_numv=  total_aeroice_numv + aeroice_numv
           total_aerouncernumh= total_aerouncernumh + aerouncernumh
           total_aerouncer_numv= total_aerouncer_numv + aerouncer_numv
           total_aeroicewatnumh=   total_aeroicewatnumh + aeroicewatnumh
           total_aeroicewat_numv= total_aeroicewat_numv + aeroicewat_numv
           total_aeroiceuncernumh= total_aeroiceuncernumh + aeroiceuncernumh
           total_aeroiceuncer_numv= total_aeroiceuncer_numv + aeroiceuncer_numv
           total_aerowatuncernumh= total_aerowatuncernumh + aerowatuncernumh
           total_aerowatuncer_numv= total_aerowatuncer_numv + aerowatuncer_numv

           total_lowconf_aeronumh= total_lowconf_aeronumh + lowconf_aeronumh
           total_lowconf_aeronumv= total_lowconf_aeronumv + lowconf_aeronumv 
 
	   total_icetop_temp=total_icetop_temp+icetop_temp
	   total_wctop_temp=total_wctop_temp+wctop_temp
	   total_wctop_temp_iceup=total_wctop_temp_iceup+wctop_temp_iceup
	   total_uncertop_temp=total_uncertop_temp+uncertop_temp
	   total_uncertop_temp_iceup=total_uncertop_temp_iceup+uncertop_temp_iceup
	   total_watuncertop_temp=total_watuncertop_temp+watuncertop_temp	
	
	   include 'deallocate.file'
	EndDo
	print *,'finish id', myid
	close(300)

	print *,'finish myid',myday
	tpfname=myday	
	call system("rm "//myday)

	wfname='caliop_cldclimatology_'//tpfname(6:13)//'.hdf'
	call write_caliop(wfname)		

!	print *,'finished wirting, myid',myid,wfname

	IF (myid == my_root) Then
	call system("rm inputfile")
	call date_and_time(values=values)
        print *,'finish time', values
	EndIf
	
	call MPI_FINALIZE(mpi_err)

	end program
