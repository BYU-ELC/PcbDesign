# BYU ECEn Shop EAGLE Files

Contains the following configuration files for the Brigham Young University Electrical and Computer Engineering Shop:

 - Shop parts library
 - EAGLE CAM Processor
 - EAGLE Design rules (for DRC)

## Usage: Git

It is easiest to use this repository by using git, which on Windows has to be installed. Linux and Mac usually come with git installed. You can find out by opening a terminal (or PowerShell for Windows) and typing `git version`. If it is not installed, [download it](git-scm.com/downloads). If using a computer without administrative privileges (a school computer), download the Portable or "thumbdrive edition".

1. Open a terminal (Ctrl+Alt+T on Linux, PowerShell on Windows).
2. Run `git version`. If an error occurs, follow the instructions in the above paragraph to download git.
3. Run `cd EAGLE`
4. Run `git clone https://github.com/BYU-ELC/PcbDesign byuPCB`
5. Open EAGLE
6. Click on the "Options" tab and select "Directories..." from the list
7. Add ":$HOME/EAGLE/byuPCB" to the end of each of the following fields. On Windows, replace the colon with a semicolon. (Ex: change _$HOME/EAGLE/libraries_ to _$HOME/EAGLE/libraries:$HOME/EAGLE/byuPCB_)
 - Libraries
 - Design Rules
 - CAM Jobs
8. After verifying that the above fields have been correctly changed, click OK.

Every once in a while, navigate to the directory (`cd EAGLE/byuPCB`) and execute `git pull`. This will keep your version of the file up to date.

## Usage: Download

This method is easier, but you will have to do it every time you want to submit a board for production. Using Git is highly recommended, but this option is included for completeness.

1. Open a browser and navigate to [https://github.com/BYU-ELC/PcbDesign](https://github.com/BYU-ELC/PcbDesign).
2. Click on the green "Code" button, then "Download ZIP"
3. Extract the files from the folder
4. To use the library, click on the "Open library manager" (3 books) button at the top, click on the "In Use" tab, and select "Browse..." and find and select the .lbr file that was extracted.
4. When running the DRC, click "Load", and then find and select the .dru file that was extracted.
5. When running the CAM Processor, click the "Load job file" button at the top (paper with an arrow) and then "Open CAM File...". Find the .cam file that was extracted.

> Remember, the file will have to be downloaded new each time it is used so that all updates will be available.

## JLC PCB

Below are links to JLC PCB's CAM and Design rule files because they are hard to find on the website.
 
[CAM files](https://support.jlcpcb.com/article/137-how-to-generate-gerber-and-drill-files-in-autodesk-eagle): use jlcpcb_2_layer_v9.cam for most jobs

[DRC files](https://github.com/oxullo/jlcpcb-eagle): use design_rules/jlcpcb-2layers.dru

