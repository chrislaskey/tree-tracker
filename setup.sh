#!/usr/bin/env bash

# A deployment bootstrap script for setting up Python environment tasks like
# installing setting up a virtualenv and importing requirements.txt into pip.
# Can be run multiple times, it is written to be idempotent.
#
# Version 1.5.2

this_file=`basename "$0"`
this_path=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
this_dir=`basename "$this_path"`

project_name="${this_dir}"
required_minimum_python_version_major=''
required_minimum_python_version_minor=''
required_minimum_python_version_minor_minor=''
virtualenvs_dir="/usr/lib/virtualenvs"
project_virtualenv_path="${virtualenvs_dir}/${project_name}" 
individual_setup_files_dir="./setup"

set -o nounset
set -o errtrace
set -o errexit
set -o pipefail

log () {
	printf "$*\n"
}

error () {
	log "ERROR: " "$*\n"
	exit 1
}

help () {
	echo "Usage is './${this_file}'"
	echo "No additional flags or arguments currently implemented."
}

# Application functions

before_exit () {
	# Works like a finally statement
	# Code that must always be run goes here
	return
} ; trap before_exit EXIT

verify_python_version () {
	python_version=`python -V 2>&1 | awk -F' ' '{print $2}'`
	python_major_version=`echo $python_version | awk -F'.' '{print $1}'`
	python_minor_version=`echo $python_version | awk -F'.' '{print $2}'`
	python_minor_minor_version=`echo $python_version | awk -F'.' '{print $3}'`

	if [[ -z "$required_minimum_python_version_major" ]]; then
		return 0
	else
		if [[ "$python_major_version" -lt "$required_minimum_python_version_major" ]]; then
			error "Python version below required threshold, ${python_major_version}<${required_minimum_python_version_major}."
		fi
	fi

	if [[ -z "$required_minimum_python_version_minor" ]]; then
		return 0
	else
		if [[ "$python_minor_version" -lt "$required_minimum_python_version_minor" ]]; then
			error "Python version below required threshold, ${python_minor_version}<${required_minimum_python_version_minor}."
		fi
	fi

	if [[ -z "$required_minimum_python_version_minor_minor" ]]; then
		return 0
	else
		if [[ "$python_minor_minor_version" -lt "$required_minimum_python_version_minor_minor" ]]; then
			error "Python version below required threshold, ${python_minor_minor_version}<${required_minimum_python_version_minor_minor}."
		fi
	fi
}

verify_virtualenv_binary_installed () {
	if ! which virtualenv 1>/dev/null; then
		error "Required python package virtualenv not installed."
	fi
}

create_system_virtualenvs_dir_if_needed () {
	if [[ -d "$virtualenvs_dir" ]]; then
		return 0
	fi

	if ! mkdir "$virtualenvs_dir"; then
		error "Could not create common virtualenv dir, 'mkdir ${$virtualenvs_dir}'."
	fi
}

create_project_virtualenv_if_needed () {
	if [[ -d "$project_virtualenv_path" ]]; then
		return 0
	fi

	if ! virtualenv "$project_virtualenv_path"; then
		error "Could not create virtualenv '${project_virtualenv_path}'."
	fi
}

install_pip_packages_into_virtualenv_if_requires_file () {
	if [[ ! -f "./requirements.txt" ]]; then
		return 0
	fi

	if [[ ! -f "${project_virtualenv_path}/bin/pip" ]]; then
		error "Could not find virtualenv's pip binary to install requirements.txt '${project_virtualenv_path}/bin/pip'."
	fi

	if ! ${project_virtualenv_path}/bin/pip install -r requirements.txt; then
		error "Could not install pip packages inside requirements.txt."
	fi
}

execute_individual_setup_files () {
	if [[ ! -d "${individual_setup_files_dir}" ]]; then
		return 0
	fi

	find "`pwd`/${individual_setup_files_dir}" -maxdepth 1 -type f | while read filename; do
		source "${filename}"
	done
}

# Application execution

verify_python_version
verify_virtualenv_binary_installed
create_system_virtualenvs_dir_if_needed
create_project_virtualenv_if_needed
install_pip_packages_into_virtualenv_if_requires_file
execute_individual_setup_files
