function setup_project()
    clc;
    fprintf('=== MRI Project Setup ===\n');
    
    % Get current folder
    projectRoot = fileparts(mfilename('fullpath'));
    
    % Add all subfolders
    addpath(genpath(projectRoot));
    
    % Create required folders
    folders = {'data','models','outputs'};
    for i = 1:length(folders)
        if ~exist(fullfile(projectRoot,folders{i}),'dir')
            mkdir(fullfile(projectRoot,folders{i}));
        end
    end
    
    % Save config
    config.projectRoot = projectRoot;
    config.dicomPath = fullfile(fileparts(projectRoot),'MTR_001');
    config.dataPath = fullfile(projectRoot,'data');
    config.modelsPath = fullfile(projectRoot,'models');
    config.outputsPath = fullfile(projectRoot,'outputs');
    
    save(fullfile(projectRoot,'config.mat'),'config');
    
    fprintf('Setup complete!\n');
    
    % Check DICOM
    if exist(config.dicomPath,'dir')
        files = dir(fullfile(config.dicomPath,'*.dcm'));
        fprintf('DICOM files found: %d\n', length(files));
    else
        fprintf('DICOM folder NOT found!\n');
    end
end