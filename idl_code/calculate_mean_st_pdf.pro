
pro calculate_mean_st_pdf,x,data,mean_value,std_value

 ns=n_elements(data)

 pdf=float(data)/total(data)

 mean_value=total(x*pdf) 
 	
 std_value=sqrt(total(x*x*pdf)-mean_value*mean_value)

end
