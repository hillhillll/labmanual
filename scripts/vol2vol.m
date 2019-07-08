close all; clear all;


file_register='./register.dat';
%provide the registration to structural freesurfer data


file_output='sfmcprstc';

TR=2.0; %second

target_dir='../analysis';

source_subject='063019';
target_subject='fsaverage';
dirs={
'005';
'007';
'009';
};


pdir=pwd;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	for idx=1:length(dirs)
		%do this outside matlab....
		%make sure freesurfer environment, register file, and subjects directory are all set.
		fn0=sprintf('bold/%s/%s.nii',dirs{idx},file_output);

		eval(sprintf('!mri_vol2vol --mov %s --reg %s --o %s/%s_%s-tal.2mm.mgh  --tal --talres 2',fn0,file_register,target_dir,file_output,dirs{idx}));

	end;

	

return;
