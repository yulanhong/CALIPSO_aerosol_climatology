pro include_median,org_data,tau_interval,mediandata

     nsize=size(org_data)
     dimx=nsize[1]
     dimy=nsize[2]
 
     mediandata=fltarr(dimx,dimy)
     for xi=0,dimx-1 do begin
         for yi=0,dimy-1 do begin
             pdf2cdf,reform(org_data[xi,yi,*])/total(float(org_data[xi,yi,*])),cdf
             diff=abs(cdf-0.5)
             ind=where(min(diff) eq diff)
             tau1=tau_interval[ind[0]]
             tau05=0
             cdf1=cdf[ind[0]]
             if (cdf1 gt 0.5) then begin
                 if (cdf[ind[0]] ne cdf[ind[0]-1]) then $
                 tau05=((0.5-cdf[ind[0]-1])*tau1+(cdf[ind[0]]-0.5)*tau_interval[ind[0]-1])/(cdf[ind[0]]-cdf[ind[0]-1]) $
                 else tau05=tau1
             endif
 
             if (cdf1 lt 0.5) then begin
                  if (cdf[ind[0]+1] ne cdf[ind[0]]) then $
                  tau05=((0.5-cdf[ind[0]])*tau_interval[ind[0]+1]+(cdf[ind[0]+1]-0.5)*tau1)/(cdf[ind[0]+1]-cdf[ind[0]]) $
                  else tau05=tau1
             endif
 
             scp=tau05
             if cdf1 eq 0.5 then scp=tau1
             tau=10.0^scp
             mediandata[xi,yi]=tau
 
         endfor
     endfor



end
