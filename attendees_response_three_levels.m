function [opt_report]=attendees_response_three_levels(No_offer,V,prob)
D=3;
opt_report=zeros(1,No_offer);
avail=find(V>0);
[V_sort,indx_sort]=sort(V,'descend');
no_avail=size(avail,2);
if(no_avail>0)
    avg_val=zeros(1,no_avail);
    for th=1:no_avail
        report=[2*ones(1,th),ones(1,no_avail-th),zeros(1,No_offer-no_avail)];
        n1=sum(report==1,2);
        n2=sum(report==2,2);
        report_indx=give_index(n1,n2,No_offer);
        for k=1:No_offer
            if(V_sort(k)>=0)
                avg_val(th)=avg_val(th)+V_sort(k)*prob(report_indx,report(k))/size(find(report==report(k)),2);
            end
        end
    end
    [max_avg_val,max_indx]=max(avg_val);
    report=[2*ones(1,max_indx),ones(1,no_avail-max_indx),zeros(1,No_offer-no_avail)];
    for i=1:No_offer
        opt_report(indx_sort(i))=report(i);
    end
end