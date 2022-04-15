pro plot_regional_seasonal_analysis1

;region='Global'
;region='Southeast_Atlantic'
;region='North_pacific'
 region='Indonesia'
restore,region+'_allaero_frequency.sav'
restore,region+'_aeroonly_frequency.sav'
restore,region+'_aerobelow_isolate_frequency.sav'
restore,region+'_aeroabove_isolate_frequency.sav'
restore,region+'_merge_layer_only_below_cloud_frequency.sav'


lnthick=2
x=findgen(12)+1
;p=plot(x,aero_only_fre,dim=[800,400],xrange=[0,13],xtitle='Month',ytitle='Frequency',thick=lnthick,symbol='circle',sym_filled=1,name='Clear')
;p1=plot(x,aerobelow_isolate_fre,overplot=p,color='r',name='Below-cloud aerosol',thick=lnthick,symbol='circle',sym_filled=1)
;p3=plot(x,aeroabove_isolate_fre,overplot=p,color='pink',name='Above-cloud aerosol',thick=lnthick,symbol='circle',sym_filled=1)
;p2=plot(x,allaero_fre,overplot=p,color='purple',name='All aerosol',thick=lnthick,symbol='circle',sym_filled=1)
;p2=plot(x,aeroabove_isolate_fre,overplot=p,color='pink',name='Above-cloud aerosol',thick=lnthick,symbol='circle',sym_filled=1) ;do not plot due to low frequency
;p3=plot(x,aeroother_isolate_fre,overplot=p,color='grey',name='Others',thick=lnthick,symbol='circle',sym_filled=1)

;p4=plot(x,merge_layer_incld,overplot=p,color='g',name='Merged layer only+below cloud',thick=lnthick,symbol='circle',sym_filled=1)
;p5=plot(x,aerobelow_incld_fre,overplot=p,color='cyan',name='Merged layer below',thick=lnthick,symbol='circle',sym_filled=1)
;p6=plot(x,aeroabove_incld_fre,overplot=p,color='purple',name='Merged layer above',thick=lnthick,symbol='circle',sym_filled=1)
;p7=plot(x,aeroother_incld_fre,overplot=p,color='blue',name='Other merged layers',thick=lnthick,symbol='circle',sym_filled=1)

;=========== plot optical depth ======

restore,region+'_aero_only_avetau.sav'
restore,region+'_allaero_avetau.sav'
restore,region+'_aerobelow_isolate_avetau.sav'
restore,region+'_aeroabove_isolate_avetau.sav'
restore,region+'_aeromergeonlybelowcld_incld_avetau.sav'
restore,region+'_aeromergenocirrus_avetau.sav'
restore,region+'_incldbelowcloud_avetau.sav'

p=plot(x,aero_only_avetau,dim=[650,600],xrange=[0,13],xtitle='Month',ytitle='AOD',thick=lnthick,symbol='circle',$
	sym_filled=1,name='Clear',position=[0.11,0.60,0.95,0.90])

p1=plot(x,aerobelow_isolate_avetau,overplot=p,color='r',name='Below-cloud aerosol',thick=lnthick,symbol='circle',sym_filled=1)
;p3=plot(x,aeroabove_isolate_avetau,overplot=p,color='pink',name='Above-cloud aerosol',thick=lnthick,symbol='circle',sym_filled=1)
p2=plot(x,allaero_avetau,overplot=p,color='purple',name='All aerosol',thick=lnthick,symbol='circle',sym_filled=1)
;p2=plot(x,aeroabove_isolate_avetau,overplot=p,color='pink',name='Above-cloud aerosol',thick=lnthick) ;do not plot due to low avetauquency
;p3=plot(x,aeroother_isolate_avetau,overplot=p,color='grey',name='Others',thick=lnthick)

p4=plot(x,aeroincld_mergelowtau,overplot=p,color='g',name='Merged-layer aerosol',thick=lnthick,symbol='circle',sym_filled=1)
;p5=plot(x,aerobelow_incld_avetau,overplot=p,color='cyan',name='Merged-layer-below-cirrus',thick=lnthick,symbol='circle',sym_filled=1)
;p6=plot(x,aeroabove_incld_avetau,overplot=p,color='purple',name='Merged-layer-above-cloud',thick=lnthick)
;p7=plot(x,aeroother_incld_avetau,overplot=p,color='blue',name='Other merged layers',thick=lnthick)
ld=legend(target=[p,p1,p2,p4],position=[0.5,0.90],transparency=100,vertical_spacing=0.01,sample_width=0.1)
; to get mean lidratio-colratio
 restore,region+'_lrcr_mean_std_aeroonly_aerobelcld_incldmergeonly_belcld.sav'
 restore,region+'_bd_mean_std_aeroonly_aerobelcld_incldmergeonly_belcld.sav'

; to get median lidratio-colratio
 restore,region+'_lrcr_median_75th_aeroonly_aerobelcld_incldmergeonly_belcld.sav'
 restore,region+'_bd_median_75th_aeroonly_aerobelcld_incldmergeonly_belcld.sav'

 symcol=['black','r','g','pink']
 for mi=0,3 do begin
  if mi eq 0 then $
	p01=scatterplot(lr_mean[mi],cr_mean[mi],sym_filled=1,sym_size=symsz,sym_color=symcol[mi],/current,$
		symbol='circle',xtitle='Lidar ratio',ytitle='Color ratio',position=[0.10,0.10,0.49,0.50])
  if mi gt 0 and mi ne 3 then p02=scatterplot(lr_mean[mi],cr_mean[mi],sym_filled=1,sym_size=symsz,sym_color=symcol[mi],$
	overplot=p01)
  if mi ne 3 then begin
  nx=round(2*lr_std[mi]/0.01)
  x1=findgen(nx)*0.01+lr_mean[mi]-lr_std[mi]
  y1=fltarr(nx)
  y1(*)=cr_mean[mi]
  p03=plot(x1,y1,color=symcol[mi],overplot=p01,transparency=0,thick=lnthick)
  ny=round(2*cr_std[mi]/0.001)
  x1=fltarr(ny)
  x1(*)=lr_mean[mi]
  y1=findgen(ny)*0.001+cr_mean[mi]-cr_std[mi]
  p04=plot(x1,y1,color=symcol[mi],overplot=p01,transparency=0,thick=lnthick)
  endif
  ;==== to plot median and percential ====
;  p05=scatterplot(lr_median[mi],cr_median[mi],sym_filled=1,symbol='s',sym_size=symsz,sym_color=symcol[mi],$
;	overplot=p01)
;  nx=round((lr_p90[mi]-lr_p10[mi])/0.01)
;  x1=findgen(nx)*0.01+lr_p10[mi]
;  y1=fltarr(nx)
;  y1(*)=cr_median[mi]
;  p51=plot(x1,y1,color=symcol[mi],overplot=p05,transparency=0,thick=lnthick,linestyle='dash')
;  ny=round((cr_p90[mi]-cr_p10[mi])/0.001)
;  x1=fltarr(ny)
;  x1(*)=lr_median[mi]
;  y1=findgen(ny)*0.001+cr_p10[mi]
;  p52=plot(x1,y1,color=symcol[mi],overplot=p05,transparency=0,thick=lnthick,linestyle='dash')

  ;============ plot bd-dep ==============
  if mi eq 0 then $
	p11=scatterplot(back_mean[mi],dep_mean[mi],sym_filled=1,sym_size=symsz,sym_color=symcol[mi],$
		symbol='circle',xtitle='$\beta$',ytitle='$\delta$',position=[0.58,0.10,0.97,0.50],/current)
  if mi gt 0 and mi ne 3 then p12=scatterplot(back_mean[mi],dep_mean[mi],sym_filled=1,sym_size=symsz,sym_color=symcol[mi],$
	overplot=p11)
  if mi ne 3 then begin
  nx=round(2*back_std[mi]/0.001)
  x1=findgen(nx)*0.001+back_mean[mi]-back_std[mi]
  y1=fltarr(nx)
  y1(*)=dep_mean[mi]
  p13=plot(x1,y1,color=symcol[mi],overplot=p11,transparency=0,thick=lnthick)
  ny=round(2*dep_std[mi]/0.001)
  x1=fltarr(ny)
  x1(*)=back_mean[mi]
  y1=findgen(ny)*0.001+dep_mean[mi]-dep_std[mi]
  p14=plot(x1,y1,color=symcol[mi],overplot=p11,transparency=0,thick=lnthick)
  endif
  ;==== to plot median ====
;  p15=scatterplot(back_median[mi],dep_median[mi],sym_filled=1,sym_size=symsz,sym_color=symcol[mi],symbol='s',$
;	overplot=p11)
;  nx=round((back_p90[mi]-back_p10[mi])/0.001)
 ; x1=findgen(nx)*0.001+back_p10[mi]
 ; y1=fltarr(nx)
 ; y1(*)=dep_median[mi]
 ; p25=plot(x1,y1,color=symcol[mi],overplot=p15,transparency=0,thick=lnthick,linestyle='dash')
 ; ny=round((dep_p90[mi]-dep_p10[mi])/0.001)
 ; x1=fltarr(ny)
 ; x1(*)=back_median[mi]
 ; y1=findgen(ny)*0.001+dep_p10[mi]
 ; p35=plot(x1,y1,color=symcol[mi],overplot=p15,transparency=0,thick=lnthick,linestyle='dash')
  
 endfor
; p03=errorplot(lr_mean,cr_mean,lr_std,cr_std)
; p04=errorplot(back_mean,dep_mean,back_std,dep_std)
 t1=text(0.11,0.91,'(a)')
 t2=text(0.11,0.51,'(b)')
 t3=text(0.57,0.51,'(c)')
 
  p.save,region+'_AOD_clbd.png'
stop

end

