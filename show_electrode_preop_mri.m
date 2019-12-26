close all; clear all;

setenv('SUBJECTS_DIR','/Users/fhlin_admin/workspace/seeg/subjects/'); %for MAC/Linux
%setenv('SUBJECTS_DIR','D:\fhlin\Users\fhlin_admin\workspace\seeg\subjects'); %for PC

mri_post=MRIread('/Users/fhlin_admin/workspace/seeg/subjects/s031_post/mri/orig.mgz'); %for MAC/Linux
%mri_post=etc_MRIread('D:\fhlin\Users\fhlin_admin\workspace\seeg\subjects\2036_post\mri\orig.mgz'); %for PC

mri=MRIread('/Users/fhlin_admin/workspace/seeg/subjects/s031/mri/orig.mgz'); %for MAC/Linux
%mri=etc_MRIread('D:\fhlin\Users\fhlin_admin\workspace\seeg\subjects\2036\mri\orig.mgz'); %for PC

% do registration between pre- and post-OP by the following command:
%
% cd /Users/fhlin_admin/workspace/seeg/subjects/s031_post/tmp
% bbregister --s s031 --mov ../mri/orig.mgz --init-fsl --reg register.dat --t1
%
xfm=etc_read_xfm('file_xfm','/Users/fhlin_admin/workspace/seeg/subjects/s031_post/tmp/register.dat'); %for MAC/Linux
%xfm=etc_read_xfm('file_xfm','D:\fhlin\Users\fhlin_admin\workspace\seeg\subjects\2036_post\tmp\register.dat'); %for PC

%load the Talairach transformation matrix from the "pre-OP" data
talxfm=etc_read_xfm('file_xfm','/Users/fhlin_admin/workspace/seeg/subjects/s031/mri/transforms/talairach.xfm'); %for MAC/Linux
%talxfm=etc_read_xfm('file_xfm','D:\fhlin\Users\fhlin_admin\workspace\seeg\subjects\2036\mri\transforms\talairach.xfm'); %for PC


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert electrode coordinates from post-op MRI to pre-op MRI

file_mat='electrode_040119_085342.mat'; %electrode coordinates in post-op MRI
load(file_mat);

electrode_out=electrode;
for e_idx=1:length(electrode)
    
    for c_idx=1:electrode(e_idx).n_contact
        
        surface_coord=electrode(e_idx).coord(c_idx,:);

        surface_coord=inv(xfm)*[surface_coord(:); 1];
        
        electrode_out(e_idx).coord(c_idx,:)=surface_coord(1:3);
        
    end;
end;

electrode=electrode_out;

[dummy,fstem]=fileparts(file_mat);

fprintf('\nmust load [%s] to locate electrodes in ***pre-op*** MRI!\n\n',sprintf('%s_s031.mat',fstem));
save(sprintf('%s_s031.mat',fstem),'electrode');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


etc_render_fsbrain('surf','orig','hemi','rh','subject','s031','vol',mri,'talxfm',(talxfm));
view(90,30);