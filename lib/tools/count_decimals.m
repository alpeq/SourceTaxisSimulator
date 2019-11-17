function [ zeros ] = count_decimals(x)
%COUNT_DECIMALS Counts the decimals of the number
%   It counts the number of zeros to round at that number
x = abs(x); %in case of negative numbers
n=0;
while (floor(x*10^n)~=x*10^n)
    n=n+1;
end

zeros = n;

end

