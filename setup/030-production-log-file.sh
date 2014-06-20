#!/usr/bin/env bash

# Version 1.1.0

production_log_file="./app/production.log"

get_production_log_user () {
	if id apache; then
		production_log_user="apache"
		production_log_group="apache"
	elif id www-data; then
		production_log_user="www-data"
		production_log_group="www-data"
	else
		error "Could not determine correct user/group file permissions for production log file."
	fi
}

create_production_log_file () {
	if [[ ! -f "${production_log_file}" ]]; then
		if ! touch "${production_log_file}"; then
			error "Could not create production log file, '${production_log_file}'."
		fi
	fi

	if ! chown "${production_log_user}:${production_log_group}" "${production_log_file}"; then
		error "Could not change production log file user and group, '${production_log_user}:${production_log_group}'."
	fi

	if ! chmod 0600 "${production_log_file}"; then
		error "Could not change production log file permissions, 'chmod 0600 "${production_log_file}"'."
	fi
}

get_production_log_user
create_production_log_file
