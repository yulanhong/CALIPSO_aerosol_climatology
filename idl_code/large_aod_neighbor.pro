
pro large_aod_neighbor

	print,systime()
   fname=file_search('/u/sciteam/yulanh/scratch/CALIOP/MLay/2008','*2008-07-*')

   Nf=n_elements(fname)

	Nratio=501							
    aod2aodf=ulonarr(Nratio) ; res 0.5 / forward neighbor aerosol
	aod2aodf_codnum=ulonarr(Nratio) ; to record the corresponding forward cod
	aod2aodf_cod=ulonarr(Nratio) ; to record the corresponding forward cod
	aod2aodb_codnum=ulonarr(Nratio) ; to record the corresponding backward cod
	aod2aodb_cod=ulonarr(Nratio) ; to record the corresponding backward cod
	aod2aodb=ulonarr(Nratio) ;res 0.5 / backward
	aod2codf=ulonarr(Nratio) ; res 0.5 / forward neighbor cloud
	aod2codb=ulonarr(Nratio) ; res 0.5 /backward
	aodbzero=0L
	aodfzero=0L
	aodallzero=0L
 
   for fi=0,Nf-1 do begin
	read_dardar,fname[fi],'Column_Optical_Depth_Cloud_532',cod
	cod=reform(cod)
	read_dardar,fname[fi],'Column_Optical_Depth_Tropospheric_Aerosols_532',aod
	aod=reform(aod)

	;ind=where(aod gt 1,count)
	;Ns=count
	Ns=n_elements(aod)
	for si=0,Ns-1 Do begin
	;	aodratiof=aod[ind[si]]/aod[ind[si]-1]
	;	aodratiob=aod[ind[si]]/aod[ind[si]+1]
		if (si eq 0 and aod[si] ge 1) then begin
			;only have forward 
			if aod[si+1] gt 0 then begin
				fratio=aod[si]/aod[si+1]
				fratio_scp=round(fratio/0.5)
				if fratio_scp gt Nratio-1 then fratio_scp=Nratio-1
				aod2aodf[fratio_scp]=aod2aodf[fratio_scp]+1
			endif
			if aod[si+1] eq 0 and cod[si+1] gt 0 then begin
				fcratio=aod[si]/cod[si+1]
				fcratio_scp=round(fcratio/0.5)
				if fcratio_scp gt Nratio-1 then fcratio_scp=Nratio-1
				aod2codf[fcratio_scp]=aod2codf[fcratio_scp]+1
			endif
			if (cod[si+1] eq 0 and aod[si+1] eq 0 ) then aodfzero=aodfzero+1 
		endif; end si = 0	

		if (si eq Ns-1 and aod[si] ge 1) then begin
			;only have backward 
			if aod[si-1] gt 0 then begin
				bratio=aod[si]/aod[si-1]
				bratio_scp=round(bratio/0.5)
				if bratio_scp gt Nratio-1 then bratio_scp=Nratio-1
				aod2aodb[bratio_scp]=aod2aodb[bratio_scp]+1
			endif
			if aod[si-1] eq 0 and cod[si-1] gt 0 then begin
				bcratio=aod[si]/cod[si-1]
				bcratio_scp=round(bcratio/0.5)
				if bcratio_scp gt Nratio-1 then bcratio_scp=Nratio-1
				aod2codb[bcratio_scp]=aod2codb[bcratio_scp]+1
			endif
			if (cod[si-1] eq 0 and aod[si-1] eq 0 ) then aodbzero=aodbzero+1 
		endif ;end si =Ns-1
		
		if (si gt 0 and si lt Ns-1 and aod[si] gt 1) then begin
			; forward
			if aod[si+1] gt 0 then begin
				fratio=aod[si]/aod[si+1]
				fratio_scp=round(fratio/0.5)
				if fratio_scp gt Nratio-1 then fratio_scp=Nratio-1
				aod2aodf[fratio_scp]=aod2aodf[fratio_scp]+1
				if cod[si+1] gt 0 then begin
				aod2aodf_codnum[fratio_scp]=aod2aodf_codnum[fratio_scp]+1
				aod2aodf_cod[fratio_scp]=aod2aodf_cod[fratio_scp]+cod[si+1]
				end
			endif
			if aod[si+1] eq 0 and cod[si+1] gt 0 then begin
				fcratio=aod[si]/cod[si+1]
				fcratio_scp=round(fcratio/0.5)
				if fcratio_scp gt Nratio-1 then fcratio_scp=Nratio-1
				aod2codf[fcratio_scp]=aod2codf[fcratio_scp]+1
			endif

			; backward
			if aod[si-1] gt 0 then begin
				bratio=aod[si]/aod[si-1]
				bratio_scp=round(bratio/0.5)
				if bratio_scp gt Nratio-1 then bratio_scp=Nratio-1
				aod2aodb[bratio_scp]=aod2aodb[bratio_scp]+1
				if cod[si-1] gt 0 then begin
				aod2aodb_codnum[bratio_scp]=aod2aodb_codnum[bratio_scp]+1
				aod2aodb_cod[bratio_scp]=aod2aodb_cod[bratio_scp]+cod[si-1]
				end
			endif
			if aod[si-1] eq 0 and cod[si-1] gt 0 then begin
				bcratio=aod[si]/cod[si-1]
				bcratio_scp=round(bcratio/0.5)
				if bcratio_scp gt Nratio-1 then bcratio_scp=Nratio-1
				aod2codb[bcratio_scp]=aod2codb[bcratio_scp]+1
			endif

			if (cod[si+1] eq 0 and aod[si+1] eq 0 and aod[si-1] gt 0) then aodfzero=aodfzero+1 
			if (cod[si-1] eq 0 and aod[si-1] eq 0 and aod[si+1] gt 0) then aodbzero=aodbzero+1 
			if (cod[si+1] eq 0 and cod[si-1] eq 0 and aod[si-1] eq 0 and aod[si+1] eq 0) then aodallzero=aodallzero+1 
		endif ; end si gt 0 and si lt Ns-1
	endfor

	endfor
	print,systime()

	stop

end
