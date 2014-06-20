#!/usr/bin/env bash
 
# A deployment bootstrap script for setting up development / build environment.
# Only useful for developers looking to contribute to the application.
#
# Version 0.1.0

this_file=`basename "$0"`
this_path=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
this_dir=`basename "$this_path"`

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

verify_node_binary () {
	if ! which node 1>/dev/null; then
		error "Required binary NodeJS is not installed."
	fi
}

verify_npm_binary () {
	if ! which npm 1>/dev/null; then
		error "Required binary NPM for NodeJS is not installed."
	fi
}

add_node_package_gulp () {
	log "Info: installing NPM module 'gulp' globally using command 'npm install -g gulp'."
	if ! npm install -g gulp; then
		error "Could not install NPM package 'gulp' globally, 'npm install -g gulp'."
	fi

	log "Info: installing NPM module 'gulp' as a devDependency using command 'npm install --save-dev gulp'."
	if ! npm install --save-dev gulp; then
		error "Could not install NPM package 'gulp' as a devDependency, 'npm install --save-dev gulp'."
	fi
}

verify_node_binary
verify_npm_binary
add_node_package_gulp
