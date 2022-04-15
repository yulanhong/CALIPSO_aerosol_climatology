pro plot_lidratio_colratio_medianbd

  dir='/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_ACLAY/Parallel_1/aerosol_cloud_overlap_screen_2'

  fname=file_search(dir,'*.hdf')

  Nf=n_elements(fname)

  lidar_ratio=1
  dep_bd=0

  fontsz=13

  Taeroonly_lrcr=0L
  Taeroisolate_lrcr_belcld=0L
  Taeroisolate_lrcr_abvcld=0L
  Taeroisolate_lrcr_other=0L

  Taeroincld_lrcr_one=0L
  Taeroincld_lrcr_belcld=0L
  Taeroincld_lrcr_abvcld=0L
  Taeroincld_lrcr_other=0L

  Taeroonly_bddep=0L
  Taeroisolate_bddep_belcld=0L
  Taeroisolate_bddep_abvcld=0L
  Taeroisolate_bddep_other=0L

  Taeroincld_bddep_one=0L
  Taeroincld_bddep_belcld=0L
  Taeroincld_bddep_abvcld=0L
  Taeroincld_bddep_other=0L

  for fi=0,Nf-1 do begin
	IF (strlen(fname[fi]) eq 139) Then Begin
	print,fname[fi]
	read_dardar,fname[fi],'aero_only_lidratio_colratio',aeroonly_lrcr
	Taeroonly_lrcr=Taeroonly_lrcr+aeroonly_lrcr
	read_dardar,fname[fi],'isolate_aero_lidratio_colratio_belcld',aeroisolate_lrcr_belcld
	Taeroisolate_lrcr_belcld=Taeroisolate_lrcr_belcld+aeroisolate_lrcr_belcld
	read_dardar,fname[fi],'isolate_aero_lidratio_colratio_abvcld',aeroisolate_lrcr_abvcld
	Taeroisolate_lrcr_abvcld=Taeroisolate_lrcr_abvcld+aeroisolate_lrcr_abvcld
	read_dardar,fname[fi],'isolate_aero_lidratio_colratio_other',aeroisolate_lrcr_other
	Taeroisolate_lrcr_other=Taeroisolate_lrcr_other+aeroisolate_lrcr_other

	read_dardar,fname[fi],'incld_aero_lidratio_colratio_one',aeroincld_lrcr_one
	Taeroincld_lrcr_one=Taeroincld_lrcr_one+aeroincld_lrcr_one
	read_dardar,fname[fi],'incld_aero_lidratio_colratio_belcld',aeroincld_lrcr_belcld
	Taeroincld_lrcr_belcld=Taeroincld_lrcr_belcld+aeroincld_lrcr_belcld
	read_dardar,fname[fi],'incld_aero_lidratio_colratio_abvcld',aeroincld_lrcr_abvcld
	Taeroincld_lrcr_abvcld=Taeroincld_lrcr_abvcld+aeroincld_lrcr_abvcld
	read_dardar,fname[fi],'incld_aero_lidratio_colratio_other',aeroincld_lrcr_other
	Taeroincld_lrcr_other=Taeroincld_lrcr_other+aeroincld_lrcr_other

	read_dardar,fname[fi],'aero_only_backscat_depratio',aeroonly_bddep
	Taeroonly_bddep=Taeroonly_bddep+aeroonly_bddep
	read_dardar,fname[fi],'isolate_aero_backscat_depratio_belcld',aeroisolate_bddep_belcld
	Taeroisolate_bddep_belcld=Taeroisolate_bddep_belcld+aeroisolate_bddep_belcld
	read_dardar,fname[fi],'isolate_aero_backscat_depratio_abvcld',aeroisolate_bddep_abvcld
	Taeroisolate_bddep_abvcld=Taeroisolate_bddep_abvcld+aeroisolate_bddep_abvcld
	read_dardar,fname[fi],'isolate_aero_backscat_depratio_other',aeroisolate_bddep_other
	Taeroisolate_bddep_other=Taeroisolate_bddep_other+aeroisolate_bddep_other

	read_dardar,fname[fi],'incld_aero_backscat_depratio_one',aeroincld_bddep_one
	Taeroincld_bddep_one=Taeroincld_bddep_one+aeroincld_bddep_one	
	read_dardar,fname[fi],'incld_aero_backscat_depratio_belcld',aeroincld_bddep_belcld
	Taeroincld_bddep_belcld=Taeroincld_bddep_belcld+aeroincld_bddep_belcld	
	read_dardar,fname[fi],'incld_aero_backscat_depratio_abvcld',aeroincld_bddep_abvcld
	Taeroincld_bddep_abvcld=Taeroincld_bddep_abvcld+aeroincld_bddep_abvcld	
	read_dardar,fname[fi],'incld_aero_backscat_depratio_other',aeroincld_bddep_other
	Taeroincld_bddep_other=Taeroincld_bddep_other+aeroincld_bddep_other
	EndIF
  endfor

  bcolor=['r','g','b','purple','cyan','yellow','grey','pink','peru']

  maxvalue=0.5

  If lidar_ratio eq 1 then begin
   symsz=5
   pos1=[0.11,0.79,0.50,0.97]
   pos2=[0.57,0.79,0.96,0.97]
   pos3=[0.11,0.58,0.50,0.76]
   pos4=[0.57,0.58,0.96,0.76]
   pos5=[0.11,0.37,0.50,0.55]  
   pos6=[0.57,0.37,0.96,0.55]
   pos7=[0.11,0.16,0.50,0.34]
   pos8=[0.57,0.16,0.96,0.34]

  x=findgen(70)+10
  xvalue=[10,30,50,70]
  xname=['10','30','50','70']
  y=findgen(121)*0.01
  yvalue=[0,20,40,60,80,100]*0.01
  yname=['0','0.2','0.4','0.6','0.8','1.0']
	sa=0.8
	sb=26
	pa=0.01
	pb=-0.01
	fa=2.
	symsz=0.6
	minvalue=0.0
	maxvalue=0.5
	xtitle='Lidar ratio (Sr)'
    ytitle='Color ratio'

  aeroincld_lrcr_one_mean=fltarr(70)
  aeroincld_lrcr_one_std=fltarr(70)
  data1=100*total(total(Taeroincld_lrcr_one,1),1)/float(total(Taeroincld_lrcr_one))

  data11=total(total(Taeroincld_lrcr_one,1),1)
  pdf2cdf,reform(data11[12,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_one_mean[12]=res[0]
  aeroincld_lrcr_one_std[12]=res[1]

  pdf2cdf,reform(data11[33,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_one_mean[33]=res[0]
  aeroincld_lrcr_one_std[33]=res[1]

  pdf2cdf,reform(data11[59,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_one_mean[59]=res[0]
  aeroincld_lrcr_one_std[59]=res[1]

  pdf2cdf,reform(data11[42,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_one_mean[42]=res[0]
  aeroincld_lrcr_one_std[42]=res[1]

  pdf2cdf,reform(data11[44,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_one_mean[44]=res[0]
  aeroincld_lrcr_one_std[44]=res[1]

  pdf2cdf,reform(data11[26,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_one_mean[26]=res[0]
  aeroincld_lrcr_one_std[26]=res[1]


  aeroincld_lrcr_belcld_mean=fltarr(70)
  aeroincld_lrcr_belcld_std=fltarr(70)
  data3=100*total(total(Taeroincld_lrcr_belcld,1),1)/float(total(Taeroincld_lrcr_belcld))
  data11=total(total(Taeroincld_lrcr_belcld,1),1)
  pdf2cdf,reform(data11[12,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_belcld_mean[12]=res[0]
  aeroincld_lrcr_belcld_std[12]=res[1]

  pdf2cdf,reform(data11[33,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_belcld_mean[33]=res[0]
  aeroincld_lrcr_belcld_std[33]=res[1]

  pdf2cdf,reform(data11[59,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_belcld_mean[59]=res[0]
  aeroincld_lrcr_belcld_std[59]=res[1]

  pdf2cdf,reform(data11[42,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_belcld_mean[42]=res[0]
  aeroincld_lrcr_belcld_std[42]=res[1]

  pdf2cdf,reform(data11[44,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_belcld_mean[44]=res[0]
  aeroincld_lrcr_belcld_std[44]=res[1]

  pdf2cdf,reform(data11[26,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_belcld_mean[26]=res[0]
  aeroincld_lrcr_belcld_std[26]=res[1]


  aeroincld_lrcr_abvcld_mean=fltarr(70)
  aeroincld_lrcr_abvcld_std=fltarr(70)
  data5=100*total(total(Taeroincld_lrcr_abvcld,1),1)/float(total(Taeroincld_lrcr_abvcld))
  data11=total(total(Taeroincld_lrcr_abvcld,1),1)
  pdf2cdf,reform(data11[12,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_abvcld_mean[12]=res[0]
  aeroincld_lrcr_abvcld_std[12]=res[1]

  pdf2cdf,reform(data11[33,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_abvcld_mean[33]=res[0]
  aeroincld_lrcr_abvcld_std[33]=res[1]

  pdf2cdf,reform(data11[59,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_abvcld_mean[59]=res[0]
  aeroincld_lrcr_abvcld_std[59]=res[1]

  pdf2cdf,reform(data11[42,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_abvcld_mean[42]=res[0]
  aeroincld_lrcr_abvcld_std[42]=res[1]

  pdf2cdf,reform(data11[44,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_abvcld_mean[44]=res[0]
  aeroincld_lrcr_abvcld_std[44]=res[1]

  pdf2cdf,reform(data11[26,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_abvcld_mean[26]=res[0]
  aeroincld_lrcr_abvcld_std[26]=res[1]


  aeroincld_lrcr_other_mean=fltarr(70)
  aeroincld_lrcr_other_std=fltarr(70)
  data7=100*total(total(Taeroincld_lrcr_other,1),1)/float(total(Taeroincld_lrcr_other))
  data11=total(total(Taeroincld_lrcr_other,1),1)
  pdf2cdf,reform(data11[12,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_other_mean[12]=res[0]
  aeroincld_lrcr_other_std[12]=res[1]

  pdf2cdf,reform(data11[33,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_other_mean[33]=res[0]
  aeroincld_lrcr_other_std[33]=res[1]

  pdf2cdf,reform(data11[59,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_other_mean[59]=res[0]
  aeroincld_lrcr_other_std[59]=res[1]

  pdf2cdf,reform(data11[42,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_other_mean[42]=res[0]
  aeroincld_lrcr_other_std[42]=res[1]

  pdf2cdf,reform(data11[44,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_other_mean[44]=res[0]
  aeroincld_lrcr_other_std[44]=res[1]

  pdf2cdf,reform(data11[26,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroincld_lrcr_other_mean[26]=res[0]
  aeroincld_lrcr_other_std[26]=res[1]

  c1=image(data1,x,y,rgb_table=22,position=pos1,dim=[500,600],min_value=minvalue,max_value=maxvalue)
	ind=where(aeroincld_lrcr_one_mean eq 0)
	aeroincld_lrcr_one_mean[ind]=!values.f_nan
	aeroincld_lrcr_one_std[ind]=!values.f_nan
    p1=errorplot(x,aeroincld_lrcr_one_mean,aeroincld_lrcr_one_std,overplot=c1,axis_style=0,sym_size=symsz,$
	linestyle='',symbol='circle',sym_filled=1,color='grey',errorbar_color='grey',xrange=[10,80])

  xaxis=axis('X',location='bottom',target=c1,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location='left',target=c1,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c1.scale,sa,sb
	t1=text(pos1[0]+pa,pos1[3]+pb,'a) Merged layer only',font_size=fontsz-fa)


	c3=image(data3,x,y,rgb_table=22,/current,position=pos3,min_value=minvalue,max_value=maxvalue)

	ind=where(aeroincld_lrcr_belcld_mean eq 0)
	aeroincld_lrcr_belcld_mean[ind]=!values.f_nan
	aeroincld_lrcr_belcld_std[ind]=!values.f_nan
    p1=errorplot(x,aeroincld_lrcr_belcld_mean,aeroincld_lrcr_belcld_std,overplot=c3,$
	linestyle='',symbol='circle',sym_filled=1,color='grey',errorbar_color='grey',sym_size=symsz,axis_style=0)

	xaxis=axis('X',location='bottom',target=c3,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location='left',target=c3,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c3.scale,sa,sb
	t3=text(pos3[0]+pa,pos3[3]+pb,'c) Merged layer below cloud',font_size=fontsz-fa)

	c5=image(data5,x,y,rgb_table=22,/current,position=pos5,min_value=minvalue,max_value=maxvalue)
	ind=where(aeroincld_lrcr_abvcld_mean eq 0)
	aeroincld_lrcr_abvcld_mean[ind]=!values.f_nan
	aeroincld_lrcr_abvcld_std[ind]=!values.f_nan
    p1=errorplot(x,aeroincld_lrcr_abvcld_mean,aeroincld_lrcr_abvcld_std,overplot=c5,$
	linestyle='',symbol='circle',sym_filled=1,color='grey',errorbar_color='grey',sym_size=symsz,axis_style=0)

	xaxis=axis('X',location='bottom',target=c5,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location='left',target=c5,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c5.scale,sa,sb
	t5=text(pos5[0]+pa,pos5[3]+pb,'e) Merged layer above cloud',font_size=fontsz-fa)

	c7=image(data7,x,y,rgb_table=22,/current,position=pos7,min_value=minvalue,max_value=maxvalue)
	ind=where(aeroincld_lrcr_other_mean eq 0)
	aeroincld_lrcr_other_mean[ind]=!values.f_nan
	aeroincld_lrcr_other_std[ind]=!values.f_nan
    p1=errorplot(x,aeroincld_lrcr_other_mean,aeroincld_lrcr_other_std,overplot=c7,$
	linestyle='',symbol='circle',sym_filled=1,color='grey',errorbar_color='grey',sym_size=symsz,axis_style=0)
	xaxis=axis('X',location='bottom',target=c7,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title=xtitle);,font_size=fontsz)
    yaxis=axis('Y',location='left',target=c7,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c7.scale,sa,sb
	t7=text(pos7[0]+pa,pos7[3]+pb,'g) Other in-cloud aerosol',font_size=fontsz-fa)

	aeroonly_lrcr_mean=fltarr(70)
	aeroonly_lrcr_std=fltarr(70)
	data2=100*total(total(Taeroonly_lrcr,1),1)/float(total(Taeroonly_lrcr))
  data11=total(total(Taeroonly_lrcr,1),1)
  pdf2cdf,reform(data11[12,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroonly_lrcr_mean[12]=res[0]
  aeroonly_lrcr_std[12]=res[1]

  pdf2cdf,reform(data11[33,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroonly_lrcr_mean[33]=res[0]
  aeroonly_lrcr_std[33]=res[1]

  pdf2cdf,reform(data11[59,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroonly_lrcr_mean[59]=res[0]
  aeroonly_lrcr_std[59]=res[1]

  pdf2cdf,reform(data11[42,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroonly_lrcr_mean[42]=res[0]
  aeroonly_lrcr_std[42]=res[1]

  pdf2cdf,reform(data11[44,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroonly_lrcr_mean[44]=res[0]
  aeroonly_lrcr_std[44]=res[1]

  pdf2cdf,reform(data11[26,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroonly_lrcr_mean[26]=res[0]
  aeroonly_lrcr_std[26]=res[1]


	aeroinsolate_lrcr_belcld_mean=fltarr(70)
	aeroinsolate_lrcr_belcld_std=fltarr(70)
	data4=100*total(total(Taeroisolate_lrcr_belcld,1),1)/float(total(Taeroisolate_lrcr_belcld))
  data11=total(total(Taeroisolate_lrcr_belcld,1),1)
  pdf2cdf,reform(data11[12,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_belcld_mean[12]=res[0]
  aeroinsolate_lrcr_belcld_std[12]=res[1]

  pdf2cdf,reform(data11[33,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_belcld_mean[33]=res[0]
  aeroinsolate_lrcr_belcld_std[33]=res[1]

  pdf2cdf,reform(data11[59,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_belcld_mean[59]=res[0]
  aeroinsolate_lrcr_belcld_std[59]=res[1]

  pdf2cdf,reform(data11[42,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_belcld_mean[42]=res[0]
  aeroinsolate_lrcr_belcld_std[42]=res[1]

  pdf2cdf,reform(data11[44,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_belcld_mean[44]=res[0]
  aeroinsolate_lrcr_belcld_std[44]=res[1]

  pdf2cdf,reform(data11[26,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_belcld_mean[26]=res[0]
  aeroinsolate_lrcr_belcld_std[26]=res[1]

	aeroinsolate_lrcr_abvcld_mean=fltarr(70)
	aeroinsolate_lrcr_abvcld_std=fltarr(70)
	data6=100*total(total(Taeroisolate_lrcr_abvcld,1),1)/float(total(Taeroisolate_lrcr_abvcld))
  data11=total(total(Taeroisolate_lrcr_abvcld,1),1)
  pdf2cdf,reform(data11[12,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_abvcld_mean[12]=res[0]
  aeroinsolate_lrcr_abvcld_std[12]=res[1]

  pdf2cdf,reform(data11[33,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_abvcld_mean[33]=res[0]
  aeroinsolate_lrcr_abvcld_std[33]=res[1]

  pdf2cdf,reform(data11[59,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_abvcld_mean[59]=res[0]
  aeroinsolate_lrcr_abvcld_std[59]=res[1]

  pdf2cdf,reform(data11[42,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_abvcld_mean[42]=res[0]
  aeroinsolate_lrcr_abvcld_std[42]=res[1]

  pdf2cdf,reform(data11[44,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_abvcld_mean[44]=res[0]
  aeroinsolate_lrcr_abvcld_std[44]=res[1]

  pdf2cdf,reform(data11[26,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_abvcld_mean[26]=res[0]
  aeroinsolate_lrcr_abvcld_std[26]=res[1]


 aeroinsolate_lrcr_other_mean=fltarr(70)
 aeroinsolate_lrcr_other_std=fltarr(70)

  data8=100*total(total(Taeroisolate_lrcr_other,1),1)/float(total(Taeroisolate_lrcr_other))
  data11=total(total(Taeroisolate_lrcr_other,1),1)
  pdf2cdf,reform(data11[12,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_other_mean[12]=res[0]
  aeroinsolate_lrcr_other_std[12]=res[1]

  pdf2cdf,reform(data11[33,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_other_mean[33]=res[0]
  aeroinsolate_lrcr_other_std[33]=res[1]

  pdf2cdf,reform(data11[59,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_other_mean[59]=res[0]
  aeroinsolate_lrcr_other_std[59]=res[1]

  pdf2cdf,reform(data11[42,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_other_mean[42]=res[0]
  aeroinsolate_lrcr_other_std[42]=res[1]

  pdf2cdf,reform(data11[44,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_other_mean[44]=res[0]
  aeroinsolate_lrcr_other_std[44]=res[1]

  pdf2cdf,reform(data11[26,*]),cdf11
  cdfy=float(cdf11)/cdf11[120]
  res=interpol(y,cdfy,[0.5,0.1])
  aeroinsolate_lrcr_other_mean[26]=res[0]
  aeroinsolate_lrcr_other_std[26]=res[1]

	c2=image(data2,x,y,rgb_table=22,/current,position=pos2,min_value=minvalue,max_value=maxvalue)
	ind=where(aeroonly_lrcr_mean eq 0)
	aeroonly_lrcr_mean[ind]=!values.f_nan
	aeroonly_lrcr_std[ind]=!values.f_nan
    p1=errorplot(x,aeroonly_lrcr_mean,aeroonly_lrcr_std,overplot=c2,$
	linestyle='',symbol='circle',sym_filled=1,color='grey',errorbar_color='grey',sym_size=symsz,axis_style=0)

	xaxis=axis('X',location='bottom',target=c2,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location='left',target=c2,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c2.scale,sa,sb
	t2=text(pos2[0]+pa,pos2[3]+pb,'b) Cloud-free aerosol',font_size=fontsz-fa)

	c4=image(data4,x,y,rgb_table=22,/current,position=pos4,min_value=minvalue,max_value=maxvalue)
	ind=where(aeroinsolate_lrcr_belcld_mean eq 0)
	aeroinsolate_lrcr_belcld_mean[ind]=!values.f_nan
	aeroinsolate_lrcr_belcld_std[ind]=!values.f_nan
    p1=errorplot(x,aeroinsolate_lrcr_belcld_mean,aeroinsolate_lrcr_belcld_std,overplot=c4,$
	linestyle='',symbol='circle',sym_filled=1,color='grey',errorbar_color='grey',sym_size=symsz,axis_style=0)

	xaxis=axis('X',location='bottom',target=c4,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location='left',target=c4,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c4.scale,sa,sb
	t4=text(pos4[0]+pa,pos4[3]+pb,'d) Below-cloud aerosol',font_size=fontsz-fa)

	c6=image(data6,x,y,rgb_table=22,/current,position=pos6,min_value=minvalue,max_value=maxvalue)
	ind=where(aeroinsolate_lrcr_abvcld_mean eq 0)
	aeroinsolate_lrcr_abvcld_mean[ind]=!values.f_nan
	aeroinsolate_lrcr_abvcld_std[ind]=!values.f_nan
    p1=errorplot(x,aeroinsolate_lrcr_abvcld_mean,aeroinsolate_lrcr_abvcld_std,overplot=c6,$
	linestyle='',symbol='circle',sym_filled=1,color='grey',errorbar_color='grey',sym_size=symsz,axis_style=0)
	xaxis=axis('X',location='bottom',target=c6,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location='left',target=c6,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c6.scale,sa,sb
	t6=text(pos6[0]+pa,pos6[3]+pb,'f) Above-cloud aerosol',font_size=fontsz-fa)

	c8=image(data8,x,y,rgb_table=22,/current,position=pos8)
	ind=where(aeroinsolate_lrcr_other_mean eq 0)
	aeroinsolate_lrcr_other_mean[ind]=!values.f_nan
	aeroinsolate_lrcr_other_std[ind]=!values.f_nan
    p1=errorplot(x,aeroinsolate_lrcr_other_mean,aeroinsolate_lrcr_other_std,overplot=c8,$
	linestyle='',symbol='circle',sym_filled=1,color='grey',errorbar_color='grey',sym_size=symsz,axis_style=0)
	xaxis=axis('X',location='bottom',target=c8,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title=xtitle);,font_size=fontsz)
    yaxis=axis('Y',location='left',target=c8,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c8.scale,sa,sb
	t8=text(pos8[0]+pa,pos8[3]+pb,'h) Other isolated-cloud aerosol',font_size=fontsz-fa)

	ct=colorbar(target=c1,position=[pos7[0]+0.05,pos7[1]-0.08,pos8[2]-0.05,pos7[1]-0.06],title='Frequency (%)',$
		font_size=fontsz-0)

  c1.save,'aerosol_onlycld_lidratio_colratio_median.png'
 stop 
  EndIf

  IF dep_bd eq 1 Then Begin
  y=findgen(21)*0.005
  x=findgen(91)*0.05-4.5 ; for logtau
  xvalue=[0,10,20,30,40,50,60]
  xname=['-4.5','-4','-3.5','-3','-2.5','-2','-1.5']
  yvalue=[0,4,8,12,16]
  yname=['0','0.02','0.04','0.06','0.08']  

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
	sb=1.3
	pa=0.01
	pb=-0.01
	fa=2.
	minvalue=0.0
	maxvalue=0.5
	data1=100*total(total(Taeroincld_bddep_one,1),1)/float(total(Taeroincld_bddep_one))
	data3=100*total(total(Taeroincld_bddep_belcld,1),1)/float(total(Taeroincld_bddep_belcld))
	data5=100*total(total(Taeroincld_bddep_abvcld,1),1)/float(total(Taeroincld_bddep_abvcld))
	data7=100*total(total(Taeroincld_bddep_other,1),1)/float(total(Taeroincld_bddep_other))

	c1=image(data1[0:60,0:19],rgb_table=33,position=pos1,dim=[500,600],min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c1,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-0.5,target=c1,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c1.scale,sa,sb
	t1=text(pos1[0]+pa,pos1[3]+pb,'a) Merged layer only',font_size=fontsz-fa)

	c3=image(data3[0:60,0:19],rgb_table=33,/current,position=pos3,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c3,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-0.5,target=c3,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c3.scale,sa,sb
	t3=text(pos3[0]+pa,pos3[3]+pb,'c) Merged layer below cloud',font_size=fontsz-fa)

	c5=image(data5[0:60,0:19],rgb_table=33,/current,position=pos5,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c5,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-0.5,target=c5,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c5.scale,sa,sb
	t5=text(pos5[0]+pa,pos5[3]+pb,'e) Merged layer above cloud',font_size=fontsz-fa)

	c7=image(data7[0:60,0:19],rgb_table=33,/current,position=pos7,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c7,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title=xtitle);,font_size=fontsz)
    yaxis=axis('Y',location=-0.5,target=c7,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title=ytitle);,font_size=fontsz)
	c7.scale,sa,sb
	t7=text(pos7[0]+pa,pos7[3]+pb,'g) Other in-cloud aerosol',font_size=fontsz-fa)


	data2=100*total(total(Taeroonly_bddep,1),1)/float(total(Taeroonly_bddep))
	data4=100*total(total(Taeroisolate_bddep_belcld,1),1)/float(total(Taeroisolate_bddep_belcld))
	data6=100*total(total(Taeroisolate_bddep_abvcld,1),1)/float(total(Taeroisolate_bddep_abvcld))
	data8=100*total(total(Taeroisolate_bddep_other,1),1)/float(total(Taeroisolate_bddep_other))

	c2=image(data2[0:60,0:19],rgb_table=33,/current,position=pos2,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c2,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-0.5,target=c2,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c2.scale,sa,sb
	t2=text(pos2[0]+pa,pos2[3]+pb,'b) Cloud-free aerosol',font_size=fontsz-fa)

	c4=image(data4[0:60,0:19],rgb_table=33,/current,position=pos4,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c4,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-0.5,target=c4,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c4.scale,sa,sb
	t4=text(pos4[0]+pa,pos4[3]+pb,'d) Below-cloud aerosol',font_size=fontsz-fa)

	c6=image(data6[0:60,0:19],rgb_table=33,/current,position=pos6,min_value=minvalue,max_value=maxvalue)
	xaxis=axis('X',location=0,target=c6,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title='');,font_size=fontsz)
    yaxis=axis('Y',location=-0.5,target=c6,tickdir=0,textpos=0,minor=4,$
	tickvalues=yvalue,tickname=yname,title='');,font_size=fontsz)
	c6.scale,sa,sb
	t6=text(pos6[0]+pa,pos6[3]+pb,'f) Above-cloud aerosol',font_size=fontsz-fa)

	c8=image(data8[0:60,0:19],rgb_table=33,/current,position=pos8)
	xaxis=axis('X',location=0,target=c8,tickdir=0,textpos=0,minor=4,$
	tickvalues=xvalue,tickname=xname,title=xtitle);,font_size=fontsz)
    yaxis=axis('Y',location=-0.5,target=c8,tickdir=0,textpos=0,minor=4,$
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
