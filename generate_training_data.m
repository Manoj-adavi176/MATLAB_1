function generate_training_data(numFiles)

    load('config.mat', 'config');
    
    if nargin < 1
        numFiles = 100; % keep small for now
    end
    
    dcmFiles = dir(fullfile(config.dicomPath, '*.dcm'));
    numFiles = min(numFiles, length(dcmFiles));
    
    fprintf('Generating data from %d files...\n', numFiles);
    
    X = [];
    Y = [];
    
    for i = 1:numFiles
        
        % Load image
        img = double(dicomread(fullfile(config.dicomPath, dcmFiles(i).name)));
        
        if ndims(img) == 3
            img = rgb2gray(img);
        end
        
        img = utils.preprocess_image(img);
        
        % Skip bad images
        if std(img(:)) < 0.05
            continue;
        end
        
        % Create undersampled version
        kspace = fftshift(fft2(img));
        mask = cs.generate_sampling_mask(size(kspace), 4);
        kspace_us = kspace .* mask;
        
        img_cs = cs.reconstruct_cs_fista(kspace_us, mask);
        
        % Store
        X(:,:,1,end+1) = img_cs;
        Y(:,:,1,end+1) = img;
        
        fprintf('Processed %d/%d\n', i, numFiles);
    end
    
    % Split
    n = size(X,4);
    idx = randperm(n);
    
    nTrain = round(0.7*n);
    nVal = round(0.15*n);
    
    XTrain = X(:,:,:,idx(1:nTrain));
    YTrain = Y(:,:,:,idx(1:nTrain));
    
    XVal = X(:,:,:,idx(nTrain+1:nTrain+nVal));
    YVal = Y(:,:,:,idx(nTrain+1:nTrain+nVal));
    
    % Save
    save(fullfile(config.dataPath, 'training_data.mat'), ...
        'XTrain','YTrain','XVal','YVal','-v7.3');
    
    fprintf('Dataset saved!\n');
end