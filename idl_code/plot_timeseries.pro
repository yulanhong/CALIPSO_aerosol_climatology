; save files are from lidlayer_phase_timeseries.pro

pro plot_timeseries

;region=['midchina','india','westafrica','global','eastasia','philipine']
region=['global','west_us','east_us','center_atlantic','africa','europe','india','east_asia','indonesia','amazon']

n=161
restore,'time.sav'
xname=strarr(14)
xvalue=fltarr(14)
yr1=0
x=findgen(n+1)

month1=intarr(n_elements(month)+1)
month1[0:108]=month[0:108]
month1[109]=2
month1[110:n]=month[109:n-1]


for i=0,n do begin
	if (month1[i] eq 1) then begin
	 yr=2007+yr1
	 xname[yr1]=strmid(strcompress(string(yr))+strmid(strcompress(string(month[i]/100.0)),3,2),3,4)
	 xvalue[yr1]=i
	 print,yr,yr1,xname[yr1]
	 yr1=yr1+1
	endif
 endfor

for k=0,n_elements(region)-1 do begin

;restore,region[k]+'_noAerosol_aero_cld_fre_series.sav'
;cld_noaero_fre=aero_cld_fre_series  ; cloud only
;restore,region[k]+'_withAerosol_aero_cld_fre_series.sav'
;restore,region[k]+'_withAerosol_aero_cld_tau_series.sav'
;restore,region[k]+'_withAerosol_aero_only_fre_series.sav'
;restore,region[k]+'_withAerosol_aero_only_tau_series.sav'
restore,region[k]+'_aero_cld_fra_series.sav'
restore,region[k]+'_aero_cld_tau_series.sav'
restore,region[k]+'_aero_only_fra_series.sav'
restore,region[k]+'_aero_only_tau_series.sav'
restore,region[k]+'_aero_allsky_fra_series.sav'
restore,region[k]+'_aero_allsky_tau_series.sav'
restore,region[k]+'_aero_isolate_fra_series.sav'
restore,region[k]+'_aero_isolate_tau_series.sav'
restore,region[k]+'_aero_incld_fra_series.sav'
restore,region[k]+'_aero_incld_tau_series.sav'

help,aero_cld_tau_series
;plot_4curve,aero_cld_fre_series,aero_cld_tau_series,aero_only_fre_series,$
;	aero_only_tau_series,month,region[k]+'_withAerosol_timeseries.png'
;=============
pcolor='orange'
fontsz=8
fonttk=1.2
margin=[0.15,0.16,0.01,0.1]
symsz=0.5
otyrange1=[0.1 ,0.0,0.05, 0.1,0.1 ,0.05, 0.1, 0.0,0.0,0.0] 
otyrange2=[0.16,0.2,0.3 , 0.5,0.6 ,0.25,0.65, 0.5,0.3,0.5]
fryrange1=[0.0 ,0.0,0.0 ,   0,0.0 , 0.0,   0, 0.0,0.0,0.0]
;fryrange2=[0.25,0.35,0.4, 0.6,0.45,0.35, 0.6, 0.5,0.4,0.45]
fryrange2=[0.6,0.6,0.6, 0.6,0.6,0.6, 0.6, 0.6,0.6,0.6]
title1=['(a) GLO','(b) WUS','(c) EUS','(d) CAO','(e) SAO','(f) EUR','(g) IND','(h) EAS','(i) MIN','(j) AMZ']

  yrange=[otyrange1[k],otyrange2[k]]
  yrange1=[fryrange1[k],fryrange2[k]]

aero_cld_tau_series1=fltarr(n+1)
aero_cld_fre_series1=fltarr(n+1)
aero_all_tau_series1=fltarr(n+1)
aero_all_fre_series1=fltarr(n+1)
aero_incld_tau_series1=fltarr(n+1)
aero_incld_fre_series1=fltarr(n+1)
aero_isolate_tau_series1=fltarr(n+1)
aero_isolate_fre_series1=fltarr(n+1)
aero_only_tau_series1=fltarr(n+1)
aero_only_fre_series1=fltarr(n+1)

aero_cld_tau_series1[0:108]=aero_cld_tau_series[0:108]
aero_cld_tau_series1[109]=!values.f_nan
aero_cld_tau_series1[110:n]=aero_cld_tau_series[109:n-1]
aero_cld_fre_series1[0:108]=aero_cld_fra_series[0:108]
aero_cld_fre_series1[109]=!values.f_nan
aero_cld_fre_series1[110:n]=aero_cld_fra_series[109:n-1]

aero_all_tau_series1[0:108]=aero_all_tau_series[0:108]
aero_all_tau_series1[109]=!values.f_nan
aero_all_tau_series1[110:n]=aero_all_tau_series[109:n-1]
aero_all_fre_series1[0:108]=aero_all_fra_series[0:108]
aero_all_fre_series1[109]=!values.f_nan
aero_all_fre_series1[110:n]=aero_all_fra_series[109:n-1]

aero_incld_tau_series1[0:108]=aero_incld_tau_series[0:108]
aero_incld_tau_series1[109]=!values.f_nan
aero_incld_tau_series1[110:n]=aero_incld_tau_series[109:n-1]
aero_incld_fre_series1[0:108]=aero_incld_fra_series[0:108]
aero_incld_fre_series1[109]=!values.f_nan
aero_incld_fre_series1[110:n]=aero_incld_fra_series[109:n-1]

aero_isolate_tau_series1[0:108]=aero_isolate_tau_series[0:108]
aero_isolate_tau_series1[109]=!values.f_nan
aero_isolate_tau_series1[110:n]=aero_isolate_tau_series[109:n-1]
aero_isolate_fre_series1[0:108]=aero_isolate_fra_series[0:108]
aero_isolate_fre_series1[109]=!values.f_nan
aero_isolate_fre_series1[110:n]=aero_isolate_fra_series[109:n-1]


aero_only_tau_series1[0:108]=aero_only_tau_series[0:108]
aero_only_tau_series1[109]=!values.f_nan
aero_only_tau_series1[110:n]=aero_only_tau_series[109:n-1]
aero_only_fre_series1[0:108]=aero_only_fra_series[0:108]
aero_only_fre_series1[109]=!values.f_nan
aero_only_fre_series1[110:n]=aero_only_fra_series[109:n-1]


if k eq 0 then begin	

  p=plot(x,aero_cld_tau_series1,dim=[820,1020],color=pcolor,name='Cloudy aerosol',layout=[2,n_elements(region),2*k+1],$
	ytitle='AOD',xtitle='Time(yymm)',xtickname=xname,xtickvalues=xvalue,margin=margin,$
	font_size=fontsz,thick=fonttk,symbol='Circle',sym_size=symsz,sym_filled=1,xrange=[0,n],yrange=yrange,yminor=3)
  pos=p.position
  t1=text(pos[0]-0.055,pos[1]+0.03,title1[k],/normal,orientation=90,font_size=fontsz+1)


  p1=plot(x,aero_only_tau_series1,overplot=p,color='r',symbol='triangle',name='Cloud-free aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)
  p2=plot(x,aero_incld_tau_series1,overplot=p,color='g',symbol='Square',name='In-cloud aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)
  p3=plot(x,aero_isolate_tau_series1,overplot=p,color='grey',symbol='diamond',name='Isolate-cloud aerosol',$
	sym_size=symsz,sym_filled=1);font_size=fontsz,thick=fonttk)

  p0=plot(x,aero_cld_fre_series1,color=pcolor,name='Cloudy aerosol',layout=[2,n_elements(region),2*k+2],$
	ytitle='Frequency',xtitle='Time(yymm)',xtickname=xname,xtickvalues=xvalue,/current,margin=margin,$
	font_size=fontsz,thick=fonttk,symbol='Circle',sym_size=symsz,sym_filled=1,xrange=[0,n-1],yrange=yrange1)
  pos=p0.position

  p1=plot(x,aero_only_fre_series1,overplot=p0,color='r',symbol='triangle',name='Cloud-free aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)
  p2=plot(x,aero_incld_fre_series1,overplot=p0,color='g',symbol='Square',name='In-cloud aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)
  p3=plot(x,aero_isolate_fre_series1,overplot=p0,color='grey',symbol='diamond',name='Isolate-cloud aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)

	endif else begin

  pot=plot(x,aero_cld_tau_series1,color=pcolor,name='Cloudy aerosol',layout=[2,n_elements(region),2*k+1],$
	ytitle='AOD',xtitle='Time(yymm)',xtickname=xname,xtickvalues=xvalue,/current,margin=margin,yminor=3,$
	font_size=fontsz,thick=fonttk,symbol='Circle',sym_size=symsz,sym_filled=1,xrange=[0,n-1],yrange=yrange)
  pos=pot.position
  t1=text(pos[0]-0.055,pos[1]+0.03,title1[k],/normal,orientation=90,font_size=fontsz+1)

  p1=plot(x,aero_only_tau_series1,overplot=pot,color='r',symbol='triangle',name='Cloud-free aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)
  p2=plot(x,aero_incld_tau_series1,overplot=pot,color='g',symbol='Square',name='In-cloud aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)
  p3=plot(x,aero_isolate_tau_series1,overplot=pot,color='grey',symbol='diamond',name='Isolate-cloud aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)

  pf=plot(x,aero_cld_fre_series1,color=pcolor,name='Cloudy aerosol',layout=[2,n_elements(region),2*k+2],$
	ytitle='Frequency',xtitle='Time(yymm)',xtickname=xname,xtickvalues=xvalue,/current,margin=margin,$
	font_size=fontsz,thick=fonttk,symbol='Circle',sym_size=symsz,sym_filled=1,xrange=[0,n-1],yrange=yrange1)

  p1=plot(x,aero_only_fre_series1,overplot=pf,color='r',symbol='triangle',name='Cloud-free aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)
  p2=plot(x,aero_incld_fre_series1,overplot=pf,color='g',symbol='Square',name='In-cloud aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)
  p3=plot(x,aero_isolate_fre_series1,overplot=pf,color='grey',symbol='diamond',name='Isolate-cloud aerosol',$
	sym_size=symsz,sym_filled=1);,font_size=fontsz,thick=fonttk)

	print,2*k+1,2*k+2
endelse 

p.save,'regional_seasonal_aerosol_aodfre.png'
;======
endfor

 stop
end

pro plot_4curve,aero_cld_fre,aero_cld_tau,aero_only_fre,aero_only_tau,$
	time,fname
 
  n=n_elements(aero_cld_fre)
  x=findgen(n)

  xname=strarr(14)
  xvalue=intarr(14)

  yr1=0
  yr2=0
 
  fontsz=11
  fonttk=2.
  symsz=0.8

  for i=0,n-1 do begin
	if ((i mod 6) eq 0) and ((i/6 mod 2) eq 0) then begin
	 yr=2007+yr1
	 xname[yr1]=strmid(strcompress(string(yr)+'01'),3,4)
	 xvalue[yr1]=i
	 print,yr,yr1,xname[yr1]
	 yr1=yr1+1
	endif
  endfor
;	if ((i mod 6) eq 1) and ((i/6 mod 2) eq 1) then begin
;	 yr=2006+yr2
;	 xname[i]=strcompress(string(yr)+'12')
;	 yr2=yr2+1
;	endif
 
  p=plot(x,aero_cld_tau,dim=[700,500],color='black',name='Aerosol in cloudy sky',layout=[1,2,1],$
	ytitle='AOD',xtitle='Time (yymm)',xtickname=xname,xtickvalues=xvalue,$
	font_size=fontsz,thick=fonttk,symbol='Circle',sym_size=symsz,sym_filled=1,xrange=[0,n-1])
  pos=p.position
  t1=text(pos[0]+0.05,pos[3]+0.01,'a)',/normal)

  p1=plot(x,aero_only_tau,color='r',symbol='Triangle',sym_size=symsz,sym_filled=1,name='Aerosol in clear sky',$
	overplot=p,thick=fonttk)
  

  p2=plot(x,aero_cld_fre,dim=[650,500],color='black',layout=[1,2,2],ytitle='Frequency',/current,$
	xtitle='Time (yymm)',xtickname=xname,xtickvalues=xvalue,font_size=fontsz,$
	thick=fonttk,symbol='Circle',sym_size=symsz,sym_filled=1,yrange=[0,0.5],xrange=[0,n-1])
  p3=plot(x,aero_only_fre,color='r',overplot=p2,thick=fonttk,symbol='Triangle',sym_size=symsz,sym_filled=1)
  pos=p2.position
  t2=text(pos[0]+0.05,pos[3]+0.01,'b)',/normal)

  ld=legend(target=[p,p1],position=[pos[0]+0.85,pos[3]+0.16],shadow=0)
  p.save,fname
 
end
