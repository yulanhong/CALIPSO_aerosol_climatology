pro plot_lidar_ratio_bd

  dir='/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap'

  fname=file_search(dir,'*.hdf')

  Nf=n_elements(fname)

  lidar_ratio=1
  dep_bd=0

  fontsz=13

  Taeroonly_lr=0L
  Taeroisolate_lr=0L
  Taeroincld_lr=0L

  Taeroonly_bd=0L
  Taeroisolate_bd=0L
  Taeroincld_bd=0L

  for fi=0,Nf-1 do begin
	read_dardar,fname[fi],'aero_only_lidar_ratio',aeroonly_lr
	read_dardar,fname[fi],'isolate_aero_lidar_ratio',aeroisolate_lr
	read_dardar,fname[fi],'incld_aero_lidar_ratio',aeroincld_lr
	Taeroonly_lr=Taeroonly_lr+aeroonly_lr
	Taeroisolate_lr=Taeroisolate_lr+aeroisolate_lr
	Taeroincld_lr=Taeroincld_lr+aeroincld_lr

	read_dardar,fname[fi],'aero_only_backscat_depratio',aeroonly_bd
	read_dardar,fname[fi],'isolate_aero_backscat_depratio',aeroisolate_bd
	read_dardar,fname[fi],'incld_aero_backscat_depratio',aeroincld_bd
	Taeroonly_bd=Taeroonly_bd+aeroonly_bd
	Taeroisolate_bd=Taeroisolate_bd+aeroisolate_bd
	Taeroincld_bd=Taeroincld_bd+aeroincld_bd	

  endfor

  bcolor=['r','g','b','purple','cyan','yellow','grey','pink','peru']

  maxvalue=0.5

  If lidar_ratio eq 1 then begin
  symsz=5
  pos1=[0.10,0.15,0.49,0.9]
  pos2=[0.59,0.15,0.98,0.9]

  x=findgen(90)+10
  aeroonly_fr=total(Taeroonly_lr,2)/float(total(Taeroonly_lr))
  ;b01=barplot(x,aeroonly_fr*100.0,index=0,nbars=5,dim=[650,300],position=pos1,xticklen=0.02,yticklen=0.02,$
;	ytitle='Frequency (%)',yrange=[0,50],xtitle='Lidar ratio')
 ; b02=barplot(x,aeroonly_fr*100.0,index=0,nbars=4,position=pos2,xticklen=0.02,yticklen=0.02,$
;	ytitle='Frequency (%)',/current,yrange=[0,50],xtitle='Lidar Ratio')
  b01=plot(x,aeroonly_fr*100.0,dim=[650,300],position=pos1,xticklen=0.02,yticklen=0.02,$
	ytitle='Frequency (%)',yrange=[0,60],xtitle='Lidar ratio',symbol='Circle',sym_filled=1,$
	sym_size=smysz,linestyle='none',name='Cloud-free aerosol')
  b02=plot(x,aeroonly_fr*100.0,/current,position=pos2,xticklen=0.02,yticklen=0.02,$
	ytitle='Frequency (%)',yrange=[0,60],xtitle='Lidar ratio',symbol='Circle',sym_filled=1,$
	sym_size=smysz,linestyle='none',name='Cloud-free aerosol')
   a1=text(pos1[0]+0.03,pos1[3]+0.01,'a)',font_size=fontsz)
	 a2=text(pos2[0]+0.03,pos2[3]+0.01,'b)',font_size=fontsz)


  ; for merged cases
   data1=reform(Taeroincld_lr[*,0])/float(total(Taeroincld_lr[*,0]))
;   d1=barplot(x,data1*100,index=1,nbars=5,color='pink',name='Merged layer only',overplot=b01)
   d1=plot(x,data1*100,color='pink',name='Merged layer only',overplot=b01,symbol='Circle',sym_filled=1,$
 	sym_size=smysz,linestyle='none')

   data2=reform(Taeroincld_lr[*,1])/float(total(Taeroincld_lr[*,1]))
;   d2=barplot(x,data2*100,index=2,nbars=5,color='r',name='Merged layer below cloud',overplot=b01)
   d2=plot(x,data2*100,color='r',name='Merged layer below cloud',overplot=b01,symbol='Triangle',sym_filled=1,$
 	sym_size=smysz,linestyle='none')

   data3=reform(Taeroincld_lr[*,2]+Taeroincld_lr[*,3])/float(total(Taeroincld_lr[*,2])+total(Taeroincld_lr[*,3]))
;   d3=barplot(x,data3*100,index=3,nbars=5,color='g',name='Merged layer above cloud',overplot=b01)
   d3=plot(x,data3*100,color='g',name='Merged layer above cloud',overplot=b01,symbol='Square',sym_filled=1,$
 	sym_size=smysz,linestyle='none')

   data4=reform(Taeroincld_lr[*,4]+Taeroincld_lr[*,5])/float(total(Taeroincld_lr[*,4])+total(Taeroincld_lr[*,5]))
;   d4=barplot(x,data4*100,index=4,nbars=5,color='cyan',name='Others',overplot=b01)
   d4=plot(x,data4*100,color='cyan',name='Other in-cloud aerosol',overplot=b01,symbol='Star',sym_filled=1,$
 	sym_size=smysz,linestyle='none')
  ld=legend(target=[b01,d1,d2,d3,d4],position=[pos1[0]+0.11,pos1[3]-0.01],transparency=100,horizontal_alignment=0,$
        vertical_spacing=0.01,sample_width=0,font_size=fontsz-2)


  ; for isolated cases
   data5=reform(Taeroisolate_lr[*,0]+Taeroisolate_lr[*,3]+Taeroisolate_lr[*,7])/float(total(Taeroisolate_lr[*,0]+Taeroisolate_lr[*,3]+Taeroisolate_lr[*,7]))
;   c1=barplot(x,data5*100,index=1,nbars=4,color='r',name='Below-cloud aerosol',overplot=b02)
   c1=plot(x,data5*100,color='r',name='Below-cloud aerosol',overplot=b02,symbol='Triangle',sym_filled=1,$
 	sym_size=smysz,linestyle='none')
   data6=reform(Taeroisolate_lr[*,1]+Taeroisolate_lr[*,4]+Taeroisolate_lr[*,6])/float(total(Taeroisolate_lr[*,1]+Taeroisolate_lr[*,4]+Taeroisolate_lr[*,6]))
   ;c2=barplot(x,data6*100,index=2,nbars=4,color='g',name='Above-cloud aerosol',overplot=b02)
   c2=plot(x,data6*100,color='g',name='Above-cloud aerosol',overplot=b02,symbol='Square',sym_filled=1,$
 	sym_size=smysz,linestyle='none')
   data7=reform(Taeroisolate_lr[*,2]+Taeroisolate_lr[*,5]+Taeroisolate_lr[*,8])/float(total(Taeroisolate_lr[*,2]+Taeroisolate_lr[*,5]+Taeroisolate_lr[*,8]))
   ;c3=barplot(x,data7*100,index=3,nbars=4,color='cyan',name='Others',overplot=b02)
   c3=plot(x,data7*100,color='cyan',name='Other isolated-cloud aerosol',overplot=b02,symbol='Star',sym_filled=1,$
 	sym_size=smysz,linestyle='none')
  ld1=legend(target=[b02,c1,c2,c3],position=[pos2[0]+0.11,pos2[3]-0.01],transparency=100,horizontal_alignment=0,$
        vertical_spacing=0.01,sample_width=0,font_size=fontsz-2)
	b01.save,'aerosol_onlycld_lidar_ratio.png'
 
  EndIf

  y=findgen(501)*0.002
  x=findgen(501)*0.01-5 ; for logtau
  xvalue=[50,100,150,200,250,300]-50;,400,500]
  xname=['-4.5','-4','-3.5','-3','-2.5','-2'];,'-1','0']
  yvalue=[0,10,20,30,40,50]
  yname=['0','0.02','0.04','0.06','0.08','0.10']  

  IF dep_bd eq 1 Then Begin
	fontsz=12
   pos1=[0.11,0.79,0.50,0.97]
   pos2=[0.57,0.79,0.96,0.97]
   pos3=[0.11,0.58,0.50,0.76]
   pos4=[0.57,0.58,0.96,0.76]
   pos5=[0.11,0.37,0.50,0.55]  
   pos6=[0.57,0.37,0.96,0.55]
   pos7=[0.11,0.16,0.50,0.34]
   pos8=[0.57,0.16,0.96,0.34]
   xtitle='$log_{10}\beta$'
   ytitle='$\delta$'
	sa=0.85
	sb=2
	pa=0.01
	pb=-0.02
	fa=2.
	minvalue=0.0
	maxvalue=0.06
	data1=100*reform(Taeroincld_bd[*,*,0])/float(total(Taeroincld_bd[*,*,0]))
	data3=100*reform(Taeroincld_bd[*,*,1])/float(total(Taeroincld_bd[*,*,1]))
	data5=100*reform(Taeroincld_bd[*,*,2]+Taeroincld_bd[*,*,3])/float(total(Taeroincld_bd[*,*,2]+Taeroincld_bd[*,*,3]))
	data7=100*reform(Taeroincld_bd[*,*,4]+Taeroincld_bd[*,*,5])/float(total(Taeroincld_bd[*,*,4]+Taeroincld_bd[*,*,5]))

	c1=image(data1[50:300,0:50],rgb_table=33,position=pos1,dim=[500,600],min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c1,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-5,target=c1,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c1.scale,sa,sb
	t1=text(pos1[0]+pa,pos1[3]+pb,'a) Merged layer only',font_size=fontsz-fa)

	c3=image(data3[50:300,0:50],rgb_table=33,/current,position=pos3,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c3,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-5,target=c3,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c3.scale,sa,sb
	t3=text(pos3[0]+pa,pos3[3]+pb,'c) Merged layer below cloud',font_size=fontsz-fa)

	c5=image(data5[50:300,0:50],rgb_table=33,/current,position=pos5,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c5,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-5,target=c5,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c5.scale,sa,sb
	t5=text(pos5[0]+pa,pos5[3]+pb,'e) Merged layer above cloud',font_size=fontsz-fa)

	c7=image(data7[50:300,0:50],rgb_table=33,/current,position=pos7,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c7,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title=xtitle);,font_size=fontsz)
    yaxis=axis('Y',location=-5,target=c7,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c7.scale,sa,sb
	t7=text(pos7[0]+pa,pos7[3]+pb,'g) Other in-cloud aerosol',font_size=fontsz-fa)


	data2=100*total(Taeroonly_bd,3)/float(total(Taeroonly_bd))
	data4=100*reform(Taeroisolate_bd[*,*,0]+Taeroisolate_bd[*,*,3]+Taeroisolate_bd[*,*,7])/$
		float(total(Taeroisolate_bd[*,*,0]+Taeroisolate_bd[*,*,3]+Taeroisolate_bd[*,*,7]))
	data6=100*reform(Taeroisolate_bd[*,*,1]+Taeroisolate_bd[*,*,4]+Taeroisolate_bd[*,*,6])/$
		float(total(Taeroisolate_bd[*,*,1]+Taeroisolate_bd[*,*,4]+Taeroisolate_bd[*,*,6]))
	data8=100*reform(Taeroisolate_bd[*,*,2]+Taeroisolate_bd[*,*,5]+Taeroisolate_bd[*,*,8])/$
		float(total(Taeroisolate_bd[*,*,2]+Taeroisolate_bd[*,*,5]+Taeroisolate_bd[*,*,8]))


	c2=image(data2[50:300,0:50],rgb_table=33,/current,position=pos2,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c2,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-5,target=c2,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c2.scale,sa,sb
	t2=text(pos2[0]+pa,pos2[3]+pb,'b) Cloud-free aerosol',font_size=fontsz-fa)

	c4=image(data4[50:300,0:50],rgb_table=33,/current,position=pos4,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c4,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-5,target=c4,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c4.scale,sa,sb
	t4=text(pos4[0]+pa,pos4[3]+pb,'d) Below-cloud aerosol',font_size=fontsz-fa)

	c6=image(data6[50:300,0:50],rgb_table=33,/current,position=pos6,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c6,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-5,target=c6,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c6.scale,sa,sb
	t6=text(pos6[0]+pa,pos6[3]+pb,'f) Above-cloud aerosol',font_size=fontsz-fa)

	c8=image(data8[50:300,0:50],rgb_table=33,/current,position=pos8)
	xaxis=axis('X',location=0,target=c8,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title=xtitle);,font_size=fontsz)
    yaxis=axis('Y',location=-5,target=c8,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c8.scale,sa,sb
	t8=text(pos8[0]+pa,pos8[3]+pb,'h) Other isolated-cloud aerosol',font_size=fontsz-fa)

	ct=colorbar(target=c1,position=[pos7[0]+0.05,pos7[1]-0.08,pos8[2]-0.05,pos7[1]-0.06],title='Frequency (%)',$
		font_size=fontsz-0)
	c1.save,'aerosol_back_lidarratio_2dpdf.png'

	stop	
  EndIF
 
	stop

end
