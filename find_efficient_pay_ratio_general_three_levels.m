function [t_matrix,prob]=find_efficient_pay_ratio_general_three_levels(No_offer,dist_N)

th=0.01;
D=3;
t_matrix=zeros((No_offer+2)*(No_offer+1)/2,1);
prob=zeros((No_offer+2)*(No_offer+1)/2,2);

for n1=0:No_offer
    for n2=0:No_offer-n1
        if(n1+n2>0)
            ind=give_index(n1,n2,No_offer);
            prob(ind,1)=n1/(n1+n2);
            prob(ind,2)=n2/(n1+n2);
        end
    end
end

err=1;
r=1;
while (err>th && r<=14)
    r=r+1;
    t_new=calculate_payments_three_levels(No_offer,prob);
    t_matrix=t_new;
    prob_new=calculate_prob_three_levels(No_offer,t_matrix,dist_N);
    err=norm(prob_new-prob);
    prob=prob_new;
end

