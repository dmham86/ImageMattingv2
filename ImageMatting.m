clear;
C= imread('images/toy.jpg'); % Observed image
trimap = double(imread('images/trimap.png'))/double(255.0); %Trimap
%save I;
subplot(4,3,1), imshow(C);
subplot(4,3,2), imshow(trimap);
%O = zeros(size(imgIn));
%for n = 1:size(imgTri),
%	if imgTri(n) < 15
%		O(n) = 1;
%	end
%end
% initialize sigmac to .01
sigmac = .01;
sigmac2 = sigmac*sigmac;


FMask = trimap > .95;
subplot(4,3,4), imshow(FMask);
BMask = trimap < .05;
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
% LT = abs(double(C) - alpha.*double(F) - (1-alpha).*double(B));
% LCFBa = -((LT(:,:,1).')*LT(:,:,1))/(sigmac);
% LCFBaT = -((LT(:,:,2).')*LT(:,:,2))/(sigmac);
% LCFBa = cat(3, LCFBa, LCFBaT);
% LCFBaT = -((LT(:,:,3).')*LT(:,:,3))/(sigmac);
% LCFBa = cat(3, LCFBa, LCFBaT);
% 'LCFBa'
% size(LCFBa)
%imshow(-LCFBa);

% Foreground
[fMean fCovInv] = MaskedGaussian(C, FMask)

% Background
[bMean bCovInv] = MaskedGaussian(C, BMask)


I = eye(3);
alpha = UMask*.5;

for i = 1:size(alpha,1)
	for j = 1:size(alpha,2)
		if(UMask(i,j))
			al = alpha(i,j);
			c = squeeze(C(i,j,:));
			map11 = fCovInv + I*(al^2/sigmac2);
			map12 = I*al*(1-al)/sigmac2;
			map22 = bCovInv + I*((1-al)^2/sigmac2);
			MAP = [map11 map12; map12 map22];
			
			sol1 = double(fCovInv*fMean);
			sol1 = sol1 + double(c)*al/sigmac2;
			sol2 = double(bCovInv*bMean);
			sol2 = sol2 + double(c)*(1-al)/sigmac2;
			SOL = [sol1; sol2];
			
			T = MAP\SOL;
			f = uint8(T(1:3));
			b = uint8(T(4:6));
			
			CF = c - f;
			CB = c - b;
			T = double(dot(CF,CB,1))
			
			mag = norm(double(f-b))
			alpha(i,j) = T/mag^2;
		end
	end
end



%calculate alpha
% subplot(4,3,12), imshow(C - F);
subplot(4,3,12), imshow(alpha)
subplot(4,3,10), imshow(F);
subplot(4,3,11), imshow(B);

pause

subplot(4,3,10), imshow(C-F);
subplot(4,3,11), imshow(C-B);

pause

subplot(4,3,10), imshow(F.*alpha);
subplot(4,3,11), imshow(B.*alpha);
% cd Documents/Classes/CISC-849/ImageMatting
