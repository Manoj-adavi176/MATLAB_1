function evaluate_model()

load('config.mat','config');
load(fullfile(config.modelsPath,'unet_model.mat'));

files = dir(fullfile(config.dicomPath,'*.dcm'));
testFile = fullfile(config.dicomPath, files(200).name);

img = double(dicomread(testFile));

if ndims(img) == 3
    img = rgb2gray(img);
end

img = utils.preprocess_image(img);

% Undersampling
kspace = fftshift(fft2(img));
mask = cs.generate_sampling_mask(size(kspace),4);
kspace_us = kspace .* mask;

% Zero-filled
img_zf = abs(ifft2(ifftshift(kspace_us)));
img_zf = (img_zf - min(img_zf(:))) / (max(img_zf(:)) - min(img_zf(:)));

% CS
img_cs = cs.reconstruct_cs_fista(kspace_us, mask);

% AI
residual = predict(net, reshape(img_cs,[256 256 1 1]));
img_ai = img_cs + squeeze(residual);

% Metrics
m_cs = utils.compute_metrics(img_cs, img);
m_ai = utils.compute_metrics(img_ai, img);

fprintf('\n=== METRICS ===\n');
fprintf('CS  -> PSNR: %.2f | SSIM: %.4f\n', m_cs.PSNR, m_cs.SSIM);
fprintf('AI  -> PSNR: %.2f | SSIM: %.4f\n', m_ai.PSNR, m_ai.SSIM);

% Display
figure
subplot(1,4,1); imshow(img,[]); title('Original')

subplot(1,4,2); imshow(img_cs,[])
title(sprintf('CS\nPSNR=%.2f', m_cs.PSNR))

subplot(1,4,3); imshow(img_ai,[])
title(sprintf('AI\nPSNR=%.2f', m_ai.PSNR))

% Uncertainty (next step)
[~, uncert] = dl.predict_with_uncertainty(img_cs, net, 20);
subplot(1,4,4); imagesc(uncert); colorbar; axis image
title('Uncertainty Map')

end