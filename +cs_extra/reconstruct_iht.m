function img_out = reconstruct_iht(img)

img = imresize(img,[128 128]);
img = img / max(img(:));

patch_size = 8;
N = patch_size^2;
M = 48;
max_iter = 50;
s = 10;

D1 = dctmtx(patch_size);
D = kron(D1,D1);

rng(1);
Phi = randn(M,N); 
Phi = Phi ./ vecnorm(Phi);

A = Phi * D;
mu = 1 / norm(A)^2;

recon_img = zeros(size(img));

for i = 1:patch_size:size(img,1)
    for j = 1:patch_size:size(img,2)

        patch = img(i:i+patch_size-1,j:j+patch_size-1);
        y = Phi * patch(:);

        alpha = zeros(N,1);

        for iter = 1:max_iter
            alpha = alpha + mu*(A'*(y - A*alpha));
            [~,idx] = sort(abs(alpha),'descend');
            alpha(idx(s+1:end)) = 0;
        end

        x_hat = D * alpha;
        recon_img(i:i+patch_size-1,j:j+patch_size-1) = reshape(x_hat,[patch_size patch_size]);
    end
end

img_out = (recon_img - min(recon_img(:))) / (max(recon_img(:)) - min(recon_img(:)));
end