
pro plot_global_mean_median_backscatter_profile

 restore,'global_beta_profile.sav'

 restore,'global_median_beta_profile.sav'


 p=plot(aveaero_cld_beta,hgt,yrange=[0,15],color='orange',name='Cloudy aerosol',$
        layout=[5,2,k+1],xtitle='$\beta (km^{-1} Sr^{-1})$',$
        ytitle='Alt. (km)',margin=margin,dim=[1000,450],xrange=xrange,$
        font_size=fontsz,thick=fonttk)
 stop

end
