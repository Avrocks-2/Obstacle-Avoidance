image = imread('/Users/avneeshv/Downloads/Mobile_Manipulation_Dev-master/src/pcv_base/resources/map/pvil_small_L.pgm');
imageBW = image < 100;
map = binaryOccupancyMap(imageBW);
show(map)
%top left point
for i = 2200:1:2300
    for j = 2730:1:2750
        occval = getOccupancy(map,[i j],'local');
        if occval == 1
            display(i)
            display(j)
            break
        end
    end
end
%top right point
for i = 2300:1:2400
    for j = 2730:1:2750
        occval = getOccupancy(map,[i j],'local');
        if occval == 1
            display(i)
            display(j)
            break
        end
    end
end
y = linspace(2741,2749,1000);
y = transpose(y);
x = linspace(2225,2309,1000);
x = transpose(x);
setOccupancy(map,[x y],ones(1000,1));
%bottom left point
for i = 2230:1:2250
    for j = 2500:1:2550
        occval = getOccupancy(map,[i j],'local');
        if occval == 1
            fprintf("i is %d\n",i)
            fprintf("j is %d\n",j)
            break
        end
    end
end
%bottom right point
for i = 2320:1:2340
    for j = 2500:1:2550
        occval = getOccupancy(map,[i j],'local');
        if occval == 1
            fprintf("i is %d\n",i)
            fprintf("j is %d\n",j)
            break
        end
    end
end
%bottom line
y = linspace(2536,2539,1000);
y = transpose(y);
x = linspace(2231,2322,1000);
x = transpose(x);
setOccupancy(map,[x y],ones(1000,1));
%left line
y = linspace(2536,2741,1000);
y = transpose(y);
x = linspace(2231,2220,1000);
x = transpose(x);
setOccupancy(map,[x y],ones(1000,1));
%right line
y = linspace(2539,2749,1000);
y = transpose(y);
x = linspace(2322,2310,1000);
x = transpose(x);
setOccupancy(map,[x y],ones(1000,1));


planner = plannerAStarGrid(map);
show(map)
 
x1 = input("Enter Starting row value: ");
y1 = input("Enter Starting column value: ");
start = [4000 - x1 y1];

  

checkvar = 1;
while checkvar == 1

  x2 = input("Enter Ending row value: ");
  y2 = input("Enter Ending column value: ");
  goal = [4000 - x2 y2];
 
  
  plan(planner,start,goal);
  show(planner)
  
  temp_x = x2;
  temp_y = y2;
  start = [temp_x temp_y];
  
  disp("Your goal coordinate is now your start coordinate")
  checkvar = input("If you wish to enter more coordinates enter 1 otherwise enter anything else to exit: ");
  
end


