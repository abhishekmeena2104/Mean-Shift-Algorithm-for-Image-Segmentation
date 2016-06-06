
% ABHISHEK MEENA
% Department of Electrical Engineering
% IIT KANPUR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all

% Gaussian Kernel is taken

%%
% VARIABLE PARAMETERS CHANGE TO GET DIFFERENT RESULTS
hs = 8; %spatial bandwidth
hr= 7;   % range bandwidth
threshold_convergence_mean = 0.25;
bandwidth=[hs,hr];
%%
i=imread('42049.jpg');
[height,width,frame] = size(i);
x=zeros(5,height*width);
%% Going from RGB space to Luv using the function RGB2LUV
for j=1:height
    for l=1:width
        x(1,l+width*(j-1)) = j;
        x(2,l+width*(j-1)) = l;
        [x(3,l+width*(j-1)),x(4,l+width*(j-1)),x(5,l+width*(j-1))] = RGB2LUV(i(j,l,1),i(j,l,2),i(j,l,3));
    end
end
%%
%% 
% finding the clusters  and plotting the clusters with their data points

% centres_clusters = centres of all clusters obtained 

[centres_clusters,data2cluster,datapoints_cluster_no] = mean_shift_algorithm(x,bandwidth,threshold_convergence_mean);

no_clusters = length(datapoints_cluster_no);
figure(1);

hold on
color_vector = 'bgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrmykbgrcmykbgrcmykbgrcmykbgrcmy';
for k = 1:no_clusters
    clusters_dataset_members = datapoints_cluster_no{k};
    cluster_centres = centres_clusters(:,k);
    plot(x(1,clusters_dataset_members),x(2,clusters_dataset_members),[color_vector(k) '.'])
    plot(cluster_centres(1),cluster_centres(2),'o','MarkerEdgeColor','k','MarkerFaceColor',color_vector(k), 'MarkerSize',13')
end
title(['data points with their cluster centres Gaussian Kernel (hs,hr)=',num2str(hs),',',num2str(hr)]);
hold off
%%
% creating a 3-D RGB matrix and then plotting the 3-D matrix to get the segmented image
[h2,w2] = size(centres_clusters);
zfilter=zeros(5,height*width);
for i12=1:w2
    mem=datapoints_cluster_no{i12,1};
    p1=size(mem);
    
    for s1=1:p1(1,2)
        zfilter(:,mem(s1))=centres_clusters(:,i12);
    end
end
zluv(:,:,1)=(reshape(zfilter(3,:),width,height))';
zluv(:,:,2)=(reshape(zfilter(4,:),width,height))';
zluv(:,:,3)=(reshape(zfilter(5,:),width,height))';
zrgb = colorspace('Luv->RGB',zluv);
zrgb1=round(zrgb*255);
figure(2)
imshow(zrgb);
title(['Segmented Image (hs,hr)=',num2str(hs),',',num2str(hr)]);
%%