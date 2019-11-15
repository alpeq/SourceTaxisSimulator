function [ zeros ] = count_decimals(x)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
x = abs(x); %in case of negative numbers
n=0
while (floor(x*10^n)~=x*10^n)
    n=n+1
end

zeros = n;

end

