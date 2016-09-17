clc,clear all,close all;
N=32;
W=500;
H=400;

NT=2*N-1;
IA_CountX=idivide(int32(W),N);
IA_CountY=idivide(int32(H),N);
IA_Count=IA_CountX*IA_CountY;
fprintf('bx \t by \t bz \t tx \t ty \t s1 \t s2 \t\n');

for bz=0:IA_Count-1
    for by=0:NT-1
        for bx=0:NT-1
            for ty=0:N-1
               for tx=0:N-1

                    Ax=( mod(bz,IA_CountX));
                    Ay=( idivide(int32(bz),IA_CountX) );

                    P1x=(Ax*N+tx);
                    P1y=(Ay*N+ty);

                    s1=(P1y*W+P1x);                                       

                    rw=(by+ty-(N-1));
                    cl=(bx+tx-(N-1));

                    P2x=(Ax*N+cl);
                    P2y=(Ay+rw);
                    s2=(P2y*W+P2x);

                    fprintf('%5d \t %5d \t %5d \t %5d \t %5d \t %5d \t %5d \t\n',bx , by , bz , tx , ty , s1 , s2);
               end 
            end
        end
    end
end