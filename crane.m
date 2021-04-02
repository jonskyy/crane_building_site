%%%%%%%%%% work zone %%%%%%%%%%%%
%% showing max crane radius
r_min = 2; r_max = 30; a_zero = 0; b_zero = 0;
t = linspace(0,2 * pi,100);
x_zero = a_zero + r_max * cos(t); y_zero = b_zero + r_max*sin(t);
plot(x_zero, y_zero, '-', 'LineWidth', 2);
axis equal;
hold on;
title ('HMI');

%% showing tower crane, min crane radius
plot(a_zero, b_zero, 'o', 'MarkerSize', 24, 'MarkerEdge', 'r');

%% protected zones
% 1st protected zone 
x_nd2 = 9;
y_nd2 = 14:0.1:28.5;
plot(x_nd2, y_nd2, 'k');

x_nd3 = 9:0.1:26.5;
y_nd3 = 14;
plot(x_nd3, y_nd3, 'k');

% 2nd protected zone 
x_nd2 = 0;
y_nd2 = r_min:0.1:r_max;
plot(x_nd2, y_nd2, 'k');

x_nd3 = r_min:0.1:r_max;
y_nd3 = 0;
plot(x_nd3, y_nd3, 'k');

%% hatching protected zones 
% hatching 1st protected zone
y1 = 14;
x1 = 9;

for i = - r_max - (r_max/2):1:r_max + (r_max/2)
    for y = - r_max - (r_max/2):0.2:r_max + (r_max/2)
        x = y + i;
        r1 = sqrt(x^2 + y^2);
        if (x > x1 && y > y1) && r1 > r_min && r1 < r_max
            plot(x, y, 'k')
        end
    end
end

% hatching 2nd protected zone
ykr = 0;
xkr = 0;
x_zero = a_zero + r_max*cos(t);
y_zero = b_zero + r_max*sin(t);

for i = - r_max - (r_max/2):1:r_max + (r_max/2)
    for y = - r_max -(r_max/2):0.2:r_max + (r_max/2)
        x=y+i;
        r1=sqrt((x-a_zero)^2+(y-b_zero)^2);
        if (x<xkr || y<ykr) && r1>r_min && r1<r_max
            plot(x, y, 'k')
        end
    end
end

%% entering data
Safe = - 1.5;
xSafe = x1 - 1.5;
ySafe = y1 - 1.5;
rSafe = sqrt(xSafe^2 + ySafe^2);

m = input('Load weight: ');

xStart = input('Starting X coordinate: ');
yStart = input('Starting Y coordinate: ');
rStart = sqrt(xStart^2 + yStart^2);

if (m == 0)
    while rStart > 30 || rStart < 2 || (xStart < 0 - Safe && yStart < 30) || (xStart < 30 && yStart < 0 - Safe)
        disp("A point has been entered outside the crane's working area! Enter a correct starting point!")
        xStart = input('Starting X coordinate: ');
        yStart = input('Starting Y coordinate: ');
        rStart = sqrt(xStart^2 + yStart^2);
    end
    plot(xStart, yStart, '-o', 'LineWidth', 1.5);

else
    while rStart>30 || rStart<2 || (xStart>=xSafe && yStart>=ySafe) || (xStart<0-Safe && yStart<30) || (xStart<30 && yStart<0-Safe)
        disp("A point has been entered outside the crane's working area! Enter a correct starting point!")
        xStart=input('Starting X coordinate: ');
        yStart=input('Starting Y coordinate: ');
        rStart=sqrt(xStart^2+yStart^2);
    end
    plot(xStart, yStart, '-o', 'LineWidth', 1.5);
end

xFinal = input('Destination X coordinate: ');
yFinal = input('Destination Y coordinate: ');
rFinal = sqrt(xFinal^2 + yFinal^2);

if (m==0)
    while rFinal > 30 || rFinal < 2 || (xFinal < 0 - Safe && yFinal < 30) || (xFinal < 30 && yFinal < 0 - Safe)
        disp("A point has been entered outside the crane's working area! Enter a correct starting point!")
        xFinal = input('Destination X coordinate: ');
        yFinal = input('Destination Y coordinate: ');
        rFinal = sqrt(xFinal^2 + yFinal^2);
    end
    plot(xFinal, yFinal,'-o', 'LineWidth', 1.5);
else
    while rFinal > 30 || rFinal < 2 || (xFinal >= xSafe && yFinal >= ySafe) || (xFinal <= 0 && yFinal < 30) || (xFinal < 30 && yFinal <= 0) || rFinal > 30 || rFinal < 2
        disp("A point has been entered outside the crane's working area! Enter a correct starting point!")
        xFinal = input('Destination X coordinate: ');
        yFinal = input('Destination Y coordinate: ');
        rFinal = sqrt(xFinal^2 + yFinal^2);
    end
    plot(xFinal, yFinal, '-o', 'LineWidth', 1.5);
end

%% calculating...
aStart = (yStart/xStart);
alfaStart = (yStart/xStart)/3.14*180;

aFinal = (yFinal/xFinal);
alfaFinal = (yFinal/xFinal)/3.14*180;

rKrok = (rFinal - rStart)/200;
aKrok = (aFinal - aStart)/200;

rStart = sqrt(xStart^2 + yStart^2);
rFinal = sqrt(xFinal^2 + yFinal^2);

if (m>0)
    %%%    1st CASe
    if (rFinal == rStart)
        rTemp = rStart;

        for aTemp = aStart:aKrok/2:aFinal
            xTemp = rStart*cos(atan(aTemp));
            yTemp = rStart*sin(atan(aTemp));

            if (xTemp > xSafe && yTemp > ySafe)
                while rTemp > rSafe
                    rTemp = rTemp - 0.1;
                    xTemp = rTemp*cos(atan(aTemp));
                    yTemp = rTemp*sin(atan(aTemp));
                    plot(xTemp, yTemp, 'c');
                end

                for aTemp = aTemp:aKrok*0.25:aFinal
                    xTemp = rSafe*cos(atan(aTemp));
                    yTemp = rSafe*sin(atan(aTemp));
                    plot(xTemp, yTemp, 'k');
                end

                for rTemp2 = rSafe:0.2:rFinal
                    xTemp2 = rTemp2*cos(atan(aTemp));
                    yTemp2 = rTemp2*sin(atan(aTemp));
                    plot(xTemp2, yTemp2, 'g');
                end

            elseif (rTemp == rFinal)
                plot(xTemp, yTemp, 'm');
            end
        end

    %%%     2nd CASE 
    elseif (rStart > rFinal)
        rCheck = 0;
        for rTemp = rStart:rKrok:rFinal
            xTemp = rTemp*cos(atan(aStart));
            yTemp = rTemp*sin(atan(aStart));
            plot(xTemp, yTemp, 'm');
        end

        for aTemp = aStart:aKrok:aFinal
            xTemp = rTemp*cos(atan(aTemp));
            yTemp = rTemp*sin(atan(aTemp));

            if (xTemp > xSafe && yTemp > ySafe)
                while rTemp > rSafe
                    rTemp = rTemp - 0.1;
                    xTemp = rTemp*cos(atan(aTemp));
                    yTemp = rTemp*sin(atan(aTemp));
                    plot(xTemp, yTemp, 'b');
                end
                rCheck = 1;
            else
                plot(xTemp, yTemp, 'k');
            end
        end
        
        if (rCheck == 1)
            for rTemp2 = rSafe:0.2:rFinal
                xTemp2 = rTemp2*cos(atan(aTemp));
                yTemp2 = rTemp2*sin(atan(aTemp));
                plot(xTemp2, yTemp2, 'g');
            end
        end

    %%%     3rd CASE
    else
        rCheck2 = 0;
        rTemp = rStart;
        for aTemp = aStart:aKrok:aFinal
            xTemp = rStart*cos(atan(aTemp));
            yTemp = rStart*sin(atan(aTemp));

            if (xTemp > xSafe && yTemp > ySafe)
                while rTemp > rSafe
                    rTemp = rTemp - 0.1;
                    xTemp = rTemp*cos(atan(aTemp));
                    yTemp = rTemp*sin(atan(aTemp));
                    plot(xTemp, yTemp, 'b');
                end
                rCheck2 = 1;
                for aTemp = aTemp:aKrok:aFinal
                    xTemp = rSafe*cos(atan(aTemp));
                    yTemp = rSafe*sin(atan(aTemp));
                    plot(xTemp, yTemp, 'm');
                end
            elseif (rTemp == rStart)
                plot(xTemp, yTemp, 'k');
            end
        end
        if (aStart == aFinal)
            for rTemp = rStart:rKrok:rFinal
                xTemp = rTemp*cos(atan(aStart));
                yTemp = rTemp*sin(atan(aStart));
                plot(xTemp, yTemp, 'c');
            end
        elseif (rCheck2 == 0)
            for rTemp = rStart:rKrok:rFinal
                xTemp = rTemp*cos(atan(aTemp));
                yTemp = rTemp*sin(atan(aTemp));
                plot(xTemp, yTemp, 'g');
            end
        else
            for rTemp = rSafe:0.1:rFinal
                xTemp = rTemp*cos(atan(aFinal));
                yTemp = rTemp*sin(atan(aFinal));
                plot(xTemp, yTemp, 'k');
            end
        end
    end

else
    if (rStart == rFinal)
        rTemp = rStart;
        for aTemp = aStart:aKrok/8:aFinal
            xTemp = rTemp*cos(atan(aTemp));
            yTemp = rTemp*sin(atan(aTemp));
            plot(xTemp, yTemp, 'g');
        end
        
    else
        for rTemp = rStart:rKrok:rFinal
            xTemp = rTemp*cos(atan(aStart));
            yTemp = rTemp*sin(atan(aStart));
            plot(xTemp, yTemp, 'g');
        end

        for aTemp = aStart:aKrok:aFinal
            xTemp = rTemp*cos(atan(aTemp));
            yTemp = rTemp*sin(atan(aTemp));
            plot(xTemp, yTemp, 'm');
        end
    end
end
