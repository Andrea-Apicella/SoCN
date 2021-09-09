function A = G_er(n,p)
% function A = G_er(n,p)
% Random graph generator - Erdos-Renyi model (no loops)
% input: n = node number
%        p = edge probability

I = [];
J = [];
for i = 2:n
    e = rand(1,i-1);
    Jnew = find(e <= p);
    enew = length(Jnew);
    if enew > 0, I = [I,repmat(i,1,enew)]; J = [J,Jnew]; end
end
A = sparse([I J],[J I],1,n,n);

            