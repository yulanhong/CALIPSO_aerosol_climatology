
pro  plot_median_beta_profile1


  region=['global','west_us','east_us','center_atlantic','africa','europe','india','east_asia','indonesia','amazon']

  title1=['(a) GLO','(b) WUS','(c) EUS','(d) CAO','(e) SAO','(f) EUR','(g) IND','(h) EAS','(i) MIN','(j) AMZ']

  fontsz=10
  fonttk=2
  margin=[0.22,0.18,0.05,0.1]
  xrange=[0,0.0055]
  xinterval=0.002

   for k=0,n_elements(region)-1 do begin

	restore,region[k]+'_median_beta_profile.sav'
	aveaero_only_beta = 10.0^reform(Taeroonly_profile[*,1])
	aveaero_cld_beta  = 10.0^reform(Tcloud_profile[*,1])
	aveaero_incld_beta= 10.0^reform(Tincld_profile[*,1])
	aveaero_isolate_beta=10.0^reform(Tisolate_profile[*,1])


	if k eq 0 then begin

	p=plot(aveaero_cld_beta,hgt,yrange=[0,15],color='orange',name='Cloudy aerosol',$
		layout=[5,2,k+1],xtitle='$\beta (km^{-1} Sr^{-1})$',$
		ytitle='Alt. (km)',margin=margin,dim=[1000,450],xrange=xrange,$
     font_size=fontsz,thick=fonttk,xmajor=nxmajor,xtickinterval=xinterval);,symbol='Circle',sym_size=symsz,sym_filled=1)
    pos=p.position
	t1=text(pos[0]+0.08,pos[3]-0.05,title1[k],/normal,orientation=0,font_size=fontsz+1)

	p1=plot(aveaero_only_beta,hgt,color='r',name='Cloud-free aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=p)
	p2=plot(aveaero_incld_beta,hgt,color='g',name='In-cloud aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=p)
	p3=plot(aveaero_isolate_beta,hgt,color='grey',name='Isolate-cloud aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=p)

   endif else begin

    index=2*k+1
	pot=plot(aveaero_cld_beta,hgt,yrange=[0,15],color='orange',name='Cloudy aerosol',$
		layout=[5,2,k+1],xtitle='$\beta (km^{-1} Sr^{-1})$',$
		ytitle='Alt. (km)',margin=margin,xrange=xrange,$
     font_size=fontsz,thick=fonttk,/current,xmajor=nxmajor,xtickinterval=xinterval);,symbol='',sym_size=symsz,sym_filled=1)
    pos=pot.position
	t1=text(pos[0]+0.08,pos[3]-0.05,title1[k],/normal,orientation=0,font_size=fontsz+1)

	p1=plot(aveaero_only_beta,hgt,color='r',name='Cloud-free aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=pot)
	p2=plot(aveaero_incld_beta,hgt,color='g',name='In-cloud aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=pot)
	p3=plot(aveaero_isolate_beta,hgt,color='grey',name='Isolate-cloud aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=pot)

	endelse


   endfor

; ld=legend(target=[pot,p1,p2,p3],transparency=100,position=[0.85,0.45])
p.save,'regional_seasonal_aerosol_meidan_backscatter_profile.png'


stop

end

