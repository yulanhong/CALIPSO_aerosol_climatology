pro area_weighted_mean,weight,data

   nsize=size(data)
   dimx=nsize[1]
   dimy=nsize[2]

	tweight=0.0
    tdata=0.0
   for xi=0,dimx-1 do begin
	for yi=0, dimy-1 do begin
	   	tdata=tdata+data[xi,yi]*weight[yi]
		tweight=tweight+weight[yi]
    endfor
   endfor

   print,tdata/tweight
   stop
end
