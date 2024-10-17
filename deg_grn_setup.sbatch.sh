#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=72000
#SBATCH --time=40:00:00

# Define the lists
goi_list=("Tbr1" "Foxg1" "Nr2f1" "Tcf4")  # Genes of interest
sample_list=("1" "2" "3")        # Sample numbers
region_list=("CR" "Excit_L2_IT_ENTl" "Excit_L5_PT_CTX" "Excit_L5IT" "Excit_L5NP_CTX" "Excit_L6CT_CTX" "Excit_L6IT" "Excit_Upper" "Inhib_Lhx6+Sst-" "Inhib_Sst")  # Regions
# jobid=""
start_processing=false  # Flag to control when to start processing


# Loop through each list
for goi in "${goi_list[@]}"; do
    for sample in "${sample_list[@]}"; do
        for region in "${region_list[@]}"; do
        
            if [[ "$goi" == "Tbr1" && "$sample" == "2" && "$region" == "Excit_L2_IT_ENTl" ]]; then
                start_processing=true  # Start processing after reaching this combination
            fi

            if [ "$start_processing" = true ]; then
                # Run the Python script or other commands with the current combination
                echo "Processing GOI: $goi, Sample: $sample, Region: $region"
                mklj "/gpfs/home/asun/jinlab/deg_grn/out/" "${goi}_${sample}_${region}"
                echo "python deg_grn.py $goi $sample $region" >> "${goi}_${sample}_${region}.sbatch"
                sbatch "${goi}_${sample}_${region}.sbatch"
                mv "${goi}_${sample}_${region}.sbatch" "/gpfs/home/asun/jinlab/deg_grn/jobs/"
                sleep 600
            fi
            
        done
    done
done