function [nhi,nh,sum_nh] = get_sum_nh(S_skel,CropSize)

[xskel, yskel, zskel] = ind2sub(CropSize,S_skel);
xskel = xskel + 1;
yskel = yskel + 1;
zskel = zskel + 1;
CropSize2 = CropSize + [2 2 2];


S_skel_pad=sub2ind(CropSize2,xskel,yskel,zskel);
%skel = false(CropSize2);
%skel(S_skel_pad) = 1;


% 26-nh of all canal voxels
%nh = logical(pk_get_nh(skel,list_canal));

[x,y,z]=ind2sub(CropSize2,S_skel_pad);

nh = false(length(S_skel_pad),27);
nhi = zeros(length(S_skel_pad),27);


for zzz = 2:max(z)
    selectByZzz = z == zzz;
    selectByZzz3 = (z >= zzz-1) & (z <= zzz+1);
    
    S_skel_pad_zzz_3{zzz} = S_skel_pad(selectByZzz3)-CropSize2(1).*CropSize2(2).*(zzz-2);
    
    S_skel_pad_zzz{zzz} = S_skel_pad(selectByZzz);
    x_zzz{zzz} = x(selectByZzz);
    y_zzz{zzz} = y(selectByZzz);
    z_zzz{zzz} = z(selectByZzz);
    nhZZZ{zzz} = false(size(S_skel_pad_zzz{zzz},1),27);
    nhiZZZ{zzz} = zeros(size(S_skel_pad_zzz{zzz},1),27);
    
end


for zzz = 2:max(z)
    [nhZZZ{zzz}, nhiZZZ{zzz}] = get_nh_par( S_skel_pad_zzz{zzz}, x_zzz{zzz}, y_zzz{zzz} ,z_zzz{zzz}, zzz, S_skel_pad_zzz_3{zzz}, CropSize2);
end

ii = 1;
for zzz = 2:max(z)
    if size(nhiZZZ{zzz},1) ~=0
        nhi(ii:ii+size(nhiZZZ{zzz},1)-1,:) = nhiZZZ{zzz};
        nh(ii:ii+size(nhiZZZ{zzz},1)-1,:) = nhZZZ{zzz};
        ii = ii+size(nhiZZZ{zzz},1);
    end
end

nhi = nhi.*nh;

sum_nh = sum(logical(nh),2);
