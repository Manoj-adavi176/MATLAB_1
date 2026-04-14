function lgraph = build_unet()

input = imageInputLayer([256 256 1],'Name','input','Normalization','none');

% Encoder
conv1 = [
    convolution2dLayer(3,32,'Padding','same','Name','conv1_1')
    reluLayer('Name','relu1_1')
    convolution2dLayer(3,32,'Padding','same','Name','conv1_2')
    reluLayer('Name','relu1_2')];

pool1 = maxPooling2dLayer(2,'Stride',2,'Name','pool1');

conv2 = [
    convolution2dLayer(3,64,'Padding','same','Name','conv2_1')
    reluLayer('Name','relu2_1')
    convolution2dLayer(3,64,'Padding','same','Name','conv2_2')
    reluLayer('Name','relu2_2')];

pool2 = maxPooling2dLayer(2,'Stride',2,'Name','pool2');

% Bottleneck
conv3 = [
    convolution2dLayer(3,128,'Padding','same','Name','conv3_1')
    reluLayer('Name','relu3_1')
    convolution2dLayer(3,128,'Padding','same','Name','conv3_2')
    reluLayer('Name','relu3_2')];

% Decoder
up1 = transposedConv2dLayer(2,64,'Stride',2,'Name','up1');

conv4 = [
    convolution2dLayer(3,64,'Padding','same','Name','conv4_1')
    reluLayer('Name','relu4_1')
    convolution2dLayer(3,64,'Padding','same','Name','conv4_2')
    reluLayer('Name','relu4_2')];

up2 = transposedConv2dLayer(2,32,'Stride',2,'Name','up2');

conv5 = [
    convolution2dLayer(3,32,'Padding','same','Name','conv5_1')
    reluLayer('Name','relu5_1')
    convolution2dLayer(3,32,'Padding','same','Name','conv5_2')
    reluLayer('Name','relu5_2')];

final = [
    convolution2dLayer(1,1,'Name','final_conv')
    regressionLayer('Name','output')];

% Layer graph
lgraph = layerGraph(input);

lgraph = addLayers(lgraph,conv1);
lgraph = addLayers(lgraph,pool1);
lgraph = addLayers(lgraph,conv2);
lgraph = addLayers(lgraph,pool2);
lgraph = addLayers(lgraph,conv3);
lgraph = addLayers(lgraph,up1);
lgraph = addLayers(lgraph,conv4);
lgraph = addLayers(lgraph,up2);
lgraph = addLayers(lgraph,conv5);
lgraph = addLayers(lgraph,final);

% Connections
lgraph = connectLayers(lgraph,'input','conv1_1');
lgraph = connectLayers(lgraph,'relu1_2','pool1');
lgraph = connectLayers(lgraph,'pool1','conv2_1');
lgraph = connectLayers(lgraph,'relu2_2','pool2');
lgraph = connectLayers(lgraph,'pool2','conv3_1');

lgraph = connectLayers(lgraph,'relu3_2','up1');
lgraph = connectLayers(lgraph,'up1','conv4_1');

lgraph = connectLayers(lgraph,'relu4_2','up2');
lgraph = connectLayers(lgraph,'up2','conv5_1');

lgraph = connectLayers(lgraph,'relu5_2','final_conv');

end