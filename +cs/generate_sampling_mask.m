function mask = generate_sampling_mask(sz, accelFactor)

    rows = sz(1);
    cols = sz(2);
    
    mask = zeros(rows, cols);
    
    % Fully sample center (important in MRI)
    center = round(rows * 0.1);
    cStart = floor(rows/2) - floor(center/2);
    cEnd = cStart + center;
    
    mask(cStart:cEnd, cStart:cEnd) = 1;
    
    % Random sampling outside center
    prob = 1/accelFactor;
    random_mask = rand(rows, cols) < prob;
    
    mask = mask | random_mask;
end