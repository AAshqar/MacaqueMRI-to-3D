#!/bin/tcsh

# Loop over subjects
set subj_dirs=`cd raw_DICOM && ls -d */ && cd ..`

mkdir ./logs
mkdir ./NIFTI
mkdir ./AFNI_outputs

foreach subj ($subj_dirs)
	echo "Processing subject $subj"
	# make dir in NiFTI and Afni outputs
	mkdir ./NIFTI/$subj
	mkdir ./AFNI_outputs/$subj

	set ses_dirs=`cd raw_DICOM/$subj/ && ls -d */ && cd ../..`
	foreach ses ($ses_dirs)

		# remove slashes from subject and session names
		set subj = `echo "$subj" | sed 's:/*$::'`
		set ses = `echo "$ses" | sed 's:/*$::'`

		echo "Processing session $ses of subject $subj..."

		# make dir in NIfTI and Afni outputs
		mkdir ./NIfTI/$subj/$ses

		# run DICOM to NiFTI conversion
		dcm2niix_afni -o ./NIfTI/$subj/$ses ./raw_DICOM/$subj/$ses
		
		# run AFNI program @animal_warper on the data
		time tcsh -xf ./do_session_aw.tcsh $subj $ses | tee ./logs/log_${subj}_${ses}_aw.txt

		# make directories for 3D models
		mkdir ./AFNI_outputs/$subj/$ses/IsoSurfaces_3D
		echo created_dir
		mkdir ./AFNI_outputs/$subj/$ses/IsoSurfaces_3D/SEG
		mkdir ./AFNI_outputs/$subj/$ses/IsoSurfaces_3D/CHARM
		mkdir ./AFNI_outputs/$subj/$ses/IsoSurfaces_3D/D99

		echo SEG_in_${subj}_anat.nii.gz
		# generate 3D models using AFNI program IsoSurface for the segmentation and ATLAS mapped volume
		IsoSurface -isorois -input ./AFNI_outputs/$subj/$ses/SEG_in_${subj}_anat.nii.gz \
			-o_stl ./AFNI_outputs/$subj/$ses/IsoSurfaces_3D/SEG/SEG_in_${subj}_

		IsoSurface -isorois -input ./AFNI_outputs/$subj/$ses/D99_in_${subj}_anat.nii.gz \
			-o_stl ./AFNI_outputs/$subj/$ses/IsoSurfaces_3D/D99/D99_in_${subj}_

	end
	
end