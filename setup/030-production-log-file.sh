#!/usr/bin/env bash

production_log_file="./production.log"
production_log_user="www-data"
production_log_group="www-data"

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

create_production_log_file
