
; use to start caliop parallel

pro start_caliop

	year=['2007','2008','2009','2010','2011','2012','2013',$
		'2014','2015','2016','2017','2018','2019','2020']		
	mon=['01','02','03','04','05','06','07','08','09','10','11','12']

	date=['01','02','03','04','05','06','07','08','09','10',$
	     '11','12','13','14','15','16','17','18','19','20',$
	     '21','22','23','24','25','26','27','28','29','30',$
	     '31']

    ny=n_elements(year)
    nx=n_elements(mon)
    nd=n_elements(date)

    for yi=0,ny-1 do begin
	dir='/u/sciteam/yulanh/scratch/CALIOP/MLay/'+year[yi]+'/'		
	for xi=0,nx-1 do begin
	
	Nodes=0

	for di=0,nd-1 do begin
	
    yymmdd=year[yi]+'-'+mon[xi]+'-'+date[di]				
	print,xi,di,yymmdd
	checkdir=file_search(dir,'*'+yymmdd+'*',count=filenum)

	if filenum ne 0 then begin
	 Nodes=Nodes+1
	spawn,'ls '+dir+'*'+yymmdd+'*'+' > fname'+year[yi]+mon[xi]+date[di]
	endif
	end ;end date
	
	if nodes gt 0 then begin
	print ,nodes

	
    nodes=string(nodes)
    nodes=strcompress(nodes,/rem)

	stra='sed s/myjob10/myjob'+year[yi]+mon[xi]+'/'+' submit2.sh > submit1.sh'
	spawn,stra
	spawn,'sed s/200702/'+year[yi]+mon[xi]+'/'+' submit1.sh > submit.sh'
	spawn,'sed s/Nnodes/'+nodes+'/'+' submit.sh > submit11.sh'
    spawn,'qsub submit11.sh'

;	spawn,'make clean'
;	spawn,'make'
;	spawn,'aprun -n '+string(Nodes)+' ./caliop'
;	spawn,'aprun -n 1 ./caliop'

;	spawn,'rm -rf fname*'
	endif

    end ; finish one month

	;finish one year here	
	end
end
