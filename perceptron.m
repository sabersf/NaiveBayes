clear;
load('Statistics.mat');
mean = Statistics(:,4);
fid = fopen('perceptronData.txt');
b = [];
tline = fgetl(fid);
%Input reading
while ischar(tline)
    %disp(tline);    
	ind = find(tline == '	');
	ind = [0 ind size(tline,2)+1];
	a = [];
	for i=1:size(ind, 2)-1
		a = cat(2, a, sscanf(tline(ind(i)+1:ind(i+1)-1), '%f'));
	end
	b = cat(1, b, a);
	tline = fgetl(fid);
end
fclose(fid);
clear a;
label = b(:,5:5);
b(:,5:5) = 1;
[rows,cols]=size(b);
display('Reading Input is now finished');
for i=1:rows
    if label(i) == -1
        b(i,:) = -1 * b(i,:);
    end
end
w = zeros(1,5);
w(:,5:5)=1;
update = 1;
iteration = 0;
while (update == 1)
    update = 0;
    err = 0;
    iteration = iteration + 1;
    for i=1:rows
        if (w * b(i,:)' <= 0)
            w = w + (b(i,:));
            err = err + 1;
            update = 1;
        end
    end
    str = fprintf('Iteration %d, total mistakes %d\n', iteration, err);
end
str = fprintf('Classifier weights: %f %f %f %f\n',w(1),w(2),w(3),w(4));
