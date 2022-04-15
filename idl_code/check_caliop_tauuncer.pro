pro check_caliop_tauuncer

  fname=file_search('/u/sciteam/yulanh/scratch/CALIOP/MLay/2018','*.hdf')

  Nf=n_elements(fname)

  for fi=0,Nf-1 do begin
	read_dardar,fname[fi],'Column_Optical_Depth_Tropospheric_Aerosols_532',tau
	read_dardar,fname[fi],'Column_Optical_Depth_Tropospheric_Aerosols_Uncertainty_532',tauerr
	nsz=size(tau)
	Ns=nsz[2]
	si=0L
	while si le Ns-1 do begin
		if tau[0,si] ge 1 then print,si,tauerr[0,si]
		si=si+1L
	endwhile
	stop
  endfor

end
