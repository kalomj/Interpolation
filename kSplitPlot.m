function kSplitPlot( I, K )
%KSPLITPLOT Given a full matrix I of format [id, t, x, y, value]
%A partition matix K of format [x, y, kthpartition], create a 2x5 plot of
%points in each fold. Only consider the first 10 partitions.
    
    %match locations in th the K matrix to the I measurement matrix and
    %find the partitions that each measurement belongs
    [~,Kmap] = ismember(I(:,3:4),K(:,1:2),'rows');

    
    for k = 1:10
        subplot(2,5,k);
        
        
       [test, sample] = kSplitGetKth(I,K(Kmap,3),k); 

        

        scatter(test(:,3),test(:,4),25,rand(1,3));


        
    end

    
end
