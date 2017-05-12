#!/bin/bash

# NOTE: if you change this, you must change it below as well
INSTALL_ROOT=/home

#############################
# begin sudo anaconda_install
#############################
export sudo_anaconda_install='
ANACONDA_VERSION=4.3.1
INSTALL_ROOT=/home
python_detect () {
	if [ -n "$pversion" ]; then
		PYTHON_VERSION=$pversion
	else
		which python3
		if [ $? -eq 0 ]; then
			PYTHON_VERSION=3
		else
			PYTHON_VERSION=2
		fi
	fi
	echo "DEBUG: using python version $PYTHON_VERSION"
}

anaconda_update () {
	echo "DEBUG: attempting to update anaconda"
	${ANACONDA_ROOT}/bin/conda update --prefix ${ANACONDA_ROOT} -y anaconda
}

anaconda_install () {
	ANACONDA_ROOT=${INSTALL_ROOT}/anaconda${PYTHON_VERSION}
	lastdir=$PWD
	echo "DEBUG: downloading anaconda binary, may take a few minutes"
	cd ${INSTALL_ROOT}
	if [ ! -f ${INSTALL_ROOT}/Anaconda${PYTHON_VERSION}-${ANACONDA_VERSION}-Linux-x86_64.sh ]; then
		wget --quiet https://repo.continuum.io/archive/Anaconda${PYTHON_VERSION}-${ANACONDA_VERSION}-Linux-x86_64.sh
		if [ $? -ne 0 ]; then
			echo "ERROR: Could not download https://repo.continuum.io/archive/Anaconda${PYTHON_VERSION}-${ANACONDA_VERSION}-Linux-x86_64.sh"
		fi
	fi

	# only bash install if the directory doesnt already exist
	if [ -e Anaconda${PYTHON_VERSION}-${ANACONDA_VERSION}-Linux-x86_64.sh ]; then
		if [ ! -d $ANACONDA_ROOT ]; then 
			echo "DEBUG: install Anaconda"
			bash Anaconda${PYTHON_VERSION}-${ANACONDA_VERSION}-Linux-x86_64.sh -b -p ${ANACONDA_ROOT}
		else
			echo "DEBUG: Anaconda already installed to $ANACONDA_ROOT"
		fi 

		# if r-install is detected do the following
		if [ -n "$rkernel" ]; then
			echo "DEBUG: installing rkernel"
			${ANACONDA_ROOT}/bin/conda install -y -c r r-essentials
		fi

		anaconda_update
	fi

	cd $lastdir
}

jupyter_notebook_launch () {
	if [ -n "$ANACONDA_IS_SET" ]; then
		cyverse_public_ip
		jupyter-notebook --no-browser --ip=0.0.0.0 2>&1 | sed s/0.0.0.0/${CYVERSE_PUBLIC_IP}/g
	else
		echo "Anaconda is not installed, cannot run jupyter-notebook"
	fi
}

python_detect $1
anaconda_install
'
###########################
# end sudo anaconda_install
###########################

python_detect () {
	if [ -n "$1" ]; then
		PYTHON_VERSION=$1
	else
		which python3
		if [ $? -eq 0 ]; then
			PYTHON_VERSION=3
		else
			PYTHON_VERSION=2
		fi
	fi
	echo "DEBUG: using python version $PYTHON_VERSION"
}

anaconda_setpath () {
	python_detect $1
	ANACONDA_ROOT=${INSTALL_ROOT}/anaconda${PYTHON_VERSION}
	if [ -n "$ANACONDA_ROOT" ]; then
		export PATH="${ANACONDA_ROOT}/bin:${PATH}"
		export ANACONDA_IS_SET=1
	fi
}

jupyter_notebook_launch () {
	if [ -n "$ANACONDA_IS_SET" ]; then
		cyverse_public_ip
		${ANACONDA_ROOT}/bin/jupyter-notebook --no-browser --ip=0.0.0.0 2>&1 | sed s/0.0.0.0/${CYVERSE_PUBLIC_IP}/g
	else
		echo "Anaconda is not installed, cannot run jupyter-notebook"
	fi
}

alias ezj="sudo bash -c '$sudo_anaconda_install'; anaconda_setpath;jupyter_notebook_launch"
alias ezj2="sudo bash -c 'eval export pversion=2;$sudo_anaconda_install'; anaconda_setpath 2;jupyter_notebook_launch"
alias ezj3="sudo bash -c 'eval export pversion=3;$sudo_anaconda_install'; anaconda_setpath 3;jupyter_notebook_launch"
alias ezjr="sudo bash -c 'eval export rkernel=1;$sudo_anaconda_install'; anaconda_setpath;jupyter_notebook_launch"

alias ez="echo '
Here are the different ez options:

ez   -> this help menu
ezj  -> run jupyter-notebook with python detection
ezj2 -> run jupyter-notebook with python 2
ezj3 -> run jupyter-notebook with python 3
ezjr -> run jupyter-notebook with R kernel
'"
