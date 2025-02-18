#!/bin/bash
# Script extracts FreeSurfer measurements of precentral and postcentral gyri of all analyzed scans
# into .csv files containing measurements of all subject for specific hemisphere side and gyrus.
#
# Subject-specific results of all atlas-based regions of interest are stored in separate files:
# APARC=$SUB/stats/$SIDE.aparc.stats
#
# Transformed results are stored in 4 new files:
# ${PATH_RESULTS}/sg.rh.aparc.stats.precentral.csv
# ${PATH_RESULTS}/sg.lh.aparc.stats.precentral.csv
# ${PATH_RESULTS}/sg.rh.aparc.stats.postcentral.csv
# ${PATH_RESULTS}/sg.lh.aparc.stats.postcentral.csv
#
# When compared to the process_data.sh shell script, variable PATH_RESULTS ($2) needs to be set to the same path
# to guaryntee well and easy functionality of MATLAB function which follows the extract_fs_measures.sh script
#
# Following matlab function (proceeding with statistical analysis and visualization of results)
# matlab/sg_structure_versus_demography.m
# is looking for these 4 files and expect them to be stored in the path_results='${PATH_RESULTS}' folder
# stat = sg_structure_versus_demography(path_results,path_data);
#
# The first input FSRESULTFOLDER ($1) is a path to general folder where Freesurfer results of all investigated subjects are stored.
# Subject folder names follows the original bids organization hierarchy. But inside subject-specific folders, the typical FreeSurfer
# result structure is expected. Script was written for FreeSurfer results generated by software version 7.2
#
# AUTHORS:
# Rene Labounek (1), Julien Cohen-Adad (2), Christophe Lenglet (3), Igor Nestrasil (1,3)
# email: rlaboune@umn.edu
#
# INSTITUTIONS:
# (1) Masonic Institute for the Developing Brain, Division of Clinical Behavioral Neuroscience, Deparmtnet of Pediatrics, University of Minnesota, Minneapolis, Minnesota, USA
# (2) NeuroPoly Lab, Institute of Biomedical Engineering, Polytechnique Montreal, Montreal, Quebec, Canada
# (3) Center for Magnetic Resonance Research, Department of Radiology, University of Minnesota, Minneapolis, Minnesota, USA

FSRESULTFOLDER=$1
cd $FSRESULTFOLDER
PATH_RESULTS=$2

for SUB in `ls -d sub-*[0-9]`;do
	for ROI in precentral postcentral;do 
		for SIDE in rh lh;do
			RESULTFILE=${PATH_RESULTS}/sg.$SIDE.aparc.stats.$ROI.csv
			APARC=$SUB/stats/$SIDE.aparc.stats
			#APARC=$SUB/stats/$SIDE.aparc.DKTatlas.stats
			#APARC=$SUB/stats/$SIDE.aparc.pial.stats
			if [ -z "$HEADER" ];then			
				HEADER=$(cat $APARC | grep "# ColHeaders" | sed 's/# ColHeaders StructName //' | sed 's/ /,/g')
				HEADER=$(echo -e "SubID,$HEADER")
				echo "$HEADER" > ${PATH_RESULTS}/sg.rh.aparc.stats.precentral.csv
				echo "$HEADER" > ${PATH_RESULTS}/sg.lh.aparc.stats.precentral.csv
				echo "$HEADER" > ${PATH_RESULTS}/sg.rh.aparc.stats.postcentral.csv
				echo "$HEADER" > ${PATH_RESULTS}/sg.lh.aparc.stats.postcentral.csv
			fi		
			DATA=$(cat $APARC | grep $ROI | sed 's/precentral//' | sed 's/postcentral//' | sed 's/^ *//g' | sed 's/ \{1,\}/,/g')
			DATA=$(echo -e "$SUB,$DATA")
			echo "$DATA" >> $RESULTFILE
		done
	done	
done



