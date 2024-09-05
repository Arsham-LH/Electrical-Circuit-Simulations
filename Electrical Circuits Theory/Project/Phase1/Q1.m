% dar tamame section haye soalate proje, _a be maanaye bakhshe alef , _b be maanaye
% bakhshe b ,... mibashad.

%% Q1_b
clear;clc;close all;
a=[11200 0];
b=[5.6 11200 10^6];
H=tf(a,b);
subplot(2,2,1);
bode(H);
grid on;


w=logspace(-1,6,4000);
h=freqs(a,b,w);
mag = abs(h);
phase = angle(h)*180/pi;
subplot(2,2,2);
loglog(w,mag);
grid on;
xlabel('Frequency (rad/s)');
ylabel('Magnitude');

subplot(2,2,4);
semilogx(w,phase);
grid on;
xlabel('Frequency (rad/s)');
ylabel('Phase(degrees)');


%% Q1_c
clear;clc;close all;
a2=[112 0];
b2=[5.6 112 10^6];
H2=tf(a2,b2);
subplot(2,2,1);
bode(H2,{0.1,10^6});
grid on;


w=logspace(-1,6,4000);
h2=freqs(a2,b2,w);
mag = abs(h2);
phase = angle(h2)*180/pi;
subplot(2,2,2);
loglog(w,mag);
grid on;
xlabel('Frequency (rad/s)');
ylabel('Magnitude');

subplot(2,2,4);
semilogx(w,phase);
grid on;
xlabel('Frequency (rad/s)');
ylabel('Phase(degrees)');

%% Q1_d
clear;clc;close all;

a=[11200 0];
b=[5.6 11200 10^6];
H=tf(a,b);
subplot(2,1,1);
pzmap(H);
grid on;

a2=[112 0];
b2=[5.6 112 10^6];
H2=tf(a2,b2);
subplot(2,1,2);
pzmap(H2);
grid on;

