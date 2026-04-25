function img_out = reconstruct_cosamp(img)

img = imresize(img,[128 128]);
img = img / max(img(:));

patch_size = 8;
N = patch_size^2;
M = 48;
max_iter = 10;
s = 10;

D1 = dctmtx(patch_size);
D = kron(D1,D1);

rng(1);
Phi = randn(M,N); 
Phi = Phi ./ vecnorm(Phi);

A = Phi * D;

recon_img = zeros(size(img));

for i = 1:patch_size:size(img,1)
    for j = 1:patch_size:size(img,2)

        patch = img(i:i+patch_size-1,j:j+patch_size-1);
        y = Phi * patch(:);

        residual = y;
        support = [];
        alpha = zeros(N,1);

        for iter = 1:max_iter
            proxy = A' * residual;
            [~,idx] = sort(abs(proxy),'descend');
            omega = idx(1:2*s);

            T = union(support,omega);
            temp = zeros(N,1);
            temp(T) = A(:,T)\y;

            [~,idx2] = sort(abs(temp),'descend');
            support = idx2(1:s);

            alpha = zeros(N,1);
            alpha(support) = A(:,support)\y;

            residual = y - A*alpha;
        end

        x_hat = D * alpha;
        recon_img(i:i+patch_size-1,j:j+patch_size-1) = reshape(x_hat,[patch_size patch_size]);
    end
end

img_out = (recon_img - min(recon_img(:))) / (max(recon_img(:)) - min(recon_img(:)));
end