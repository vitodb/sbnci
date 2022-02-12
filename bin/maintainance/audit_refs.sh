#!/bin/bash

# global vars
valwfs=( "crt" "pds" "tpcsim" "tpcreco" )
tpcrecodirs=( "pfpslicevalidation" "pfpvalidation" "recoeff" "showervalidation" )
nmiss=0

# some useful functions
# check if a file exists and print a formatted result
# -- args --
# $1: full path to file
# $2: workflow name
# $3: subdirectory (for tpcreco only)
# return: none 
exist() {

  sub=""
  if [ $2 == "tpcreco" ]; then
    sub="/$3"
  fi

  if [ -e $1 ]; then
    echo -e "\033[0;32m \t$2$sub reference found \033[0m" #print this in green
  else
    echo -e "\033[0;31m \t$2$sub reference MISSING\033[0m" #print this in red
    let nmiss=$nmiss+1
  fi

}

# look for ref files for all validation WFs base directory
# $1: full directory path
# return: none
look() {

  for wf in ${valwfs[@]}; do

    if [ $wf == "tpcreco" ]; then

      for sub in ${tpcrecodirs[@]}; do

        path=$1/$wf/$sub/ci_validation_histos.root
        exist $path $wf $sub
      done

    else
      path=$1/$wf/ci_validation_histos.root
      exist $path $wf
    fi
  
  done
}

############################################################################
# main body

source sbnci_setcodename.sh # figure out if we're doing SBND or ICARUS stuff
refdir=/pnfs/${expName}/persistent/ContinuousIntegration/reference/validation

echo -e "\nlooking for files in ${refdir}..."

echo -e "\nchecking test references..."
look "$refdir/test"

echo -e "\nchecking production references..."
look "$refdir"

if [ $nmiss == 0 ]; then
  echo -e "\033[0;32m \nall references found :) \033[0m" #print this in green
elif [ $nmiss == 1 ]; then
  echo -e "\033[0;31m \n1 reference MISSING\033[0m" #print this in red
else
  echo -e "\033[0;31m \n$nmiss references MISSING\033[0m" #print this in red
fi

echo -e "\naudit complete."
