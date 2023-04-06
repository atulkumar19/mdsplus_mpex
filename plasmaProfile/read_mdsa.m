function [t,datin]=read_mdsa(subtree,timespec,diag_list,shot_list)

% This routine reads analyzed diagnostic data stored in MDSplus, and returns a vector with times
% And array of data for all diagnostics listed in "diag_list" and shots in
% "shot_list".

%Inputs
%-------------
%treename string containing name of MDS data tree
%diag_list string array containing MDS diagnostic names for data to be read
%shot_list integer vector containing shot numbers for data to be read

%Outputs
%-------
%t   real vector of length equal to the number of data points read
%datin real array of size(number of data points read, number of diagnostics,
%    number of shots) containing signal data 


%close all
%**************************
%Connect to the MPEX server
%**************************
mdsconnect('mpexserver');


nshots=length(shot_list);
sdiag=size(diag_list);
ndiags=sdiag(1);
 %irarr_in=cell(nshots,1);
%Read time data

mdsopen('MPEX',shot_list(1));
[X,~]=mdsvalue(['\MPEX::TOP:analyzed:',subtree,':',timespec]);
 ntpts=length(X);
 t=X(1:ntpts);

mdsclose;

% Read in signal data 

datin=zeros(ntpts,ndiags,nshots);
for ishot=1:nshots %loop over all shots
 mdsopen('MPEX',shot_list(ishot));
 disp(['shot =',num2str(shot_list(ishot))]);
 for idiag=1:ndiags %loop over all diagnostics
     address=['\MPEX::TOP:','analyzed:',subtree,':',strtrim(diag_list(idiag,:))];
     %disp(address)
     [Y,~]=mdsvalue(address);
     
    % keyboard
    
     sy=size(Y);
     %keyboard
     if(sy(2)>=1),datin(1:sy(2)<ntpts,idiag,ishot)=Y(1:sy(2)<ntpts);end      
 end
 
 mdsclose;
end

%*******************************
%Disconnect from the MPEX server
%*******************************
mdsdisconnect;


