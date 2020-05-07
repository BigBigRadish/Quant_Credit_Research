function [] = compare(matH,matF)
% compare:compares values of 3-D and 2-D matrices of equal dimensions
%   by construction...
%   yield bins are along the 1st dimension.
%   spread bins are along the 2nd dimension.
%   duration bins are along the 3rd dimension.

%% 3-D bin weights comparison

% process matH to add subtotals
% assuming matH has dimensions binNum1xbinNum2xbinNum3 = 10x10x10
% the processed matH will have dimensions 11x11x10
% get totals accross 1st dimension to obtain 2-D surface
% with subtotals across yield and duration bins
% surface has dimensions binNum1x1xbinNum3
sum_y = sum(matF,2);
% get totals accross 2nd dimension to obtaion 2-D surface
% with subtotals across spread and duration bins
% surface has dimensions 1xbinNum2xbinNum3
sum_s = sum(matF,1);
% get totals across 1st and 2nd dimension to obtaion 1-D vector
% with subtotals across duration bins
% vector has dimensions 1x1xbinNum3
sum_d = sum(sum(matF,2),1);
% add vertical surface to right side of cube
% cube will have dimensions binNum1x(binNum2+1)xbinNum3
matFt = [matF sum_y];
% add flat surface to bottom of cube
% cube will have dimensions (binNum1+1)x(binNum2+1)xbinNum3
matFt = [matFt;[sum_s sum_d]];


binNum = size(matH);

% process matF to add subtotals in same manner as matH was processed above
sum_y = sum(matH,2);
sum_s = sum(matH,1);
sum_d = sum(sum(matH,2),1);
matHt = [matH sum_y];
matHt = [matHt;[sum_s sum_d]];

% create a 3rd cube with the porcentage weight of matF relative to matH
matPct = (matFt-matHt)./matHt*100;
matPct(isnan(matPct))=0;
matPct(isinf(matPct))=0;

% create axis labels for graphs
% label for 1st dimension
lbl_1='{';
for i=1:binNum(1)
   lbl_1 = [lbl_1,'''',num2str(i),''','];
end
lbl_1 = [lbl_1,'''Tot''}'];
lbl_1 = cellstr(eval(lbl_1)');

% label for 2nd dimension
lbl_2='{';
for i=1:binNum(2)
   lbl_2 = [lbl_2,'''',num2str(i),''','];
end
lbl_2 = [lbl_2,'''Tot''}'];
lbl_2 = cellstr(eval(lbl_2)');

% label for 3rd dimension
lbl_3='{';
for i=1:binNum(3)
   lbl_3 = [lbl_3,'''',num2str(i),''','];
end
lbl_3 = [lbl_3,'''Tot''}'];
lbl_3 = cellstr(eval(lbl_3)');


%figure(1)
% this figure contains the portfolio weights in the 2 dimensional (STW,YTW)
% bin bucket, where each subplot will correspond to a particular duration
% bin.
% this figure will display the weights for each (STW,YTW) pair for half of
% the duration buckets.
% the top subplot rows will show the % weight difference between the
% constructed portfolio and the original portfolio
figure('Name',['DTW 1-',num2str(ceil(binNum(2)/2))],'NumberTitle','off') 
for i=1:ceil(binNum(3)/2)

    subplot(2,ceil(binNum(3)/2),i);
    heatmap(matPct(:,:,i),lbl_2,lbl_1,'%.0f','Colormap','money');
    xlabel('x axis - STW');
    ylabel('YTW');
    title(strcat('% Diff - DTW - ',num2str(i)));    


end
% the top subplot rows will show the weight for the original portfolio
for i=1:ceil(binNum(3)/2)

    subplot(2,ceil(binNum(3)/2),ceil(binNum(3)/2)+i);
    heatmap(matHt(:,:,i),lbl_2,lbl_1,'%.1f','Colormap','money');
    xlabel('x axis - STW');
    ylabel('YTW');
    title(strcat('Orig Val - DTW - ',num2str(i)));    

end

%figure(2)
% similar as figure(1), but the subplots will correspond the the second
% half duration bins.
figure('Name',['DTW ',num2str(ceil(binNum(2)/2)+1),' - ',num2str(binNum(2))],'NumberTitle','off') 

for i=1:floor(binNum(3)/2)

    subplot(2,ceil(binNum(3)/2),i);
    heatmap(matPct(:,:,i+ceil(binNum(3)/2)),lbl_2,lbl_1,'%.1f','Colormap','money');
    xlabel('x axis - STW');
    ylabel('YTW');
    title(strcat('% Diff - DTW - ',num2str(i+ceil(binNum(2)/2))));    


end

for i=1:floor(binNum(3)/2)

    subplot(2,ceil(binNum(3)/2),ceil(binNum(3)/2)+i);
    heatmap(matHt(:,:,i+ceil(binNum(2)/2)),lbl_2,lbl_1,'%.2f','Colormap','money');
    xlabel('x axis - STW');
    ylabel('YTW');
    title(strcat('Orig Val - DTW - ',num2str(i+ceil(binNum(2)/2))));    

end

%% 2-D bin weight comparison

% yield against duration
% get a surface with dimensions binNum1x1xbinNum3 (ytw X 1 X DTW
nmF = sum(matF,2);
% permute matrix to have surface with dimension binNum1xbinNum2
nmF = permute(nmF,[1 3 2]);
% get totals across 1st dimension to have vector 1xbinNum2
% with STW bin weight subtotals
sum_r = sum(nmF,1);
% get totals across 2nd dimension to have vector binNum1x1
% with YTW bin weight subtotals
sum_c = sum(nmF,2);
% get total portfolio weight
sum_t = sum(sum(nmF));
% add vertical vector to right side of matrix
nmFt = [nmF sum_c];
% add horizontal vector and portfolio weight total to bottom of matrix
nmFt = [nmFt;[sum_r sum_t]];

nmH = sum(matH,2);
nmH = permute(nmH,[1 3 2]);
sum_r = sum(nmH,1);
sum_c = sum(nmH,2);
sum_t = sum(sum(nmH));
nmHt = [nmH sum_c];
nmHt = [nmHt;[sum_r sum_t]];

nmPct = (nmFt-nmHt)./nmHt*100;
nmPct(isnan(nmPct))=0;

%figure(3)
figure('Name','2D - Comparison','NumberTitle','off') 
subplot(2,3,1)
heatmap(nmPct,lbl_3,lbl_1,'%.1f','Colormap','money');
title('% Diff - Yield Vs. Duration')
xlabel('x-axis - Duration')
ylabel('Yield')

subplot(2,3,4)
heatmap(nmHt,lbl_3,lbl_1,'%.1f','Colormap','money');
title('Orig Val - Yield Vs. Duration')
xlabel('x-axis - Duration')
ylabel('Yield')


% yield against stw

nmF = sum(matF,3);
nmF = permute(nmF,[1 2 3]);
sum_r = sum(nmF,1);
sum_c = sum(nmF,2);
sum_t = sum(sum(nmF));
nmFt = [nmF sum_c];
nmFt = [nmFt;[sum_r sum_t]];

nmH = sum(matH,3);
nmH = permute(nmH,[1 2 3]);
sum_r = sum(nmH,1);
sum_c = sum(nmH,2);
sum_t = sum(sum(nmH));
nmHt = [nmH sum_c];
nmHt = [nmHt;[sum_r sum_t]];

nmPct = (nmFt-nmHt)./nmHt*100;
nmPct(isnan(nmPct))=0;

subplot(2,3,2)
heatmap(nmPct,lbl_2,lbl_1,'%.1f','Colormap','money');
title('% Diff - Yield Vs. Spread')
xlabel('x-axis - Spread')
ylabel('Yield')

subplot(2,3,5)
heatmap(nmHt,lbl_2,lbl_1,'%.1f','Colormap','money');
title('Orig Val - Yield Vs. Spread')
xlabel('x-axis - Spread')
ylabel('Yield')


% stw against duration

nmF = sum(matF,1);
nmF = permute(nmF,[2 3 1]);
sum_r = sum(nmF,1);
sum_c = sum(nmF,2);
sum_t = sum(sum(nmF));
nmFt = [nmF sum_c];
nmFt = [nmFt;[sum_r sum_t]];

nmH = sum(matH,1);
nmH = permute(nmH,[2 3 1]);
sum_r = sum(nmH,1);
sum_c = sum(nmH,2);
sum_t = sum(sum(nmH));
nmHt = [nmH sum_c];
nmHt = [nmHt;[sum_r sum_t]];

nmPct = (nmFt-nmHt)./nmHt*100;
nmPct(isnan(nmPct))=0;
nmPct(isinf(nmPct))=0;

subplot(2,3,3)
heatmap(nmPct,lbl_3,lbl_2,'%.1f','Colormap','money');
title('% Diff - Spread Vs. Duration')
xlabel('x-axis - Duration')
ylabel('Spread')

subplot(2,3,6)
heatmap(nmHt,lbl_3,lbl_2,'%.1f','Colormap','money');
title('Orig Val - Spread Vs. Duration')
xlabel('x-axis - Duration')
ylabel('Spread')



end
