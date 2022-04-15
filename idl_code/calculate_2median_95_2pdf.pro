
pro calculate_2median_95_2pdf,x,y,data,median_valuex,p10_valuex,p90_valuex,median_valuey,p10_valuey,p90_valuey


 pdfx=float(total(data,2))/total(data)
 pdf2cdf,pdfx,cdfx
 pdfy=float(total(data,1))/total(data)
 pdf2cdf,pdfy,cdfy
  
 xout=[0.25,0.5,0.75]
 res=interpol(x,cdfx,xout)
 median_valuex=res[1]
 p10_valuex=res[0]
 p90_valuex=res[2]

 res=interpol(y,cdfy,xout)
 median_valuey=res[1]
 p10_valuey=res[0]
 p90_valuey=res[2]


end
