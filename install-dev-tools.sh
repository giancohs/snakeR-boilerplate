sudo dpkg --add-architecture i386
sudo apt-get update

sudo apt-get install libxt6 # This is need according to a similar error in: https://notes.rmhogervorst.nl/post/2020/09/23/solving-libxt-so-6-cannot-open-shared-object-in-grdevices-grsoftversion/


# sudo apt install libxtst6 ## This was already installed, but version for i386 is needed to render qmd notebooks

# Install R packages:
## devtools sparkline 
R -e 'devtools::install_github("Bart6114/sparklines")'

# Install Python packages:
pip3 install requests
pip3 install pandas
pip3 install bs4

