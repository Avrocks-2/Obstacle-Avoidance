clear;
clc;

%% Initialization

% Input the position points for robots to pass over. The  coordinates of
% the points correspond to the binary map of the room.
FP1=fopen('Room1_plus.txt','rt');
N=fscanf(FP1,'%d',1);  
C=fscanf(FP1,'%f',[2,N]);   
C=C';
D=zeros(N); 

% Distance between two arbitrary points  
for i=1:N
    for j=1:N 
        D(i,j)=((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2)^0.5;
    end
end

NP=200;  

% G is the Iteration Number (Can be changed). A higher iteration number can 
% provide more accurate and optimized solution.
G=500;  

f=zeros(NP,N);  
nf=zeros(NP,N);   

% pc and pm is the parameter values from online traveling salesmen problem
% example. From test of shprtest path.in three rooms and some randome point 
% data, it is proved that these two paramteres are applicable in our 
% project.
pc=0.4; 
pm=0.2; 

F=[];

%% Iteration & Self-learning
% Initial Random Plan. Use randperm function to find a random path
% solution, no mattter if it is the shortest or not. It is highly likely to
% be a bad path planning and therefore needs optimization from
% self-learning iterations.
for i=1:NP
    f(i,:)=randperm(N);   
end
R=f(1,:);  
len=zeros(NP,1);  
fitness=zeros(NP,1);  
gen=0;

% Apply G iterations for optimization. The optimization method is learned
% from online resources.Generally, the optimization includes variation, 
while gen<G
    for i=1:NP
        len(i,1)=D(f(i,N),f(i,1));
        for j=1:N-1
            len(i,1)=len(i,1)+D(f(i,j),f(i,j+1));
        end
    end
    maxlen=max(len);
    minlen=min(len);
    rr=find(len==minlen);   
    R=f(rr(1,1),:);   
    
    for i=1:NP
        fitness(i,1)=(1-(len(i,1)-minlen)/(maxlen-minlen+0.001));
    end
    
%% Self-fitness and New Occurance

% From online resources
    sumFit=sum(fitness);
    fitvalue=fitness./sumFit;
    fitvalue=cumsum(fitvalue);
    ms=sort(rand(NP,1));
    fiti=1;
    newi=1;
    while newi <= NP
       if (ms(newi)) < fitvalue(fiti)
           nf(newi,:)=f(fiti,:);  
           newi=newi+1;
       else
           fiti=fiti+1;
       end 
    end
    
%% Order Interchange

% NOTE: The order interchange doesn't refer to the exchange between two 
% points. Every point in the loop path will interchange its poisiton 
% accordingly with its matched point.

    for i=1:2:NP
        for j=1:N
            if rand<pc

                A=find(nf(i,:)==nf(i+1,j));
                nf(i,A)=nf(i,j);
                B=find(nf(i+1,:)==nf(i,j));
                nf(i+1,B)=nf(i+1,j);

                temp1=nf(i+1,j);
                nf(i+1,j)=nf(i,j);
                nf(i,j)=temp1;
            end
        end
    end
    
%% Variation Operation

% It means to pick some points for change instead of exchange orders, which
% can achieve the target if it is close to the result. For example, the
% right order follows point oder 2-4-6-3-7-1-5-2 for a shortest loop path 
% through seven points. And now what we have is 2-7-6-3-4-1-5-2. At these
% point, it can be efficient if the MATLAb operation is samrt/lucky enough
% to pick up 2nd and 5th points to make a change.

% NOTE: Variation Operation is different from order interchange. It is only
% partial adjustment of the loop path, which is quick to operate, but can 
% also be effectiveless.

    for i=1:NP
        for j=1:N
            if rand<pm
                temp2=nf(i,j);
                temp3=randi([1,N],1,1);
                A=find(nf(i,:)==temp3);
                nf(i,j)=temp3;
                nf(i,A)=temp2; 
            end
        end
    end
   f=nf;
   f(1,:)=R;
   clear F
   gen=gen+1;
   Rlength(gen)=minlen;
end

%% Result Output
% This figure is to straightforward show the optimized path after G times
% of iteration. The blue line represents the optimized loop path. The red
% section line means the starting points and the first direction to go
% according to the optimized results. But it actually doesn't matter too
% much in our project, since it's a loop, the start point doesn't influence
% the total length of path to go.
figure
for i=1:N-1
    plot([C(R(i),1),C(R(i+1),1)],[C(R(i),2),C(R(i+1),2)],'bo-')
    hold on;
end
plot([C(R(N),1),C(R(1),1)],[C(R(N),2),C(R(1),2)],'ro-')
title(['Shortest distance:',num2str(minlen)])

% This figure is to show the operation of self-learning and the
% effectiveness of the path optimization. If the target functions varies
% drastically corresponding to the interation number, then it means the
% iteration is working properly. When the target function doesn't vary
% much, it means the solution is kind of optimized to the best of its
% self-learning ability.
figure
plot(Rlength)
xlabel('Iteration number')
ylabel('Target function')
title('Curve for iterations')
disp('The shortest path is：')
disp(R)
