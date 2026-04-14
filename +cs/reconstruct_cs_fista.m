function img_cs = reconstruct_cs_fista(kspace_us, mask)

    maxIter = 30;
    lambda = 0.01;
    
    % Initial (zero-filled)
    x = abs(ifft2(ifftshift(kspace_us)));
    y = x;
    t = 1;
    
    for i = 1:maxIter
        
        % Data consistency
        k_est = fftshift(fft2(y));
        grad = ifft2(ifftshift(mask .* (k_est - kspace_us)));
        
        x_new = y - real(grad);
        
        % TV denoise
        x_new = cs.tv_denoise(x_new, lambda);
        
        % FISTA update
        t_new = (1 + sqrt(1 + 4*t^2)) / 2;
        y = x_new + ((t - 1)/t_new) * (x_new - x);
        
        x = x_new;
        t = t_new;
    end
    
    img_cs = abs(x);
    
    % Normalize
    img_cs = (img_cs - min(img_cs(:))) / (max(img_cs(:)) - min(img_cs(:)));
end