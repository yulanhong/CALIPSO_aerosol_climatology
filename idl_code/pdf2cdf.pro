pro pdf2cdf,pdf,cdf

 nsize=size(pdf)

 cdf=fltarr(nsize[1])
 for yi=0,nsize[1]-1 do begin
	if yi eq 0 then cdf[yi]=pdf[yi] else cdf[yi]=cdf[yi-1]+pdf[yi]
 endfor 

end
