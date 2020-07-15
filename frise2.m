function [c1,c2,t1,t2,rise]=frise2(fname1,fname2)
nma=5;
C1=dlmread(fname1,sep=",");
caps1=C1(2:end,end);
caps1=caps1(5:5:end);
C2=dlmread(fname2,sep=",");
caps2=C2(2:end,end);
caps2=caps2(5:5:end);
caps=[caps1' caps2']';
caps=caps(caps>54);
try
  y10=glideav(caps,5);
  capsb=min(y10);
  t=0.5:0.5:0.5*length(caps);
  ty10=t(5:end);
  indexr=find((y10-min(y10))>0.5);
  if ((length(indexr)==0) || (indexr(1)<=5))
      t1=0;
      t2=0;
      rise=0;
  else
    t1=ty10(indexr(1));
    dcaps=caps(indexr(1)+nma:end);
    dy=abs(diff(dcaps));
    dy50=glideav(dy,nma);
    nvals50=length(dy50);
    ty50=t(end-nvals50+1:end);
    capsdy50=caps(end-nvals50+1:end);
    y10=y10(end-nvals50+1:end);
    compg50=dy50;
    gab50=find(compg50<0.01);
    if (length(gab50)==0)
        t2=-1;
        c2=-1;
    else
        gab50=sort(gab50);
        t2=ty50(gab50(1))-nma*0.5;
        c2=capsdy50(gab50(1));
        
    end
    c1=capsb;
    rise=c2-capsb;
    end
  catch 
      t1=0;
      t2=0;
      rise=0;
  end_try_catch
end

