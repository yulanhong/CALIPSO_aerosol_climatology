
pro   plot_region_aerofre_profile


  region=['global','west_us','east_us','center_atlantic','africa','europe','india','east_asia','indonesia','amazon']

  title1=['(a) GLO','(b) WUS','(c) EUS','(d) CAO','(e) SAO','(f) EUR','(g) IND','(h) EAS','(i) MIN','(j) AMZ']

  fontsz=10
  fonttk=2
  margin=[0.22,0.18,0.05,0.1]
;  xrange=[0,0.3]
  xrange=[0,8]
 ; xinterval=0.1

   for k=0,n_elements(region)-1 do begin

	print,region[k]

	restore,region[k]+'_aero_verfre_profile.sav'
	if k eq 0 then tobsnum=tobsnum/1.0e7
	if k gt 0 then tobsnum=tobsnum/1.0e5
	
	if k eq 0 then begin

	p=plot(cloud_fre*tobsnum,hgt,yrange=[0,15],color='orange',name='Cloudy aerosol',$
		layout=[5,2,k+1],xtitle='Sample $(x10^7)$',$
		ytitle='Alt. (km)',margin=margin,dim=[1000,450],xrange=xrange,$
     font_size=fontsz,thick=fonttk,xmajor=nxmajor,xtickinterval=xinterval);,symbol='Circle',sym_size=symsz,sym_filled=1)
    pos=p.position
	t1=text(pos[0]+0.08,pos[3]-0.05,title1[k],/normal,orientation=0,font_size=fontsz+1)

	p1=plot(aeroonly_fre*tobsnum,hgt,color='r',name='Cloud-free aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=p)
	p2=plot(incld_fre*tobsnum,hgt,color='g',name='In-cloud aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=p)
	p3=plot(isolate_fre*tobsnum,hgt,color='grey',name='Isolate-cloud aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=p)

   endif else begin
	if k eq 3 or k eq 8 then xrange=[0,20] else xrange=[0,8]
    index=2*k+1
	pot=plot(cloud_fre*tobsnum,hgt,yrange=[0,15],color='orange',name='Cloudy aerosol',$
		layout=[5,2,k+1],xtitle='Sample $(x10^5)$',$
		ytitle='Alt. (km)',margin=margin,xrange=xrange,$
     font_size=fontsz,thick=fonttk,/current,xmajor=nxmajor,xtickinterval=xinterval);,symbol='',sym_size=symsz,sym_filled=1)
    pos=pot.position
	t1=text(pos[0]+0.08,pos[3]-0.05,title1[k],/normal,orientation=0,font_size=fontsz+1)

	p1=plot(aeroonly_fre*tobsnum,hgt,color='r',name='Cloud-free aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=pot)
	p2=plot(incld_fre*tobsnum,hgt,color='g',name='In-cloud aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=pot)
	p3=plot(isolate_fre*tobsnum,hgt,color='grey',name='Isolate-cloud aerosol',$
     	font_size=fontsz,thick=fonttk,overplot=pot)

	endelse


   endfor

; ld=legend(target=[pot,p1,p2,p3],transparency=100,position=[0.85,0.45])
p.save,'regional_seasonal_aerosol_sample_profile.png'


stop

end

