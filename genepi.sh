bash aci/nextflow run -ansi-log false aci/genepi.nf -params-file genepi.yaml -resume | grep --invert-match "skipping"

rm -r work
