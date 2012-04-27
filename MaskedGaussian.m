function [mm mv] = MaskedGaussian(A, Mask)
sum = int32(0);
num = int32(0);
%mm = zeros(size(A,3));
for i = 1:size(A,3)
	B = A(:,:,i);
	C = B(find( Mask == 1 ));
	mm(i) = mean(C);
	mv(i) = var(C);
end
	% if Mask(i,j) > 0
		% sum = sum + int32(A(i,j,k));
		% num = num + int32(1);
	% end
% end
% sum
% for k = size(A,3)
	% sum = 0;
	% num = 0;
	% for j = 1:size(A,2),
		% for i = 1:size(A,1),
			% if Mask(i,j) > 0
				% sum = sum + int32(A(i,j,k));
				% num = num + int32(1);
			% end
		% end
	% end
	% mm(k) = double(sum) / double(num);	
	
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

