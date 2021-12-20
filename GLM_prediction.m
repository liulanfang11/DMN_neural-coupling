

% GLM_prediction
clear

load([pathX,'NC_mat_fishz.mat']);
load([pathX,'score.mat']);
score=score.retell;
subN=length(score);
NC_mat=NC_mat_fishz(:,[1,3],4); % choose the NC values of LN and pDMN

% predict listener's comprehension score using leave-one out procedure
clear id
for  n=1:subN
     id=setdiff(1:subN,n);
     [b,bint,r,rint,stats]=regress(score(id),[ones(subN-1,1),NC_mat(id,:)]);
     aud=NC_mat(n,1);
     def=NC_mat(n,2);
     cons=b(1);
     prd(n,1)=cons+b(2)*aud+b(3)*def ;
end

real_r=corr(prd,score);

% determine the significance of brain-behavior prediction by permutation
for M=1:1000
    id_perm=randperm(subN); 
    score=score(id_perm);% shuffle the subject ID randomly
   for  n=1:subN
        id=setdiff(1:subN,n);
        [b,bint,r,rint,stats]=regress(score(id),[ones(subN-1,1),NC_mat(id,:)]); % 
        aud=NC_mat(n,1);
        def=NC_mat(n,2);
        cons=b(1);
        prd_perm(n,1)=cons+b(2)*aud+b(3)*def;
   end
       perm_r(M)=corr(score,prd_perm);
end
     p=length(find(real_r<perm_r))./1000

     
     





  