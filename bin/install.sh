#!/usr/bin/env bash
# Encoding : UTF-8
# Install Taxon Concept backend.

set -eo pipefail

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
    parseScriptOptions "${@}"sudo
    loadScriptConfig "${setting_file_path-}"
    #redirectOutput "${install_log}"

    checkSuperuser
    commands=("curl")
    checkBinary "${commands[@]}"

    #+----------------------------------------------------------------------------------------------------------+
    # Start script
    printInfo "${app_name} install script started at: ${fmt_time_start}"

    #+----------------------------------------------------------------------------------------------------------+
    # TODO: install system packages + sqlite3-devel. See: https://github.com/pyenv/pyenv/wiki/Common-build-problems
    # TODO: use setup.py to build database. Ex. : pipenv run python setup.py
    updateBashrc
    installPyenv
    installPipenv
    installPythonDependencies

    #+----------------------------------------------------------------------------------------------------------+
    displayTimeElapsed
}

function updateBashrc() {
    printMsg "Add env variables for Pyenv and Pipenv to ${HOME}/.bashrc"
    if ! grep -q 'export PIPENV_VENV_IN_PROJECT=' "${HOME}/.bashrc" ; then
        echo "export PIPENV_VENV_IN_PROJECT=\"${pipenv_venv_in_project}\"" >> "${HOME}/.bashrc"
    elif ! grep -q "export PIPENV_VENV_IN_PROJECT=\"${pipenv_venv_in_project}\"" "${HOME}/.bashrc" ; then
        sed -i "s/^export PIPENV_VENV_IN_PROJECT=[^$]*\$/export PIPENV_VENV_IN_PROJECT=\"${pipenv_venv_in_project}\"/" "${HOME}/.bashrc"
    else
        printPretty "export PIPENV_VENV_IN_PROJECT=\"${pipenv_venv_in_project}\" already exists in ${HOME}/.bashrc !" ${Gra-}
    fi

    if ! grep -q 'export PYENV_VERSION=' "${HOME}/.bashrc" ; then
        echo "export PYENV_VERSION=\"${python_version}\"" >> "${HOME}/.bashrc"
    elif ! grep -q "export PYENV_VERSION=\"${python_version}\"" "${HOME}/.bashrc" ; then
        sed -i "s/^export PYENV_VERSION=[^$]*\$/export PYENV_VERSION=\"${python_version}\"/" "${HOME}/.bashrc"
    else
        printPretty "export PYENV_VERSION=\"${python_version}\" already exists in ${HOME}/.bashrc !" ${Gra-}
    fi

    printMsg "Sourcing new ${HOME}/.bashrc"
    . ~/.bashrc
}

function installPyenv() {
    installPackagesForPythonBuilding
    addPyenvToBashrc
    downloadPyenv
    runPyenv
    installPythonWithPyenv
}

function installPackagesForPythonBuilding() {
    printMsg "Installing Python building dependencies..."
    sudo apt-get install libzip-dev libssl-dev libreadline-dev
}

function addPyenvToBashrc() {
    if ! grep -q 'pyenv init' "${HOME}/.bashrc" ; then
        printMsg "Editing ${HOME}/.bashrc to load Pyenv on Terminal launch"
        echo -e "\n# Load Pyenv" >> "${HOME}/.bashrc"
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "${HOME}/.bashrc"
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> "${HOME}/.bashrc"
        echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n    . "$(pyenv root)/completions/pyenv.bash"\n    eval "$(pyenv init -)"\n    eval "$(pyenv virtualenv-init -)"\nfi' >> "${HOME}/.bashrc"
    else
        printPretty "Pyenv load directives already exists in ${HOME}/.bashrc !" ${Gra-}
    fi
}

function downloadPyenv() {
    if ! [[ -d "${HOME}/.pyenv" ]]; then
        printMsg "Download and install Pyenv..."
        curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    else
        printPretty "Pyenv already installed. Updating..." ${Gra-}
        cd "${PYENV_ROOT}" && git pull && cd -
    fi
}

function runPyenv() {
    printMsg "Running Pyenv..."
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi
    printInfo "Version: $(pyenv --version)"
}

function installPythonWithPyenv() {
    printMsg "Install requires Python version"
    pyenv install -s "${python_version}"
}

function installPipenv() {
    printMsg "Install Pipenv"
    cd "${root_dir}"
    pyenv shell
    pip install --user pipenv
}

function installPythonDependencies() {
    printMsg "Install Python dependencies with Pipfile"
    cd "${root_dir}"
    export PIPENV_IGNORE_VIRTUALENVS="1" # Force .venv to be rebuild with 'pipenv install' command
    pipenv install
}

main "${@}"
