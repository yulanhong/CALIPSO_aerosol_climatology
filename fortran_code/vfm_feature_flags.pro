pro vfm_feature_flags,val,ice_water_phase,ice_water_phase_qa,feature_type

;  this routine demonstrates how to read and extract values from a feature
;  classification flag 16-bit integer value in CALIPSO Level 2 Vertical
;  Feature Mask files
;
;  INPUT:
;  val - the feature classification flag value to be decoded
;
;  OUTPUT:
;  all information is printed into the IDL log window


feature_type = 0
feature_type_qa = 0
ice_water_phase = 0
ice_water_phase_qa = 0
feature_subtype = 0
cloud_aerosol_psc_type_qa = 0
horizontal_averaging = 0
aerotyp_flag=0
type=0

for i=0,15 do begin
  if ((val and 2L^i) NE 0) then begin
    print,'Bit set: ',i+1
    case i+1 of
    1 : feature_type = feature_type + 1
    2 : feature_type = feature_type + 2
    3 : feature_type = feature_type + 4
    4 : feature_type_qa = feature_type_qa + 1
    5 : feature_type_qa = feature_type_qa + 2
    6 : ice_water_phase = ice_water_phase + 1
    7 : ice_water_phase = ice_water_phase + 2
    8 : ice_water_phase_qa = ice_water_phase_qa + 1
    9 : ice_water_phase_qa = ice_water_phase_qa + 2
    10 : feature_subtype = feature_subtype + 1
    11 : feature_subtype = feature_subtype + 2
    12 : feature_subtype = feature_subtype + 4
    13 : cloud_aerosol_psc_type_qa = cloud_aerosol_psc_type_qa + 1
    14 : horizontal_averaging = horizontal_averaging + 1
    15 : horizontal_averaging = horizontal_averaging + 2
    16: horizontal_averaging = horizontal_averaging + 4
    else:
    endcase
  endif
endfor
;print,feature_type,ice_water_phase,ice_water_phase_qa

case feature_type of
0 : a=1;print,"Feature Type : invalid (bad or missing data)"
1 : a=1;print,"Feature Type : clear air"
2 : begin
;      print,"Feature Type : cloud"
      case feature_subtype of
      0 : type=0;print, "Feature Subtype : low overcast, transparent"
      1 : type=1;print, "Feature Subtype : low overcast, opaque"
      2 : type=2;print, "Feature Subtype : transition stratocumulus"
      3 : type=3;print, "Feature Subtype : low, broken cumulus"
      4 : type=4;print, "Feature Subtype : altocumulus (transparent)"
      5 : type=5;print, "Feature Subtype : altostratus (opaque)"
      6 : type=6;print, "Feature Subtype : cirrus (transparent)"
      7 : type=7;print, "Feature Subtype : deep convective (opaque)"
      else : type=8;print,"*** error getting Feature Subtype"
      endcase
    end
3 : begin
 ;     print,"Feature Type : aerosol"
      case feature_subtype of
      0 : aerotyp_flag=0 
      1 : aerotyp_flag=1
      2 : aerotyp_flag=2
      3 : aerotyp_flag=3
      4 : aerotyp_flag=4 
      5 : aerotyp_flag=5
      6 : aerotyp_flag=6
      7 : aerotyp_flag=7
      else : a=1;print,"*** error getting Feature Subtype"
      endcase
    end
4 : begin
  ;    print,"Feature Type : stratospheric feature--PSC or stratospheric aerosol"
      case feature_subtype of
      0 : type=0;print, "Feature Subtype : not determined"
      1 : type=1;print, "Feature Subtype : non-depolarizing PSC"
      2 : type=2;print, "Feature Subtype : depolarizing PSC"
      3 : type=3;print, "Feature Subtype : non-depolarizing aerosol"
      4 : type=4;print, "Feature Subtype : depolarizing aerosol"
      5 : type=5;print, "Feature Subtype : spare"
      6 : type=6;print, "Feature Subtype : spare"
      7 : type=7;print, "Feature Subtype : other"
      else : type=8;print,"*** error getting Feature Subtype"
      endcase
    end
5 :a=1; print,"Feature Type : surface"
6 :a=1; print,"Feature Type : subsurface"
7 :a=1; print,"Feature Type : no signal (totally attenuated)"
else : a=1;print,"*** error getting Feature Type"
endcase

;  print,"Cloud/Aerosol/PSC Type QA : not confident"
;endif else begin
;  print,"Cloud/Aerosol/PSC Type QA : confident"
;endelse
	stop
end
