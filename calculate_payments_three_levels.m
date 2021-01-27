function [t_new]=calculate_payments_three_levels(No_offer,prob)
D=3;
t_new=zeros((No_offer+2)*(No_offer+1)/2,1);
cc=zeros((No_offer+2)*(No_offer+1)/2,1);
for n1=1:No_offer
    for n2=1:No_offer-n1
        ind=give_index(n1,n2,No_offer);
        cc(ind,1)=n1;
        t_new(ind,1)=cc(ind,1)/prob(ind,1);
    end
end
end