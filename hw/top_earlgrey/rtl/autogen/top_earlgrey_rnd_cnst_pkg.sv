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
    40'h9B_54CB121F
  };

  // Compile-time random permutation for LFSR output
  parameter otp_ctrl_pkg::lfsr_perm_t RndCnstOtpCtrlLfsrPerm = {
    240'h98E2_882519C6_32459B2E_065A1E26_174DD3D2_0A50D48C_455035F8_4578101C
  };

  // Compile-time random permutation for scrambling key/nonce register reset value
  parameter otp_ctrl_pkg::scrmbl_key_init_t RndCnstOtpCtrlScrmblKeyInit = {
    256'h4ECD8C03_2462B3E1_8549CB1E_70D5A83D_E6673D2C_1C0A7B55_176264E5_5C329C8A
  };

  ////////////////////////////////////////////
  // lc_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivInvalid = {
    128'hE4725AEA_F6728150_127AC755_D7006327
  };

  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivTestDevRma = {
    128'h7642B530_9A163990_B966CD49_4444C3BC
  };

  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivProduction = {
    128'hDF8087B7_FACD65E9_654CD85B_C66D1020
  };

  // Compile-time random bits used for invalid tokens in the token mux
  parameter lc_ctrl_pkg::lc_token_mux_t RndCnstLcCtrlInvalidTokens = {
    256'h8C4FB51B_97BBF4D1_2C378CCF_D6A5A5BF_3032DB51_FA1EB92F_6CE10E90_F9C5C06F,
    256'h733DC911_A321DD4C_0AC2406D_467215DA_B3F2B54A_52E67286_78AF0718_068E344D,
    256'h2EAE4D73_C8FA54DE_8AA4A4F2_58F3B2A1_45FD1950_AE55D693_E5796811_7E66DC63,
    256'h4155E0F8_15024286_2EB20EEA_9A1F7544_71655151_2A112DED_678CE824_A08E29C7
  };

  ////////////////////////////////////////////
  // alert_handler
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter alert_pkg::lfsr_seed_t RndCnstAlertHandlerLfsrSeed = {
    32'h72795A35
  };

  // Compile-time random permutation for LFSR output
  parameter alert_pkg::lfsr_perm_t RndCnstAlertHandlerLfsrPerm = {
    160'h44CF9FB5_8B712090_29F2B7B8_22DE86DF_6BA18711
  };

  ////////////////////////////////////////////
  // sram_ctrl_ret_aon
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlRetAonSramKey = {
    128'hD1095889_FBD8A7B5_7FB1E11D_F367C1C1
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlRetAonSramNonce = {
    128'hEDE3F35C_FC8F6E72_ABDD73A9_EEFBF8B7
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlRetAonLfsrSeed = {
    32'h081EB9F6
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlRetAonLfsrPerm = {
    160'hFE3A112E_29F49E45_5808835D_99968CBE_C7AA9F86
  };

  ////////////////////////////////////////////
  // flash_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for default address key
  parameter flash_ctrl_pkg::flash_key_t RndCnstFlashCtrlAddrKey = {
    128'h9A6F99B1_A7AC0842_24ADE461_2980D48E
  };

  // Compile-time random bits for default data key
  parameter flash_ctrl_pkg::flash_key_t RndCnstFlashCtrlDataKey = {
    128'h6C6493A5_0EEDBAC6_A46B7A8A_9B2C7AEC
  };

  // Compile-time random bits for default seeds
  parameter flash_ctrl_pkg::all_seeds_t RndCnstFlashCtrlAllSeeds = {
    256'h92F39E49_478C398C_91DB1841_831B1F5C_82A55609_6FFF6175_FC10F939_792B444E,
    256'h521D4711_E6406690_8ADFD591_8F8C563C_92184F1C_76A61E11_2578BF9F_469FC482
  };

  // Compile-time random bits for initial LFSR seed
  parameter flash_ctrl_pkg::lfsr_seed_t RndCnstFlashCtrlLfsrSeed = {
    32'hFA14A8F2
  };

  // Compile-time random permutation for LFSR output
  parameter flash_ctrl_pkg::lfsr_perm_t RndCnstFlashCtrlLfsrPerm = {
    160'h3B1F1170_D2D85BDC_A1542D46_0BC1C9C6_BF3F1176
  };

  ////////////////////////////////////////////
  // aes
  ////////////////////////////////////////////
  // Default seed of the PRNG used for register clearing.
  parameter aes_pkg::clearing_lfsr_seed_t RndCnstAesClearingLfsrSeed = {
    64'h3B3EA79B_D7F203D5
  };

  // Permutation applied to the LFSR of the PRNG used for clearing.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingLfsrPerm = {
    128'h346D6424_A752C66F_D50AFE04_E4343282,
    256'h18E97875_88FA2DF4_7D368F73_B0589C06_453AEB6B_C3C45B52_5EA82F3B_3633DA97
  };

  // Permutation applied to the clearing PRNG output for clearing the second share of registers.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingSharePerm = {
    128'h352C351E_B2238AC0_C93B4942_BD9DCB5C,
    256'h07989ED9_0631D455_531EA17D_3E04168F_2A833F8F_5BFD9B41_CCBB98AA_79F5AB81
  };

  // Default seed of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_seed_t RndCnstAesMaskingLfsrSeed = {
    32'hE9F0EC4C,
    256'h712146A4_AB60DA8B_656EABB0_B3EF6E9B_197CE582_FC9B5965_D697C23B_EAFE8389
  };

  // Permutation applied to the concatenated LFSRs of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_perm_t RndCnstAesMaskingLfsrPerm = {
    256'h1A695301_8D0A1F40_7A46869E_434A6366_73717976_9406249B_4458057B_04650F30,
    256'h41707D0C_345E0D6A_67573B29_276B2393_2261914B_1D78971E_873E2C35_1337959D,
    256'h4F25314D_387F1081_92886E74_5B4E092D_6D485582_998F728A_856C5C02_9C1B3A68,
    256'h64214218_5F8B2089_50840E08_2F629F47_8C392A0B_28153683_037C1907_168E7E75,
    256'h4C6F4980_3F60541C_9833322B_3D5D1456_7745009A_26905952_2E961151_125A3C17
  };

  ////////////////////////////////////////////
  // kmac
  ////////////////////////////////////////////
  // Compile-time random data for PRNG default seed
  parameter kmac_pkg::lfsr_seed_t RndCnstKmacLfsrSeed = {
    32'h4645AAD1,
    256'hFB21C181_24635E3D_50A88F68_08045627_AC18F377_D9071BEC_A6F194EF_96F3E535
  };

  // Compile-time random permutation for PRNG output
  parameter kmac_pkg::lfsr_perm_t RndCnstKmacLfsrPerm = {
    64'h7343288A_4950317B,
    256'h4E5C4A1B_C6D83E23_6531A47C_90891B0D_E03CC998_242AAA14_EAD444B3_55DA3AAF,
    256'h8C9AC1A1_2F179AA3_B4947ACF_0C1888BE_E7876072_19040319_C952D457_0D007E6B,
    256'h00528CA4_E996660A_39E836EE_855797C7_957DB4AC_F4364305_8672CE56_931804B0,
    256'h9C8D13A4_60C3C2D9_0AF58990_42D4656B_0945F88E_2D8FAA71_FCB16590_6B2D7726,
    256'h0270359A_6A15573D_CC3E67F2_E67A898D_202D1575_AE87C4F7_165373BA_7E5A9759,
    256'hEEBFBA8A_D025746E_4A158DCB_BC5D391E_ED341272_8A7422C3_3807029B_4752812B,
    256'h0AEF30E1_C86C2F70_546CB92A_95351A42_5053C59B_604EC965_CA0625E2_D8BF1392,
    256'h43058BB1_D9D9CEFD_0FEA59BC_9E5E188C_32172316_414ACC04_8067A095_6327D35C,
    256'h793FC843_14CB9D69_112E146A_CE15F80A_4C687145_A0B84BAB_C0200785_784AE77B,
    256'h21149690_2ED6C69E_51BE8E92_6CAA046B_2370505B_D7A8E20E_79CD1198_2E325013,
    256'h22E07515_6870DD48_C817DAB9_808BE2D5_D58B06A8_7A0C92DD_1BD99526_8DA1EAAB,
    256'h684F697C_341D8858_6C6DA556_864EF550_CDB4828F_96CE489C_EF3C9920_39ED1800,
    256'h02BDA629_E2538B14_0C158440_61709DFA_0B1B5C66_B4D2BB35_9B446D70_68D9E301,
    256'h618611DC_2A3A8BAD_A8A6DE4F_E448F6E6_412E2471_D28BC087_F4B73A04_818A1D2B,
    256'h2810BED8_59C65589_7B0DC6B4_D8249631_F67307C7_1C59A112_298861C4_FB65D476,
    256'hEA403F0E_3BF22A13_677105C6_AF0FA78A_AC8D8B09_98A423E9_AB104F8A_2DD430D5,
    256'h5A5E6C3E_E922A617_4028B941_37B80F7C_1B1A7305_55C87311_7680F042_8DAD994F,
    256'hEC463C76_607C7701_9C1A58C5_B2249508_20CA1550_E11D2252_AF4B0716_B7E50446,
    256'hCA4B5FC5_82C027DF_4361AF57_2353825D_34CC24A9_BFC26801_607E71D3_9202A12B,
    256'h80160B03_ACDE1918_4AA62003_3031B247_D8853388_01D125DB_2F03963A_1007DF70,
    256'hA5FAB42A_6294E661_9796CE60_B54DEAC5_E41EE79B_18901BF0_D3F6F942_28AB7308,
    256'hC56F875E_A308496A_FA96A828_95BA3937_DFB7D61A_50835521_29AB69E8_2C034F04,
    256'h631D4481_5BE42994_24C1942D_4C351AE4_ECB2A100_22A20FBC_AEF22664_9F126598,
    256'h9D5FCF8C_49B56346_E041F20F_507AE10F_B5E8B892_63B6D5A5_44363665_41713E09,
    256'h9839B1F8_C3AFF917_13645A41_52D49380_58FE4D87_EEE8AEB7_525DE7A5_3057DB79,
    256'h9DDD1D1C_E8EDF3C6_007B8C5A_C64CF089_5BA903B0_6DB868A8_65CE5716_F102E294,
    256'h98A9B10A_5A0F0826_16CEB21C_476A4AAE_91456463_7BCEB810_2C85AB67_A98F6F4C,
    256'hDA766E4B_9FE95692_485547FE_B44F5C19_48F478C7_88CC8E86_6A2B169F_62903B09,
    256'h53818174_C823A214_6339983A_AAA83615_5497245C_E5920735_3CF51326_91581A9D,
    256'h80C594A9_9A87725F_1A702304_D6AE4E16_D9C64FC0_2130E941_A36EB772_D147E722,
    256'h0CB4A5ED_9010BDC7_A3745AEC_6101C14D_1E4099FB_F98744C4_510DA91C_05D2AED6
  };

  // Compile-time random data for PRNG buffer default seed
  parameter kmac_pkg::buffer_lfsr_seed_t RndCnstKmacBufferLfsrSeed = {
    32'h464D1D91,
    256'h0540EEC6_BA0486F0_7CFFAF7B_8B9213BD_8DC7B927_797C09DF_EAF1272B_92ABC409,
    256'h056CFA51_3AED0DE2_186C2B2A_4874E4AD_ACA4C680_9E571B35_1756BF8D_18E24BE7,
    256'hE1C96737_B726A4C6_F04993B3_E6AAE70F_22AAF748_B57C3202_64E157E2_C74A2803
  };

  // Compile-time random permutation for LFSR Message output
  parameter kmac_pkg::msg_perm_t RndCnstKmacMsgPerm = {
    128'h682670D0_3594FA0F_1D4A18F8_022BA72C,
    256'hEBEC7CD9_5CA2DDFF_279A5317_21FAC4AA_E647591E_CC6D8F40_8A955C11_3D6FB60C
  };

  ////////////////////////////////////////////
  // otbn
  ////////////////////////////////////////////
  // Default seed of the PRNG used for URND.
  parameter otbn_pkg::urnd_prng_seed_t RndCnstOtbnUrndPrngSeed = {
    256'h465EFE57_AA3B59BD_6B0A4021_6363420F_041ED29A_965B68FA_EA3E59D4_F2E2A0B4
  };

  // Compile-time random reset value for IMem/DMem scrambling key.
  parameter otp_ctrl_pkg::otbn_key_t RndCnstOtbnOtbnKey = {
    128'h2EB9A8C3_AB227B50_766D2EAE_C89EB13B
  };

  // Compile-time random reset value for IMem/DMem scrambling nonce.
  parameter otp_ctrl_pkg::otbn_nonce_t RndCnstOtbnOtbnNonce = {
    64'h07E9BF4E_E4278413
  };

  ////////////////////////////////////////////
  // keymgr
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter keymgr_pkg::lfsr_seed_t RndCnstKeymgrLfsrSeed = {
    64'h6D42C85E_456F3B26
  };

  // Compile-time random permutation for LFSR output
  parameter keymgr_pkg::lfsr_perm_t RndCnstKeymgrLfsrPerm = {
    128'h67DFF577_9DF3AEA6_1CE14690_B285A917,
    256'h1EA43910_237CFC1B_0A2C8682_D101F870_F6ED3352_3272882F_C949BDE9_AE8555F4
  };

  // Compile-time random permutation for entropy used in share overriding
  parameter keymgr_pkg::rand_perm_t RndCnstKeymgrRandPerm = {
    160'h341C41F2_9ADF4058_A907F3EA_297C295E_18DBCED9
  };

  // Compile-time random bits for revision seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrRevisionSeed = {
    256'h576CA8A8_225C8E17_053E44B6_8DD7822A_6859F2CF_52A55FD1_81B082D0_3C583756
  };

  // Compile-time random bits for creator identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrCreatorIdentitySeed = {
    256'hF11AA5B3_7F9544C4_AA90EB97_E1C0F808_6F627A28_1C5681D6_566641EE_CCCC8887
  };

  // Compile-time random bits for owner intermediate identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrOwnerIntIdentitySeed = {
    256'h6AD113C5_0AD1BE4D_94DCE8FC_A54128A3_860AE1D3_493FBEF6_B9BA5DFE_4463A461
  };

  // Compile-time random bits for owner identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrOwnerIdentitySeed = {
    256'h5EF46762_A794A8C2_597E69FB_259B9619_14CD75BB_FD36BA48_E780D27C_D582540C
  };

  // Compile-time random bits for software generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrSoftOutputSeed = {
    256'h7A68FF25_4EDFD852_829FECCC_ABD4AF9C_9032DA20_BDAF59FE_2AE209B8_325D2C8C
  };

  // Compile-time random bits for hardware generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrHardOutputSeed = {
    256'h35FC9606_79B106A8_7E59E6AE_B1B5302D_33401070_251696FB_B4BA169A_6CD82FAD
  };

  // Compile-time random bits for generation seed when aes destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrAesSeed = {
    256'h46A0A5C0_4009BB93_4C7EF7B8_3B6E4061_0B4309FC_B9DC54D4_276137F9_901D09A7
  };

  // Compile-time random bits for generation seed when kmac destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrKmacSeed = {
    256'h6AEAA19D_E5C579FD_38BDF38F_0C21D6A5_2226B6A4_A7BDB05F_E921615B_F2FF9845
  };

  // Compile-time random bits for generation seed when otbn destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrOtbnSeed = {
    256'h40F7D43E_CE76B4EB_13363774_ED2ED455_45E927F6_D9E4ABAC_398D42C7_45EEF646
  };

  // Compile-time random bits for generation seed when no CDI is selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrCdi = {
    256'hC1464DCA_86DAFD7C_7C71E605_8DDFD871_C51CACBA_F4410F06_DCC036FC_D16FCDE9
  };

  // Compile-time random bits for generation seed when no destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrNoneSeed = {
    256'h7D171891_105DD895_E3A1D0A1_9A16D6DB_D8B20FC9_E662E1E1_B4982B3E_8EFF6389
  };

  ////////////////////////////////////////////
  // csrng
  ////////////////////////////////////////////
  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivNonProduction = {
    128'h0DBEAE92_6FD468A7_7EFDE3DE_5B4CAF47,
    256'h76A247BA_BA4C9908_ED16BC54_15EC16D2_8C535513_12FCEDCF_2832A66C_EACF8ED4
  };

  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivProduction = {
    128'hD5B61617_7DD43B56_FA754E1F_53AD6581,
    256'h93B563D9_BDC6D2AE_E84852F0_CC7371ED_3A6FAA51_6C144B34_C96DFABB_6F6E7920
  };

  ////////////////////////////////////////////
  // sram_ctrl_main
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlMainSramKey = {
    128'h8A74F35C_79F397C4_E4C7E22B_7581848A
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlMainSramNonce = {
    128'h90A1254B_2276BEC9_FC1A7A57_22A9AACA
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlMainLfsrSeed = {
    32'h4DB84A32
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlMainLfsrPerm = {
    160'h7CB60455_500E897A_15A977BB_93DBF111_9835CF1C
  };

  ////////////////////////////////////////////
  // rom_ctrl
  ////////////////////////////////////////////
  // Fixed nonce used for address / data scrambling
  parameter bit [63:0] RndCnstRomCtrlScrNonce = {
    64'hCC69A214_7819B290
  };

  // Randomised constant used as a scrambling key for ROM data
  parameter bit [127:0] RndCnstRomCtrlScrKey = {
    128'hA4BB0264_347C0F91_B0CEC93C_0129D85B
  };

  ////////////////////////////////////////////
  // rv_core_ibex
  ////////////////////////////////////////////
  // Default seed of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_seed_t RndCnstRvCoreIbexLfsrSeed = {
    32'h95801DBE
  };

  // Permutation applied to the LFSR of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_perm_t RndCnstRvCoreIbexLfsrPerm = {
    160'h4093FA68_A3C595C3_DCD2AC19_972E33E8_49B6BFC0
  };

  // Default icache scrambling key
  parameter logic [ibex_pkg::SCRAMBLE_KEY_W-1:0] RndCnstRvCoreIbexIbexKeyDefault = {
    128'h8E7026D0_E5DCE9E2_65A416A8_12231CFA
  };

  // Default icache scrambling nonce
  parameter logic [ibex_pkg::SCRAMBLE_NONCE_W-1:0] RndCnstRvCoreIbexIbexNonceDefault = {
    64'h76E3D982_F8FDCEC9
  };

endpackage : top_earlgrey_rnd_cnst_pkg
