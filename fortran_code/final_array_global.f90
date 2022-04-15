
	module final_array_global
	    !=== for send output
	use global, only : dimx,dimy,dimh

	implicit none

        integer (kind=4) :: total_obsnumh(dimx,dimy),&
                total_icenumh(dimx,dimy),&
                total_watnumh(dimx,dimy),&
                total_uncernumh(dimx,dimy),&
                total_icewatnumh(dimx,dimy),&
                total_iceuncernumh(dimx,dimy),&
                total_watuncernumh(dimx,dimy),&
                total_lowconf_numh(dimx,dimy),&
                total_obsnumv(dimx,dimy,dimh),&
                total_icenumv(dimx,dimy,dimh),&
                total_watnumv(dimx,dimy,dimh),&
                total_uncernumv(dimx,dimy,dimh),&
                total_icewatnumv(dimx,dimy,dimh),&
                total_iceuncernumv(dimx,dimy,dimh),&
                total_watuncernumv(dimx,dimy,dimh),&
                total_lowconf_numv(dimx,dimy,dimh)

        real :: total_wctop_temp(dimx,dimy,dimh),&
                total_wctop_temp_iceup(dimx,dimy,dimh),&
                total_uncertop_temp(dimx,dimy,dimh),&
                total_uncertop_temp_iceup(dimx,dimy,dimh),&
                total_watuncertop_temp(dimx,dimy,dimh),&
                total_icetop_temp(dimx,dimy,dimh)

       	end
