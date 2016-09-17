clc, clear , close all;

Str='abcbcbcbcabbacbabcabc';
A=['a' 'b' 'c'];

L=length(A);                
codebook=cell(L,1);         
for j=1:L                   
    codebook{j}=A(j);
end


i=1;
k=1;

while i<=length(Str),       
flag=0;                     
search=Str(i);              

    while flag==0,
        index=search_cell(codebook,search);  
        if index~=0             
            codeDec(k)=index;   
            i=i+1;          
            if i<=length(Str)   
                search=[search Str(i)];
            else
                flag=1;         
            end
        else                    
            flag=1;             
            codebook{length(codebook)+1}=search;   
        end
        
    end
    
k=k+1;    
end

codeDec=codeDec'
codeBin=dec2bin(codeDec,ceil(log2(max(codeDec))))
