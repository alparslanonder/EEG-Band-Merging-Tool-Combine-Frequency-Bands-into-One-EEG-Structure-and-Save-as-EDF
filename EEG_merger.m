% Clear the command window
clc;

% Clear all variables from the workspace
clear;

% Define the path to the main folder containing the EDF files
mainFolderPath='C:\Users\alpar\Desktop\1'; % Replace with your folder path

% Get the list of EDF files in the main folder
fileList = dir(fullfile(mainFolderPath, '*.edf'));

% Define the new sampling rate for resampling the EEG data
new_sampling_rate=200;

% Loop through each EDF file in the folder
for file_idx = 1:length(fileList)
    % Load EEG data from the current EDF file using pop_biosig
    file_name = fileList(file_idx).name;
    file_path = fullfile(mainFolderPath, file_name);
    EEG = pop_biosig(file_path);

    % Check if the file exists before attempting to delete it
    if exist(file_path, 'file') == 2
        try
            % Delete the original EDF file
            force_delete(file_path);
            disp(['Deleted file: ', file_path]);
        catch ME
            % Catch any errors that occur during file deletion
            warning(['Failed to delete file: ', file_path, ' Error: ', ME.message]);
        end
    else
        % Display a warning if the file does not exist
        warning(['File does not exist: ', file_path]);
    end
    
    % Resample the EEG data to the new sampling rate
    EEG = pop_resample(EEG, new_sampling_rate);

    % Update the EEG structure
    EEG = eeg_checkset(EEG);

    % Create a folder for the processed data
    [~, filenameWithoutExt, ~] = fileparts(file_name);
    name_of_subfolder = fullfile(mainFolderPath, filenameWithoutExt);
    outputFolderName = fullfile(name_of_subfolder, [filenameWithoutExt, '_ProcessedData']);
    if ~exist(outputFolderName, 'dir')
        mkdir(outputFolderName);
    end

    % Save the original signal as an EDF file
    saveOriginalFilename = fullfile(outputFolderName, [filenameWithoutExt, '_original.edf']);
    pop_writeeeg(EEG, saveOriginalFilename, 'TYPE', 'EDF');
    disp(['Original signal saved as ', saveOriginalFilename]);
   
    % Filter EEG data into different frequency bands and save as separate EDF files
    EEG_delta = pop_eegfiltnew(EEG, 1, 3, [], 0, 0, 1);
    pop_writeeeg(EEG_delta, [outputFolderName '\' filenameWithoutExt '_Delta.edf'], 'TYPE', 'EDF');
    EEG_theta = pop_eegfiltnew(EEG, 3, 7, [], 0, 0, 1);
    pop_writeeeg(EEG_theta, [outputFolderName '\' filenameWithoutExt '_Theta.edf'], 'TYPE', 'EDF');
    EEG_alpha = pop_eegfiltnew(EEG, 7, 12, [], 0, 0, 1);
    pop_writeeeg(EEG_alpha, [outputFolderName '\' filenameWithoutExt '_Alpha.edf'], 'TYPE', 'EDF');
    EEG_Spindle = pop_eegfiltnew(EEG, 12, 15, [], 0, 0, 1);
    pop_writeeeg(EEG_Spindle, [outputFolderName '\' filenameWithoutExt '_Spindle.edf'], 'TYPE', 'EDF');

    % Merge all frequency bands into one EEG structure and save as an EDF file
    EEG_merged = EEG;
    EEG_merged.data = vertcat(EEG.data, EEG_delta.data, EEG_theta.data, EEG_alpha.data, EEG_igler.data);
    EEG_merged.chanlocs = vertcat(EEG.chanlocs, EEG_delta.chanlocs, EEG_theta.chanlocs, EEG_alpha.chanlocs, EEG_igler.chanlocs);
    EEG_merged.nbchan = size(EEG_merged.data,1);
    pop_writeeeg(EEG_merged, [outputFolderName '\' filenameWithoutExt '_All_Merged.edf'], 'TYPE', 'EDF');
end
