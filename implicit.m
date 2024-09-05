function p=implicit(mat,NumberOfClouds)

NumberOfClouds2=NumberOfClouds
p = cell ( NumberOfClouds2 , 1) ;
kif =0;
for n=1:NumberOfClouds2 
    
    ck=cos (mat (n , 9 ) ) ; %Calculate cos
    sk=sin (mat (n , 9 ) ) ; %Calculate sin
    ak=mat (n , 5 ) ^ 2 ; %Semi axes
    bk=mat (n , 6 ) ^ 2 ; %semi axes
    
    for z=1:1750
        for w=1:1750
            h( z ,w)=((1/ ak ) * ( ( z- mat (n , 1 ) ) *ck+(w - mat (n , 2 ) ) * sk ) ^2 + (1/ bk )*( ( z-mat (n , 1 ) ) *sk-(w-mat (n , 2 ) ) *ck ) ^2)-1;
        end
    end
    
    p(n)={h} ;
    if  kif==0
        PSI=p{1};
    else
        PSI=min(PSI , p{n}) ; %%%%%%% LEVEL SET FUNCTION %%%%%%%%
    end
    
    if n==NumberOfClouds2 
        PSI=rot90 (PSI ) ;
        p=imagesc (PSI<=0);
    end
    kif =1;
end
end