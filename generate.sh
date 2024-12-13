#!/bin/bash

dockingList=(
    "./POKMOL3D/Source/Targets/BCL2/BCL2_6GL8_rec_A.pdb"
    "./POKMOL3D/Source/Targets/BRAF/BRAF_1UWH_rec_A.pdb"
    "./POKMOL3D/Source/Targets/SRC/SRC_7OTE_rec_A.pdb"
    "./POKMOL3D/Source/Targets/PPAR/PPAR_alpha_1KKQ_rec_A.pdb"
    "./POKMOL3D/Source/Targets/EZH2/EZH2_5WFD_rec_A.pdb"
    "./POKMOL3D/Source/Targets/5TH2A/5HT2A_7WC7_rec_A.pdb"
    "./POKMOL3D/Source/Targets/Beta2AR/Beta2AR_8JJL_rec_A.pdb"
    "./POKMOL3D/Source/Targets/FXR/FXR_7D42_rec_A.pdb"
    "./POKMOL3D/Source/Targets/IDO1/IDO1_6AZV_rec_A.pdb"
    "./POKMOL3D/Source/Targets/PRMT5/PRMT5_7S1S_rec_A.pdb"
)
dockingConfigList=(
    "./POKMOL3D/Source/vina-prepared-receptors/2/docking-config.txt"
    "./POKMOL3D/Source/vina-prepared-receptors/4/docking-config.txt"
    "./POKMOL3D/Source/vina-prepared-receptors/31/docking-config.txt"
    "./POKMOL3D/Source/vina-prepared-receptors/27/docking-config.txt"
    "./POKMOL3D/Source/vina-prepared-receptors/12/docking-config.txt"
    "./POKMOL3D/Source/vina-prepared-receptors/0/docking-config.txt"
    "./POKMOL3D/Source/vina-prepared-receptors/3/docking-config.txt"
    "./POKMOL3D/Source/vina-prepared-receptors/13/docking-config.txt"
    "./POKMOL3D/Source/vina-prepared-receptors/17/docking-config.txt"
    "./POKMOL3D/Source/vina-prepared-receptors/28/docking-config.txt"
)
methods=(
    "smiles_ga"
    "smiles_lstm_hc"
    "reinvent"
    "pasithea"
    "smiles_vae"
    "graph_ga"
    "mimosa"
    "moldqn"
    "dst"
    "jt_vae"
)
docking=(
    "BCL2"
	"BRAF"
	"SRC"
	"PPAR-alpha"
	"EZH2"
    "5HT2A"
	"Beta2AR"
	"FXR"
	"IDO1"
	"PRMT5"
)

for ((j=2; j<3; j++)); do # iterate over method
    for ((i=0; i<10; i++)); do # iterate over docking target
        if [ ! -d "./main/${methods[j]}/results/${docking[i]}" ]; then
            mkdir -p "./main/${methods[j]}/results/${docking[i]}"
        fi
        python3 -u run.py --method ${methods[j]} \
            --task production --n_runs 3 --wandb offline \
            --max_oracle_calls 1000 \
            --custom_docking ${dockingList[i]} \
            --custom_docking_config ${dockingConfigList[i]} \
            --output_dir ./main/${methods[j]}/results/${docking[i]} \
            > ./main/${methods[j]}/results/${docking[i]}/log.out &
        echo "${methods[j]} for ${docking[i]} done"
    done
done