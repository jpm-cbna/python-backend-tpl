#!/usr/bin/env bash
# Encoding : UTF-8
# Script to run Flask Migrage with Pipenv.

set -eo pipefail #Don't use '-u' option if you want source python virtualenv without error !

# DESC: Usage help
# ARGS: None
# OUTS: None
function printScriptUsage() {
    cat << EOF
Usage: ./$(basename $BASH_SOURCE) [flask db options]
EOF
    exit 0
}

# DESC: Main control flow
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: None
function main() {
    #+----------------------------------------------------------------------------------------------------------+
    # Load utils
    source "$(dirname "${BASH_SOURCE[0]}")/utils.bash"

    #+----------------------------------------------------------------------------------------------------------+
    # Init script
    initScript "${@}"
    loadScriptConfig "${setting_file_path-}"

    #+----------------------------------------------------------------------------------------------------------+
    # Start script
    printInfo "Taxon Concept Flask-Migrate DB script started at: ${fmt_time_start}"

    #+----------------------------------------------------------------------------------------------------------+
    runFlaskDb "${@}"

    #+----------------------------------------------------------------------------------------------------------+
    displayTimeElapsed
}

function runFlaskDb() {
    printMsg "Run Flask Db with Pipenv virtualenv"
    cd "${root_dir}"
    #export PIPENV_IGNORE_VIRTUALENVS=1
    #source $(pipenv --venv)/bin/activate

    export FLASK_APP="${flask_app}"
    pipenv run flask db "${@}"
}

main "${@}"



