function [Mean CovInv] = MaskedGaussian(A, Mask)
Mean = [0 0 0];
IND = find( Mask == 1 )(:);
size(IND);
for i = 1:size(A,3)
	B = A(:,:,i)(IND);
	Mean(i) = double(mean(B));
end
Mean = Mean.';

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
Cov = Cov * 1/size(IND,1);
%need the inverse of Mc
CovInv = inv(Cov);
