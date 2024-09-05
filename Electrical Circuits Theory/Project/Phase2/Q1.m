%% PHASE2_part1
clear;clc;close all;

fileID = fopen('input.txt');
j = 0;
endFileDetector = fgets(fileID);
while (endFileDetector ~= -1)
    endFileDetector = fgets(fileID);
    j= j+1;
end
fclose(fileID);


numberOfElements = j;
element = strings(1,numberOfElements);
type = strings(1,numberOfElements);
name= strings(1,numberOfElements);
node1 = zeros(1,numberOfElements);
node2 = zeros(1,numberOfElements);
value = zeros(1,numberOfElements);

voltage = zeros(1,numberOfElements);
current = zeros(1,numberOfElements);
power = zeros(1,numberOfElements);

fileID = fopen('input.txt');
i = 1;

endFileDetector = fgets(fileID);
while (endFileDetector ~= -1)
    element = convertCharsToStrings(endFileDetector);
    split_element = (split(element,",")).';
    
    type(1,i) = split_element(1,1);
    name(1,i) = split_element(1,2);
    node1(1,i) = str2num(split_element(1,3));
    node2(1,i) = str2num(split_element(1,4));
    value(1,i) = str2num(split_element(1,5));
    
    endFileDetector = fgets(fileID);
    i= i+1;
end
fclose(fileID);

%in final phase, some code for realizing the number of non-zero nodes
numberOfNodes = 3;
e0 = 0;
e1 = 0;
e2 = 0;

%first equation: v0 = 0
first_row = [1 , zeros(1,numberOfNodes-1)];
first_value = 0;
%

%equations of independent voltage sources
voltage_source_rows = zeros(1,numberOfNodes);
voltage_source_values = zeros(1,1);
i=1;
while(i<=numberOfElements)
    if (type(1,i) == "V")
        added_row = zeros(1,numberOfNodes);
        added_row(1,node1(1,i)+1) = +1;
        added_row(1,node2(1,i)+1) = -1;
        if (voltage_source_rows(1,:) == zeros(1,numberOfNodes))
            voltage_source_rows(1,:) = [added_row];
        else
            voltage_source_rows = [voltage_source_rows;
                                    added_row];
        end
        added_value = value(1,i);
        if (voltage_source_values == 0)
            voltage_source_values = added_value;
        else
            voltage_source_values = [voltage_source_values;added_value];
        end
    end
    
    
    %for recognizing R1 , R2 , V1 , I1__ nothing special for generalizing
    if (type(1,i) == "R" && ((node1(1,i) == 2 && node2(1,i) == 0)||(node1(1,i) == 0 && node2(1,i) == 2)))
        if(node1(1,i) == 2)
            R1_reverse = 0;
        else
            R1_reverse = 1;
        end
        R1 = value(1,i);
    else if (type(1,i) == "R")
        if(node1(1,i) == 1)
            R2_reverse = 0;
        else
            R2_reverse = 1;
        end
        R2 = value(1,i);
    else if (type(1,i) == "V")
        if(node1(1,i) == 1)
            V1_reverse = 0;
        else
            V1_reverse = 1;
        end
        V1 = value(1,i);
    else if (type(1,i) == "I")
        if(node1(1,i) == 0)
            I1_reverse = 0;
        else
            I1_reverse = 1;
        end
        I1 = value(1,i);
        end
        end
        end        
    end
    
    i= i+1;
end
%

%nothing special done for generalizing circuit

%kcl equations
kcl2_row = [-1/R1 -1/R2 1/R1+1/R2];
kcl2_value = I1;
%




matrix = [first_row;
           kcl2_row;
           voltage_source_rows];
sources_vector = [0;kcl2_value;voltage_source_values];

nodes = (linsolve(matrix,sources_vector)).';
e0 = nodes(1,1);
e1 = nodes(1,2);
e2 = nodes(1,3);

VR1 = e2-e0;
IR1 = VR1/R1;
PR1 = VR1*IR1;
if (R1_reverse)
    VR1 = VR1*(-1);
    IR1=IR1*(-1);
end

VR2 = e1-e2;
IR2 = VR2/R2;
PR2 = VR2*IR2;
if (R2_reverse)
    VR2 = VR2*(-1);
    IR2=IR2*(-1);
end
VI1 = e0-e2;
II1 = I1;
if (I1_reverse)
    VI1 = VI1*(-1);
end
PI1 = VI1*II1;

VV1 = V1;
if (R2_reverse == 0)
IV1 = -IR2;
else
IV1 = IR2;
end
if (V1_reverse)
    IV1=IV1*(-1);
end
PV1 = VV1*IV1;

voltage = [VR1 VR2 VV1 VI1];
current = [IR1 IR2 IV1 II1];
power = [PR1 PR2 PV1 PI1];
%

%writing result on file
i=1;
outFileID = fopen('output.txt','w');
 while(i<=numberOfElements)
fprintf(outFileID,'<%s><%f><%f><%f>\n',name(1,i),voltage(1,i),current(1,i),power(1,i));
i=i+1;
end
fclose(outFileID);
%

%plotting values
x = [-5:5:5];
figure;
% subplot(2,2,1)
    subplot(1,3,1)
        plot(x,[VR1,VR1,VR1],'blue','LineWidth',1);
        grid minor;
        title('Voltage of Element R1');
    subplot(1,3,2)
        plot(x,[IR1,IR1,IR1],'red','LineWidth',1);
        grid minor;
        title('Current of Element R1');
    subplot(1,3,3)
        plot(x,[PR1,PR1,PR1],'yellow','LineWidth',1);
        grid minor;
        title('Power of Element R1');
        
% subplot(2,2,2)
figure;
    subplot(1,3,1)
        plot(x,[VR2,VR2,VR2],'blue','LineWidth',1);
        grid minor;
        title('Voltage of Element R2')
    subplot(1,3,2)
        plot(x,[IR2,IR2,IR2],'red','LineWidth',1);
        grid minor;
        title('Current of Element R2')
    subplot(1,3,3)
        plot(x,[PR2,PR2,PR2],'yellow','LineWidth',1);
        grid minor;
        title('Power of Element R2')
% subplot(2,2,3)
figure;
    subplot(1,3,1)
        plot(x,[VV1,VV1,VV1],'blue','LineWidth',1);
        grid minor;
        title('Voltage of Element V1')
    subplot(1,3,2)
        plot(x,[IV1,IV1,IV1],'red','LineWidth',1);
        grid minor;
        title('Current of Element V1')
    subplot(1,3,3)
        plot(x,[PV1,PV1,PV1],'yellow','LineWidth',1);
        grid minor;
        title('Power of Element V1')
% subplot(2,2,1)
figure;
    subplot(1,3,1)
        plot(x,[VI1,VI1,VI1],'blue','LineWidth',1);
        grid minor;
        title('Voltage of Element I1')
    subplot(1,3,2)
        plot(x,[II1,II1,II1],'red','LineWidth',1);
        grid minor;
        title('Current of Element I1')
    subplot(1,3,3)
        plot(x,[PI1,PI1,PI1],'yellow','LineWidth',1);
        grid minor;
        title('Power of Element I1')

%


           
