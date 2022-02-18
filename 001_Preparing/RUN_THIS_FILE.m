clear

%{
dir_root = {'Z:\Yongsoo_Kim_Lab\STP_processed\2019_optical\20191212_UC_U504_C57J_FITC-fill_M_p67_optical';
            'Z:\Yongsoo_Kim_Lab_2\STP_processed\2020_optical\20200220_UC_U547_C57J_FITC-fill_M_p559_optical';
            'Z:\Yongsoo_Kim_Lab_2\STP_processed\2020_optical\20200227_UC_U548_C57J_FITC-fill_M_p559_optical';
            'Z:\Yongsoo_Kim_Lab_2\STP_processed\2020_optical\20200319_HB_U549_C57J_FITC-fill_M_p63_optical';
            'Z:\Yongsoo_Kim_Lab_2\STP_processed\2020_optical\20200324_YK_U533_C57J_FITC-fill_F_p56_optical';
            'Z:\Yongsoo_Kim_Lab_2\STP_processed\2020_optical\20200407_UC_U581_C57J_FITC-fill_F_p557_optical';
            'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200402_YK_U554_C57J_FITC-fill_F_p56_optical'};
%}       
%{
dir_root = {'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200328_YK_U573_QZ719_C57J_FITC-fill_F_24mo_optical';
            'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200412_YK_U550_C57J_FITC-fill_M_p63_optical';
            'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200424_UC_U582_C57J_FITC-fill_F_p557_optical';
            'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200501_UC_U598_C57J_FITC-fill_F_p69_optical'};

dir_root = {
'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200515_UC_U583_C57J_FITC-fill_F_p557_optical'
};
%}        
%{
dir_root = {
'Z:\Yongsoo_Kim_Lab_2\STP_processed\2020_optical\20200123_HB_HB106_PA5xFAD_WT_FITC-rat_optical';
'Z:\Yongsoo_Kim_Lab_2\STP_processed\2020_optical\20200109_HB_HB107_PA5xFAD_MUT_FITC-rat_optical';
'Z:\Yongsoo_Kim_Lab_2\STP_processed\2020_optical\20200312_HB_HB125_PA5xFAD_MUT_P72_FITC-fill_optical';
'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200522_HB_HB130_5xFAD_FITC-filll_F_MUT_p236_optical';
'Z:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200529_HB_HB131_5xFAD_FITC-fill_F_WT_p236_optical';
};
%}

%{
% Batch #2
dir_root = {
'Y:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200725_HB_U584_C57J_FITC-fill_F_p558_optical';
'Y:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200729_HB_U601_C57J_FITC-fill_F_p56_optical';
'Y:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200803_HB_U602_C57J_FITC-fill_F_p56_optical';
'Y:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200814_YK_U585_C57J_FITC-fill_F_18mo_optical';
'Y:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200827_HB_U605_C57J_FITC-fill_M_p56_optical';
%'Y:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20201008_HB_HB292_C57J_FITC-fill_M_p64_optical';
'Y:/Yongsoo_Kim_Lab_2/STP_processed/2020_optical/20200417_HB_HB123_5xFAD_WT_p120_FITC-rat_optical';
'Y:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200522_HB_HB130_5xFAD_FITC-filll_F_MUT_p236_optical';
'Y:/Yongsoo_Kim_Lab_3/STP_processed/2020_optical/20200529_HB_HB131_5xFAD_FITC-fill_F_WT_p236_optical';
};
%}


% Batch #2
dir_root = {
'Y:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20201013_HB_HB294_C57J-NIA_FITC-fill_F_18mo_optical';
};



for ii = 1:length(dir_root)
    mat_clean_skel(dir_root{ii});
end
