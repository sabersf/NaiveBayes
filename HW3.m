load('Statistics.mat');
mean = Statistics(:,4);
fid = fopen('spambase.data');
b = [];
tline = fgetl(fid);
%Input reading
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
a = [] ; fold = [];
label = b(:,58:58);
b(:,58:58)=[];
[rows,cols]=size(b);
display('Reading Input is now finished');
%normalization
St = zeros(1,57);
Mu = zeros(1,57);
for i=1:57
    Mu(i) = mean(i);
    St(i) = std(b(:,i));
end
% a is normal 
for i=1:rows
    for j=1:cols
        a(i,j) = (b(i,j) - Mu(j))/St(j);
    end
end
%Folding
temp = 1;
for i=1:10:cols 
    for j=1:rows
        fold(j,temp) = a(j,i);
    end
    temp = temp + 1;
end
Class1 = b(find(label==1),:);
Class2 = b(find(label==0),:);
