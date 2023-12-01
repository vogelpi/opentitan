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
    40'hF9_39792B44
  };

  // Compile-time random permutation for LFSR output
  parameter otp_ctrl_pkg::lfsr_perm_t RndCnstOtpCtrlLfsrPerm = {
    240'h6012_8634081A_85F58C79_C1642D78_889CF8C2_6E639D24_34A55594_04447513
  };

  // Compile-time random permutation for scrambling key/nonce register reset value
  parameter otp_ctrl_pkg::scrmbl_key_init_t RndCnstOtpCtrlScrmblKeyInit = {
    256'hA084A048_FFE9FB86_140A79D3_8055B24B_5F3B3EA7_9BD7F203_D55EABF9_F733D9B0
  };

  ////////////////////////////////////////////
  // lc_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivInvalid = {
    128'hCC2CA2B3_94F2526E_4430C2AF_B4F5B43B
  };

  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivTestDevRma = {
    128'h1667039C_6305BF98_3AF472A2_3DB96BE8
  };

  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivProduction = {
    128'h4FCF7DA0_C6D5CF43_B1EFE1DD_3BC5F603
  };

  // Compile-time random bits used for invalid tokens in the token mux
  parameter lc_ctrl_pkg::lc_token_mux_t RndCnstLcCtrlInvalidTokens = {
    256'h7B9DACA1_8EB5801C_444EBC53_EC27F13E_B602172C_4D950331_BEBAD605_BB696BE7,
    256'hA52B9A29_E3C871EE_416DC904_583DF8BA_E9C46DEE_80A869A1_CE14C113_994CF87E,
    256'hDA861406_51AC88EB_62E834AA_3425C620_C68CE201_20A0D95C_E4EE55B0_32C07A29,
    256'hB920B795_3E485F23_AD102C6A_0EFCE9F0_EC4C7121_46A4AB60_DA8B656E_ABB0B3EF
  };

  ////////////////////////////////////////////
  // alert_handler
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter alert_pkg::lfsr_seed_t RndCnstAlertHandlerLfsrSeed = {
    32'h6E9B197C
  };

  // Compile-time random permutation for LFSR output
  parameter alert_pkg::lfsr_perm_t RndCnstAlertHandlerLfsrPerm = {
    160'h199C4437_A0DD8B57_A439553F_7147C7C4_B4C5CE1C
  };

  ////////////////////////////////////////////
  // sram_ctrl_ret_aon
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlRetAonSramKey = {
    128'h14975D3D_2B32E933_D88E2E1C_F65460F2
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlRetAonSramNonce = {
    128'h3FB78049_9E6FCCE6_4CEAFD28_2C0E33FD
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlRetAonLfsrSeed = {
    32'h2C07986C
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlRetAonLfsrPerm = {
    160'h9E2904EC_20B54F9B_924D3710_CD0FABFC_5EEF0945
  };

  ////////////////////////////////////////////
  // flash_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for default address key
  parameter flash_ctrl_pkg::flash_key_t RndCnstFlashCtrlAddrKey = {
    128'h5F9355F5_A89085A9_5A12AB13_E0EC9CCD
  };

  // Compile-time random bits for default data key
  parameter flash_ctrl_pkg::flash_key_t RndCnstFlashCtrlDataKey = {
    128'h04512F5C_01D8958E_F421D22B_B7701362
  };

  // Compile-time random bits for default seeds
  parameter flash_ctrl_pkg::all_seeds_t RndCnstFlashCtrlAllSeeds = {
    256'h4B5A4BFF_0BDD4DD6_B30B717A_A80FF777_A157878A_468D23EE_CBD09DE6_B8F9FAEA,
    256'hF1A70E57_E8EDA03A_353B76A2_F833509A_CC7B3AA3_FA7DAC23_3E2B7823_06AF306A
  };

  // Compile-time random bits for initial LFSR seed
  parameter flash_ctrl_pkg::lfsr_seed_t RndCnstFlashCtrlLfsrSeed = {
    32'h1F36165E
  };

  // Compile-time random permutation for LFSR output
  parameter flash_ctrl_pkg::lfsr_perm_t RndCnstFlashCtrlLfsrPerm = {
    160'hB7BB97DE_81D1BF01_36A4C396_C8A87246_CA79813C
  };

  ////////////////////////////////////////////
  // aes
  ////////////////////////////////////////////
  // Default seed of the PRNG used for register clearing.
  parameter aes_pkg::clearing_lfsr_seed_t RndCnstAesClearingLfsrSeed = {
    64'h5627AC18_F377D907
  };

  // Permutation applied to the LFSR of the PRNG used for clearing.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingLfsrPerm = {
    128'h5535942E_1E120F1B_CE9F424F_B3F6F088,
    256'h0728AE6E_9E21FCA4_F42073DA_A810B984_5DDC465A_3075C5D4_A8ED379F_A5F29EC6
  };

  // Permutation applied to the clearing PRNG output for clearing the second share of registers.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingSharePerm = {
    128'h45F7A633_939D82EC_CFC22A41_4880945D,
    256'h956C1B66_2BF3B35A_E8A1E524_512DDFE8_DBC80E2A_BCB4F459_C9F5910F_7F8680F1
  };

  // Default seed of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_seed_t RndCnstAesMaskingLfsrSeed = {
    104'hE6_AEF30D85_77834CCC_6CAAA63A,
    256'h8E660433_8151B9A2_3C08F9EE_D04CA1EB_B0BDD305_FFB6C481_8054E0E0_EDB0ACD0
  };

  // Permutation applied to the concatenated LFSRs of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_perm_t RndCnstAesMaskingLfsrPerm = {
    168'h64_95090A00_F0568107_A348CC74_42C9A8AA_F7929E8B,
    256'hE4C249CA_AB369642_14D4A063_3D314826_A669ABE8_EAA82F18_AED86787_8753D8D3,
    256'h2F86899F_B0021C05_3E4605A6_E774F142_5E961372_B1E06033_649AC6FE_00C5896E,
    256'h9AC23057_373681C8_95688ACA_380E480B_C7036912_2A6A6298_B9191103_FB5E7CCE,
    256'h99171C50_451D9424_8F6D4154_86471D4E_9D0E16A4_5B87766B_B1281DA0_AEA66EB3,
    256'h743E8EED_2ED9E7E0_42002213_381F34E5_41986254_E75E5E55_CFCF13EA_89348695,
    256'h94194580_6B54A50A_209297E4_50FA7866_1A173107_ABB3B2C5_E618AE22_5388208C,
    256'h5566169D_4B502746_DB84DEA9_6F8EDDE6_05B30C48_B762C5DF_35121084_A63C1AA9,
    256'hCD6B57A4_A13B3027_22058C22_BA000129_783EA42F_C93B804A_65151A04_4E6528E8,
    256'hCCD64399_E0479663_45BD6257_4517A5EA_D465431E_053B91C7_C5C8C853_504B46E6,
    256'h8D204D0C_7E2057B1_AA41C183_2C68AD97_56D16855_82E04E83_7C06CE0D_930D31CE,
    256'hAB6A46AA_8F51B80A_0C710A01_8A3642D4_E41EE85A_3004749A_13ECF6F2_080C6483,
    256'h927A4958_A889D9A4_0D885A34_8F122B37_5A15960A_4EBE5B3A_D1508058_FBFE7B60
  };

  ////////////////////////////////////////////
  // kmac
  ////////////////////////////////////////////
  // Compile-time random data for LFSR default seed
  parameter kmac_pkg::lfsr_seed_t RndCnstKmacLfsrSeed = {
    32'h5C0CAE7E,
    256'hD7FE6C45_D1534FD3_90C7B068_CFE89687_94DE88E8_FF4ADC3D_02EBFA0A_1D5FAA5E,
    256'hE00CA534_911723E1_EA068740_2A816510_C535A816_4939D97D_F7421AD4_D2C18B27,
    256'h0D422EC3_9C41F727_D130ED9B_18B90E42_E4287F60_AD57D6A5_51E78F94_0B8AE9F2
  };

  // Compile-time random permutation for LFSR output
  parameter kmac_pkg::lfsr_perm_t RndCnstKmacLfsrPerm = {
    64'hA51D8722_2A50AA29,
    256'h019521C7_B9E1B7A9_CA39F141_186719FB_15852F85_34DD885D_D2E51345_9E679470,
    256'h42176675_59964A77_AEBB3BED_1130059E_F1225AE0_C1D18750_FBC00E86_80493C18,
    256'hBC282A27_85DC270B_6590A400_23A41E86_85DA1A12_6485903D_4A2A75FE_83563304,
    256'h370C145B_F93AB358_348C0EBC_6E170693_BDE5B779_5FA013E0_A237A34E_291E1F39,
    256'h9F78008C_4E0A43BA_DD03194B_28C55D4E_C6271157_19311441_19E9CC42_EBAD9702,
    256'h7099B4A4_B0753C16_DFCB183C_BE685B92_8B9397B0_65EF3618_58F60893_0AB268F6,
    256'h1C9F1AA0_CD3C953C_08F77851_00FDAC60_A61B9435_4FDA5169_2E0CA489_E69255E9,
    256'hF15C7A06_A0AB0CD7_C34A1935_4E619978_F96D552D_925E289A_4748D31A_1E57D9B5,
    256'h52870C90_D165968F_E58902BD_ADA48919_AE306B99_7434A118_693218CB_58171719,
    256'h5F8BF1C7_4A075454_3B8598A0_5D2B91A2_E352D773_AC51B253_C50252A9_330AC8FA,
    256'h3DB58CF1_E8F23574_A26C6184_8FCFA1B5_B87A90DB_ED776987_3BB08B59_9A720697,
    256'h97A581C5_3B5692A8_C5F3138A_95001667_B0C262BF_2345F78C_2DAAC4A9_499BAB8F,
    256'hC63CF355_AB216464_04C552CD_20C7E9AA_0F0F3AC2_95F84B34_CB2C0DBF_A54882EC,
    256'h92BC2C75_2929ACE2_2ADD1120_CACB8AF5_A21F57B2_BD3FD4B1_BA5F416D_FAF2F234,
    256'h10446E3A_8311C6BE_8A7E8333_E56E8B25_13911F91_1714B0B1_B60DC93E_EE4D9992,
    256'h11D33442_F1F57F73_6603AA56_32011591_9F41B089_DD8CA92B_49AC6614_7194BDD7,
    256'h72E1D2F9_F2B08BCB_A2B513E0_66F53D89_CDA72A15_61D73BAA_2998B014_D43D970C,
    256'h6BA4145E_8762BCBD_C71FFA99_DB2962DB_050E80E0_128130C6_DE033DA4_1888E31E,
    256'h6FB6C2C9_09BC8C93_1119253C_6A070EBE_540B8080_D9AC4062_52AC7080_4A589181,
    256'hC1E55567_24D8DAE6_E386DCF8_3D1A9146_AAB612A0_95BB7854_6C144926_8682DF02,
    256'h75EE04A7_3A10AEB2_CE505613_A6DB9405_C4B50447_F440BBC8_0AAA6A44_9095A947,
    256'h3E0B709C_7E1FDA81_595D5B2C_C9D82468_DBB49139_A466375A_662281B2_FC076BAB,
    256'hA22422A0_5E977031_4DECE0F8_CE9D0AD4_1CE1A65B_300E8747_580A95D9_8AC01788,
    256'hA690C860_341895C2_179E70A3_1465C878_85D171F1_43216D53_F5A23305_C64A0264,
    256'h6C0A6008_841BABD1_036619AB_F57C5AE3_08E1AB6F_8D575439_11CDFBCD_604D1B49,
    256'h424A3D2C_95470E7B_61E1A4ED_42EFA36C_7774304A_C0C26DA4_19D4B402_DC99BA67,
    256'h0D9DF792_54070023_000057B1_353D2D71_60418178_880C31AE_0E9CB163_2E7D9A04,
    256'hD6B42E8D_AD689619_606D037A_3B0258E5_E59CAA66_59FEC86A_4BAA7A09_8BE3988D,
    256'hFB0403A5_BDD1240C_4A255870_05E3A6CF_32AC45A4_6F35A6C1_20529904_25A0E0A8,
    256'h5B28914C_430E37D9_49A38384_9DF97180_FB709B14_C82975F4_955CC586_A35211EB,
    256'h9E7A27C4_36C6186A_AD32C0A8_BFD14254_0A140E70_9B0507C5_8C74B6AB_D0F622ED
  };

  // Compile-time random permutation for forwarding LFSR state
  parameter kmac_pkg::lfsr_fwd_perm_t RndCnstKmacLfsrFwdPerm = {
    160'hECEB102F_686A5838_49D915DF_EA58E50F_F8436958
  };

  // Compile-time random permutation for LFSR Message output
  parameter kmac_pkg::msg_perm_t RndCnstKmacMsgPerm = {
    128'hE3963FE8_9DC631FA_D1829D8B_65C757D0,
    256'hF0EE9ECE_F017C568_F6F4DE41_489ACEA1_E5C7E916_B6110D8C_8D723819_8200A49B
  };

  ////////////////////////////////////////////
  // otbn
  ////////////////////////////////////////////
  // Default seed of the PRNG used for URND.
  parameter otbn_pkg::urnd_prng_seed_t RndCnstOtbnUrndPrngSeed = {
    256'h992BFE5D_2E12489D_22504AA7_AC1C67F5_9CBA5482_C1E35E6E_3335C20C_C778FC30
  };

  // Compile-time random reset value for IMem/DMem scrambling key.
  parameter otp_ctrl_pkg::otbn_key_t RndCnstOtbnOtbnKey = {
    128'h9917B9C8_70ABE089_5D76F862_EF81F419
  };

  // Compile-time random reset value for IMem/DMem scrambling nonce.
  parameter otp_ctrl_pkg::otbn_nonce_t RndCnstOtbnOtbnNonce = {
    64'hE3C6CDC8_662C71EA
  };

  ////////////////////////////////////////////
  // keymgr
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter keymgr_pkg::lfsr_seed_t RndCnstKeymgrLfsrSeed = {
    64'hC141666E_443C6492
  };

  // Compile-time random permutation for LFSR output
  parameter keymgr_pkg::lfsr_perm_t RndCnstKeymgrLfsrPerm = {
    128'h61A6CECF_B5057011_229C298B_2A35BEB5,
    256'h5646CAC9_74C314FA_A0DE1142_103CFEBB_87D604A9_7DE33990_FDD70DD2_09ABDBF6
  };

  // Compile-time random permutation for entropy used in share overriding
  parameter keymgr_pkg::rand_perm_t RndCnstKeymgrRandPerm = {
    160'h6A7171BF_59A089F3_44303AE4_8E31C5EA_AD59F81B
  };

  // Compile-time random bits for revision seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrRevisionSeed = {
    256'h31BBC9A8_C73FC4CC_3D14CA6B_C0B96812_DE7C775A_54FF1934_3CB32040_B3490768
  };

  // Compile-time random bits for creator identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrCreatorIdentitySeed = {
    256'h889D27E0_BA8588D3_4C05BCF1_27DAE58B_65D6A251_088099B3_7107B1CC_CF1A955F
  };

  // Compile-time random bits for owner intermediate identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrOwnerIntIdentitySeed = {
    256'h03DE1A84_47BF83B6_9C50E149_CF51784A_9D7AC691_306E5C56_CE38CD7D_7E3B1ABF
  };

  // Compile-time random bits for owner identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrOwnerIdentitySeed = {
    256'hB7978189_A21AE856_F1D908E3_F70DE343_D2226E9E_864465A8_EE55EC0E_6A296789
  };

  // Compile-time random bits for software generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrSoftOutputSeed = {
    256'hDED5C0AF_59EE62F1_FD1BBEBE_AC2205B1_FA5E94E7_2EB7EB1A_713AD15D_2565D9AB
  };

  // Compile-time random bits for hardware generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrHardOutputSeed = {
    256'h4FBCD2E1_7C406F48_D1401F8A_6A52286F_6954C27A_9AEFBE0B_C9EE440C_514CCACB
  };

  // Compile-time random bits for generation seed when aes destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrAesSeed = {
    256'h019995F3_1FA95885_9293C559_1AE604A9_2A303760_EB8D7785_A7BBDCE1_D6A02B6F
  };

  // Compile-time random bits for generation seed when kmac destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrKmacSeed = {
    256'h0F24F5DB_8EF02F9F_B0A4023D_8F96A41F_062BB66B_228701E8_317CD4BF_08BD6684
  };

  // Compile-time random bits for generation seed when otbn destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrOtbnSeed = {
    256'hA1D596CC_57E137A0_321FB803_BFD2DE7A_90A1357E_743CE460_442C1068_6E82613D
  };

  // Compile-time random bits for generation seed when no CDI is selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrCdi = {
    256'hE0806DDE_1D35AD61_60EE7EF4_8222DAD7_2D4D6289_EDD5F001_DCD40958_90A290A9
  };

  // Compile-time random bits for generation seed when no destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrNoneSeed = {
    256'hB632F039_5D11CAC7_F7E9E764_ADD7EDE2_32A4E00D_ABF1D1D2_AD2E2A51_33F6A12F
  };

  ////////////////////////////////////////////
  // csrng
  ////////////////////////////////////////////
  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivNonProduction = {
    128'hF2EC1569_BEF1F0B9_24C470AC_5A998099,
    256'h85DC415B_A1EACED3_82D54C9E_378D030E_A5D37665_D43A035F_4EA1E463_032A3A8E
  };

  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivProduction = {
    128'h24B4547F_8B0DB0C7_7E902776_B104C3A9,
    256'hDA020306_21A4D3D7_3871FDAF_5AD0C1DD_1E95F99D_7129CA68_61A4425B_9CC42EDB
  };

  ////////////////////////////////////////////
  // sram_ctrl_main
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlMainSramKey = {
    128'hA88A15B7_52539FB8_E598F891_C2BD3162
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlMainSramNonce = {
    128'h77126EA6_934D3749_740A7CE7_C92A49F7
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlMainLfsrSeed = {
    32'h1747D5A7
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlMainLfsrPerm = {
    160'h1B551D67_7E7C926B_F58B1070_485413A1_CAE47EDC
  };

  ////////////////////////////////////////////
  // rom_ctrl
  ////////////////////////////////////////////
  // Fixed nonce used for address / data scrambling
  parameter bit [63:0] RndCnstRomCtrlScrNonce = {
    64'h8B146F61_6B608246
  };

  // Randomised constant used as a scrambling key for ROM data
  parameter bit [127:0] RndCnstRomCtrlScrKey = {
    128'h5E44680C_E93649A8_4575B465_479F31A9
  };

  ////////////////////////////////////////////
  // rv_core_ibex
  ////////////////////////////////////////////
  // Default seed of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_seed_t RndCnstRvCoreIbexLfsrSeed = {
    32'h75234377
  };

  // Permutation applied to the LFSR of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_perm_t RndCnstRvCoreIbexLfsrPerm = {
    160'hC324DDDB_C38A1D7F_8B4783C8_9AF67905_14B3143C
  };

  // Default icache scrambling key
  parameter logic [ibex_pkg::SCRAMBLE_KEY_W-1:0] RndCnstRvCoreIbexIbexKeyDefault = {
    128'h77A65B1A_AD174DD4_1ACA70D3_807BA54E
  };

  // Default icache scrambling nonce
  parameter logic [ibex_pkg::SCRAMBLE_NONCE_W-1:0] RndCnstRvCoreIbexIbexNonceDefault = {
    64'h793023FA_711994CC
  };

endpackage : top_earlgrey_rnd_cnst_pkg
