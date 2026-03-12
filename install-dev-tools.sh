#!/usr/bin/env bash
#
# install-dev-tools.sh
# --------------------
# One-time setup of dev dependencies for this project: system libraries,
# R packages, Python packages (including Selenium), Google Chrome (stable),
# and ChromeDriver. All installed versions are recorded in
# docs-and-references/installed-versions.md (Ubuntu, R, Python, Quarto, Chrome, ChromeDriver).
#
# Usage: run with appropriate privileges (e.g. sudo bash install-dev-tools.sh
#        or from a devcontainer that runs this as part of build).
#

set -e

# =============================================================================
# 1. System: 32-bit libraries and base updates
# =============================================================================
# Required for some R graphics (e.g. grDevices) and optional i386 packages.

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y libxt6
# Ref: https://notes.rmhogervorst.nl/post/2020/09/23/solving-libxt-so-6-cannot-open-shared-object-in-grdevices-grsoftversion/
# Note: libxtst6 (i386) may be needed for rendering QMD notebooks if you see
#       related errors; install with: sudo apt install libxtst6:i386

# =============================================================================
# 2. R packages
# =============================================================================

R -e 'devtools::install_github("Bart6114/sparklines")'

# =============================================================================
# 3. Python packages
# =============================================================================
# Used for scripting, Jupyter, and browser automation (Selenium). Can be
# mirrored in a requirements.txt if you prefer pip install -r requirements.txt.

pip3 install requests pandas bs4 selenium openpyxl ipykernel
sudo apt-get install -y python3-lxml   # Used by pandas for certain parsers

# =============================================================================
# 4. System: unzip
# =============================================================================
# Needed to extract ChromeDriver and other archives.

sudo apt-get install -yqq unzip

# =============================================================================
# 5. Google Chrome (stable)
# =============================================================================
# Installed from Google’s official APT repo so it stays on the stable channel
# and can be updated with apt. Required for Selenium with a real Chrome window.

# Modern method: keyring in /etc/apt/keyrings (apt-key is deprecated)
sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub \
  | gpg --dearmor | sudo tee /etc/apt/keyrings/google-chrome.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
  | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
sudo apt-get -y update
sudo apt-get install -y google-chrome-stable

# =============================================================================
# 6. ChromeDriver (stable, matches Chrome)
# =============================================================================
# ChromeDriver 115+ is distributed via “Chrome for Testing”. We fetch the
# latest stable version and URL from the official JSON so Selenium can drive
# the installed Chrome. The version is printed here and written to the docs.

CFT_JSON=$(curl -sSL "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json")
CHROMEDRIVER_VERSION=$(echo "$CFT_JSON" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d['channels']['Stable']['version'])
")
CHROMEDRIVER_URL=$(echo "$CFT_JSON" | python3 -c "
import sys, json
d = json.load(sys.stdin)
for p in d['channels']['Stable']['downloads']['chromedriver']:
    if p['platform'] == 'linux64':
        print(p['url'])
        break
")

echo "Installing ChromeDriver (Stable) version: $CHROMEDRIVER_VERSION"
wget -q -O /tmp/chromedriver.zip "$CHROMEDRIVER_URL"
unzip -o /tmp/chromedriver.zip -d /tmp/
sudo mv /tmp/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver
sudo chmod +x /usr/local/bin/chromedriver
rm -rf /tmp/chromedriver-linux64 /tmp/chromedriver.zip

# =============================================================================
# 7. Document installed versions (no manual devcontainer notes needed)
# =============================================================================
# Writes docs-and-references/installed-versions.md with Ubuntu, R, Python,
# Quarto, Chrome, and ChromeDriver. Base image string is read from
# .devcontainer/devcontainer.json "image" field. Override output dir with: VERSIONS_DIR=/path/to/dir

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
VERSIONS_DIR="${VERSIONS_DIR:-$SCRIPT_DIR/docs-and-references}"
mkdir -p "$VERSIONS_DIR"

DEVCONTAINER_JSON="$SCRIPT_DIR/.devcontainer/devcontainer.json"
DEVCONTAINER_IMAGE="unknown"
if [[ -f "$DEVCONTAINER_JSON" ]]; then
	DEVCONTAINER_IMAGE=$(sed -n 's/.*"image"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$DEVCONTAINER_JSON" | head -1)
	[[ -z "$DEVCONTAINER_IMAGE" ]] && DEVCONTAINER_IMAGE="unknown"
fi

# Capture versions (avoid failing the script if a command is missing)
UBUNTU_VERSION=$( (lsb_release -ds 2>/dev/null || (source /etc/os-release 2>/dev/null && echo "$PRETTY_NAME")) || echo "unknown")
R_VERSION=$(R --version 2>/dev/null | head -1 || echo "unknown")
PYTHON_VERSION=$(python3 --version 2>/dev/null || echo "unknown")
QUARTO_VERSION=$(quarto --version 2>/dev/null || echo "not installed")
CHROME_VERSION=$(google-chrome --version 2>/dev/null || google-chrome-stable --version 2>/dev/null || echo "unknown")
INSTALL_DATE=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

cat > "$VERSIONS_DIR/installed-versions.md" << EOF
# Installed versions (devcontainer)

Generated by \`install-dev-tools.sh\` at **$INSTALL_DATE**. No need to manually keep devcontainer.json in sync with these versions.

## Base image

| Item        | Value |
|-------------|--------|
| Image       | \`${DEVCONTAINER_IMAGE}\` |
| OS          | \`$UBUNTU_VERSION\` |

Image value is read from \`.devcontainer/devcontainer.json\` \`image\` field.

## Main runtimes and tools

| Component   | Version | Notes |
|-------------|---------|--------|
| R           | \`$R_VERSION\` | From base image + packages in install-dev-tools.sh |
| Python      | \`$PYTHON_VERSION\` | From base image + pip packages in install-dev-tools.sh |
| Quarto      | \`$QUARTO_VERSION\` | From devcontainer feature \`quarto-cli\` |
| Chrome      | \`$CHROME_VERSION\` | Google APT repo (stable) |
| ChromeDriver| \`$CHROMEDRIVER_VERSION\` | [Chrome for Testing](https://googlechromelabs.github.io/chrome-for-testing/) – Stable |

## ChromeDriver (Selenium)

Download URL used: \`$CHROMEDRIVER_URL\`
EOF

echo "Versions written to: $VERSIONS_DIR/installed-versions.md"

# =============================================================================
# Legacy / reference (2023 method)
# =============================================================================
# Old Chrome repo setup (apt-key is deprecated on modern Ubuntu):
#   wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
#   echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
#
# Old ChromeDriver (fixed 2023 version 116.0.5845.96):
#   wget -O /tmp/chromedriver.zip https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/116.0.5845.96/linux64/chromedriver-linux64.zip
#   unzip /tmp/chromedriver.zip -d /tmp/
#   sudo mv /tmp/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver
#   sudo chmod +x /usr/local/bin/chromedriver
