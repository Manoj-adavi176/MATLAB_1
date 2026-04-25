function benchmark_all_methods()

clc;
fprintf('=== Running Full Benchmark ===\n');

load('config.mat','config')

% Load test image
[img,~] = utils.load_dicom_series(config.dicomPath);
img = utils.preprocess_image(img);

% Reference for fair comparison
img_ref_128 = imresize(img,[128 128]);

%% ==============================
% CS (FISTA - k-space)
%% ==============================
kspace = fftshift(fft2(img));
mask = cs.generate_sampling_mask(size(kspace),4);
kspace_us = kspace .* mask;

img_cs = cs.reconstruct_cs_fista(kspace_us, mask);

%% ==============================
% Classical Methods
%% ==============================
img_sp     = cs_extra.reconstruct_sp(img);
img_iht    = cs_extra.reconstruct_iht(img);
img_cosamp = cs_extra.reconstruct_cosamp(img);

%% ==============================
% Load AI Model
%% ==============================
load(fullfile(config.modelsPath,'unet_model.mat'))

%% ==============================
% Apply AI with Gating
%% ==============================
img_cs_ai     = utils.apply_ai_gated(img_cs, net);
img_sp_ai     = utils.apply_ai_gated(img_sp, net);
img_iht_ai    = utils.apply_ai_gated(img_iht, net);
img_cosamp_ai = utils.apply_ai_gated(img_cosamp, net);

%% ==============================
% Benchmark
%% ==============================
methods = {
    'CS (FISTA)', ...
    'CS + AI', ...
    'SP', ...
    'SP + AI', ...
    'IHT', ...
    'IHT + AI', ...
    'CoSaMP', ...
    'CoSaMP + AI'
};

images = {
    img_cs, ...
    img_cs_ai, ...
    img_sp, ...
    img_sp_ai, ...
    img_iht, ...
    img_iht_ai, ...
    img_cosamp, ...
    img_cosamp_ai
};

fprintf('\n=== RESULTS ===\n');

for i = 1:length(methods)
    tic
    recon = imresize(images{i}, [128 128]);
    t = toc;

    m = utils.compute_metrics(recon, img_ref_128);

    fprintf('%-15s -> PSNR: %.2f | SSIM: %.3f | Time: %.4fs\n', ...
        methods{i}, m.PSNR, m.SSIM, t);
end

%% ==============================
% Visualization
%% ==============================
figure('Name','Method Comparison')

for i = 1:length(images)
    subplot(2,4,i)
    imshow(images{i},[])
    title(methods{i})
end

%% ==============================
% Metrics Comparison (Bar Plots)
%% ==============================
psnr_vals = zeros(1,length(images));
ssim_vals = zeros(1,length(images));

for i = 1:length(images)
    recon = imresize(images{i}, [128 128]);
    m = utils.compute_metrics(recon, img_ref_128);
    psnr_vals(i) = m.PSNR;
    ssim_vals(i) = m.SSIM;
end

figure
bar(psnr_vals)
set(gca,'XTickLabel',methods)
xtickangle(45)
title('PSNR Comparison')

figure
bar(ssim_vals)
set(gca,'XTickLabel',methods)
xtickangle(45)
title('SSIM Comparison')

end
