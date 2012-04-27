imgIn= imread('images/toy.jpg');
imgTri = imread('images/trimap.png');
%save I;
subplot(4,3,1), imshow(imgIn);
subplot(4,3,2), imshow(imgTri);
%O = zeros(size(imgIn));
%for n = 1:size(imgTri),
%	if imgTri(n) < 15
%		O(n) = 1;
%	end
%end

% Foreground
FMask = imgTri > 242;
F = imgIn .* FMask;
[fMean fVar] = MaskedGaussian(imgIn, FMask)
subplot(4,3,4), imshow(FMask);
subplot(4,3,7), imshow(F);

% Background
BMask = imgTri < 13;
B = imgIn .* BMask;
[bMean bVar] = MaskedGaussian(imgIn, BMask)
subplot(4,3,5), imshow(BMask);
subplot(4,3,8), imshow(B);

% Undefined Region
UMask = not(or(FMask, BMask));
U = imgIn .* UMask;
subplot(4,3,6), imshow(UMask);
subplot(4,3,9), imshow(U);



