function filter = binomialFilter1D( filterSize )
% Find the binomical filter of 1-Dim by convolution [1,1]

filter = [1,1];
for i = 1 : filterSize - 2
    filter = conv(filter, [1,1]);
end
sumOfFilter = sum(filter);
filter = filter./sumOfFilter;

end

