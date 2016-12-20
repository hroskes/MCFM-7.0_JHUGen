#!/bin/bash

#128: signal
#131: BSI
#132: bkg

#2 loops: over stats, and over PROCS/MULTS together

#STATS=("ELMU" "ELEL" "MUMU")
STATS=("ELMU") 
#PROCS=(128 128 116 116 116 116)
#PROCS=(128 128 128 128 131 131 131 131)
#MULTS=(1 10 50 247 1 10 50 247)  #H width (NOT width multiplier, changed from how Ulascan had it)
PROCS=(2201)
MULTS=(247)  #H width (NOT width multiplier, changed from how Ulascan had it)
M=(450)  #H width (NOT width multiplier, changed from how Ulascan had it)

for i in ${STATS[@]}; do
#for j in {0..8}; do
for j in 0; do
#3rd argument: njobs
#4th argument: nevents/job
#bash templateMCFM.sh ${PROCS[$j]} $i 3 20000 ${MULTS[$j]} ${M[$j]}
#bash templateMCFM.sh ${PROCS[$j]} $i 100 500 ${MULTS[$j]} ${M[$j]}

#bash templateMCFM.sh ${PROCS[$j]} $i 100 500 ${MULTS[$j]} ${M[$j]} SIG
bash templateMCFM.sh ${PROCS[$j]} $i 200 500 ${MULTS[$j]} ${M[$j]} BKG
#bash templateMCFM.sh ${PROCS[$j]} $i 200 500 ${MULTS[$j]} ${M[$j]} BSI
done
done

