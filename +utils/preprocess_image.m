function img_out = preprocess_image(img)

    % Normalize to 0–1
    img = (img - min(img(:))) / (max(img(:)) - min(img(:)));
    
    % Resize to fixed size
    img_out = imresize(img, [256 256]);
    
end