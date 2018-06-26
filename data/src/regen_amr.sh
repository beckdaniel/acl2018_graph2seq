#!/bin/bash

# CHANGE THIS
REPO_DIR=/home/dbeck/acl2018_graph2seq

# CONSTANTS
DATA_DIR=${REPO_DIR}/data
PREPROC_DIR=${DATA_DIR}/tmp_amr
ORIG_AMR_DIR=${DATA_DIR}/abstract_meaning_representation_amr_2.0/data/alignments/split
FINAL_AMR_DIR=${DATA_DIR}/amr

#####
# CREATE FOLDER STRUCTURE

mkdir -p ${PREPROC_DIR}/train
mkdir -p ${PREPROC_DIR}/dev
mkdir -p ${PREPROC_DIR}/test

mkdir -p ${FINAL_AMR_DIR}/train
mkdir -p ${FINAL_AMR_DIR}/dev
mkdir -p ${FINAL_AMR_DIR}/test

#####
# CONCAT ALL SEMBANKS INTO A SINGLE ONE
cat ${ORIG_AMR_DIR}/training/amr-release-* > ${PREPROC_DIR}/train/raw_amrs.txt
cat ${ORIG_AMR_DIR}/dev/amr-release-* > ${PREPROC_DIR}/dev/raw_amrs.txt
cat ${ORIG_AMR_DIR}/test/amr-release-* > ${PREPROC_DIR}/test/raw_amrs.txt

#####
# CONVERT ORIGINAL AMR SEMBANK TO ONELINE FORMAT
for SPLIT in train dev test; do
    python split_amr.py ${PREPROC_DIR}/${SPLIT}/raw_amrs.txt ${PREPROC_DIR}/${SPLIT}/surface.txt ${PREPROC_DIR}/${SPLIT}/graphs.txt
done
