function y=glideav(x,n)
    index=0;
    nvals=length(x);
    for i = n:nvals
        gvec=x(i-n+1:i);
        index=index+1;
        y(index)=mean(gvec);
    end
    
