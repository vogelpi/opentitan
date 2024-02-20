// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_earlgrey/data/top_earlgrey.hjson \
//                -o hw/top_earlgrey/ \
//                --rnd_cnst_seed \
//                1017106219537032642877583828875051302543807092889754935647094601236425074047


package top_earlgrey_rnd_cnst_pkg;

  ////////////////////////////////////////////
  // otp_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter otp_ctrl_pkg::lfsr_seed_t RndCnstOtpCtrlLfsrSeed = {
    40'hEB_C8DCE5FA
  };

  // Compile-time random permutation for LFSR output
  parameter otp_ctrl_pkg::lfsr_perm_t RndCnstOtpCtrlLfsrPerm = {
    240'h0D33_98354325_2A315A54_099B7C42_C7096452_9CF82226_17069012_1065E5DD
  };

  // Compile-time random permutation for scrambling key/nonce register reset value
  parameter otp_ctrl_pkg::scrmbl_key_init_t RndCnstOtpCtrlScrmblKeyInit = {
    256'h0A248B1E_E6367C90_4595EC41_A7D5CC53_87D7861E_31B129CA_3C092D60_25E9D954
  };

  ////////////////////////////////////////////
  // lc_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivInvalid = {
    128'hB0101D0C_BC7C25E7_C365C1C3_F86AB97A
  };

  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivTestDevRma = {
    128'hCB4B43F7_496A3756_DED698A5_71A5B415
  };

  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivProduction = {
    128'hECBB2C56_FEDF1A2E_5D096040_1C95A2AE
  };

  // Compile-time random bits used for invalid tokens in the token mux
  parameter lc_ctrl_pkg::lc_token_mux_t RndCnstLcCtrlInvalidTokens = {
    256'h096F35F2_CBFC0488_13377DBB_F477B1CA_8268B4C6_64286C91_ED60055E_2DADB203,
    256'h490A2F66_9B6BB183_69095C44_63951A03_5ADBBDB3_3494D716_9F84C3DB_99DF52A9,
    256'h154380A6_2CA16384_1D9DB753_96DD52AC_43C480CE_EDC50A48_A2D19EC4_A50918F9,
    256'h14B96453_AD9AC055_59CCB964_4A32BEC1_B3E328FD_BA18B4D2_C12EBE28_C38565DB
  };

  ////////////////////////////////////////////
  // alert_handler
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter alert_pkg::lfsr_seed_t RndCnstAlertHandlerLfsrSeed = {
    32'hAE9A8E24
  };

  // Compile-time random permutation for LFSR output
  parameter alert_pkg::lfsr_perm_t RndCnstAlertHandlerLfsrPerm = {
    160'h4FD146F7_326574FB_638E2916_70CE0251_A3700F7E
  };

  ////////////////////////////////////////////
  // sram_ctrl_ret_aon
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlRetAonSramKey = {
    128'h50C8CE6C_7323501D_5DE917A5_8DA839F1
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlRetAonSramNonce = {
    128'hCCC049F9_B72A95CB_3EAB9391_6CCE5039
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlRetAonLfsrSeed = {
    32'hEE637BB0
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlRetAonLfsrPerm = {
    160'h9E03BB80_686A4FA5_9786953C_CCBEAE87_6DF24542
  };

  ////////////////////////////////////////////
  // flash_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for default address key
  parameter flash_ctrl_pkg::flash_key_t RndCnstFlashCtrlAddrKey = {
    128'h9F385BA2_ACFE0B00_57F563F3_450B66AA
  };

  // Compile-time random bits for default data key
  parameter flash_ctrl_pkg::flash_key_t RndCnstFlashCtrlDataKey = {
    128'hB3D8EC2E_66B6F85C_E5492495_FB42530F
  };

  // Compile-time random bits for default seeds
  parameter flash_ctrl_pkg::all_seeds_t RndCnstFlashCtrlAllSeeds = {
    256'hCAD9158D_C97AD60B_2FDD23F3_986313D6_12FDCD62_AFD0C3A5_FC772CEB_91C16F5D,
    256'h6E17DFF0_661BFBA6_F4E0571E_AE0FC6E6_A1A665F0_42709B54_CB121F70_02A405EC
  };

  // Compile-time random bits for initial LFSR seed
  parameter flash_ctrl_pkg::lfsr_seed_t RndCnstFlashCtrlLfsrSeed = {
    32'hDCF1FEB0
  };

  // Compile-time random permutation for LFSR output
  parameter flash_ctrl_pkg::lfsr_perm_t RndCnstFlashCtrlLfsrPerm = {
    160'h75B0C3D0_0B9A9126_A637DF42_3292BA37_33E809FF
  };

  ////////////////////////////////////////////
  // kmac
  ////////////////////////////////////////////
  // Compile-time random data for PRNG default seed
  parameter kmac_pkg::lfsr_seed_t RndCnstKmacLfsrSeed = {
    32'hAB44E1E9,
    256'h2CCFEBAD_AD9193A3_EE4ECD8C_032462B3_E18549CB_1E70D5A8_3DE6673D_2C1C0A7B
  };

  // Compile-time random permutation for PRNG output
  parameter kmac_pkg::lfsr_perm_t RndCnstKmacLfsrPerm = {
    64'h0B1A89D2_1B0CC0F8,
    256'h6A61A016_E36417C6_65EA3C12_295F2848_747C6C68_FAF98A26_BB3104AB_5BC21A4E,
    256'h760683B1_63752217_7900A4D1_4514B545_C3D2D08C_1920C54A_9C1A6F19_008DC244,
    256'hC6899A9E_4760D650_5E6AE963_081FE608_FC32AA41_5A32CF4E_B1B6C85F_AC59914D,
    256'hD9791C33_EC789CDE_1BEE0448_080C4AFF_09D1C574_36B5896B_9306BB43_89568472,
    256'hC346AC30_6D84A326_97504DD3_A5EC34E2_6B881F63_CBC399A7_AEE369D4_5788A668,
    256'hBDEF5AC9_BB666DB3_923334D5_AAC18916_B33CEB86_525A9C65_BABE5D89_60D3A2D3,
    256'h3C208302_294C84F0_2AA56B87_EBAE352D_DD11593D_8EDFC220_8E9487B6_AA11070C,
    256'hE681F5A4_53C6EE70_014C4A90_AE2112C6_C479A1AD_0566417E_0BB9517F_09028735,
    256'h486046B0_FE44875F_310A7638_451C2CE4_6195C003_054A0E35_9E105320_7966F57E,
    256'h8041012E_9329FB68_3E621CE8_1AC40666_4B4A6225_4732F85B_436093F6_8E286E19,
    256'h24946170_1995807B_42318CA2_628DFA83_1D126682_14A61A8D_7C561595_F1648507,
    256'h755D28DD_DFAD4932_CC4E2FE2_D7F6CB31_837021D3_5A883AAA_F87A9644_49776E56,
    256'h92A01BA8_9970B89F_04E179A4_FC706D74_8A6E3225_C0A9B0C3_5F447D26_43DD0455,
    256'h902927C3_D2482BE3_4B0DE90E_8E747656_2261470A_8957EB2C_7DB8BDA9_B6CDE373,
    256'h0DC34543_7012B0B5_DC9AA0A5_2931535D_6B1C1E7C_1FB679A3_578E23B6_A6C608AC,
    256'h0831BEAC_D4081642_D8E3D605_31F03199_4E89097A_D12A9E89_02A8FF56_89EA7A88,
    256'h7DD9C718_F10F20FA_610C5456_253CC57F_DA1585BF_40D6D02D_7B2671CB_70A319CC,
    256'hCA655566_2A3C52AC_929F91C9_2487CA7B_0026C7B0_40AE6703_53B01A63_2C9AC151,
    256'h359EC4B0_86134609_A65A2E5F_49CBC938_49DE6424_1D76CA09_7EBD5D4E_E8B19369,
    256'h59D7FA9A_1045A52D_6C0085E1_566C46EC_95DB139D_C29AD881_B1587C3A_E6A75A91,
    256'hC2D8B46D_55602087_17824519_936EC478_E091E78A_F8C1069E_03E0EABA_9DA35039,
    256'h23E51ADD_C54DC2F4_BD2D1340_7BF41192_E16B8D7E_54D915E8_1436D0E5_6E90174A,
    256'h98F0CF2C_30AA34FE_60CB82B1_74A2DDD4_58032616_62E56883_965195BA_B751AB2A,
    256'hD4AFE7E3_E5E8C015_6C1CD034_98B88D46_A0EBABB9_B7581057_1E720313_6172DE80,
    256'h23A7B8EF_7D93F6BC_F6B08EB6_300E1651_0526539B_CFA5F201_79C50A06_822E862B,
    256'hDE1EBD2A_15C05282_E7F9F5E2_B6C71184_F28C646C_450111C7_54E4AD39_44375EE0,
    256'hA55721B1_068CA30C_3CB18A9A_DA51928E_60361108_AC1BE089_A4B95508_82870430,
    256'hC6986D2D_9821F2C1_BFAA7C6A_3D5CD9F1_DE270948_B710DA5C_6E8AA0D8_120AB30E,
    256'h8A0EC6F3_5AE7BC09_28CC4451_1954447D_B2218026_E9637101_15E593F1_750A85A4,
    256'h9CFAE534_8E060AF2_194A5C86_D53021C4_63DDBD90_CBD1E947_32EFCA58_DEBBC6E4,
    256'hF8826D16_F4CEDF80_AF344D25_66E42160_C24289D0_05577AD4_0729C98A_CCA62554
  };

  // Compile-time random data for PRNG buffer default seed
  parameter kmac_pkg::buffer_lfsr_seed_t RndCnstKmacBufferLfsrSeed = {
    32'hECDC716A,
    256'h92861FF7_C06C6910_E727CBED_4EE2B19E_B8B9EC47_A05221A8_D0F96EFB_EEF3F9FF,
    256'h6B587673_02C22995_7B7D1597_40CA72CE_50C55920_BA14E126_DCD0A3F6_C9B71D03,
    256'hE571BEE0_E47E5B49_E80E3DA3_9A52777D_BCFD9E38_D4D189EC_4B433E53_14F88C89
  };

  // Compile-time random permutation for LFSR Message output
  parameter kmac_pkg::msg_perm_t RndCnstKmacMsgPerm = {
    128'hBADEABC5_53DA419A_524DE47E_07281D97,
    256'h0A1C8A4E_CA9E15C2_639F0053_71C6D0D0_F8CFD275_BF62E68C_415623F7_EA32C6CE
  };

  ////////////////////////////////////////////
  // otbn
  ////////////////////////////////////////////
  // Default seed of the PRNG used for URND.
  parameter otbn_pkg::urnd_prng_seed_t RndCnstOtbnUrndPrngSeed = {
    256'h8253A7A2_D2902EA7_6A5AB206_9FE29967_AA756708_5E49639B_C56B0269_8ED537B2
  };

  // Compile-time random reset value for IMem/DMem scrambling key.
  parameter otp_ctrl_pkg::otbn_key_t RndCnstOtbnOtbnKey = {
    128'h8BE5D471_604F8672_C813D598_89625BEE
  };

  // Compile-time random reset value for IMem/DMem scrambling nonce.
  parameter otp_ctrl_pkg::otbn_nonce_t RndCnstOtbnOtbnNonce = {
    64'h8DA30B81_E1F9D834
  };

  ////////////////////////////////////////////
  // keymgr
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter keymgr_pkg::lfsr_seed_t RndCnstKeymgrLfsrSeed = {
    64'hF414FCD6_6B581354
  };

  // Compile-time random permutation for LFSR output
  parameter keymgr_pkg::lfsr_perm_t RndCnstKeymgrLfsrPerm = {
    128'h7A58CF37_C4087F6F_541F9743_4554E4ED,
    256'hA61B4B3E_AE28917E_72BB04B4_B5C08B41_B082AA37_A4286F30_15B89F56_713A6FF2
  };

  // Compile-time random permutation for entropy used in share overriding
  parameter keymgr_pkg::rand_perm_t RndCnstKeymgrRandPerm = {
    160'hD72EB30B_3F0A9E3A_B2888B65_BEF8A7B0_12E84C98
  };

  // Compile-time random bits for revision seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrRevisionSeed = {
    256'h021DE436_F5703142_E83B671A_6BCE2387_B97B6B2C_03E1AE54_5B996ACF_DB3D1292
  };

  // Compile-time random bits for creator identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrCreatorIdentitySeed = {
    256'h9B942F6D_14C2D1ED_D24D31EC_5DABD858_25526737_C611FA0E_7D754AE6_4A354CC7
  };

  // Compile-time random bits for owner intermediate identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrOwnerIntIdentitySeed = {
    256'hC16FA06A_E28E208C_1D5AFC5F_0D9DE8D6_1CC3C920_B2ED6566_A1662940_D8B187A1
  };

  // Compile-time random bits for owner identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrOwnerIdentitySeed = {
    256'hA31A45A0_9A6EBDE6_CF840D02_166D8360_79645F80_AF649517_22330EDD_3E68903F
  };

  // Compile-time random bits for software generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrSoftOutputSeed = {
    256'h680EA721_7450DC1F_11AA9BE9_BCE028AC_BB45FC85_DEAEE9E9_571E205C_BA9A4851
  };

  // Compile-time random bits for hardware generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrHardOutputSeed = {
    256'hB89A0AD9_B8E60F7B_4BCF8ACB_C5840E79_CB084D95_CA061203_52218C90_DFAB7429
  };

  // Compile-time random bits for generation seed when aes destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrAesSeed = {
    256'h9E7882F5_3F007A8A_C1BC2FDE_BBDB8276_4E00B660_18476EC7_E9AE86D2_4FAC08B7
  };

  // Compile-time random bits for generation seed when kmac destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrKmacSeed = {
    256'h04A4D6DF_1792AD00_E16CC7C0_15D85290_553843B5_B6AF2BF8_AC41CB2B_75E15066
  };

  // Compile-time random bits for generation seed when otbn destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrOtbnSeed = {
    256'h39338BE5_DC0FA4BD_DBE5F3D5_A9F9386D_A84DDB0C_6EBD1E77_067A438F_6CB7F937
  };

  // Compile-time random bits for generation seed when no CDI is selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrCdi = {
    256'hD1E60908_ABB1B5FA_56226EF0_EED9D76B_62E7B4E4_466B9601_DBB4592F_F19842D5
  };

  // Compile-time random bits for generation seed when no destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrNoneSeed = {
    256'h1606FE22_B8ED0E3F_50759650_EF701A4E_6E4916EE_E56EF868_E4092F95_16CC8B20
  };

  ////////////////////////////////////////////
  // csrng
  ////////////////////////////////////////////
  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivNonProduction = {
    128'hBED74B6A_715B33CA_DB9092B1_125746C4,
    256'h9F15A16A_2A1FD01F_8E09D92D_D13E0298_799D91C5_4BFD2A51_F45AADF3_44C262BB
  };

  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivProduction = {
    128'h0ABDE9B2_40D763DA_6C4250BA_5A44A7D4,
    256'hF4D7F99B_4A6480DA_2D53E7CA_15201A8F_56530010_117F58C9_E9946C11_180407FE
  };

  ////////////////////////////////////////////
  // sram_ctrl_main
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlMainSramKey = {
    128'hB4710F40_4E6E4FAC_E59B972D_1FDCAF71
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlMainSramNonce = {
    128'h1C056939_7BFC4197_6AC86B02_BF2B89BE
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlMainLfsrSeed = {
    32'h218ECED8
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlMainLfsrPerm = {
    160'h29AAEC05_7B5378CD_5BC720A3_47FF37E8_2434A270
  };

  ////////////////////////////////////////////
  // rom_ctrl
  ////////////////////////////////////////////
  // Fixed nonce used for address / data scrambling
  parameter bit [63:0] RndCnstRomCtrlScrNonce = {
    64'h2B2A4874_E4ADACA4
  };

  // Randomised constant used as a scrambling key for ROM data
  parameter bit [127:0] RndCnstRomCtrlScrKey = {
    128'hC6809E57_1B351756_BF8D18E2_4BE7E1C9
  };

  ////////////////////////////////////////////
  // rv_core_ibex
  ////////////////////////////////////////////
  // Default seed of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_seed_t RndCnstRvCoreIbexLfsrSeed = {
    32'h6737B726
  };

  // Permutation applied to the LFSR of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_perm_t RndCnstRvCoreIbexLfsrPerm = {
    160'hF2E0D3C5_172BB3CF_8E62DA98_033FBA20_6B692714
  };

  // Default icache scrambling key
  parameter logic [ibex_pkg::SCRAMBLE_KEY_W-1:0] RndCnstRvCoreIbexIbexKeyDefault = {
    128'hAB1B3D78_F992D223_469898EB_2AFE18DE
  };

  // Default icache scrambling nonce
  parameter logic [ibex_pkg::SCRAMBLE_NONCE_W-1:0] RndCnstRvCoreIbexIbexNonceDefault = {
    64'h121F1E16_4EAC2904
  };

endpackage : top_earlgrey_rnd_cnst_pkg
