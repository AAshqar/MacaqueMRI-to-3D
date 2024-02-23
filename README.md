# Macaque MRI-to-3D

Shell tcsh scripts to be run from the terminal for processing monkey brain MRI scans, mapping them to NMT template and ATLAS segmentations and also generating 3D stl files for all available segments. The scripts use commands from the AFNI software suite. https://afni.nimh.nih.gov/

## Instructions

- The commands use tcsh commands, make sure you have tcsh shell installed.

- Install AFNI software suite:
    - Follow the instructions here for your operating system and environment: https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/background_install/main_toc.html

- Install NMT v2.1 template (can be another version if you prefer) in the folder where you will be running the scripts using the following AFNI command:
    ```
    @Install_NMT -nmt_ver 2.0 -sym asym
    ```
    or simply download and extract the file from the link: https://afni.nimh.nih.gov/pub/dist/atlases/macaque/nmt/NMT_v2.1_sym.tgz

    More on the different versions can be found here: https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/template_nmtv2.html

- Create a folder callded 'raw_DICOM' in the same directory from which you run the scripts. Copy your MRI datasets to this folder so that they have the following structure:
    ```
    | raw_DICOM\
    |   Subj_01\
    |       Ses_01 (DICOM sequence folder)    
    |       Ses_02 (DICOM sequence folder)
    |   Subj_02\
    |       Ses_01 (DICOM sequence folder)
    |       Ses_02 (DICOM sequence folder)
    |   ...
    ```

- Run the commands with tcsh:
    ```
    tcsh pipeline.tcsh
    ```

- Check your outputs in the created AFNI_outputs folder. Have fun!
