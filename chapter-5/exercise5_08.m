clc, clearvars, close all;

% A/A    Name           Description
% 1      Mass           Weight in kilograms
% 2      Fore           Maximum circumference of the forearm
% 3      Bicep          Maximum circumference of the bicep muscle
% 4      Chest          Circumference of the chest (measured at the level below the armpits)
% 5      Neck           Circumference of the neck (measured at the middle height of the neck)
% 6      Shoulder       Circumference of the shoulder
% 7      Waist          Circumference of the waist (lumbar area)
% 8      Height         Height from the top of the head to the soles of the feet
% 9      Calf           Maximum circumference of the calf
% 10     Thigh          Circumference of the thigh
% 11     Head           Circumference of the head

physicalData = load('physical.txt');
Y = physicalData(:,1);
X = physicalData(:,2:size(physicalData, 2));
X1 = [ones(size(X, 1), 1), X];
n = length(Y);
alpha = 0.05;
zcrit = norminv(1 - alpha / 2);

[B, BINT, R, RINT, STATS] = regress(Y, X1);
my = mean(Y);
sse = sum(R.^2);  % sum of squared errors
sst = sum((Y - my).^2);  % total sum of squares
R2 = STATS(1);  % alternatively: R2 = 1 - sse / sst;
rmse = sqrt(STATS(4));  % alternatively: rmse = sqrt(sse / (n - k - 1));
stdres = R / rmse;
k = size(X, 2);  % number of predictors in the model
adjR2 = 1 - (n - 1) / (n - (k + 1)) * sse / sst;
fprintf('========== Regression Model (all predictors) ==========\n');
fprintf('rmse = %.6f, R^2 = %.6f, adjR^2 = %.6f\n', rmse, R2, adjR2);
for i = 1:length(B)
    fprintf('b_%d = %.6f\n', i - 1, B(i));
end

figure;
scatter(Y, stdres, 10, 'k', 'filled');
hold on;
plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 2);
plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 2);
hold off;
title('Diagnostic Plot (Full Model)');
xlabel('Mass');
ylabel('Standard Residual');


[B, ~, ~, INMODEL, STATS] = stepwisefit(X, Y, 'display', 'off');  % or use stepwise for GUI
rmse = STATS.rmse;
b0 = STATS.intercept;
Ypred = X(:,INMODEL) * B(INMODEL) + b0;
stdres = (Y - Ypred) / rmse;
sse = sum((Y - Ypred).^2);
R2 = 1 - sse / sst;
k = sum(INMODEL);  % number of predictors in the model
adjR2 = 1 - (n - 1) / (n - (k + 1)) * sse / sst;
fprintf('\n========== Stepwise Regression Model ==========\n');
fprintf('rmse = %.6f, R^2 = %.6f, adjR^2 = %.6f\n', rmse, R2, adjR2);
fprintf('b_0 = %.6f\n', b0);
for i = 1:length(B)
    if INMODEL(i) == 1
        fprintf('b_%d = %.6f\n', i, B(i));
    end
end

figure;
scatter(Y, stdres, 10, 'k', 'filled');
hold on;
plot(xlim, zcrit * [1, 1], '--r', 'LineWidth', 2);
plot(xlim, -zcrit * [1, 1], '--r', 'LineWidth', 2);
hold off;
title('Diagnostic Plot (Stepwise Regression Model)');
xlabel('Mass');
ylabel('Standard Residual');


%% Exercise 5.8 - Mass and Physical Measurements for Male Subjects
datdir = 'C:\MyFiles\Teach\DataAnalysis\Data\';
dattxt = 'physical';
varnameM = str2mat('Mass','Fore','Bicep','Chest','Neck','Shoulder','Waist','Height','Calf','Thigh','Head');
alpha = 0.05;

datM = physicalData;
yV = datM(:,1);
xM = datM(:,2:end);
k = size(xM,2);
n = length(yV);
zcrit = norminv(1-alpha/2);

for i=1:k
    x1M = [ones(n,1) xM(:,i)];
    [b1V,b1int,stats1] = regress(yV,x1M);
    yhat1V = x1M * b1V;
    e1V = yV-yhat1V;
    se12 = (1/(n-2))*(sum(e1V.^2));
    se1 = sqrt(se12);
    my = mean(yV);
    R21 = 1-(sum(e1V.^2))/(sum((yV-my).^2));
    adjR21 =1-((n-1)/(n-2))*(sum(e1V.^2))/(sum((yV-my).^2));
    estar1V = e1V / se1;

    figure((i-1)*2+1)
    clf
    plot(xM(:,i),yV,'.')
    hold on
    plot(xM(:,i),yhat1V,'r')
    title(sprintf('x=%s, R^2=%1.5f adjR^2=%1.5f',deblank(varnameM(i+1,:)),R21,adjR21))
    
    figure(i*2)
    clf
    plot(yV,estar1V,'o')
    hold on
    ax = axis;
    plot([ax(1) ax(2)],[0 0],'k')
    plot([ax(1) ax(2)],zcrit*[1 1],'c--')
    plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
    xlabel('y')
    ylabel('e^*')
    title(sprintf('diagnostic plot, x=%s',deblank(varnameM(i+1,:))));
    pause;
end

my = mean(yV);
xregM = [ones(n,1) xM];
[ballV,ballint,rall,rallint,statsall] = regress(yV,xregM);
yhatallV = xregM * ballV;
eallV = yV-yhatallV;
seall2 = (1/(n-(k+1)))*(sum(eallV.^2));
seall = sqrt(seall2);
R2all = 1-(sum(eallV.^2))/(sum((yV-my).^2));
adjR2all =1-((n-1)/(n-(k+1)))*(sum(eallV.^2))/(sum((yV-my).^2));
estarallV = eallV / seall;

disp(['n = ',int2str(n)])
disp([' '])
fprintf('FULL MODEL: \n');
fprintf('x-variable \t beta \t estimate \t 95%% CI \n');
fprintf('const \t beta0 \t %2.5f \t [%2.5f,%2.5f] \n',ballV(1),ballint(1,1),ballint(1,2));
for i=2:k+1
    fprintf('%s \t beta%d \t %2.5f \t [%2.5f,%2.5f] \n',deblank(varnameM(i,:)),...
        i-1,ballV(i),ballint(i,1),ballint(i,2));
end
disp(['residual variance=',num2str(seall2)])
disp(['residual SD=',num2str(seall)])
fprintf('R^2 = %1.5f   adjR^2=%1.5f \n',R2all,adjR2all);

figure(k*2+1)
clf
% paperfigure
plot(yV,estarallV,'o')
hold on
ax = axis;
plot([ax(1) ax(2)],[0 0],'k')
plot([ax(1) ax(2)],zcrit*[1 1],'c--')
plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
xlabel('y')
ylabel('e^*')
title('diagnostic plot, full model');

[bV,sdbV,pvalV,inmodel,stats]=stepwisefit(xM,yV);
b0 = stats.intercept;
indxV = find(inmodel==1);
yhatV = xregM * ([b0;bV].*[1 inmodel]');
eV = yV-yhatV;
k1 = sum(inmodel);
se2 = (1/(n-(k1+1)))*(sum(eV.^2));
se = sqrt(se2);
R2 = 1-(sum(eV.^2))/(sum((yV-my).^2));
adjR2 =1-((n-1)/(n-(k1+1)))*(sum(eV.^2))/(sum((yV-my).^2));
estarV = eV / se;

disp([' '])
fprintf('MODEL FROM STEPWISE REGRESSION: \n');
fprintf('x-variable \t beta \t estimate \t 95%% CI \n');
fprintf('const \t beta0 \t %2.5f \n',b0);
tcrit = tinv(1-alpha/2,n-(k1+1));
for i=1:k1
    fprintf('%s \t beta%d \t %2.5f \t [%2.5f,%2.5f] \n',deblank(varnameM(indxV(i)+1,:)),...
        indxV(i),bV(indxV(i)),bV(indxV(i))-tcrit*sdbV(indxV(i)),...
        bV(indxV(i))+tcrit*sdbV(indxV(i)));
end
disp(['residual variance=',num2str(se2)])
disp(['residual SD=',num2str(se)])
fprintf('R^2 = %1.5f   adjR^2=%1.5f \n',R2,adjR2);
fprintf('\n');

figure((k+1)*2)
clf
% paperfigure
plot(yV,estarV,'o')
hold on
ax = axis;
plot([ax(1) ax(2)],[0 0],'k')
plot([ax(1) ax(2)],zcrit*[1 1],'c--')
plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
xlabel('y')
ylabel('e^*')
title('diagnostic plot, model from stepwise regression');


