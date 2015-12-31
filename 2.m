%filename = input('Open file: ', 's');
clear all
load('Statistics.mat')
load rocdata
%fid = fopen(filename);
fid = fopen('spambase.data');
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
    Mean1 = mean(Cl1);
    Mean2 = mean(Cl2);
    Cov1 = cov(Cl1);
    Cov2 = cov(Cl2);
    Predict = [];
    for i=1:size(b,1)
    %for i=1:3
       G1 = Discriminant_Function1(b(i,:), Mean1, Cov1);
       G2 = Discriminant_Function1(b(i,:), Mean2, Cov2);
       if (G1 > G2)
           Predict = cat(1, Predict, 1);
       else
           Predict = cat(1, Predict, 0);       
       end
    end
    per = find(Predict==label);
    100*(size(per,1)/size(b,1))
end


 TP = zeros(1,kf); TN = zeros(1,kf); FN = zeros(1,kf); FP = zeros(1,kf);
 Tag = [];
 for i=1:size(label)
    k = mod(i * 1,kf);
    if k == 0
        k = kf;
    end
     if (label(i) == 0) && (Predict(i) ==0)
         Tag(i) = 0;
         TP(k) = TP(k) + 1;
     end
     if (label(i) == 0) && (Predict(i) ==1)
         FP(k) = FP(k) + 1;
         Tag(i) = 1;
     end
     if (label(i) == 1) && (Predict(i) ==1)
         TN(k) = TN(k) + 1;
         Tag(i) = 0;
     end
     if (label(i) == 1) && (Predict(i) ==0)
         FN(k) = FN(k) + 1;   
         Tag(i) = 1;
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
result = [Predict', Tag'];
%roc(result,5);
