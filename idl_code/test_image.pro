
pro test_image

  fname='/u/sciteam/yulanh/mydata/radar-lidar_out/CAL_CLAY/IDL_pro/lidlayer_phase_200607.hdf'
  read_dardar,fname,'lat',lat
  read_dardar,fname,'lon',lon
  read_dardar,fname,'obs_numh',obsnumh
  read_dardar,fname,'obs_numv',obsnumv
  maplimit=[-180,-90,180,90]
  im1=image(obsnumh,lon,lat,rgb_table=33,grid_units=2,position=[0.05,0.05,0.9,0.9],map_projection='Geographic')
  map=im1.mapprojection 
  grid=map.mapgrid
  grid.color='grey'
  grid.linestyle=2
  grid.grid_longitude=60
  grid.grid_latitude=30
  grid.label_position=0
  c=mapcontinents(color='grey')
  stop
end
