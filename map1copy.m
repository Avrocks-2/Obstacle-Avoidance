image = imread('/Users/avneeshv/Downloads/Mobile_Manipulation_Dev-master/src/pcv_base/resources/map/p_village.pgm');
imageBW = image < 100;
map = binaryOccupancyMap(imageBW);
show(map)
%left bed
%bottom line
for i = 1930:1:1950
    for j = 1850:1:1860
        occval = getOccupancy(map,[i j],'local');
        if occval == 1
            display(i)
            display(j)
            break
        end
    end
end
%top line
for i = 1930:1:1950
    for j = 1880:1:1900
        occval = getOccupancy(map,[i j],'local');
        if occval == 1
            display(i)
            display(j)
            break
        end
    end
end
a = [1942];
x = repelem(a,50);
x = transpose(x);
y = linspace(1853,1895,50);
y = transpose(y);
setOccupancy(map,[x y],ones(50,1));
%right bed
%bottom line
for i = 2000:1:2050
    for j = 1850:1:1860
        occval = getOccupancy(map,[i j],'local');
        if occval == 1
            disp(i)
            disp(j)
            break
        end
    end
end
%top line
for i = 2000:1:2050
    for j = 1880:1:1900
        occval = getOccupancy(map,[i j],'local');
        if occval == 1
            disp(i)
            disp(j)
            break
        end
    end
end
a = [2024];
x = repelem(a,50);
x = transpose(x);
y = linspace(1853,1895,50);
y = transpose(y);
setOccupancy(map,[x y],ones(50,1));
show(map)
robotradius = 1;
inflate(map,robotradius)

planner = plannerAStarGrid(map);
 
x1 = input("Enter Starting row value: ");
y1 = input("Enter Starting column value: ");
start = [4000 - x1 y1];

  
checker = 0;
checkvar = 1;
while checkvar == 1

  x2 = input("Enter Ending row value: ");
  y2 = input("Enter Ending column value: ");
  goal = [4000 - x2 y2];
  if checker >= 1
      goal = [x2 y2];
  end
 
  
  plan(planner,start,goal);
  show(planner)
  
  temp_x =  x2;
  temp_y = y2;
  start = [4000 - temp_x temp_y];
  
  if checker >= 1
     temp_x =  x2;
     temp_y = y2;
     start = [temp_x temp_y];
  end
  
  disp("Your goal coordinate is now your start coordinate")
  checkvar = input("If you wish to enter more coordinates enter 1 otherwise enter anything else to exit: ");
  checker = checker +1;
end


