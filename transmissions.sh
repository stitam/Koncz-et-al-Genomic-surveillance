# Run ancestral state prediction and tidy state changes
bash prophyl/nextflow run -ansi-log false prophyl/get_state_changes.nf -profile cluster -params-file transmissions.yaml -resume | grep --invert-match "skipping"

# send notification
singularity exec --bind /node8_R10:/node8_R10 /node8_R10/stamas/containers/stitam-r-bio-1.1.img Rscript /node8_R10/stamas/notification.R 230622_aci_ST2_pastml

# Clean up working directory
rm -r work
