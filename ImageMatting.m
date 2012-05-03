clear;
startTime = cputime;

%set the output image format
imgRows = 2;
imgCols = 3;
cPos = 1; triPos = 2; aPos = 3;
fmPos = 4; bmPos = 5; umPos = 6;
fiPos = 4; biPos = 5; uiPos = 6;
fPos = 4; bPos = 5; compositePos = 6;


C= double(imread('images/toy.jpg'))/double(255.0); % Observed image
trimap = double(imread('images/trimap.png'))/double(255.0); %Trimap
%save I;
subplot(imgRows, imgCols,cPos), imshow(C);
subplot(imgRows, imgCols,triPos), imshow(trimap);

sigmac = .01;
sigmac2 = sigmac*sigmac;


FMask = trimap > .95;
subplot(imgRows, imgCols,fmPos), imshow(FMask);
BMask = trimap < .05;
subplot(imgRows, imgCols,bmPos), imshow(BMask);

F = C .* FMask;
B = C .* BMask;
subplot(imgRows, imgCols,fiPos), imshow(F);
subplot(imgRows, imgCols,biPos), imshow(B);

% unknown region
UMask = not(or(FMask, BMask));
U = C .* UMask;
subplot(imgRows, imgCols,umPos), imshow(UMask);
subplot(imgRows, imgCols,uiPos), imshow(U);

% Foreground mean and covariance
[fMean fCovInv] = MaskedGaussian(C, FMask);

% Background mean and cov
[bMean bCovInv] = MaskedGaussian(C, BMask);

Isig = double(eye(3))/sigmac2
alpha = FMask + UMask*.5;

sol1a = double(fCovInv*fMean);
sol2a = double(bCovInv*bMean);

for k = 1:10
	for i = 1:size(alpha,1)
		for j = 1:size(alpha,2)
			if(UMask(i,j))
				al = alpha(i,j);
				c = squeeze(C(i,j,:));

				map11 = fCovInv + Isig*(al^2);
				map12 = Isig*al*(1-al);
				map22 = bCovInv + Isig*((1-al)^2);
				MAP = [map11 map12; map12 map22];
				
				sol1 = sol1a + double(c)*al/sigmac2;
				sol2 = sol2a + double(c)*(1-al)/sigmac2;
				SOL = [sol1; sol2];
				
				T = MAP\SOL;
				f = T(1:3);
				F(i,j,:) = f;
				b = T(4:6);
				B(i,j,:) = b;
				
				CB = c - b;
				FB = f - b;
				T = double(dot(CB,FB,1));
				mag = norm(FB);
				alpha(i,j) = max(min(T/(mag^2),1),-1);
			end
		end
	end
end
subplot(imgRows, imgCols, aPos), imshow(alpha);
subplot(imgRows, imgCols, fPos), imshow(F.*(alpha));
subplot(imgRows, imgCols, bPos), imshow(B.*(1-alpha));

%Put the foreground over the new background image
nback = double(imread('images/bookshelf.jpg'))/double(255.0);
subplot(imgRows, imgCols, compositePos), imshow(F.*(alpha) + nback.*(1-alpha));

totalTime = cputime - startTime
