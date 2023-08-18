sudo dpkg --add-architecture i386
sudo apt-get update

sudo apt-get install libxt6 # This is need according to a similar error in: https://notes.rmhogervorst.nl/post/2020/09/23/solving-libxt-so-6-cannot-open-shared-object-in-grdevices-grsoftversion/


# sudo apt install libxtst6. This was already installed, but version for i386 is needed to render qmd notebooks

# Install R packages:
## devtools sparkline 
R -e 'devtools::install_github("Bart6114/sparklines")'

# Install Python packages, also can be used as "requirements.txt":
pip3 install requests
pip3 install pandas
pip3 install bs4
pip3 install selenium
sudo apt-get install python3-lxml # This is for pandas parser
pip3 install openpyxl



# INSTALLING UNZIP
sudo apt-get install -yqq unzip

# DOWNLOAD AND INSTALL STABLE VERSION OF GOOGLE CHROME

# Adding trusting keys to apt for repositories
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# Adding Google Chrome to the repositories
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Updating apt to see and install Google Chrome
apt-get -y update

# Magic happens
apt-get install -y google-chrome-stable

# INSTALL CHROME DRIVER

## According to the chromium webpage, the lastest release of chrome is above 115: https://chromedriver.chromium.org/downloads. 

## I will use the latest stable version (17/08/2023) which is Version: 116.0.5845.96 (r1160321)
wget -O /tmp/chromedriver.zip https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/116.0.5845.96/linux64/chromedriver-linux64.zip

## Unzip the Chrome Driver into /usr/local/bin directory
unzip /tmp/chromedriver.zip -d /usr/local/bin/

