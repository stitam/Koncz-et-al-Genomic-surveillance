bash aci/nextflow run -ansi-log false aci/carbapenem.nf -params-file carbapenem.yaml -resume | grep --invert-match "skipping"

rm -r work
