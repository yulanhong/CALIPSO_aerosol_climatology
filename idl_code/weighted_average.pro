
pro weighted_average,weight,data,avedata

  nsize=size(data)
  nx=nsize[1]
  ny=nsize[2]
  twdata=0.0
  tweight=0.0

  for xi=0,nx-1 do begin
	for yi=0,ny-1 do begin
		if finite(data[xi,yi]) eq 1 then begin
		twdata=twdata+data[xi,yi]*weight[yi]
		tweight=tweight+weight[yi]			
		endif
	endfor
  endfor

stop
end
