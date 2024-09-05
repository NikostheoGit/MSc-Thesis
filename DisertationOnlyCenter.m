% written by Nikolaos Theodorakopoulos, The University of Manchester, UK,
% nikostheodorakopoulos1990@hotmail.com
% Special Thanks to Dr. Oliver Dorn for his notes and corrections.
clear
clc
close all
%%%%%%%%%%%%%%---Kalman Center Only----%%%%%%%%%%
kfinit=1
O=0
dt = 5;
noise =0.001; %Process noise big noise=time lag
tkn_x = 1;  %Covariance of sensor in X
tkn_y = 1;  %Covariance of sensor in Y
Ez = [tkn_x 0; 0 tkn_y]; %Error in the observations Matrix
Q= [dt^4/4 0 dt^3/2 0; ...
    0 dt^4/4 0 dt^3/2; ...
    dt^3/2 0 dt^2 0; ...
    0 dt^3/2 0 dt^2]*noise^2 %Process Noise
Ppost = Q; % Initialise Priori Covairance
F = [1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1]; %State update matrice
H = [1 0 0 0; 0 1 0 0];

for day =2:31 %<--Change this if you want another day
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
            
            %%%%Comment this 2 lines for multiple tracking%%%
            %%%%%%%----Find The Biggest Ellipse----%%%%%%%%%
            [num] = max(k(:)) ; %Find The location of the Biggest Ellipse
            [x] = ind2sub(size(k),find(k==num))
            % %%%%%%%%%--------------------------------%%%%%%%%
            
            %%%%Uncomment this 2 lines for multiple tracking%%%
            % [sortedValues,sortIndex] = sort(k(:),'descend')  %# Sort the values in descending order
            % maxIndex = sortIndex(1:3)  %# Get a linear index into A of the 10 largest values
            %%%%%%%%%%%%%%%%-----------------%%%%%%%%%%%%%%%%%
            
            
            O=O+1;
            
            %%%%%-------Kalman Filter for Center-------%%%%%%%
            
            
            for n=1:1 %Change n range for multiple center tracking
                
                if kfinit==1
                    % x=maxIndex(n) %Uncomment for multiple tracking
                    mat(n,:) =[A.data(x,3),A.data(x,4),0,0]' ;
                    
                else
                    % x=maxIndex(n) %Uncomment for multiple tracking
                    mat(n,:) = F * mat2(n,:)'; %%Prediction of state
                    figure(1)
                    subplot(2,2,1);plot(mat(n,1),mat(n,2),'.b');
                    hold on
                    
                    subplot(2,2,3);plot(mat(n,1),mat(n,2),'.b');
                    title(['Predicted Position' ])
                    hold on
                end
                Pprior = F * Ppost * F' +Q; %%Covariance
                
                K = Pprior*H'/(H*Pprior*H' + Ez);%Kalman Gain
                
                %Update State and covariance estimation.
                mat2(n,:)=mat(n,:)' + K*([A.data(x,3),A.data(x,4)]'-H*mat(n,:)')
                Ppost =  (eye(4)-K*H)*Pprior;
                
                
                
                subplot(2,2,1);plot(mat2(n,1),mat2(n,2),'.r');
                hold on
                plot(A.data(x,3),A.data(x,4),'.g');
                title(['Prediction(B) Update(R) Observations(G)' ])
                hold on
                
                subplot(2,2,2); plot(A.data(x,3),A.data(x,4),'.g'); % the actual tracking
                title(['Day ' num2str(day,'%02i') ' T= ' num2str(hour,'%02i') ':' num2str(shot,'%02i') '  Observed Position' ])
                hold on
                
                subplot(2,2,4);plot(mat2(n,1),mat2(n,2),'.r'); % the kalman filtered tracking
                title([ ' Updated Position' ])
                hold on
                
            end
            
            kfinit=2;
            
            %%%%%%%%%%%%%%%%%--------%%%%%%%%%%%%%%%%%%%%%%
            e1(O)=abs(A.data(x,3)-mat(n,1)); %%%A priori Error
            e2(O)=abs(A.data(x,3)-mat2(n,1));%%%A posteririori Error
            
            %%%%%---Error Staf---%%%%%
            figure(2);
            subplot(2,1,1)
            title(['Priori And Posteriori Covariance' ])
            ylabel('Covariance');
            xlabel('Steps');
            legend('Priori','Posteriori','Location','southeast')
            
            stem(O,trace(Pprior),'.R')
            hold on
            stem(O,trace(Ppost),'.G')
            hold on
            subplot(2,1,2)
            title(['Kalman Gain' ])
            ylabel('Kalman Gain');
            xlabel('Steps');
            stem(O,K(1,1),'.B')
            hold on
            
            figure(3)
            title(['Priori And Posteriori Error' ])
            ylabel('Error');
            xlabel('Steps');
            legend('e-','e+')
            plot(e1,'r')
            hold on
            plot(e2,'b')
            hold on
            
            pause (.5)
            
            k=0;
            
        end
        
    end
end
