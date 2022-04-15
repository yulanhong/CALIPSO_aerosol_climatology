pro layer2profile,alt,top,base,data,prof_data

 Nh=n_elements(alt)

 Nsize=size(top)

 Ns=Nsize[2]
 prof_data=fltarr(Ns,Nh)

 for si=0,Ns-1 do begin
	tptop=top[*,si]
	tpbase=base[*,si]
	tpdata=data[*,si]

	ind=where(tptop gt 0, count)
	Nlayer=count
	if Nlayer gt 0 then begin
		for hi=0,Nlayer-1 do begin
			topdiff=abs(tptop[hi]-alt)
			ind=where(min(topdiff) eq topdiff)
			top_scp=ind[0]
			basediff=abs(tpbase[hi]-alt)
			ind=where(min(basediff) eq basediff)
			base_scp=ind[0]
			signdata=0.0
			if (tpdata[hi] ge 156) then signdata=tpdata[hi]-256
			if (tpdata[hi] ge 0 and tpdata[hi] le 100) then signdata=tpdata[hi] ;missing value
			prof_data[si,top_scp:base_scp]=signdata

		endfor ;endif nlayer > 0
	endif ; endif layer > 0
 endfor 


end
