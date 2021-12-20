

% get the Dice similarity between each ICA component and the template network;
% To avoide arbitrary choice of threshold, a set of t-value was applied to
% binarize the two maps, then pick the one consistently showing high Dice score
% as the target

clear
clc

cd(pathX)
tp=load_nii('Reslice_default_association-test_z_FDR_0.01.nii'); % the meta-analytic network(template) downloaded from Neurosynth
tp=tp.img;
id=find(tp>0);
z=min(tp(id)); % the min z value in the meta-analytic
clear id
cd(pathX);
map=load_nii('lis_spk_tmap_component_ica_s1_.nii'); % do not use icatb_loadData, causing left-right flippled!!!
map=map.img;


for i=1:20
    ic=map(:,:,:,i);
    n=0;
     
    for  thresh=z:0.25:6
         n=n+1;
         id1=find(tp>=thresh);
         m1=mean(tp(id1));
         id2=find(ic>=thresh); 
         m2=mean(ic(id2));
         
         % the T-values in IC map are much higher than the Z-value in the
         % meta-analysitic map. Adust the threshold to account for this discrepancy 
         gap=m2-m1;  
         id3=find(ic>=thresh+gap); % using a higher threshold for IC map 
         a=intersect(id1,id3);
         b=length(id1)+length(id3);
         c=2*length(a)./b;
         Dice(i,n)=c;
     end            
end
imagesc(Dice)
qq=z:0.25:6;
qq=round(qq,2);
mm=1:2:length(qq);
xticks(mm)  
xticklabels(qq(mm))
