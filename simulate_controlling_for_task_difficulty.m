
% Simulation for the statistical control of subject-shared task difficulty on listener-speaker neural coupling

clear
clc
close all
% simulate the fluctuation of subject-shared task diffculty
fs = 200;
t = 0:1/fs:1;
diff_vec=sin(2*pi*10*t);

% the time course of speaker and listeners
spk= diff_vec + randn(size(t))/10;
L1 = spk + randn(size(t))/10;

%the mean listener
for k=1:60
    L2(k,:) = spk + randn(size(t))/10;
end
L2=mean(L2);
corr([L1',L2',spk'])
[a,b,rs]=regress(L1',L2');
corr(rs,spk')

figure 
subplot(3,2,1);
plot(t*100,diff_vec)
title('task difficulty');

subplot(3,2,2);
plot(t*100,L1);
title('listener 1');

subplot(3,2,3);
plot(t*100,L2);
title('mean listener');

subplot(3,2,4);
plot(t*100,spk)
title('speaker');

figure
subplot(2,2,1);
scatter(L1,L2)
title('listener-listener correlation')

subplot(2,2,2)
scatter(L2,spk)
title('listener-speaker neural coupling')

subplot(2,2,3)
plot(t*100,rs);
title('residule of listener1');

subplot(2,2,4)
scatter(rs,spk')
title('residual listener-speaker neural coupling');


