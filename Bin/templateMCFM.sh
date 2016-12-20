#!/bin/sh

multiply(){ awk "BEGIN { printf "$*"}"; }

PROCESS=$1
FINALSTATE=$2
NJOBS=$3
NEVENTSPERJOB=$4
WIDTH=$5
HMASS=$6"d0"
SMWIDTH=247.
WIDTHVALUE=1
TYP=$7
JOBSDIR="./m"$HMASS
#JOBSDIR="./iii"

WIDTHMULTIPLIER=1.0
if [ ! $PROCESS -eq "132" ]
then
 if [ ! $WIDTH == "" ]
 then
   WIDTHMULTIPLIER="$(echo print $WIDTH / $SMWIDTH | python)"
 fi
fi


if [ $PROCESS -eq "128" ]
then
 JOBSDIR=$JOBSDIR"ggZZ_Sig"
elif [ $PROCESS -eq "131" ]
then
 JOBSDIR=$JOBSDIR"ggZZ_BSI"
elif [ $PROCESS -eq "132" ]
then
 JOBSDIR=$JOBSDIR"ggZZ_Bkg"
elif [ $PROCESS -eq "220" ]
then
 JOBSDIR=$JOBSDIR"xsecVBF_"$TYP
elif [ $PROCESS -eq "2201" ]
then
 JOBSDIR=$JOBSDIR"VBF_${TYP}_QCD"
fi

if [ ! $PROCESS -eq "132" ]
then
 if [ ! $WIDTH == "" ]
 then
  JOBSDIR=$JOBSDIR$WIDTH
 fi
fi

#WIDTH=$WIDTHMULTIPLIER"d0"
WIDTH=$WIDTHMULTIPLIER

printf "%s%.10f\n" "Width: " $WIDTHMULTIPLIER

JOBSDIR=$JOBSDIR"_"$FINALSTATE"/"
mkdir -p $JOBSDIR

PROCESS=$PROCESS"."$FINALSTATE

chmod 755 * 2> /dev/null

FILENAME=$JOBSDIR"input.DAT"
FILENAMEmo="input.TEMPLATE."$TYP
#cp input.TEMPLATE $FILENAME
cp $FILENAMEmo $FILENAME
pushd $JOBSDIR > /dev/null

ln -sf ../process.DAT process.DAT
ln -sf ../hto_output.dat hto_output.dat
ln -sf ../ffwarn.dat ffwarn.dat
ln -sf ../ffperm5.dat ffperm5.dat
ln -sf ../fferr.dat fferr.dat
ln -sf ../dm_parameters.DAT dm_parameters.DAT
ln -sf ../br.sm1 br.sm1
ln -sf ../br.sm2 br.sm2

let COUNTER=0
while [ $COUNTER -lt $NJOBS ];
do
 JOBFILE="input_"$COUNTER".DAT"
 cp input.DAT $JOBFILE
 sed -i 's~NEVENTS~'$NEVENTSPERJOB'~g' $JOBFILE
 sed -i 's~JOBNUMBER~'$COUNTER'~g' $JOBFILE
 sed -i 's~PROCESS~'$PROCESS'~g' $JOBFILE
 sed -i 's~WIDTH~'$WIDTH'~g' $JOBFILE
 sed -i 's~HMASS~'$HMASS'~g' $JOBFILE

 mkdir -p Logs
 mkdir -p Errors
 cp ../submitMCFM.slurm.sh ./
 chmod 755 $JOBFILE
 sbatch -o "./Logs/slurmlog_Job_"$COUNTER".txt" -e "./Errors/slurmerr_Job_"$COUNTER".err" submitMCFM.slurm.sh $JOBFILE
 #source submitMCFM.slurm.sh $JOBFILE

 let COUNTER=$COUNTER+1
done
popd > /dev/null

