function kSplitWrite( I, K, folder )
%KSPLITWRITE Given a full matrix I of format [id, t, x, y, value]
%A partition matix K of format [x, y, kthpartition], and folder name, write
%the partitioned data to file
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    %match locations in th the K matrix to the I measurement matrix and
    %find the partitions that each measurement belongs
    [~,Kmap] = ismember(I(:,3:4),K(:,1:2),'rows');

    for k = 1:max(K(:,3))
        
        if ~exist(sprintf('%s\\fold%d',folder,k), 'dir')
            mkdir(sprintf('%s\\fold%d',folder,k));
        end
        
       [test, sample] = kSplitGetKth(I,K(Kmap,3),k); 
       
       %write st_sample data to file
       fo = sprintf('%s\\fold%d\\st_sample.txt',folder,k);
       dlmwrite(fo,sample(:,[3 4 2]),'delimiter','\t','precision',12); 
       
       %write st_test data to file
       fo = sprintf('%s\\fold%d\\st_test.txt',folder,k);
       dlmwrite(fo,test(:,[3 4 2]),'delimiter','\t','precision',12); 
       
       %write value_sample data to file
       fo = sprintf('%s\\fold%d\\value_sample.txt',folder,k);
       dlmwrite(fo,sample(:,5),'delimiter','\t','precision',12); 
       
       %write value_test data to file
       fo = sprintf('%s\\fold%d\\value_test.txt',folder,k);
       dlmwrite(fo,test(:,5),'delimiter','\t','precision',12); 
    end
end

