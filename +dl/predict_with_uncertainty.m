function [meanImg, uncert] = predict_with_uncertainty(img, net, N)

if nargin < 3
    N = 20;
end

img = reshape(img,[256 256 1 1]);

preds = zeros(256,256,N);

for i = 1:N
    noisy = img + 0.01*randn(size(img));
    p = predict(net, noisy);
    preds(:,:,i) = squeeze(p);
end

meanImg = mean(preds,3);
uncert = std(preds,0,3);

uncert = uncert / max(uncert(:));

end