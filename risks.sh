# # run pipeline
# module load singularity/3.9.0

# global, no focus
bash ./prophyl/nextflow run -ansi-log false ./prophyl/get_risks.nf \
  --assemblies /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/assemblies_for_country_rr.tsv \
  --tree /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/results/add_duplicates/dated_tree.rds \
  --snps /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/results/build_tree/chromosomes.nodup.filtered_polymorphic_sites.fasta \
  --duplicates /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/results/remove_duplicates/duplicates.txt \
  --subsample_count 100 \
  --mrca_categories "0,6,12,40" \
  --resdir results/rr_geodate2_no_pop_global_no_focus \
  -profile cluster -resume | grep --invert-match "skipping"

rm -r work

# send notification
singularity exec --bind /node8_R10:/node8_R10 /node8_R10/stamas/containers/stitam-r-bio-1.1.img Rscript /node8_R10/stamas/notification.R rr_global_no_focus

# global, focus on Europe
bash ./prophyl/nextflow run -ansi-log false ./prophyl/get_risks.nf \
  --assemblies /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/assemblies_for_country_rr.tsv \
  --tree /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/results/add_duplicates/dated_tree.rds \
  --snps /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/results/build_tree/chromosomes.nodup.filtered_polymorphic_sites.fasta \
  --duplicates /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/results/remove_duplicates/duplicates.txt \
  --subsample_count 100 \
  --focus_by continent \
  --focus_on Europe \
  --resdir results/rr_geodate2_no_pop_global_focus_europe \
  -profile cluster -resume | grep --invert-match "skipping"

rm -r work

# send notification
singularity exec --bind /node8_R10:/node8_R10 /node8_R10/stamas/containers/stitam-r-bio-1.1.img Rscript /node8_R10/stamas/notification.R rr_global_focus_europe

# regional, only include countries from which we have collected isolates ourselves
bash ./prophyl/nextflow run -ansi-log false ./prophyl/get_risks.nf \
  --assemblies /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/assemblies_for_city_rr.tsv \
  --tree /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/results/add_duplicates/dated_tree.rds \
  --snps /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/results/build_tree/chromosomes.nodup.filtered_polymorphic_sites.fasta \
  --duplicates /node8_R10/stamas/prophyl_jobs/230622_aci_ST2/results/remove_duplicates/duplicates.txt \
  --resdir results/rr_geodate2_no_pop_regional_500_samples_100_tips \
  --subsample_count 500 \
  --subsample_tipcount 100 \
  --mrca_categories "0,2,6,40" \
  --colldist_max 0.5 \
  -profile cluster -resume | grep --invert-match "skipping"

rm -r work

# send notification
singularity exec --bind /node8_R10:/node8_R10 /node8_R10/stamas/containers/stitam-r-bio-1.1.img Rscript /node8_R10/stamas/notification.R rr_regional

