#!/usr/bin/env bash
# Encoding : UTF-8
# Script to run Backend in developpement mode.

set -eo pipefail #Don't use '-u' option if you want source python virtualenv without error !

# DESC: Usage help
# ARGS: None
# OUTS: None
function printScriptUsage() {
    cat << EOF
Usage: ./$(basename $BASH_SOURCE)[options]
     -h | --help: display this help
     -v | --verbose: display more infos
     -x | --debug: display debug script infos
     -c | --config: path to config file to use (default : config/settings.ini)
EOF
    exit 0
}

# DESC: Parameter parser
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: Variables indicating command-line parameters and options
function parseScriptOptions() {
    # Transform long options to short ones
    for arg in "${@}"; do
        shift
        case "${arg}" in
            "--help") set -- "${@}" "-h" ;;
            "--verbose") set -- "${@}" "-v" ;;
            "--debug") set -- "${@}" "-x" ;;
            "--config") set -- "${@}" "-c" ;;
            "--"*) exitScript "ERROR : parameter '${arg}' invalid ! Use -h option to know more." 1 ;;
            *) set -- "${@}" "${arg}"
        esac
    done

    while getopts "hvxc:" option; do
        case "${option}" in
            "h") printScriptUsage ;;
            "v") readonly verbose=true ;;
            "x") readonly debug=true; set -x ;;
            "c") setting_file_path="${OPTARG}" ;;
            *) exitScript "ERROR : parameter invalid ! Use -h option to know more." 1 ;;
        esac
    done
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
    parseScriptOptions "${@}"
    loadScriptConfig "${setting_file_path-}"
    #redirectOutput "${install_log}"

    #+----------------------------------------------------------------------------------------------------------+
    # Start script
    printInfo "Taxon Concept bootstrap script started at: ${fmt_time_start}"

    #+----------------------------------------------------------------------------------------------------------+
    runFlask

    #+----------------------------------------------------------------------------------------------------------+
    displayTimeElapsed
}

function runFlask() {
    printMsg "Run Flask with Pipenv virtualenv"
    cd "${root_dir}"
    export PIPENV_IGNORE_VIRTUALENVS=1
    source $(pipenv --venv)/bin/activate

    python_env=$(python -c "import sys; sys.stdout.write('Yes') if hasattr(sys, 'real_prefix') else sys.stdout.write('No')")
    python_bin=$(python -c "import sys; sys.stdout.write(sys.executable);")
    echo "Virtualenv used: ${python_env}"
    echo "Python version: $(python --version)"
    echo "Python binary: ${python_bin}"

    export FLASK_ENV="${flask_env}"
    export FLASK_APP="${flask_app}"
    python -m flask run -h "${flask_host}" --port="${flask_port}"
}

main "${@}"



