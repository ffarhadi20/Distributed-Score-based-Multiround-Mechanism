function [t_matrix,prob]=Calculate_t_p_three_levels(Lmax,dist_N)

%Input:
% Lmax:  Maximum number of agreements the initiator is allowed to offer at each round 
% dist_N: distribution of the number of agents participate in each negotiation

% Output:
% t_matrix: Reward function, a 3-D matrix of size (Lmax+2)*(Lmax+1)/2  \times 1 \times Lmax
% prob:  Probability that an offer with an specific score will be selected, a 3-D matrix of size (Lmax+2)*(Lmax+1)/2  \times 2 \times Lmax 

t_matrix=zeros((Lmax+2)*(Lmax+1)/2,1,Lmax);
prob=zeros((Lmax+2)*(Lmax+1)/2,2,Lmax);
for i=2:Lmax
    [t_matrix(1:(i+2)*(i+1)/2,:,i),prob(1:(i+2)*(i+1)/2,:,i)]=find_efficient_pay_ratio_general_three_levels(i,dist_N);
end