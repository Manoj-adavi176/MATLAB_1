function out = apply_ai_gated(img, net)

% Resize to model size
img_up = imresize(img,[256 256]);

% Predict residual
res = predict(net, reshape(img_up,[256 256 1 1]));
pred = img_up + squeeze(res);

% Normalize
img_up = (img_up - min(img_up(:))) / (max(img_up(:)) - min(img_up(:)) + eps);
pred   = (pred   - min(pred(:)))   / (max(pred(:))   - min(pred(:)) + eps);

% Gating
diff_energy = mean((pred(:) - img_up(:)).^2);

if diff_energy > 0.003
    out = img_up;
else
    out = pred;
end

% Normalize output
out = (out - min(out(:))) / (max(out(:)) - min(out(:)) + eps);

end