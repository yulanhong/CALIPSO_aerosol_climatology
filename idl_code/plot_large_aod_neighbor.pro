
pro plot_large_aod_neighbor

 restore,'aod_cod_relationship.sav'

 Nratio=501
 ratio=findgen(Nratio)*0.5
 
 pdf2cdf,aod2aodf,aod2aodf_cdf
 aod2aodf_cdf=aod2aodf_cdf/aod2aodf_cdf[Nratio-1]
 pdf2cdf,aod2aodb,aod2aodb_cdf
 aod2aodb_cdf=aod2aodb_cdf/aod2aodb_cdf[Nratio-1]
 diff=abs(aod2aodf_cdf -0.95)
 ind=where(min(diff) eq diff)
 bsc95=ind[0] 
 diff=abs(aod2aodf_cdf -0.90)
 ind=where(min(diff) eq diff)
 bsc90=ind[0] 

 pdf2cdf,aod2codf,aod2codf_cdf
 aod2codf_cdf=aod2codf_cdf/aod2codf_cdf[Nratio-1]
 pdf2cdf,aod2codb,aod2codb_cdf
 aod2codb_cdf=aod2codb_cdf/aod2codb_cdf[Nratio-1]

 p=plot(ratio,aod2aodf,xtitle='$AOD/AOD_{neighbor})$',ytitle='number',ylog=1,name='Forward',thick=2,font_size=12,xticklen=0.02,yticklen=0.02)
 p1=plot(ratio,aod2aodb,color='r',name='Backward',overplot=p,thick=2)
; p2=plot(ratio,aod2codf,color='black',name='Forward',linestyle='--',overplot=p)
; p3=plot(ratio,aod2codb,color='r',name='Backward',linestyle='--',overplot=p)

 x=fltarr(Nratio)
 x[*]=ratio[bsc95]
 y=findgen(Nratio)*1000
 y[0]=1
 p4=plot(x,y,color='purple',overplot=p,thick=2)
 x[*]=ratio[bsc90]
 p5=plot(x,y,color='pink',overplot=p,thick=2)
 ld=legend(target=[p,p1],position=[0.8,0.7])
 stop
end
