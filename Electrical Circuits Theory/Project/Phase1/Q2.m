%% Q2
clear;clc;close all;
syms s Ia Ib ia ib;
A = [4*s+5, 4*s;
    4*s, 4*s+15];
S = [10/s;20/s];
res = linsolve(A,S);
Ia = res(1)
Ib = res(2)

ia = ilaplace(Ia)
ib = ilaplace(Ib)