; save files are from lidlayer_phase_timeseries.pro

pro plot_aerosol_timeseries

region=['midchina','nwindian','india','westafrica','global','eastasia','philipine']

for k=1,1 do begin

restore,region[k]+'_aero_allsky_fre_series.sav'
restore,region[k]+'_aero_allsky_tau_series.sav'
restore,region[k]+'_aero_only_fre_series.sav'
restore,region[k]+'_aero_only_tau_series.sav'
restore,region[k]+'_aero_cld_fre_series.sav'
restore,region[k]+'_aero_cld_tau_series.sav'
restore,'time.sav'

n=n_elements(aero_all_tau_series)
x=findgen(n)
y=aero_all_tau_series;*aero_all_fre_series
print,linfit(x,y)
p=plot(x,y)

stop
;plot_4curve,reform(aero_cld_fre_series[*,0]),reform(aero_cld_tau_series[*,0]),aero_only_fre_series,$
;	aero_only_tau_series,cld_noaero_fre,month,region[k]+'_withAerosol_timeseries.png'

endfor
end

pro plot_4curve,aero_cld_fre,aero_cld_tau,aero_only_fre,aero_only_tau,cld_noaero_fre,$
	time,fname
 
  n=n_elements(aero_cld_fre)
  x=findgen(n)

  xname=strarr(12)
  xvalue=intarr(12)

  yr1=0
  yr2=0
 
  fontsz=11
  fonttk=2.
  symsz=0.8

  for i=0,n-1 do begin
	
	if ((i mod 6) eq 0) and ((i/6 mod 2) eq 0) then begin
	 yr=2006+yr1
	 xname[yr1]=strmid(strcompress(string(yr)+'06'),3,4)
	 xvalue[yr1]=i
	 yr1=yr1+1
	endif
;	if ((i mod 6) eq 1) and ((i/6 mod 2) eq 1) then begin
;	 yr=2006+yr2
;	 xname[i]=strcompress(string(yr)+'12')
;	 yr2=yr2+1
;	endif
  endfor
 
  p=plot(x,aero_cld_tau,dim=[700,500],color='black',name='Aerosol-cloud overlap',layout=[1,2,1],$
	ytitle='AOD',xtitle='Time (yymm)',xtickname=xname,xtickvalues=xvalue,$
	font_size=fontsz,thick=fonttk,symbol='Circle',sym_size=symsz,sym_filled=1)
  pos=p.position
  t1=text(pos[0]+0.05,pos[3]+0.01,'a)',/normal)

  p1=plot(x,aero_only_tau,color='r',symbol='Triangle',sym_size=symsz,sym_filled=1,name='Aerosol-no cloud overlap',$
	overplot=p,thick=fonttk)
  

  p2=plot(x,aero_cld_fre,dim=[650,500],color='black',layout=[1,2,2],ytitle='Frequency',/current,$
	xtitle='Time (yymm)',xtickname=xname,xtickvalues=xvalue,font_size=fontsz,$
	thick=fonttk,yrange=[0,1],symbol='Circle',sym_size=symsz,sym_filled=1)
  p3=plot(x,aero_only_fre,color='r',overplot=p2,thick=fonttk,symbol='Triangle',sym_size=symsz,sym_filled=1)
  p4=plot(x,cld_noaero_fre,color='blue',overplot=p2,thick=fonttk,symbol='Square',sym_size=symsz-0.2,$
	sym_filled=1,transparency=30,name='Cloud-no aerosol overlap')
  pos=p2.position
  t2=text(pos[0]+0.05,pos[3]+0.01,'b)',/normal)

  ld=legend(target=[p,p1,p4],position=[pos[0]+0.85,pos[3]+0.16],shadow=0)
  p.save,fname
 
end
