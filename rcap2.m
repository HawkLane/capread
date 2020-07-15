function rises=rcap2(datestr,volumes,nloggers)

nruns=length(volumes)/2;
rises=zeros(nruns,3);
index=0;
for i=1:nruns
    vol1=volumes(2*i-1);
    vol2=volumes(2*i);
    basestr1=strcat(datestr,int2str(vol1),int2str(2*i-1));
    basestr2=strcat(datestr,int2str(vol2),int2str(2*i));
    for j=1:nloggers
        fname1=strcat(basestr1,int2str(j),"C.csv");
        fname2=strcat(basestr2,int2str(j),"C.csv");
        if ((exist(fname1)==2) && (exist(fname2)==2))
            C=dlmread(fname1,sep=",");
            if (size(C,1)==0)
                fname1=strcat(basestr1,int2str(j),"C-0.csv");
            end
            fname2=strcat(basestr2,int2str(j),"C.csv")
            C=dlmread(fname2,sep=",");
            if (size(C,1)==0)
                fname2=strcat(basestr1,int2str(j),"C-0.csv");
            end
            [t1,t2,rise]=frise2(fname1,fname2);
            index=index+1;
            rises(index,:)=[t1 t2 rise];
        end
    end
end

