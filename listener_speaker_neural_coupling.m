% get listener-speaker neural coupling using ICA timecourse; 
clear
close all
datapath=[];
destpath=[];
type='lag';   % listener's brain activity proceed or lag behind the speaker's brain activity

load([path,'story_set.mat']); % the  ID of story  heard by each listener

ID=[11,18,16,4,7];%  the ICA components of cLN ,aDMN, pDMN; EcCN, visual networks

cd(datapath);
load('lis_spk_ica_c66-1.mat');
S1=tc(:,ID);
clear ic tc

load('lis_spk_ica_c67-1.mat');
S2=tc(:,ID);
clear ic tc

load('lis_spk_ica_c68-1.mat');
S3=tc(:,ID);
clear ic tc

list=dir('lis_spk_ica_c*.mat');
list=list(1:end-4);


NC_mat=nan(length(list),size(ID,1),8);
NC_mat_fishz=nan(length(list),size(ID,1),8);
for shift=0:7
   for i=1:length(list)
        load(list(i).name);
        lis=tc(:,ID);

         if      S_set(i)==1
                 spk=S1;
         elseif  S_set(i)==2
                 spk=S2;
         elseif  S_set(i)==3
                 spk=S3; 
         end
 
    if  strcmp (type,'lag')
        [r,~]=corr(lis(shift+1:end,:),spk(1:end-shift,:));
    elseif strcmp (type,'pred')
        [r,~]=corr(lis(1:end-shift,:),spk(shift+1:end,:));
    end
      r=diag(r);
      fishz=0.5*(log(1+r)-log(1-r));
      NC_mat(i,1:5,shift+1)=r;
      NC_mat_fishz(i,1:5,shift+1)=fishz;
    
   end
end

% 
save([destpath,'NC_mat_r'],'NC_mat');
save([destpath,'NC_mat_fishz'],'NC_mat_fishz');

cd(destpath)

