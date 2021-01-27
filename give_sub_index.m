function [n1,n2]=give_sub_index(ind,No_offer)

th(1)=0;
for i=1:No_offer+1
    th(i+1)=(2*No_offer+3-i)*i/2;
    if(ind<=th(i+1))
        n1=i-1;
        n2=ind-th(i)-1;
        break;
    end
end

