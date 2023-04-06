
function [t,datin]=read_mdsg(treename,diag_list,shot_list)

% This routine reads general diagnostic data stored in MDSplus, and returns a vector with times
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

%Read time data

mdsopen('MPEX',shot_list(1));
[X,~]=mdsvalue(['DIM_OF(\MPEX::TOP.',treename,':',strtrim(diag_list(1,:)),')']);
 npts=length(X)-1;
 t=X(1:npts);
mdsclose;

% Read in signal data 

datin=zeros(npts,ndiags,nshots);
for ishot=1:nshots %loop over all shots
 mdsopen('MPEX',shot_list(ishot));
 disp(['shot =',num2str(shot_list(ishot))]);
 for idiag=1:ndiags %loop over all diagnostics
     [Y,~]=mdsvalue(['\MPEX::TOP.',treename,':',strtrim(diag_list(idiag,:))]);
    % keyboard
     sy=size(Y);
     %keyboard
     if(sy(1)>=npts),datin(:,idiag,ishot)=Y(1:npts);end
 end
 mdsclose;
end

%*******************************
%Disconnect from the MPEX server
%*******************************
mdsdisconnect;


