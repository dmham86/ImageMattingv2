function [mm McInv LX] = MaskedGaussian(A, Mask)
summ = int32(0);
num = int32(0);
%mm = zeros(size(A,3));
B = A(find( Mask == 1 ));
mm = mean(B);
V = double(A)-mm;
clear B;
V = V*(V.');
Mc = V/size(V(:),1);

%need the inverse of Mc
McInv = inv(Mc);
clear Mc;

% Find prior probability L(X)
XDiff = double(A.*Mask - mm);
%size(XDiff)
%size(McInv)
T = -XDiff.' * McInv;
%size(T)
LX = T * XDiff / 2;
%size(LX)


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

