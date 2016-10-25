#!/bin/bash

##################################################
# InitializeSCUFFonAWS.sh -- script to be run remotely
# on an AWS instance to get things set up for SCUFF
# calculations
##################################################

##################################################
#- write some convenient initialization commands
#- to .bashrc file in home directory
##################################################
echo '
export PATH=::${PATH}:${HOME}/bin
export LD_LIBRARY_PATH=${PATH}:${HOME}/lib:${HOME}/OpenBLAS
set -o vi
alias ls="ls --color=auto -CF"
PS1='\''$HISTCMD '\''`hostname`'\'' $PWD <> '\''
' > .bashrc

echo '
colors morning
' > .gvimrc

##################################################
# fetch and build OpenBLAS
##################################################
printf '\n*\n* Building OpenBLAS...\n*\n'

git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
make
cd

if [ -r ${HOME}/OpenBLAS/libopenblas.a ]
then
  printf '\n*\n* SUCCESS building Openblas...\n*\n'
else
  printf '\n*\n* FAILED building Openblas...\n*\n'
fi

# create ${HOME}/lib and put openblas binaries there
mkdir lib
ln -s ${HOME}/OpenBLAS/libopenblas.a ${HOME}/lib
ln -s ${HOME}/OpenBLAS/libopenblas.so ${HOME}/lib

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HOME}/OpenBLAS

export BLAS_LIBS="-L${HOME}/lib -Wl,-rpath=${HOME}/lib -lopenblas -lgfortran"

##################################################
# build SCUFF-EM
##################################################
NUMPROCS=`cat /proc/cpuinfo | grep processor | tail -1 | sed "s/.*:[ ]*//"`
NUMPROCS=$((NUMPROCS+1))
echo ${NUMPROCS} processors

printf '\n*\n* Building SCUFF-EM ('${NUMPROCS}' CPUs)...\n*\n'

cd
git clone http://github.com/homerreid/scuff-em
cd scuff-em
sh autogen.sh CC=mpicc CXX=mpicxx --prefix=${HOME}
make install -j ${NUMPROCS}

if [ -x ${HOME}/bin/scuff-scatter ]
then
  printf '\n*\n* SUCCESS building SCUFF-EM \n*\n'
else
  printf '\n*\n* FAILED building SCUFF-EM \n*\n'
fi

##################################################
# build BUFF-EM
##################################################
BUILDBUFF=1
if [ ${BUILDBUFF} -eq 1 ]
then
  printf '\n*\n* Building BUFF-EM ('${NUMPROCS}'CPUs)...\n*\n'
  
  cd
  git clone http://github.com/homerreid/buff-em
  cd buff-em
  export LDFLAGS="${LDFLAGS} -L${HOME}/lib"
  export CPPFLAGS="${CPPFLAGS} -I${HOME}/include/scuff-em"
  sh autogen.sh CC=mpicc CXX=mpicxx --prefix=${HOME}
  make install -j ${NUMPROCS}
  
  if [ -x ${HOME}/bin/buff-scatter ]
  then
    printf '\n*\n* SUCCESS building BUFF-EM \n*\n'
  else
    printf '\n*\n* FAILED building BUFF-EM \n*\n'
  fi
fi
