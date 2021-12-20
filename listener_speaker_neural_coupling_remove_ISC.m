% removing ISC from the listener's time course to controll for task difficulty
% then get NC between speaker and listener;
clear
close all
datapathX=[];
destpathX=[];

load([pathX,'sub_other_tc.mat']); % for each subject, the mean TC of the left-out subject
load([pathX,'lis_lis_fishz.mat']);

load([pathX,'story_set.mat']); % the IDof story heard by each listener

ID=[11,18,16,4];%  the ICA components of cLN ,aDMN, pDMN and ECN

cd(datapathX);
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
type='lag';   % listener's brain activity proceed or lag behind the speaker's brain activity
for shift=0:7
    for i=1:length(list)
        load(list(i).name);
        lis=tc(:,ID);

        if      S_set(i)==1
                 spk=S1;
        elseif S_set(i)==2
                 spk=S2;
        elseif S_set(i)==3
                  spk=S3; 
        end

        other_tc=sub_other_tc{i}; nc=[];
        for k=1:length(ID)
            lis_tc=lis(:,k);
            spk_tc=spk(:,k);
            other_tc2=other_tc(:,k); 
            [~,~,lis_tc_rd]=regress(lis_tc,other_tc2); % 
            if  strcmp (type,'lag')       
                [r,~]=corr(lis_tc_rd(shift+1:end,:),spk_tc(1:end-shift,:));
            elseif strcmp (type,'pred')
                [r,~]=corr(lis_tc_rd(1:end-shift,:),spk_tc(shift+1:end,:));
            end
             nc(k)=r;
        end      
         fishz=0.5*(log(1+nc)-log(1-nc));
         NC_mat(i,1:4,shift+1)=nc;
         NC_mat_fishz(i,1:4,shift+1)=fishz;
     end
end

save([destpathX,'NC_r_reg_ISC'],'NC_mat');
save([destpathX,'NC_fishz_reg_ISC'],'NC_mat_fishz');

