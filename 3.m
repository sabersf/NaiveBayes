clear all
filename = input('Open file: ', 's');
load('Statistics.mat');
mean1 = Statistics(:,4);
minmean = min(mean1);
maxmean = max(mean1);
meanmean = mean(mean1);
min = Statistics(:,2);
max = Statistics(:,3);
fid = fopen(filename);
b =[];
tline = fgetl(fid);
while ischar(tline)
    %disp(tline);    
	ind = find(tline == ',');
	ind = [0 ind size(tline,2)+1];
	a =[];
	for i=1:size(ind, 2)-1
		a = cat(2, a, sscanf(tline(ind(i)+1:ind(i+1)-1), '%f'));
	end
	b = cat(1, b, a);
	tline = fgetl(fid);
end
fclose(fid);
clear a;
label = b(:,58:58);
b(:,58:58)=[];
Class1 = b(find(label==1),:);
Class2 = b(find(label==0),:);

kf = 10;
for k=0:(kf-1)
    Cl1 = Class1(k*(size(Class1)/kf)+1:((k+1)*(size(Class1)/kf)),:);
    Cl2 = Class2(k*(size(Class2)/kf)+1:((k+1)*(size(Class2)/kf)),:);
    for i=1:57
        pn = find(Cl1(:,i)<=mean(i));
        pr1_1(i) = size(pn)/size(Cl1);

        pn = find(Cl1(:,i)>mean(i));
        pr1_2(i) = size(pn)/size(Cl1);

        pn = find(Cl2(:,i)<=mean(i));
        pr2_1(i) = size(pn)/size(Cl2);

        pn = find(Cl2(:,i)>mean(i));
        pr2_2(i) = size(pn)/size(Cl2);
    end
    for i=1:size(b)
        p1 = 0;
        p2 = 0;
        for j=1:57
            if b(i,j) <= mean(j)
                p1 = p1 + log(pr1_1(j));
            else
                p1 = p1 + log(pr1_2(j));
            end

            if b(i,j) <= mean(j)
                p2 = p2 + log(pr2_1(j));
            else
                p2 = p2 + log(pr2_2(j));
            end       
        end
        if ( (p1 > p2) )
            newlabel(i) = 1;
        else
            newlabel(i) = 0;
        end
    end
    display(k)
    size(find(newlabel' == label))/size(b)
    'TP'
    TP(k+1) = size( find(newlabel' == 1 & newlabel' == label ) ) / ( size( find(newlabel' == label) ) );
    'FP'
    FP(k+1) = size( find(newlabel' == 1 &  label == 0) ) / ( size( find(newlabel' == label) ) )
end
 TP = zeros(1,kf); TN = zeros(1,kf); FN = zeros(1,kf); FP = zeros(1,kf);
 Tag = [];
 for i=1:size(label)
    k = mod(i * 1,kf);
    if k == 0
        k = kf;
    end
     if (label(i) == 0) && (newlabel(i) ==0)
         TP(k) = TP(k) + 1;
     end
     if (label(i) == 0) && (newlabel(i) ==1)
         FP(k) = FP(k) + 1;
     end
     if (label(i) == 1) && (newlabel(i) ==1)
         TN(k) = TN(k) + 1;
     end
     if (label(i) == 1) && (newlabel(i) ==0)
         FN(k) = FN(k) + 1;   
     end
 end
for j=1:kf
    FNR(j) = FN(j) / (FN(j) + TP(j));
    TPR(j) = TP(j) / (TP(j) + FN(j));
    FPR(j) = FP(j) / (FP(j) + TN(j));
    overall(j) = (FN(j) + FP(j)) / ( FN(j) + FP(j) + TP(j) + TN(j));
end

FPR
FNR
overall
plot(TP,FP)
axis([0 1 0 1]);
