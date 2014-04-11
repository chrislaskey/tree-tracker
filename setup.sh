#!/usr/bin/env bash

# A deployment bootstrap script for setting up Python environment tasks like
# installing setting up a virtualenv and importing requirements.txt into pip.
# Can be run multiple times, it is written to be idempotent.
#
# Version 1.5.0

this_file=`basename "$0"`
this_path=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
this_dir=`basename "$this_path"`

project_name="${this_dir}"
required_minimum_python_version_major=''
required_minimum_python_version_minor=''
required_minimum_python_version_minor_minor=''
virtualenvs_dir="/usr/lib/virtualenvs"
project_virtualenv_path="${virtualenvs_dir}/${project_name}" 
environment_json_file="./app/environment.json"
individual_setup_files_dir="./setup"

# option_force=
# parse_options () {
#	while getopts "f" opt; do
#		case $opt in
#			f)
#				option_force="true"
#				;;
#		esac
#	done
# } ; parse_options $@

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

create_json_file_with_environment_information () {
	# TODO: Deprecated
	# Original use for environment.json file no longer needed.
	if [[ -f "${environment_json_file}" ]]; then
		if ! rm "${environment_json_file}"; then
			error "Could not remove environment JSON file, '${environment_json_file}'."
		fi
	fi

	if ! touch "${environment_json_file}"; then
		error "Could not create environment JSON file, 'touch ${environment_json_file}'."
	fi

	# Use the virtualenv python binary to export the virtualevn site-packages
	# directory, which is not a standard location as it includes the specific
	# python version in the path, e.g. ".venv/lib/python2.7/site-packages/".
	site_packages_path=`${project_virtualenv_path}/bin/python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"`
	site_packages_dir=`echo ${site_packages_path} | sed -e "s#$(pwd)/##"`

	# virtualenv path may be relative, this makes sure the path is absolute.
	original_pwd=`pwd`
	project_virtualenv_abspath=`cd ${project_virtualenv_path}; pwd`
	cd "$original_pwd"
	
	env_data="{"
	env_data="${env_data} \"base_path\": \"`pwd`\", "
	env_data="${env_data} \"virtualenv_dir\": \"${project_virtualenv_path}\", "
	env_data="${env_data} \"virtualenv_path\": \"${project_virtualenv_abspath}\", "
	env_data="${env_data} \"site_packages_dir\": \"${site_packages_dir}\", "
	env_data="${env_data} \"site_packages_path\": \"${site_packages_path}\" "
	env_data="${env_data} }"

	# Use python -mjson to pretty print JSON into file
	echo ${env_data} | python -mjson.tool > ${environment_json_file}
}

execute_individual_setup_files () {
	if [[ ! -d "${individual_setup_files_dir}" ]]; then
		return 0
	fi

	find "`pwd`/${individual_setup_files_dir}" -maxdepth 1 -type f | while read filename; do
		source "${filename}"
	done
}

verify_python_version
verify_virtualenv_binary_installed
create_system_virtualenvs_dir_if_needed
create_project_virtualenv_if_needed
install_pip_packages_into_virtualenv_if_requires_file
execute_individual_setup_files
