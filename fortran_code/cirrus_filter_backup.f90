	subroutine cirrus_filter()
		   !judge cirrus filter: altitude gt 4 km and in contact with ice clouds
                IF (tpaerobase(1) < 4.0) then
                     filterci = 0 
                 Else 
                   IF ((sum(tpciflag_p1)+sum(tpciflag_m1))==0) filterci=0
                   IF (sum(tpciflag_p1) > 0) then
                        Do hi=1,count(tpcldtop_p1 > 0) ! judge boundary
                            IF(tpcldbase_p1(hi) > tpcldtop(1)) neighboor_gap=&
                            tpcldbase_p1(hi)-tpcldtop(1)
                             IF(tpcldtop_p1(hi) > tpcldtop(1) .and. tpcldbase_p1(hi) <= tpcldtop(1)) neighboor_gap=0.0
                             IF(tpcldtop_p1(hi) <= tpcldtop(1) .and. tpcldtop_p1(hi) >= tpcldbase(1)) neighboor_gap=0.0
                             IF(tpcldtop_p1(hi) < tpcldbase(1)) neighboor_gap=tpcldbase(1)-tpcldbase_p1(hi)
                             IF(neighboor_gap > gap_threshold) filterci=0 ! not connected   
                         EndDo
                     print *,si,neighboor_gap,filterci,'cirrus'
                    EndIf
                    
                    IF (sum(tpciflag_m1) > 0) then
                        Do hi=1,count(tpcldtop_m1 > 0)
                             IF(tpcldbase_m1(hi) > tpcldtop(1)) neighboor_gap=&
                            tpcldbase_m1(hi)-tpcldtop(1)
                             IF(tpcldtop_m1(hi) > tpcldtop(1) .and. tpcldbase_m1(hi) <= tpcldtop(1)) neighboor_gap=0.0
                             IF(tpcldtop_m1(hi) <= tpcldtop(1) .and. tpcldtop_m1(hi) >= tpcldbase(1)) neighboor_gap=0.0
                             IF(tpcldbase_m1(hi) < tpcldbase(1)) neighboor_gap=tpcldbase(1)-tpcldbase_m1(hi)
                             IF(neighboor_gap > gap_threshold) filterci=0 ! not connected   
                         EndDo
                     print *,si,neighboor_gap,filterci,'cirrus'
                    EndIf
                    
                 EndIF ! endif cirrus filter
 	end
