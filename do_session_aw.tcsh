#!/bin/tcsh

# AW: run @animal_warper to skullstrip and estimate a nonlinear warp.

# Process a single session nii file.

# ---------------------------------------------------------------------------
# top level definitions (constant across demo)
# ---------------------------------------------------------------------------
 
# labels
# remove slashes from passed subject and session names
set subj           = `echo "$1" | sed 's:/*$::'`
set ses            = `echo "$2" | sed 's:/*$::'`
set subjses_dir    = ${subj}/${ses}

# upper directories
set dir_log        = ./logs
set dir_ref        = ../../BrainTemplates/NMT_v2.1_sym/NMT_v2.1_sym_05mm

# subject directories
set sdir_anat      = ./NIfTI/$subjses_dir
set sdir_aw        = AFNI_outputs/$subjses_dir

# --------------------------------------------------------------------------
# data and control variables
# --------------------------------------------------------------------------

# dataset inputs, with abbreviations for each 
set anat_orig    = ${sdir_anat}/*.nii
set anat_orig_ab = ${subj}_anat

set ref_base     = ${dir_ref}/NMT_v2.1_sym_05mm_SS.nii.gz
set ref_base_ab  = NMT2

set ref_atl      = ( ${dir_ref}/CHARM_in_NMT_v2.1_sym_05mm.nii.gz     \
                     ${dir_ref}/D99_atlas_in_NMT_v2.1_sym_05mm.nii.gz )
set ref_atl_ab   = ( CHARM D99 )

set ref_seg      = ${dir_ref}/NMT_v2.1_sym_05mm_segmentation.nii.gz
set ref_seg_ab   = SEG

set ref_mask     = ${dir_ref}/NMT_v2.1_sym_05mm_brainmask.nii.gz 
set ref_mask_ab  = MASK

# control variables

# check available N_threads and report what is being used
# + consider using up to 16 threads (alignment programs are parallelized)
# + N_threads may be set elsewhere; to set here, uncomment the following line:
### setenv OMP_NUM_THREADS 16

set nthr_avail = `afni_system_check.py -disp_num_cpu`
set nthr_using = `afni_check_omp`

echo "++ INFO: Using ${nthr_avail} of available ${nthr_using} threads"

# ---------------------------------------------------------------------------
# run programs
# ---------------------------------------------------------------------------

time @animal_warper                                 \
    -echo                                           \
    -input            ${anat_orig}                  \
    -input_abbrev     ${anat_orig_ab}               \
    -base             ${ref_base}                   \
    -base_abbrev      ${ref_base_ab}                \
    -atlas_followers  ${ref_atl}                    \
    -atlas_abbrevs    ${ref_atl_ab}                 \
    -seg_followers    ${ref_seg}                    \
    -seg_abbrevs      ${ref_seg_ab}                 \
    -skullstrip       ${ref_mask}                   \
    -outdir           ${sdir_aw}                    \
    -ok_to_exist

echo "++ FINISHED AW"

exit 0
