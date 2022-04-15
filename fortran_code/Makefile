HDFEOSHOME=/u/sciteam/yulanh/software_installed
HDFHOME=/sw/xe/hdf4/4.2.10/cle5.2_gnu4.8.2

#MPIHOME=/sw/openmpi-3.0.0-gnu-6.1.0
#MPIHOME=/opt/cray/mpt/7.7.4/gni/mpich-gnu/7.1


 FFLAGS =  -g -I$(HDFHOME)/include -I$(HDFEOSHOME)/hdfeos/include 
LDFLAGS = -L$(HDFHOME)/lib -L$(HDFEOSHOME)/hdfeos/lib -lhdfeos -lGctp -lmfhdf -ldf -ljpeg -lz

FC = ftn 

#SOURCES= global.f90 inquire_info.f90 read_caliop.f90 read_caliop_prof.f90 vfm_feature_flag.f90 isolated_80_filter.f90 cirrus_filter.f90 integrate_filter_aod.f90 calculate_core.f90 write_caliop.f90 main_caliop_parallel_copy1.f90 
SOURCES= global.f90 inquire_info.f90 read_caliop.f90 read_caliop_prof.f90 vfm_feature_flag.f90 isolated_80_filter.f90 cirrus_filter.f90 calculate_core.f90 write_caliop.f90 main_caliop_parallel_copy1.f90 

OBJECTS=$(SOURCES:.f90=.f90.o)

all: caliop 

clean:
	rm -f *.o caliop

caliop: $(OBJECTS) 
	$(FC) $(OBJECTS) $(FFLAGS) $(LDFLAGS) -o $@

%.f90.o: 
	$(FC) $(FFLAGS) -c $(@:.o=) -o $@


