;save files are from plot_lidlayer_phase.pro

pro plot_average_result
	
 ;======== all average ====================
 aeroflag='global_withaerosol'
 opaque_flag='phillipine_allsky_'
 restore,aeroflag+'_zonal_obsnumv.sav'
 restore,aeroflag+'_zonal_aeroonly_numv.sav'
 restore,aeroflag+'_ave_aeroonly_tau.sav'
 restore,aeroflag+'_zonal_aerocld_numv.sav'
 restore,aeroflag+'_ave_allaero_cld_tau.sav'
 restore,aeroflag+'_aerocld_numh.sav'
 restore,aeroflag+'_aeroonly_numh.sav'
 restore,aeroflag+'_hor_obsnumh.sav'

 lat=findgen(36)*5+2.5-90
 lon=findgen(72)*5+2.5-180
 maplimit=[-20,80,30,150]
 figure_name='aerosol_'+opaque_flag+'climatology_JJASON.png'
 plot_aerosol,hor_obsnumh,aeroonly_numh,ave_aeroonly_tau,aerocld_numh,$
	ave_allaero_cld_tau,lat,lon,maplimit,figure_name

 restore,'global_noaerosol_'+opaque_flag+'_icenumh.sav'
 icenumh_noaero=allicenumh 
 restore,'global_noaerosol_'+opaque_flag+'_watnumh.sav' 
 watnumh_noaero=allwatnumh
 restore,'global_aerosol_'+opaque_flag+'_icenumh.sav'
 icenumh_aero=allicenumh 
 restore,'global_aerosol_'+opaque_flag+'_watnumh.sav' 
 watnumh_aero=allwatnumh
 
 ;======= decompose aerosol with cloud overlap categories =======
 figure_name='aerosol_'+opaque_flag+'cloud_phase_JJASON.png'
 plot_cloud_4p,hor_obsnumh,icenumh_aero,icenumh_noaero,watnumh_aero,watnumh_noaero,lat,lon,maplimit,$
	figure_name
 stop
end
