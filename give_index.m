function [ind]=give_index(n1,n2,No_offer)
k=size(n1,2);
ind=(2*No_offer*ones(k,1)-n1+3).*(n1)/2+n2+1;
