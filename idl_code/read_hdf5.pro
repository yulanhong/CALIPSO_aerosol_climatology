pro read_hdf5,fname,fieldname,data

 fid=h5f_open(fname)

 did=h5d_open(fid,fieldname)

 data=h5d_read(did)

 h5d_close,did
 h5f_close,fid

end
