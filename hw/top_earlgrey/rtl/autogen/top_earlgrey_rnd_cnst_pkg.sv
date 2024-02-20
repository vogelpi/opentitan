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
    40'hC8_A8CC102F
  };

  // Compile-time random permutation for LFSR output
  parameter otp_ctrl_pkg::lfsr_perm_t RndCnstOtpCtrlLfsrPerm = {
    240'h3855_A22D2308_28778091_46067219_C46656DF_82624345_A4DD0503_D7563342
  };

  // Compile-time random permutation for scrambling key/nonce register reset value
  parameter otp_ctrl_pkg::scrmbl_key_init_t RndCnstOtpCtrlScrmblKeyInit = {
    256'hF2EBC8DC_E5FA74DC_BC5F7B66_42DF22AE_DC078766_35E60949_45CF7C08_DA94FA8A
  };

  ////////////////////////////////////////////
  // lc_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivInvalid = {
    128'h8D163B5E_2388328C_B3E2E10B_49EB88FA
  };

  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivTestDevRma = {
    128'h526754D1_874A1774_967A0A24_8B1EE636
  };

  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivProduction = {
    128'h7C904595_EC41A7D5_CC5387D7_861E31B1
  };

  // Compile-time random bits used for invalid tokens in the token mux
  parameter lc_ctrl_pkg::lc_token_mux_t RndCnstLcCtrlInvalidTokens = {
    256'h29CA3C09_2D6025E9_D954B010_1D0CBC7C_25E7C365_C1C3F86A_B97ACB4B_43F7496A,
    256'h3756DED6_98A571A5_B415ECBB_2C56FEDF_1A2E5D09_60401C95_A2AE096F_35F2CBFC,
    256'h04881337_7DBBF477_B1CA8268_B4C66428_6C91ED60_055E2DAD_B203490A_2F669B6B,
    256'hB1836909_5C446395_1A035ADB_BDB33494_D7169F84_C3DB99DF_52A91543_80A62CA1
  };

  ////////////////////////////////////////////
  // alert_handler
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter alert_pkg::lfsr_seed_t RndCnstAlertHandlerLfsrSeed = {
    32'h63841D9D
  };

  // Compile-time random permutation for LFSR output
  parameter alert_pkg::lfsr_perm_t RndCnstAlertHandlerLfsrPerm = {
    160'h200F1CBF_B7731BAE_14CB10FF_3A2430C2_2BEDC956
  };

  ////////////////////////////////////////////
  // sram_ctrl_ret_aon
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlRetAonSramKey = {
    128'hB4D2C12E_BE28C385_65DBAE9A_8E24F1FE
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlRetAonSramNonce = {
    128'hDD1F00BF_8E345616_DAEE809C_0D3BAFDC
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlRetAonLfsrSeed = {
    32'h5D24EC2B
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlRetAonLfsrPerm = {
    160'h1EB0B247_B7878A23_99EC9233_36EFEEA5_9205543C
  };

  ////////////////////////////////////////////
  // flash_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for default address key
  parameter flash_ctrl_pkg::flash_key_t RndCnstFlashCtrlAddrKey = {
    128'hCCC049F9_B72A95CB_3EAB9391_6CCE5039
  };

  // Compile-time random bits for default data key
  parameter flash_ctrl_pkg::flash_key_t RndCnstFlashCtrlDataKey = {
    128'hEE637BB0_1251FF89_2217B58D_8577A87D
  };

  // Compile-time random bits for default seeds
  parameter flash_ctrl_pkg::all_seeds_t RndCnstFlashCtrlAllSeeds = {
    256'h8F67508E_576E4353_EBB9C766_709E58B2_7214878D_6E689F38_5BA2ACFE_0B0057F5,
    256'h63F3450B_66AAB3D8_EC2E66B6_F85CE549_2495FB42_530FCAD9_158DC97A_D60B2FDD
  };

  // Compile-time random bits for initial LFSR seed
  parameter flash_ctrl_pkg::lfsr_seed_t RndCnstFlashCtrlLfsrSeed = {
    32'h23F39863
  };

  // Compile-time random permutation for LFSR output
  parameter flash_ctrl_pkg::lfsr_perm_t RndCnstFlashCtrlLfsrPerm = {
    160'hF1E099C5_03218177_D941DF78_B6C8AEA6_2ACCFF42
  };

  ////////////////////////////////////////////
  // kmac
  ////////////////////////////////////////////
  // Compile-time random data for PRNG default seed
  parameter kmac_pkg::lfsr_seed_t RndCnstKmacLfsrSeed = {
    32'hA405ECDC,
    256'hF1FEB0FA_7A14877E_C8863787_AF272EFA_A51F0DE7_10C891D4_7FF7209F_95D61484
  };

  // Compile-time random permutation for PRNG output
  parameter kmac_pkg::lfsr_perm_t RndCnstKmacLfsrPerm = {
    64'h3FA71BB8_5C5296C4,
    256'h6E9A45AC_035CC4BF_0809621F_322282CE_C53C1EEB_3A429C14_16842680_2EB690A3,
    256'h2A98B7F6_ACA36BEA_1D5A8426_A8713F76_D72B4ABA_135F89FC_A48BE35C_7CC7BDC8,
    256'hF8F70828_8A98FC1D_B5CC5B08_5F385D09_84604B31_D8CAF029_4134CA1D_2EC8AA64,
    256'hE0C007F1_A6D60B02_F0D4E5C5_C0C5A89D_BB4FDB65_B27704C6_B95C1D01_23880B05,
    256'hE501AA4C_AB57B1C8_9001CE43_F2369946_D355D15B_A747BD6D_3D8033AC_6218DA6A,
    256'h6EFE5BED_D75888B2_6DB9D566_4752F54A_4F4E2016_0591B458_06ED47AE_E2612318,
    256'hA70C9092_675026B7_852A371C_F6210700_55B8650C_5E6BFB7C_6E19C229_470E4342,
    256'hA6BEBDA5_316095A2_0F967A2A_537194D8_6A168B0B_E5F25FBE_9251F868_6F6809B6,
    256'h11268863_7850B705_8ABA9FBC_8BC916D8_85259A98_1F86C33B_982E6D1E_00F5F74A,
    256'hCF940E5C_7C604001_AD5FC892_70C2ACB1_A96EC44A_5A743EF4_B209E3A5_F5650419,
    256'h90426298_70D8CA45_57EA0CF3_A920F4A1_FA8DD777_D0A15D2E_A02A2971_C7C2E432,
    256'hAADB8B84_96659506_61140260_6826A8AC_CAF80A25_B6AE70C2_2E0D0AD9_06345D9F,
    256'h0902F92E_027BA0F8_C353EC41_90A43193_9EE38F1F_C9F13488_8F50DDAC_5390698A,
    256'hB4018517_8E0D169C_89BB092D_2F608EDE_508FBAC2_B1041E64_91C20E5E_7C4AA3BB,
    256'h31C61120_C790B234_4744A773_75BE61B0_A304935F_45B1D6D0_2128547C_FF4F5605,
    256'h65005865_59FA81C3_DE8A19D3_3667B794_1B575754_D992AA68_9015D86A_48159530,
    256'h4DD64B88_6FC1E563_58E3441A_A0A23A00_A7837E49_49C592DA_92706956_3D43638B,
    256'h52609B67_68E7A59B_4E5AB550_66712039_364474AC_D6357114_A52051B6_46104839,
    256'h4CC4E236_65BC3B98_23306475_2207FDB5_B82C377F_0603A390_C613974D_0A107A96,
    256'h90210DA3_22ED3338_AB4B8761_55F27761_72F46C35_2079D856_231F67B0_CD3B4E85,
    256'h7D5E7783_F8842D5A_58970257_21F0C890_4F129559_F49475F1_4A8AEF67_EB71DD78,
    256'h2FE9872D_57511B00_7838B068_B499511C_E9732F11_B3044524_465184B3_C45E89CE,
    256'hFBFE0B7C_DBA8B583_215316A2_FD239212_0A9D5CC0_4A948325_C199CDFB_4CC4E14C,
    256'hF7045B7B_2CAE696A_131A542C_4083E89F_53D3A1C4_0D43A60B_199C9BCC_3C6CB233,
    256'hD7A03CEC_4B5560A6_1848E129_2AAA062E_9C2C9946_8951E1DA_4F248BC6_3E8AD9A4,
    256'h7148C05E_4615BF56_20A1F60C_18647C0D_1E9E64B7_AE6C7AA9_1BEE4E6C_4A624821,
    256'hAE2669A4_AC426F81_1415488D_28227A73_6B598E88_1ECF236C_2073AAF6_E5FEA796,
    256'h2B1C7905_A43422F3_3A8A034C_6B36AA7A_F03C8ED6_8724A7A0_99E2DCA8_515C5757,
    256'h040EEF54_2854415F_9682B919_517B2963_A4E2A54D_352E8D10_681C789C_A52ED5C5,
    256'h45746501_0AE8C730_3A6CEE43_02968CCB_097B058C_44065597_87911B94_E69A2D47,
    256'h658C1260_55AE725C_193175ED_1C0F4A81_C3856CF2_46304EE8_F91AB644_F0236238
  };

  // Compile-time random data for PRNG buffer default seed
  parameter kmac_pkg::buffer_lfsr_seed_t RndCnstKmacBufferLfsrSeed = {
    32'h30ED9B18,
    256'hB90E42E4_287F60AD_57D6A551_E78F940B_8AE9F2BB_40621F43_F3ABD8D7_37F8D12D,
    256'h8F43FD16_19FB83E1_A607DCC1_72099339_EF142E02_83257145_13BFDC2A_062C2EB4,
    256'hECDC716A_92861FF7_C06C6910_E727CBED_4EE2B19E_B8B9EC47_A05221A8_D0F96EFB
  };

  // Compile-time random permutation for LFSR Message output
  parameter kmac_pkg::msg_perm_t RndCnstKmacMsgPerm = {
    128'h626C4CD4_612A06C8_4E9158CB_3728190B,
    256'h79EDAD16_FDA535E2_FEF3C34A_ED38E47A_09CC8F94_E90D857D_E94AC007_1D59AF3B
  };

  ////////////////////////////////////////////
  // keymgr
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter keymgr_pkg::lfsr_seed_t RndCnstKeymgrLfsrSeed = {
    64'h25D4B19B_23F40E35
  };

  // Compile-time random permutation for LFSR output
  parameter keymgr_pkg::lfsr_perm_t RndCnstKeymgrLfsrPerm = {
    128'h12999388_87B3BFCF_F5DA77D7_2F4C52B7,
    256'hA2906A56_D180F0B8_8640FB65_DAC9077C_A8F9535C_B8560EC3_9A8C02C5_161FD1A3
  };

  // Compile-time random permutation for entropy used in share overriding
  parameter keymgr_pkg::rand_perm_t RndCnstKeymgrRandPerm = {
    160'hF96FB21E_54E046F0_29155E3B_31660963_BD636A2D
  };

  // Compile-time random bits for revision seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrRevisionSeed = {
    256'h9D9F58F7_0432D8BF_8509A79C_A1D3AB83_A61AF330_C5CFD188_035E2F18_108133B3
  };

  // Compile-time random bits for creator identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrCreatorIdentitySeed = {
    256'h8A7167F8_2D4B5453_CA029357_90001030_32EED900_BB073D95_19792FAE_CDF66777
  };

  // Compile-time random bits for owner intermediate identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrOwnerIntIdentitySeed = {
    256'hFEED150D_A5FC2ECF_4C99C2FE_249B8772_4C02DEB6_382D21F3_CD9D71CA_9790686D
  };

  // Compile-time random bits for owner identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrOwnerIdentitySeed = {
    256'h8EE0F7C7_49308188_1EAE1452_0CC2B374_021DE436_F5703142_E83B671A_6BCE2387
  };

  // Compile-time random bits for software generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrSoftOutputSeed = {
    256'hB97B6B2C_03E1AE54_5B996ACF_DB3D1292_9B942F6D_14C2D1ED_D24D31EC_5DABD858
  };

  // Compile-time random bits for hardware generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrHardOutputSeed = {
    256'h25526737_C611FA0E_7D754AE6_4A354CC7_C16FA06A_E28E208C_1D5AFC5F_0D9DE8D6
  };

  // Compile-time random bits for generation seed when aes destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrAesSeed = {
    256'h1CC3C920_B2ED6566_A1662940_D8B187A1_A31A45A0_9A6EBDE6_CF840D02_166D8360
  };

  // Compile-time random bits for generation seed when kmac destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrKmacSeed = {
    256'h79645F80_AF649517_22330EDD_3E68903F_680EA721_7450DC1F_11AA9BE9_BCE028AC
  };

  // Compile-time random bits for generation seed when otbn destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrOtbnSeed = {
    256'hBB45FC85_DEAEE9E9_571E205C_BA9A4851_B89A0AD9_B8E60F7B_4BCF8ACB_C5840E79
  };

  // Compile-time random bits for generation seed when no CDI is selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrCdi = {
    256'hCB084D95_CA061203_52218C90_DFAB7429_9E7882F5_3F007A8A_C1BC2FDE_BBDB8276
  };

  // Compile-time random bits for generation seed when no destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrNoneSeed = {
    256'h4E00B660_18476EC7_E9AE86D2_4FAC08B7_04A4D6DF_1792AD00_E16CC7C0_15D85290
  };

  ////////////////////////////////////////////
  // csrng
  ////////////////////////////////////////////
  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivNonProduction = {
    128'h553843B5_B6AF2BF8_AC41CB2B_75E15066,
    256'h39338BE5_DC0FA4BD_DBE5F3D5_A9F9386D_A84DDB0C_6EBD1E77_067A438F_6CB7F937
  };

  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivProduction = {
    128'hD1E60908_ABB1B5FA_56226EF0_EED9D76B,
    256'h62E7B4E4_466B9601_DBB4592F_F19842D5_1606FE22_B8ED0E3F_50759650_EF701A4E
  };

  ////////////////////////////////////////////
  // sram_ctrl_main
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlMainSramKey = {
    128'h6E4916EE_E56EF868_E4092F95_16CC8B20
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlMainSramNonce = {
    128'hBED74B6A_715B33CA_DB9092B1_125746C4
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlMainLfsrSeed = {
    32'h9F15A16A
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlMainLfsrPerm = {
    160'hC37B470B_885B2E62_43755653_2B3E603F_C31F6865
  };

  ////////////////////////////////////////////
  // rom_ctrl
  ////////////////////////////////////////////
  // Fixed nonce used for address / data scrambling
  parameter bit [63:0] RndCnstRomCtrlScrNonce = {
    64'hA7D4F4D7_F99B4A64
  };

  // Randomised constant used as a scrambling key for ROM data
  parameter bit [127:0] RndCnstRomCtrlScrKey = {
    128'h80DA2D53_E7CA1520_1A8F5653_0010117F
  };

  ////////////////////////////////////////////
  // rv_core_ibex
  ////////////////////////////////////////////
  // Default seed of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_seed_t RndCnstRvCoreIbexLfsrSeed = {
    32'h58C9E994
  };

  // Permutation applied to the LFSR of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_perm_t RndCnstRvCoreIbexLfsrPerm = {
    160'hCAD91A13_D77C0DBC_1D55E965_3D7D280B_ADC00C4D
  };

  // Default icache scrambling key
  parameter logic [ibex_pkg::SCRAMBLE_KEY_W-1:0] RndCnstRvCoreIbexIbexKeyDefault = {
    128'hBF2B89BE_218ECED8_859F464D_1D910540
  };

  // Default icache scrambling nonce
  parameter logic [ibex_pkg::SCRAMBLE_NONCE_W-1:0] RndCnstRvCoreIbexIbexNonceDefault = {
    64'hEEC6BA04_86F07CFF
  };

endpackage : top_earlgrey_rnd_cnst_pkg
