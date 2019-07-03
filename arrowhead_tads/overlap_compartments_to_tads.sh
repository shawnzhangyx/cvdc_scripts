pushd ../../analysis/tads/

intersectBed -a ../ab_compartments/compartmentSwitch/switchType.bed  -b stage_specific_tads/D00.unique.tads -u > overlap_compartments_to_tads/D00.compartments.switchType.txt

intersectBed -a ../ab_compartments/compartmentSwitch/switchType.bed  -b stage_specific_tads/D80.unique.tads -u > overlap_compartments_to_tads/D80.compartments.switchType.txt

intersectBed -a ../ab_compartments/compartmentSwitch/switchType.bed  -b stage_specific_tads/gain.unique.tads -u > overlap_compartments_to_tads/gain.compartments.switchType.txt

intersectBed -a ../ab_compartments/compartmentSwitch/switchType.bed  -b <( tail -n +2 combined_tads.uniq.gt1.txt ) -u > overlap_compartments_to_tads/all.compartments.switchType.txt



