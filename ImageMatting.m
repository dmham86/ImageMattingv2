clear;
C= imread('images/toy.jpg'); % Observed image
alpha = double(imread('images/trimap.png'))/double(255.0); %Trimap
%save I;
subplot(4,3,1), imshow(C);
subplot(4,3,2), imshow(alpha);
%O = zeros(size(imgIn));
%for n = 1:size(imgTri),
%	if imgTri(n) < 15
%		O(n) = 1;
%	end
%end
% initialize sigmac to .01
sigmac = .01;
sigmac2 = sigmac*sigmac;


FMask = alpha > .95;
subplot(4,3,4), imshow(FMask);
BMask = alpha < .05;
subplot(4,3,5), imshow(BMask);

F = C .* FMask;
B = C .* BMask;
subplot(4,3,7), imshow(F);
subplot(4,3,8), imshow(B);

% TODO: Remove the 4 lines below if not drawing the unknown region
UMask = not(or(FMask, BMask));
U = C .* UMask;
subplot(4,3,6), imshow(UMask);
subplot(4,3,9), imshow(U);

%calculate L(C|F,B,alpha)
LT = abs(double(C) - alpha.*double(F) - (1-alpha).*double(B));
LCFBa = -((LT(:,:,1).')*LT(:,:,1))/(sigmac);
LCFBaT = -((LT(:,:,2).')*LT(:,:,2))/(sigmac);
LCFBa = cat(3, LCFBa, LCFBaT);
LCFBaT = -((LT(:,:,3).')*LT(:,:,3))/(sigmac);
LCFBa = cat(3, LCFBa, LCFBaT);
'LCFBa'
size(LCFBa)
%imshow(-LCFBa);

% Foreground
[fMean fCovInv LF] = MaskedGaussian(C(:,:,1), alpha);
[fMean covX LX] = MaskedGaussian(C(:,:,2), alpha);
LF = cat(3, LF, LX);
fCovInv = cat(3, fCovInv, covX);
[fMean covX LX] = MaskedGaussian(C(:,:,3), alpha);
LF = cat(3, LF, LX);
fCovInv = cat(3, fCovInv, covX);
'LF'
%size(LF)
%size(fCovInv)

% Background
[bMean bCovInv LB] = MaskedGaussian(C(:,:,1), 1-alpha);
[xMean covX    LX] = MaskedGaussian(C(:,:,2), 1-alpha);
LB = cat(3, LB, LX);
bCovInv = cat(3, bCovInv, covX);
bMean = cat(3, bMean, xMean);
[xMean covX    LX] = MaskedGaussian(C(:,:,3), 1-alpha);
LB = cat(3, LB, LX);
bCovInv = cat(3, bCovInv, covX); 
bMean = cat(3, bMean, xMean);

subplot(4,3,10), imshow(LF);
subplot(4,3,11), imshow(LB);

% try to clear some memory
clear LX covX xMean

FBaC = LCFBa - LF - LB;

I = eye(3);
%alpha = cat(3, alpha, alpha, alpha);

for i = 1:size(alpha,1)
	for j = 1:size(alpha,2)
		al = alpha(i,j);
		map11 = fCovInv(i,j,:)(:) + I*(al^2/sigmac2);
		map12 = I*al*(1-al)/sigmac2;
		map22 = bCovInv(i,j,:) + I*(1-al)^2/sigmac2;
		MAP = [map11 map12; map12 map22]
		pause
		
		sol1 = fCovInv(i,j,:)(:)*fMean + C(i,j,:)(:)*al/sigmac2;
		sol2 = fCovInv(i,j,:)(:)*bMean + C(i,j,:)(:)*al/sigmac2;
		
		
	end
end



%calculate alpha
% subplot(4,3,12), imshow(C - F);
 T = double(dot((C - F),(C - B),1));
 size(T)
 T = sum(T,2)
 mag = abs(F-B);
 mag = mag.*mag;
 alpha = double(double(mag(:,:,2)) * 1/mag(1));
 
 subplot(4,3,12), imshow(alpha)

% cd Documents/Classes/CISC-849/ImageMatting
