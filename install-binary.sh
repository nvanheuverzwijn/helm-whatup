#!/bin/bash

# Combination of the Glide and Helm scripts, with my own tweaks.

PROJECT_NAME="helm-whatup"
PROJECT_GH="fabmation-gmbh/${PROJECT_NAME}"

# set HELM_HOME if it is not set, to the default Value
if [ -z "${HELM_HOME}" ]; then
        export HELM_HOME="${HOME}/.helm"
fi

if [[ ${SKIP_BIN_INSTALL} == "1" ]]; then
  echo "Skipping binary install"
  exit
fi

# initArch discovers the architecture for this system.
initArch() {
  ARCH=$(uname -m)
  case $ARCH in
    armv5*) ARCH="armv5";;
    armv6*) ARCH="armv6";;
    armv7*) ARCH="armv7";;
    aarch64) ARCH="arm64";;
    x86) ARCH="386";;
    x86_64) ARCH="amd64";;
    i686) ARCH="386";;
    i386) ARCH="386";;
  esac
}

# initOS discovers the operating system for this system.
initOS() {
  OS=$(echo `uname`|tr '[:upper:]' '[:lower:]')

  case "$OS" in
    # Minimalist GNU for Windows
    mingw*) OS='windows';;
  esac
}

# verifySupported checks that the os/arch combination is supported for
# binary builds.
verifySupported() {
  local supported="linux-amd64\ndarwin-amd64"
  if ! echo "${supported}" | grep -q "${OS}-${ARCH}"; then
    echo "No prebuild binary for ${OS}-${ARCH}."
    exit 1
  fi

  if ! type "curl" > /dev/null && ! type "wget" > /dev/null; then
    echo "Either curl or wget is required"
    exit 1
  fi
}

# getDownloadURL checks the latest available version.
getDownloadURL() {
  # Use the GitHub API to find the latest version for this project.
  local latest_url="https://api.github.com/repos/$PROJECT_GH/releases/latest"
  if type "curl" > /dev/null; then
    DOWNLOAD_URL=$(curl -s ${latest_url} | grep $OS | awk '/\"browser_download_url\":/{gsub( /[,\"]/,"", $2); print $2}')
  elif type "wget" > /dev/null; then
    DOWNLOAD_URL=$(wget -q -O - ${latest_url} | awk '/\"browser_download_url\":/{gsub( /[,\"]/,"", $2); print $2}')
  fi
}

# downloadFile downloads the latest binary package and also the checksum
# for that binary.
downloadFile() {
  PLUGIN_TMP_FILE="/tmp/${PROJECT_NAME}.tgz"
  echo "Downloading ${DOWNLOAD_URL}"
  if type "curl" > /dev/null; then
    curl -L "${DOWNLOAD_URL}" -o "${PLUGIN_TMP_FILE}"
  elif type "wget" > /dev/null; then
    wget -q -O "${PLUGIN_TMP_FILE}" "${DOWNLOAD_URL}"
  fi
}

# installFile unpacks and installs helm-whatup.
installFile() {
  HELM_TMP="/tmp/${PROJECT_NAME}"
  mkdir -p "${HELM_TMP}"
  tar xf "${PLUGIN_TMP_FILE}" -C "${HELM_TMP}"
  echo "Preparing to install into ${HELM_PLUGIN_DIR}"
  cp -R "${HELM_TMP}/bin" "${HELM_PLUGIN_DIR}/"
}

# fail_trap is executed if an error occurs.
fail_trap() {
  result=$?
  if [[ "${result}" != "0" ]]; then
    echo "Failed to install ${PROJECT_NAME}"
    echo -e "\tFor support, go to https://github.com/fabmation-gmbh/helm-whatup."
  fi
  exit ${result}
}

# testVersion tests the installed client to make sure it is working.
testVersion() {
  set +e
  echo "${PROJECT_NAME} installed into ${HELM_PLUGIN_DIR}/${PROJECT_NAME}"
  ${HELM_PLUGIN_DIR}/bin/helm-whatup -h
  set -e
}

# Execution

#Stop execution on any error
trap "fail_trap" EXIT
set -e
initArch
initOS
verifySupported
getDownloadURL
downloadFile
installFile
testVersion
