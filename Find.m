function location=Find(cur,scope,flag)
if(strcmp(flag,'k')==1)
    location=1;
    for t=1:length(scope)-1
        if(cur>scope(t)&&cur<=scope(t+1))
            location=t+1;
        end
    end
end

if(strcmp(flag,'m')==1)
    location=0;
    for t=1:length(scope)-1
        if(cur>scope(t)&&cur<=scope(t+1))
            location=t;
        end
    end
    if(cur>scope(length(scope)))
        location=length(scope);
    end
end