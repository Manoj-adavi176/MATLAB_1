function train_model()

load('config.mat','config');
load(fullfile(config.dataPath,'training_data.mat'));

layers = dl.build_unet();

options = trainingOptions('adam', ...
    'MaxEpochs',15, ...
    'MiniBatchSize',4, ...
    'InitialLearnRate',1e-3, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'Verbose',true);

net = trainNetwork(XTrain, YTrain - XTrain, layers, options);
save(fullfile(config.modelsPath,'unet_model.mat'),'net');

fprintf('Model trained and saved!\n');

end