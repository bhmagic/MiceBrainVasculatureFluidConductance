function [integrated] = shereical_integral(input_tensor)


fibo = load('fibo_cordinate.mat');

integrated = input_tensor*fibo.fibo_cordinate';
integrated = integrated.*integrated;
integrated = sqrt(sum(integrated,1));
integrated = mean(integrated,2);


