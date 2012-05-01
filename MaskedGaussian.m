function [Mean CovInv] = MaskedGaussian(A, Mask)
Mean = [0 0 0];
IND = find( Mask == 1 )(:);
size(IND)
for i = 1:size(A,3)
	B = A(:,:,i)(IND);
	Mean(i) = double(mean(B));
end
Mean = Mean.'

%for k = 1:size(A,3)
Cov=zeros(size(A,3));
for i = 1:size(A,1)
	for j = 1:size(A,2)
		if(Mask(i,j) > 0)
			Diff = double(A(i,j,:)(:)) - Mean;
			Cov = Cov + Diff * Diff.';
		end
	end
end
Cov = Cov * 1/(size(A,1)*size(A,2));
%need the inverse of Mc
CovInv = inv(Cov);

% Find prior probability L(X)
% XDiff = double(A.*Mask - mm);
% size(XDiff)
% size(McInv)
% T = -XDiff.' * McInv;
% size(T)
% LX = T * XDiff / 2;
%size(LX)

% [fMean fCovInv LF] = MaskedGaussian(C(:,:,1), alpha);
% [fMean covX LX] = MaskedGaussian(C(:,:,2), alpha);
% LF = cat(3, LF, LX);
% fCovInv = cat(3, fCovInv, covX);
% [fMean covX LX] = MaskedGaussian(C(:,:,3), alpha);
% LF = cat(3, LF, LX);
% fCovInv = cat(3, fCovInv, covX);

	% if Mask(i,j) > 0
		% summ = summ + int32(A(i,j,k));
		% num = num + int32(1);
	% end
% end
% summ
% for k = size(A,3)
	% summ = 0;
	% num = 0;
	% for j = 1:size(A,2),
		% for i = 1:size(A,1),
			% if Mask(i,j) > 0
				% summ = summ + int32(A(i,j,k));
				% num = num + int32(1);
			% end
		% end
	% end
	% mm(k) = double(summ) / double(num);	
	
	% mv(k) = double(0);
	% for j = 1:size(A,2),
		% for i = 1:size(A,1),
			% if Mask(i,j) > 0
				% mv(k) = mv(k) + double((mm(k) - double(A(i,j,k)))^2);
			% end
		% end
	% end
	% mv(k) = mv(k) / double(num);	
% end

