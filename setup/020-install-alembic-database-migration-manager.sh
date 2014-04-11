#!/usr/bin/env bash

alembic_target_dir="alembic"
alembic_target_path="${this_path}/alembic"
alembic_binary_path="${project_virtualenv_path}/bin/alembic"
alembic_env_file_source="${this_path}/setup/alembic/env.py"
alembic_env_file_target="${this_path}/alembic/env.py"
alembic_ini_file_source="${this_path}/setup/alembic/alembic.ini"
alembic_ini_file_target="${this_path}/alembic.ini"

initialize_alembic_database_migration_manager () {
	if [[ -d "${alembic_target_dir}" ]]; then
		return 0
	fi

	if ! "${alembic_binary_path}" init "${alembic_target_path}"; then
		error "Could not initialize alembic database migration manager, '${alembic_binary_path} init ${alembic_target_path}'."
	fi
}

copy_alembic_env_file () {
	if [[ ! -f "${alembic_env_file_source}" ]]; then
		return 0
	fi

	if ! cp "${alembic_env_file_source}" "${alembic_env_file_target}"; then
		error "Could not transfer alembic env.py file, 'cp ${alembic_env_file_source} ${alembic_env_file_target}'."
	fi
}

update_alembic_ini_script_location () {
	if [[ ! -f "${alembic_ini_file_target}" ]]; then
		return 0
	fi

	if ! sed -i'' -e "s#script_location.*#script_location = ${alembic_target_path}#" "${alembic_ini_file_target}"; then
		error "Could not update script_location value in alembic.ini file, 'sed -i'' 's#^script_location.*#script_location = ${alembic_target_path}#' ${alembic_ini_file_target}'."
	fi
}

copy_alembic_ini_file () {
	if [[ ! -f "${alembic_ini_file_source}" ]]; then
		update_alembic_ini_script_location
		return $?
	fi

	if ! cp "${alembic_ini_file_source}" "${alembic_ini_file_target}"; then
		error "Could not transfer alembic.ini file, 'cp ${alembic_ini_file_source} ${alembic_ini_file_target}'."
	fi
}

initialize_alembic_database_migration_manager
copy_alembic_env_file
copy_alembic_ini_file
