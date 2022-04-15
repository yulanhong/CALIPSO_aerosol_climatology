
pro calculate_2mean_2st_2pdf,x,y,data,mean_valuex,std_valuex,mean_valuey,std_valuey


 pdfx=float(total(data,2))/total(data)
 pdfy=float(total(data,1))/total(data)

 mean_valuex=total(x*pdfx) 
 std_valuex=sqrt(total(x*x*pdfx)-mean_valuex*mean_valuex)

 mean_valuey=total(y*pdfy) 
 std_valuey=sqrt(total(y*y*pdfy)-mean_valuey*mean_valuey)


end
