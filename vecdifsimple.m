%this function calculates cosine similarity

function d=vecdifsimple(x,y)
a(1,:)=x;
b(1,:)=y;
d=sum(a.*b)/(norm(a)*norm(b));
end