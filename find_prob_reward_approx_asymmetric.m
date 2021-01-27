function [trans_prob,reward,value_func,opt]=find_prob_reward_approx_asymmetric(M,VI,N,L_min,L_max,density_resp,density_init,beta_init,theta_init)
penalty=-100000000;
value_func=zeros(1,M+2);
value_func(M+2)=penalty;
[VI]=sort(VI,'descend');
trans_prob=zeros(M,M+2,L_max);
reward=zeros(M,M+2,L_max);
prob_feas=prod(1-density_resp);
for no_avail=1:M
    for L=1:L_max
        if(L<=no_avail)
            trans_prob(no_avail,M+1,L)=1-(1-prob_feas)^L;
            reward(no_avail,M+1,L)=mean(VI(M-no_avail+1:M-no_avail+L));

            if(L<no_avail && L>=L_min)
                trans_prob(no_avail,no_avail-L,L)=(1-prob_feas)^L;
            else
                trans_prob(no_avail,M+2,L)=(1-prob_feas)^L;
            end
        else
            trans_prob(no_avail,M+2,L)=1;
        end
        V(no_avail,L)=dot(trans_prob(no_avail,:,L),reward(no_avail,:,L)+value_func)-beta_init-(N-1)*theta_init*(min(density_init,1-density_init))*L;
    end
    [value_func(no_avail),opt(no_avail)]=max(V(no_avail,:));

end
