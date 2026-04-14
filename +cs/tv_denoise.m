function u = tv_denoise(f, lambda)

    niter = 20;
    [nx, ny] = size(f);
    
    p = zeros(nx, ny, 2);
    tau = 0.25;
    
    for i = 1:niter
        
        % Divergence
        div = [diff(p(:,:,1),1,1); zeros(1,ny)] + ...
              [diff(p(:,:,2),1,2), zeros(nx,1)];
        
        u = f - lambda * div;
        
        % Gradient
        [ux, uy] = gradient(u);
        
        % Update
        p(:,:,1) = (p(:,:,1) + tau*ux) ./ (1 + tau*abs(ux)/lambda);
        p(:,:,2) = (p(:,:,2) + tau*uy) ./ (1 + tau*abs(uy)/lambda);
    end
end