imgIn = imread('images/toy.jpg');
imgTri = imread('images/trimap.png');
%save I;
subplot(2,2,1), imshow(imgIn);
subplot(2,2,2), imshow(imgTri);
%O = zeros(size(imgIn));
%for n = 1:size(imgTri),
%	if imgTri(n) < 15
%		O(n) = 1;
%	end
%end
BMask = imgTri < 15;
B = imgIn .* BMask;
subplot(2,2,3), imshow(B);
FMask = imgTri > 240;
F = imgIn .* FMask;
subplot(2,2,4), imshow(F);
UMask = not(or(FMask, BMask));
subplot(2,2,2), imshow(UMask);

[bmean bVar] = MaskedGaussian(imgIn, BMask)
[fmean fVar] = MaskedGaussian(imgIn, FMask)