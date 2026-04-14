function [img, info] = load_dicom_series(folderPath)

    files = dir(fullfile(folderPath, '*.dcm'));
    
    if isempty(files)
        error('No DICOM files found');
    end
    
    % Load first file
    filePath = fullfile(folderPath, files(1).name);
    
    img = dicomread(filePath);
    info = dicominfo(filePath);
    
    img = double(img);
    
    % Convert to grayscale if needed
    if ndims(img) == 3
        img = rgb2gray(img);
    end
    
    fprintf('Loaded: %s\n', files(1).name);
    fprintf('Size: %dx%d\n', size(img,1), size(img,2));
end