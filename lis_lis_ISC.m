
% get listener-listener correlation （ISC） by correlating the time course of each subject
% with the average time course of left-out subjects
clear
close all

datapath=[];
destpath=[];

load([path,'story_set.mat']); % the  ID of story heard by each listener
set1=find(S_set==1); set2=find(S_set==2);set3=find(S_set==3);

ID=[11,18,16,4,7];%  the ICA components of cLN ,aDMN, pDMN; EcCN, visual networks

cd(datapath);
list=dir('lis_spk_ica_c*.mat');
list=list(1:end-4);

% pool the time course of all subjects together
sub_tc=nan(300,5,64);
for   i=1:size(list,1)
       load(list(i).name);
       sub_tc(:,:,i)=tc(:,ID);  
end


% estimate ISC
 for   i=1:size(sub_tc,3)
       lis=sub_tc(:,:,i);
       lis=squeeze(lis);  
       if  intersect(i,set1)
           other_id=setdiff(set1,i);
           other_tc=sub_tc(:,:,other_id);
             
       elseif intersect(i,set2)
           other_id=setdiff(set2,i);
           other_tc=sub_tc(:,:,other_id);
                      
       elseif intersect(i,set3)
            other_id=setdiff(set3,i);
            other_tc=sub_tc(:,:,other_id);
        end
        other_tc=squeeze(mean(other_tc,3));
        [r,~]=corr(lis,other_tc);
        qq=diag(r);
        sub_fishz=0.5*(log((1+qq)./(1-qq))); 
    
        sub_isc_r(i,:)=qq;
        sub_isc_fishz(i,:)=sub_fishz;
        sub_other_tc{i}=other_tc;
end
save([destpath,'lis_lis_fishz'],'sub_isc_fishz');
save([destpath,'lis_lis_r'],'sub_isc_r');
save([destpath,'sub_other_tc'],'sub_other_tc');
