# EEG-Band-Merging-Tool-Combine-Frequency-Bands-into-One-EEG-Structure-and-Save-as-EDF

In our research group, my Principal Investigator (P.I.), a retired neurologist, has expressed the need to visually inspect all frequency bands in a single trace on a large monitor to enhance the detection of abnormalities in EEG data. To address this requirement, we developed this tool to merge filtered versions of EEG recordings into a unified trace, facilitating comprehensive analysis and anomaly identification.

## Description
This MATLAB script processes EEG data files in EDF format. It utilizes functions from the EEGLAB toolbox along with other MATLAB functions to perform resampling, filtering, and data manipulation tasks.


## Prerequisites
To use this script, you need to have the following prerequisites installed and available in your MATLAB environment:
- **MATLAB**: The script is written in MATLAB and requires MATLAB environment to execute.
- **EEGLAB Toolbox**: A toolbox for processing and analyzing EEG data in MATLAB.
- **Required Functions**:
  - `pop_biosig`: A function from EEGLAB for loading EEG data from EDF files.
  - `force_delete`: A custom function for deleting files.
  - `pop_resample`: A function from EEGLAB for resampling EEG data.
  - `eeg_checkset`: A function from EEGLAB for checking and updating EEG structures.
  - `pop_writeeeg`: A function from EEGLAB for saving EEG data to EDF files.
  - `pop_eegfiltnew`: A function from EEGLAB for applying frequency filters to EEG data.

## Usage
1. Place your EDF files in a folder.
2. Update the `mainFolderPath` variable in the script to point to the folder containing your EDF files.
3. Make sure you have the EEGLAB toolbox installed and added to your MATLAB path.
4. Run the script in MATLAB.

## Process
1. The script loops through each EDF file in the specified folder.
2. It loads the EEG data using `pop_biosig` function from EEGLAB.
3. Original files are deleted after loading using `force_delete`.
4. EEG data is resampled to a new sampling rate using `pop_resample` function from EEGLAB.
5. The script creates a folder for each input file and saves the original signal as an EDF file in that folder using `pop_writeeeg` function from EEGLAB.
6. Frequency-specific EEG bands (Delta, Theta, Alpha, and Igler) are extracted using `pop_eegfiltnew` function from EEGLAB.
7. Each frequency band is saved as a separate EDF file using `pop_writeeeg` function from EEGLAB.
8. All frequency bands are merged into one EEG structure and saved as an EDF file using `pop_writeeeg` function from EEGLAB.

## Note
- Make sure to have the EEGLAB toolbox installed and added to your MATLAB path for the script to execute successfully.
- Ensure that the main folder path (`mainFolderPath`) is correctly set to the location of your input EDF files.

