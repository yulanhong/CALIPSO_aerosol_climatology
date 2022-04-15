
;to plot aerosol cloud overlap in four seasons

pro  plot_aerocld_overlap

  subtitle=['MAM','JJA','SON','DJF']
  subtitle1=['a1)','a2)','a3)','a4)']
  subtitle2=['b1)','b2)','b3)','b4)']
  fontsz=10.5
  symsz=0.55
  minvalue=0
  maxvalue1=0.6
  maxvalue2=0.8

  posx1=[0.05,0.29,0.53,0.77]
  posx2=[0.25,0.49,0.73,0.97]
  posy1=[0.76,0.37]
  posy2=[0.96,0.62]
  barpos1=[0.30,0.70,0.70,0.72]
  barpos2=[0.30,0.33,0.70,0.35]
 
  posc=[0.08,0.08,0.49,0.24]
  posd=[0.56,0.08,0.98,0.24]

  lon=findgen(72)*5-180+2.5
  lat=findgen(90)*2-90+1

  maplimit=[-20,80,30,150]
;  maplimit=[-90,-180,90,180]
;  saveflag='global_aerocld_tau'
  saveflag='Southeast_aerocld_fre'

  restore,'Southeast_sea_noaerosol_aero_cld_fre_series.sav'
  noaero_cld_fre_series=aero_cld_fre_series
  restore,'Southeast_sea_aerosol_aero_cld_fre_series.sav'
  aero_cld_fre_series=aero_cld_fre_series
  restore,'Southeast_sea_aerosol_aero_cld_tau_series.sav'
  restore,'Southeast_sea_aerosol_aero_only_fre_series.sav'
  restore,'Southeast_sea_aerosol_aero_only_tau_series.sav'
  restore,'time.sav'

  
  for mi=0,3 do begin
  pos1=[posx1[mi],posy1[0],posx2[mi],posy2[0]]
  pos2=[posx1[mi],posy1[1],posx2[mi],posy2[1]]

  restore,'global_withaerosol'+subtitle[mi]+'_aerocld_freh.sav'
  ; aerocld_freh
  restore,'global_withaerosol'+subtitle[mi]+'_aeroonly_freh.sav'
  ; aeroonly_freh
  restore,'global_withaerosol'+subtitle[mi]+'_ave_aerocld_tau.sav'
  ;ave_aerocld_tau
  restore,'global_withaerosol'+subtitle[mi]+'_ave_aeroonly_tau.sav'
  ;ave_aeroonly_tau
  indlat=where(lat ge maplimit[0] and lat le maplimit[2])
  aerocld_freh1=aerocld_freh[*,indlat]
  aeroonly_freh1=aeroonly_freh[*,indlat] 
  print,'aero-cld, aero-no cld',aerocld_freh[62,38],aeroonly_freh[62,38]

  indlon=where(lon ge maplimit[1] and lon le maplimit[3])
  aerocld_freh2=aerocld_freh1[indlon,*]
  aeroonly_freh2=aeroonly_freh1[indlon,*] 

;  print,min(aerocld_freh2,/nan),max(aerocld_freh2,/nan)
;  print,min(aeroonly_freh2,/nan),max(aeroonly_freh2,/nan)

  if mi eq 0 then begin
  im=image(aerocld_freh,lon,lat,dim=[850,600],rgb_table=33,min_value=0.0,$
	max_value=maxvalue1, position=pos1)
  endif else begin
  im=image(aerocld_freh,lon,lat,rgb_table=33,min_value=0.0,$
	max_value=maxvalue1, position=pos1,/current)
  endelse

  mp=map('Geographic',limit=maplimit,transparency=30,overplot=im)
  grid=mp.MAPGRID
  grid.label_position=0
  grid.linestyle='dotted'
  grid.grid_longitude=20
  mc=mapcontinents(/continents,transparency=30)
  mc['Longitudes'].label_angle=0

  t=text(pos1[0],pos1[3],subtitle1[mi]+' '+subtitle[mi],/normal,font_size=fontsz)

  im1=image(aeroonly_freh,lon,lat,rgb_table=33,min_value=0,max_value=maxvalue2,$
	position=pos2,/current)
  mp=map('Geographic',limit=maplimit,transparency=30,overplot=im1)
  grid=mp.MAPGRID
  grid.label_position=0
  grid.linestyle='dotted'
  grid.grid_longitude=20
  mc=mapcontinents(/continents,transparency=30)
  mc['Longitudes'].label_angle=0
  t=text(pos2[0],pos2[3]-0.02,subtitle2[mi]+' '+subtitle[mi],/normal,font_size=fontsz)
  
  endfor
  ct=colorbar(target=im,title='Aerosol Occurrence Frequency (cloud overlap)',taper=1,$
	border=1,position=barpos1,font_size=fontsz)

  ct1=colorbar(target=im1,title='Aerosol Occurrence Frequency (no cloud overlap)',taper=1,$
	border=1,position=barpos2,font_size=fontsz)

 ;=== to plot time series=========================
 nx=n_elements(aero_only_fre_series)
 x=findgen(nx)
 xname=strarr(12)
 xvalue=intarr(12)
 yr1=0
 for i=0,nx-1 do begin
        if ((i mod 6) eq 0) and ((i/6 mod 2) eq 0) then begin
          yr=2006+yr1
          xname[yr1]=strmid(strcompress(string(yr)+'06'),3,4)
          xvalue[yr1]=i
          yr1=yr1+1
        endif
 endfor

 p=plot(x,aero_only_fre_series,position=posc,ytitle='Frequency',xtitle='Time (yymm)',$
	xtickname=xname,xtickvalues=xvalue,font_size=fontsz,symbol='Circle',sym_filled=1,$
	sym_size=symsz,name='Aerosol-no cloud overlap',/current,xrange=[0,nx],yrange=[0,1])

 ax=p.AXES
 ax[0].text_orientation=20

 t=text(posc[0],posc[3]+0.01,'c)',/normal)
 p01=plot(x,aero_cld_fre_series[*,0],overplot=p,name='Aerosol-cloud overlap',$
	symbol='Triangle',sym_filled=1,sym_size=symsz,color='r')

 p02=plot(x,noaero_cld_fre_series[*,0],overplot=p,color='blue',symbol='Square',sym_size=symsz,$
	sym_filled=1,name='Cloud-no aerosol overlap',transparency=30)
 
 ld=legend(target=[p02],position=[posc[0]+0.4,posc[3]-0.01],shadow=0,/auto_text_color,/normal)
 ld.sample_width=0.08
 ld.linestyle=6
 ld.transparency=100
 ld.font_size=fontsz

 ld=legend(target=[p,p01],position=[posd[0]+0.4,posd[3]-0.01],shadow=0,/auto_text_color,/normal)
 ld.sample_width=0.08
 ld.linestyle=6
 ld.transparency=100
 ld.font_size=fontsz
 ld.vertical_spacing=0

 p1=plot(x,aero_only_tau_series,position=posd,ytitle='AOD',xtitle='Time (yymm)',$
	xtickname=xname,xtickvalues=xvalue,font_size=fontsz,symbol='Circle',sym_filled=1,$
	sym_size=symsz,/current,xrange=[0,nx])
 ax=p1.AXES
 ax[0].text_orientation=20
 p11=plot(x,aero_cld_tau_series[*,0],overplot=p1,symbol='Triangle',sym_filled=1,$
	sym_size=symsz,color='r') 
 t=text(posd[0],posd[3]+0.01,'d)',/normal)

 im.save,saveflag+'_fourseason.png'

 stop
end
