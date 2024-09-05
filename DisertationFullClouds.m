% written by Nikolaos Theodorakopoulos, The University of Manchester, UK,
% nikostheodorakopoulos1990@hotmail.com
% Special Thanks to Dr. Oliver Dorn for his notes and corrections.
clear
clc
close all
%%%%%--Kalman filter For WHOLE ELLIPSE--%%
kfinit=1;
dt=5;
F = [1 0 dt 0 0 0 0 0 0 0;
    0 1 0 dt 0 0 0 0 0 0;
    0 0 1 0 0 0 0 0 0 0;
    0 0 0 1 0 0 0 0 0 0;
    0 0 0 0 1 0 dt 0 0 0;
    0 0 0 0 0 1 0 dt 0 0;
    0 0 0 0 0 0 1 0 0 0;
    0 0 0 0 0 0 0 1 0 0;
    0 0 0 0 0 0 0 0 1 dt;
    0 0 0 0 0 0 0 0 0 1];

H = [1 0 0 0 0 0 0 0 0 0;
    0 1 0 0 0 0 0 0 0 0;
    0 0 0 0 1 0 0 0 0 0;
    0 0 0 0 0 1 0 0 0 0;
    0 0 0 0 0 0 0 0 1 0];


B = [(dt^2/2); (dt^2/2); dt; dt]; %Control Matrix
noise = 0.001;
tkn_x =100;  %measurement noise in the horizontal direction (x axis).
tkn_y =100;  %measurement noise in the horizontal direction (y axis).
Ez = [tkn_x 0 0 0 0;
    0 tkn_x 0 0 0;
    0 0 tkn_x 0 0;
    0 0 0 tkn_x 0;
    0 0 0 0 tkn_x]

O=0

Q = [dt^4/4 0 dt^3/2 0 0 0 0 0 0 0; ...
    0 dt^4/4 0 dt^3/2 0 0 0 0 0 0;...
    dt^3/2 0 dt^2 0 0 0 0 0 0 0; ...
    0 dt^3/2 0 dt^2 0 0 0 0 0 0;...
    0 0 0 0 dt^4/4 0 dt^3/2 0 0 0;...
    0 0 0 0 0 dt^4/4 0 dt^3/2 0 0;...
    0 0 0 0 dt^3/2 0 dt^2 0 0 0;...
    0 0 0 0 0 dt^3/2 0 dt^2 0 0;...
    0 0 0 0 0 0 0 0 dt^4/4 dt^3/2;...
    0 0 0 0 0 0 0 0 dt^3/2 dt^2]*noise^2

P0 = Q;

NumberOfClouds=6 % <--- Change this if you want to track and predict more/less clouds
for day =2:2     % <--- Change if you want another day
    close all
    for hour = 0: 23
        for shot = 0:5:55
            P = sprintf('201512%s%s%s_all.txt',num2str(day,'%02i'),num2str(hour,'%02i'),num2str(shot,'%02i'))
            
            A= importdata(P);
            
            for i=1:size(A.data)
                
                A.data(i,3); %Center X
                A.data(i,4); %Center Y
                A.data(i,7); %Orientation of the ellipse
                A.data(i,10); %Semimajor axis length in X direction (Cartesian)
                A.data(i,11); %Semimajor axis length in Y direction (Cartesian)
                
                
                k(i)=A.data(i,10)*A.data(i,11)*pi; %Surface of Ellipses
            end
            
            [sortedValues,sortIndex] = sort(k(:),'descend')  %Sort the values in descending order
            maxIndex = sortIndex(1:NumberOfClouds)  
            
            
            %%%-------Kalman 2 FULL ELLIPSE------%%%%%%%%%
            for n=1:NumberOfClouds 
                x=maxIndex(n)
                if kfinit==1
                    x=maxIndex(n)
                    mat(n,:) =[A.data(x,3),A.data(x,4),0,0,A.data(x,10),A.data(x,11),0,0,A.data(x,7),0]' ;
                    
                else
                    mat(n,:) = F * mat2(n,:)';
                    
                end
                figure(1)
                title([ 'Prediction in Explicit Form' ])
                subplot(2,2,[1 3])
                ellipse(mat(n,5),mat(n,6),mat(n,9),mat(n,1),mat(n,2),'g');
                Ppre = F * P0 * F' + Q;
                %Kalman Gain
                K = Ppre*H'/(H*Ppre*H' + Ez);
                
                %Update State and covariance estimation.
                mat2(n,:)=(mat(n,:)' +K*([A.data(x,3),A.data(x,4),A.data(x,10),A.data(x,11),A.data(x,7)]'-H*mat(n,:)'))';
                P0 =  (eye(10)-K*H)*Ppre;
                
                if n==NumberOfClouds 
                    FIG=   figure(1)
                    subplot(2,2,[2 4]);
                    implicit(mat,NumberOfClouds);
                    title([ 'Prediction in Implicit Form' ])
                    hold on
                end
            end
            
            kfinit=2;
            pause (2)
            clf(figure(1))
            k=0;
        end
        
    end
end
