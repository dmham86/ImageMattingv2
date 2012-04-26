function [mm mv] = MaskedGaussian(A, Mask)
sum = int32(0);
num = int32(0);
for n = 1:size(A),
	if Mask(n) > 0
		sum = sum + int32(A(n));
		num = num + int32(1);
	end
end
mm = double(sum) / double(num);
mv = double(0);
for n = 1:size(A),
	if Mask(n) > 0
		mv = mv + (mm - double(A(n)))^2;
	end
end