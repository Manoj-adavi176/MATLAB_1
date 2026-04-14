function metrics = compute_metrics(img1, img2)

% Convert both to double
img1 = double(img1);
img2 = double(img2);

% Normalize both to [0,1]
img1 = (img1 - min(img1(:))) / (max(img1(:)) - min(img1(:)) + eps);
img2 = (img2 - min(img2(:))) / (max(img2(:)) - min(img2(:)) + eps);

% Ensure same size
if ~isequal(size(img1), size(img2))
    img2 = imresize(img2, size(img1));
end

% Compute metrics
metrics.PSNR = psnr(img1, img2);
metrics.SSIM = ssim(img1, img2);

end