%% Q4_a
clear;clc;close all;

syms s Vs;
A = [1 0 0;
    0 3 -1;
    6 0 -1];
B = [Vs*10^4/(1.05*s+10^4) ; 0 ; 0];

V = linsolve(A,B);
V2=V(2);
Hs = V2/Vs



a=[4*10^5];
b=[21 2*10^5];
H=tf(a,b);
bode(H);
grid on;