// Copyright lowRISC contributors (OpenTitan project).
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

package top_earlgrey_pkg;
  /**
   * Peripheral base address for uart0 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_UART0_BASE_ADDR = 32'h40000000;

  /**
   * Peripheral size in bytes for uart0 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_UART0_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for uart1 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_UART1_BASE_ADDR = 32'h40010000;

  /**
   * Peripheral size in bytes for uart1 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_UART1_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for uart2 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_UART2_BASE_ADDR = 32'h40020000;

  /**
   * Peripheral size in bytes for uart2 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_UART2_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for uart3 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_UART3_BASE_ADDR = 32'h40030000;

  /**
   * Peripheral size in bytes for uart3 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_UART3_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for gpio in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_GPIO_BASE_ADDR = 32'h40040000;

  /**
   * Peripheral size in bytes for gpio in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_GPIO_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for spi_device in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SPI_DEVICE_BASE_ADDR = 32'h40050000;

  /**
   * Peripheral size in bytes for spi_device in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SPI_DEVICE_SIZE_BYTES = 32'h2000;

  /**
   * Peripheral base address for i2c0 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_I2C0_BASE_ADDR = 32'h40080000;

  /**
   * Peripheral size in bytes for i2c0 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_I2C0_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for i2c1 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_I2C1_BASE_ADDR = 32'h40090000;

  /**
   * Peripheral size in bytes for i2c1 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_I2C1_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for i2c2 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_I2C2_BASE_ADDR = 32'h400A0000;

  /**
   * Peripheral size in bytes for i2c2 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_I2C2_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for pattgen in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_PATTGEN_BASE_ADDR = 32'h400E0000;

  /**
   * Peripheral size in bytes for pattgen in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_PATTGEN_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for rv_timer in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_TIMER_BASE_ADDR = 32'h40100000;

  /**
   * Peripheral size in bytes for rv_timer in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_TIMER_SIZE_BYTES = 32'h200;

  /**
   * Peripheral base address for core device on otp_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_OTP_CTRL_CORE_BASE_ADDR = 32'h40130000;

  /**
   * Peripheral size in bytes for core device on otp_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_OTP_CTRL_CORE_SIZE_BYTES = 32'h1000;

  /**
   * Peripheral base address for prim device on otp_macro in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_OTP_MACRO_PRIM_BASE_ADDR = 32'h40138000;

  /**
   * Peripheral size in bytes for prim device on otp_macro in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_OTP_MACRO_PRIM_SIZE_BYTES = 32'h20;

  /**
   * Peripheral base address for regs device on lc_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_LC_CTRL_REGS_BASE_ADDR = 32'h40140000;

  /**
   * Peripheral size in bytes for regs device on lc_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_LC_CTRL_REGS_SIZE_BYTES = 32'h100;

  /**
   * Peripheral base address for dmi device on lc_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_LC_CTRL_DMI_BASE_ADDR = 32'h0;

  /**
   * Peripheral size in bytes for dmi device on lc_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_LC_CTRL_DMI_SIZE_BYTES = 32'h1000;

  /**
   * Peripheral base address for alert_handler in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ALERT_HANDLER_BASE_ADDR = 32'h40150000;

  /**
   * Peripheral size in bytes for alert_handler in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ALERT_HANDLER_SIZE_BYTES = 32'h800;

  /**
   * Peripheral base address for spi_host0 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SPI_HOST0_BASE_ADDR = 32'h40300000;

  /**
   * Peripheral size in bytes for spi_host0 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SPI_HOST0_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for spi_host1 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SPI_HOST1_BASE_ADDR = 32'h40310000;

  /**
   * Peripheral size in bytes for spi_host1 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SPI_HOST1_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for usbdev in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_USBDEV_BASE_ADDR = 32'h40320000;

  /**
   * Peripheral size in bytes for usbdev in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_USBDEV_SIZE_BYTES = 32'h1000;

  /**
   * Peripheral base address for pwrmgr_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_PWRMGR_AON_BASE_ADDR = 32'h40400000;

  /**
   * Peripheral size in bytes for pwrmgr_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_PWRMGR_AON_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for rstmgr_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RSTMGR_AON_BASE_ADDR = 32'h40410000;

  /**
   * Peripheral size in bytes for rstmgr_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RSTMGR_AON_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for clkmgr_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_CLKMGR_AON_BASE_ADDR = 32'h40420000;

  /**
   * Peripheral size in bytes for clkmgr_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_CLKMGR_AON_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for sysrst_ctrl_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SYSRST_CTRL_AON_BASE_ADDR = 32'h40430000;

  /**
   * Peripheral size in bytes for sysrst_ctrl_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SYSRST_CTRL_AON_SIZE_BYTES = 32'h100;

  /**
   * Peripheral base address for adc_ctrl_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ADC_CTRL_AON_BASE_ADDR = 32'h40440000;

  /**
   * Peripheral size in bytes for adc_ctrl_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ADC_CTRL_AON_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for pwm_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_PWM_AON_BASE_ADDR = 32'h40450000;

  /**
   * Peripheral size in bytes for pwm_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_PWM_AON_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for pinmux_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_PINMUX_AON_BASE_ADDR = 32'h40460000;

  /**
   * Peripheral size in bytes for pinmux_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_PINMUX_AON_SIZE_BYTES = 32'h1000;

  /**
   * Peripheral base address for aon_timer_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_AON_TIMER_AON_BASE_ADDR = 32'h40470000;

  /**
   * Peripheral size in bytes for aon_timer_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_AON_TIMER_AON_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for ast in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_AST_BASE_ADDR = 32'h40480000;

  /**
   * Peripheral size in bytes for ast in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_AST_SIZE_BYTES = 32'h400;

  /**
   * Peripheral base address for sensor_ctrl_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SENSOR_CTRL_AON_BASE_ADDR = 32'h40490000;

  /**
   * Peripheral size in bytes for sensor_ctrl_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SENSOR_CTRL_AON_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for regs device on sram_ctrl_ret_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SRAM_CTRL_RET_AON_REGS_BASE_ADDR = 32'h40500000;

  /**
   * Peripheral size in bytes for regs device on sram_ctrl_ret_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SRAM_CTRL_RET_AON_REGS_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for ram device on sram_ctrl_ret_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SRAM_CTRL_RET_AON_RAM_BASE_ADDR = 32'h40600000;

  /**
   * Peripheral size in bytes for ram device on sram_ctrl_ret_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SRAM_CTRL_RET_AON_RAM_SIZE_BYTES = 32'h1000;

  /**
   * Peripheral base address for core device on flash_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_FLASH_CTRL_CORE_BASE_ADDR = 32'h41000000;

  /**
   * Peripheral size in bytes for core device on flash_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_FLASH_CTRL_CORE_SIZE_BYTES = 32'h200;

  /**
   * Peripheral base address for prim device on flash_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_FLASH_CTRL_PRIM_BASE_ADDR = 32'h41008000;

  /**
   * Peripheral size in bytes for prim device on flash_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_FLASH_CTRL_PRIM_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for mem device on flash_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_FLASH_CTRL_MEM_BASE_ADDR = 32'h20000000;

  /**
   * Peripheral size in bytes for mem device on flash_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_FLASH_CTRL_MEM_SIZE_BYTES = 32'h100000;

  /**
   * Peripheral base address for regs device on rv_dm in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_DM_REGS_BASE_ADDR = 32'h41200000;

  /**
   * Peripheral size in bytes for regs device on rv_dm in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_DM_REGS_SIZE_BYTES = 32'h10;

  /**
   * Peripheral base address for mem device on rv_dm in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_DM_MEM_BASE_ADDR = 32'h10000;

  /**
   * Peripheral size in bytes for mem device on rv_dm in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_DM_MEM_SIZE_BYTES = 32'h1000;

  /**
   * Peripheral base address for dbg device on rv_dm in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_DM_DBG_BASE_ADDR = 32'h1000;

  /**
   * Peripheral size in bytes for dbg device on rv_dm in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_DM_DBG_SIZE_BYTES = 32'h200;

  /**
   * Peripheral base address for rv_plic in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_PLIC_BASE_ADDR = 32'h48000000;

  /**
   * Peripheral size in bytes for rv_plic in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_PLIC_SIZE_BYTES = 32'h8000000;

  /**
   * Peripheral base address for aes in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_AES_BASE_ADDR = 32'h41100000;

  /**
   * Peripheral size in bytes for aes in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_AES_SIZE_BYTES = 32'h100;

  /**
   * Peripheral base address for hmac in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_HMAC_BASE_ADDR = 32'h41110000;

  /**
   * Peripheral size in bytes for hmac in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_HMAC_SIZE_BYTES = 32'h2000;

  /**
   * Peripheral base address for kmac in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_KMAC_BASE_ADDR = 32'h41120000;

  /**
   * Peripheral size in bytes for kmac in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_KMAC_SIZE_BYTES = 32'h1000;

  /**
   * Peripheral base address for otbn in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_OTBN_BASE_ADDR = 32'h41130000;

  /**
   * Peripheral size in bytes for otbn in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_OTBN_SIZE_BYTES = 32'h10000;

  /**
   * Peripheral base address for keymgr in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_KEYMGR_BASE_ADDR = 32'h41140000;

  /**
   * Peripheral size in bytes for keymgr in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_KEYMGR_SIZE_BYTES = 32'h100;

  /**
   * Peripheral base address for csrng in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_CSRNG_BASE_ADDR = 32'h41150000;

  /**
   * Peripheral size in bytes for csrng in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_CSRNG_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for entropy_src in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ENTROPY_SRC_BASE_ADDR = 32'h41160000;

  /**
   * Peripheral size in bytes for entropy_src in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ENTROPY_SRC_SIZE_BYTES = 32'h100;

  /**
   * Peripheral base address for edn0 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_EDN0_BASE_ADDR = 32'h41170000;

  /**
   * Peripheral size in bytes for edn0 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_EDN0_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for edn1 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_EDN1_BASE_ADDR = 32'h41180000;

  /**
   * Peripheral size in bytes for edn1 in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_EDN1_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for regs device on sram_ctrl_main in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SRAM_CTRL_MAIN_REGS_BASE_ADDR = 32'h411C0000;

  /**
   * Peripheral size in bytes for regs device on sram_ctrl_main in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SRAM_CTRL_MAIN_REGS_SIZE_BYTES = 32'h40;

  /**
   * Peripheral base address for ram device on sram_ctrl_main in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SRAM_CTRL_MAIN_RAM_BASE_ADDR = 32'h10000000;

  /**
   * Peripheral size in bytes for ram device on sram_ctrl_main in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_SRAM_CTRL_MAIN_RAM_SIZE_BYTES = 32'h20000;

  /**
   * Peripheral base address for regs device on rom_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ROM_CTRL_REGS_BASE_ADDR = 32'h411E0000;

  /**
   * Peripheral size in bytes for regs device on rom_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ROM_CTRL_REGS_SIZE_BYTES = 32'h80;

  /**
   * Peripheral base address for rom device on rom_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ROM_CTRL_ROM_BASE_ADDR = 32'h8000;

  /**
   * Peripheral size in bytes for rom device on rom_ctrl in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ROM_CTRL_ROM_SIZE_BYTES = 32'h8000;

  /**
   * Peripheral base address for cfg device on rv_core_ibex in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_CORE_IBEX_CFG_BASE_ADDR = 32'h411F0000;

  /**
   * Peripheral size in bytes for cfg device on rv_core_ibex in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RV_CORE_IBEX_CFG_SIZE_BYTES = 32'h100;

  /**
   * Memory base address for ram_ret_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RAM_RET_AON_BASE_ADDR = 32'h40600000;

  /**
   * Memory size for ram_ret_aon in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RAM_RET_AON_SIZE_BYTES = 32'h1000;

  /**
   * Memory base address for eflash in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_EFLASH_BASE_ADDR = 32'h20000000;

  /**
   * Memory size for eflash in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_EFLASH_SIZE_BYTES = 32'h100000;

  /**
   * Memory base address for ram_main in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RAM_MAIN_BASE_ADDR = 32'h10000000;

  /**
   * Memory size for ram_main in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_RAM_MAIN_SIZE_BYTES = 32'h20000;

  /**
   * Memory base address for rom in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ROM_BASE_ADDR = 32'h8000;

  /**
   * Memory size for rom in top earlgrey.
   */
  parameter int unsigned TOP_EARLGREY_ROM_SIZE_BYTES = 32'h8000;


  // Enumeration of alert modules
  typedef enum int unsigned {
    TopEarlgreyAlertPeripheralUart0 = 0,
    TopEarlgreyAlertPeripheralUart1 = 1,
    TopEarlgreyAlertPeripheralUart2 = 2,
    TopEarlgreyAlertPeripheralUart3 = 3,
    TopEarlgreyAlertPeripheralGpio = 4,
    TopEarlgreyAlertPeripheralSpiDevice = 5,
    TopEarlgreyAlertPeripheralI2c0 = 6,
    TopEarlgreyAlertPeripheralI2c1 = 7,
    TopEarlgreyAlertPeripheralI2c2 = 8,
    TopEarlgreyAlertPeripheralPattgen = 9,
    TopEarlgreyAlertPeripheralRvTimer = 10,
    TopEarlgreyAlertPeripheralOtpCtrl = 11,
    TopEarlgreyAlertPeripheralLcCtrl = 12,
    TopEarlgreyAlertPeripheralSpiHost0 = 13,
    TopEarlgreyAlertPeripheralSpiHost1 = 14,
    TopEarlgreyAlertPeripheralUsbdev = 15,
    TopEarlgreyAlertPeripheralPwrmgrAon = 16,
    TopEarlgreyAlertPeripheralRstmgrAon = 17,
    TopEarlgreyAlertPeripheralClkmgrAon = 18,
    TopEarlgreyAlertPeripheralSysrstCtrlAon = 19,
    TopEarlgreyAlertPeripheralAdcCtrlAon = 20,
    TopEarlgreyAlertPeripheralPwmAon = 21,
    TopEarlgreyAlertPeripheralPinmuxAon = 22,
    TopEarlgreyAlertPeripheralAonTimerAon = 23,
    TopEarlgreyAlertPeripheralSensorCtrlAon = 24,
    TopEarlgreyAlertPeripheralSramCtrlRetAon = 25,
    TopEarlgreyAlertPeripheralFlashCtrl = 26,
    TopEarlgreyAlertPeripheralRvDm = 27,
    TopEarlgreyAlertPeripheralRvPlic = 28,
    TopEarlgreyAlertPeripheralAes = 29,
    TopEarlgreyAlertPeripheralHmac = 30,
    TopEarlgreyAlertPeripheralKmac = 31,
    TopEarlgreyAlertPeripheralOtbn = 32,
    TopEarlgreyAlertPeripheralKeymgr = 33,
    TopEarlgreyAlertPeripheralCsrng = 34,
    TopEarlgreyAlertPeripheralEntropySrc = 35,
    TopEarlgreyAlertPeripheralEdn0 = 36,
    TopEarlgreyAlertPeripheralEdn1 = 37,
    TopEarlgreyAlertPeripheralSramCtrlMain = 38,
    TopEarlgreyAlertPeripheralRomCtrl = 39,
    TopEarlgreyAlertPeripheralRvCoreIbex = 40,
    TopEarlgreyAlertPeripheralCount
  } alert_peripheral_e;

  // Enumeration of alerts
  typedef enum int unsigned {
    TopEarlgreyAlertIdUart0FatalFault = 0,
    TopEarlgreyAlertIdUart1FatalFault = 1,
    TopEarlgreyAlertIdUart2FatalFault = 2,
    TopEarlgreyAlertIdUart3FatalFault = 3,
    TopEarlgreyAlertIdGpioFatalFault = 4,
    TopEarlgreyAlertIdSpiDeviceFatalFault = 5,
    TopEarlgreyAlertIdI2c0FatalFault = 6,
    TopEarlgreyAlertIdI2c1FatalFault = 7,
    TopEarlgreyAlertIdI2c2FatalFault = 8,
    TopEarlgreyAlertIdPattgenFatalFault = 9,
    TopEarlgreyAlertIdRvTimerFatalFault = 10,
    TopEarlgreyAlertIdOtpCtrlFatalMacroError = 11,
    TopEarlgreyAlertIdOtpCtrlFatalCheckError = 12,
    TopEarlgreyAlertIdOtpCtrlFatalBusIntegError = 13,
    TopEarlgreyAlertIdOtpCtrlFatalPrimOtpAlert = 14,
    TopEarlgreyAlertIdOtpCtrlRecovPrimOtpAlert = 15,
    TopEarlgreyAlertIdLcCtrlFatalProgError = 16,
    TopEarlgreyAlertIdLcCtrlFatalStateError = 17,
    TopEarlgreyAlertIdLcCtrlFatalBusIntegError = 18,
    TopEarlgreyAlertIdSpiHost0FatalFault = 19,
    TopEarlgreyAlertIdSpiHost1FatalFault = 20,
    TopEarlgreyAlertIdUsbdevFatalFault = 21,
    TopEarlgreyAlertIdPwrmgrAonFatalFault = 22,
    TopEarlgreyAlertIdRstmgrAonFatalFault = 23,
    TopEarlgreyAlertIdRstmgrAonFatalCnstyFault = 24,
    TopEarlgreyAlertIdClkmgrAonRecovFault = 25,
    TopEarlgreyAlertIdClkmgrAonFatalFault = 26,
    TopEarlgreyAlertIdSysrstCtrlAonFatalFault = 27,
    TopEarlgreyAlertIdAdcCtrlAonFatalFault = 28,
    TopEarlgreyAlertIdPwmAonFatalFault = 29,
    TopEarlgreyAlertIdPinmuxAonFatalFault = 30,
    TopEarlgreyAlertIdAonTimerAonFatalFault = 31,
    TopEarlgreyAlertIdSensorCtrlAonRecovAlert = 32,
    TopEarlgreyAlertIdSensorCtrlAonFatalAlert = 33,
    TopEarlgreyAlertIdSramCtrlRetAonFatalError = 34,
    TopEarlgreyAlertIdFlashCtrlRecovErr = 35,
    TopEarlgreyAlertIdFlashCtrlFatalStdErr = 36,
    TopEarlgreyAlertIdFlashCtrlFatalErr = 37,
    TopEarlgreyAlertIdFlashCtrlFatalPrimFlashAlert = 38,
    TopEarlgreyAlertIdFlashCtrlRecovPrimFlashAlert = 39,
    TopEarlgreyAlertIdRvDmFatalFault = 40,
    TopEarlgreyAlertIdRvPlicFatalFault = 41,
    TopEarlgreyAlertIdAesRecovCtrlUpdateErr = 42,
    TopEarlgreyAlertIdAesFatalFault = 43,
    TopEarlgreyAlertIdHmacFatalFault = 44,
    TopEarlgreyAlertIdKmacRecovOperationErr = 45,
    TopEarlgreyAlertIdKmacFatalFaultErr = 46,
    TopEarlgreyAlertIdOtbnFatal = 47,
    TopEarlgreyAlertIdOtbnRecov = 48,
    TopEarlgreyAlertIdKeymgrRecovOperationErr = 49,
    TopEarlgreyAlertIdKeymgrFatalFaultErr = 50,
    TopEarlgreyAlertIdCsrngRecovAlert = 51,
    TopEarlgreyAlertIdCsrngFatalAlert = 52,
    TopEarlgreyAlertIdEntropySrcRecovAlert = 53,
    TopEarlgreyAlertIdEntropySrcFatalAlert = 54,
    TopEarlgreyAlertIdEdn0RecovAlert = 55,
    TopEarlgreyAlertIdEdn0FatalAlert = 56,
    TopEarlgreyAlertIdEdn1RecovAlert = 57,
    TopEarlgreyAlertIdEdn1FatalAlert = 58,
    TopEarlgreyAlertIdSramCtrlMainFatalError = 59,
    TopEarlgreyAlertIdRomCtrlFatal = 60,
    TopEarlgreyAlertIdRvCoreIbexFatalSwErr = 61,
    TopEarlgreyAlertIdRvCoreIbexRecovSwErr = 62,
    TopEarlgreyAlertIdRvCoreIbexFatalHwErr = 63,
    TopEarlgreyAlertIdRvCoreIbexRecovHwErr = 64,
    TopEarlgreyAlertIdCount
  } alert_id_e;

  // Enumeration of interrupts
  typedef enum int unsigned {
    TopEarlgreyIrqIdUart0TxWatermark = 1,
    TopEarlgreyIrqIdUart0RxWatermark = 2,
    TopEarlgreyIrqIdUart0TxDone = 3,
    TopEarlgreyIrqIdUart0RxOverflow = 4,
    TopEarlgreyIrqIdUart0RxFrameErr = 5,
    TopEarlgreyIrqIdUart0RxBreakErr = 6,
    TopEarlgreyIrqIdUart0RxTimeout = 7,
    TopEarlgreyIrqIdUart0RxParityErr = 8,
    TopEarlgreyIrqIdUart0TxEmpty = 9,
    TopEarlgreyIrqIdUart1TxWatermark = 10,
    TopEarlgreyIrqIdUart1RxWatermark = 11,
    TopEarlgreyIrqIdUart1TxDone = 12,
    TopEarlgreyIrqIdUart1RxOverflow = 13,
    TopEarlgreyIrqIdUart1RxFrameErr = 14,
    TopEarlgreyIrqIdUart1RxBreakErr = 15,
    TopEarlgreyIrqIdUart1RxTimeout = 16,
    TopEarlgreyIrqIdUart1RxParityErr = 17,
    TopEarlgreyIrqIdUart1TxEmpty = 18,
    TopEarlgreyIrqIdUart2TxWatermark = 19,
    TopEarlgreyIrqIdUart2RxWatermark = 20,
    TopEarlgreyIrqIdUart2TxDone = 21,
    TopEarlgreyIrqIdUart2RxOverflow = 22,
    TopEarlgreyIrqIdUart2RxFrameErr = 23,
    TopEarlgreyIrqIdUart2RxBreakErr = 24,
    TopEarlgreyIrqIdUart2RxTimeout = 25,
    TopEarlgreyIrqIdUart2RxParityErr = 26,
    TopEarlgreyIrqIdUart2TxEmpty = 27,
    TopEarlgreyIrqIdUart3TxWatermark = 28,
    TopEarlgreyIrqIdUart3RxWatermark = 29,
    TopEarlgreyIrqIdUart3TxDone = 30,
    TopEarlgreyIrqIdUart3RxOverflow = 31,
    TopEarlgreyIrqIdUart3RxFrameErr = 32,
    TopEarlgreyIrqIdUart3RxBreakErr = 33,
    TopEarlgreyIrqIdUart3RxTimeout = 34,
    TopEarlgreyIrqIdUart3RxParityErr = 35,
    TopEarlgreyIrqIdUart3TxEmpty = 36,
    TopEarlgreyIrqIdGpioGpio0 = 37,
    TopEarlgreyIrqIdGpioGpio1 = 38,
    TopEarlgreyIrqIdGpioGpio2 = 39,
    TopEarlgreyIrqIdGpioGpio3 = 40,
    TopEarlgreyIrqIdGpioGpio4 = 41,
    TopEarlgreyIrqIdGpioGpio5 = 42,
    TopEarlgreyIrqIdGpioGpio6 = 43,
    TopEarlgreyIrqIdGpioGpio7 = 44,
    TopEarlgreyIrqIdGpioGpio8 = 45,
    TopEarlgreyIrqIdGpioGpio9 = 46,
    TopEarlgreyIrqIdGpioGpio10 = 47,
    TopEarlgreyIrqIdGpioGpio11 = 48,
    TopEarlgreyIrqIdGpioGpio12 = 49,
    TopEarlgreyIrqIdGpioGpio13 = 50,
    TopEarlgreyIrqIdGpioGpio14 = 51,
    TopEarlgreyIrqIdGpioGpio15 = 52,
    TopEarlgreyIrqIdGpioGpio16 = 53,
    TopEarlgreyIrqIdGpioGpio17 = 54,
    TopEarlgreyIrqIdGpioGpio18 = 55,
    TopEarlgreyIrqIdGpioGpio19 = 56,
    TopEarlgreyIrqIdGpioGpio20 = 57,
    TopEarlgreyIrqIdGpioGpio21 = 58,
    TopEarlgreyIrqIdGpioGpio22 = 59,
    TopEarlgreyIrqIdGpioGpio23 = 60,
    TopEarlgreyIrqIdGpioGpio24 = 61,
    TopEarlgreyIrqIdGpioGpio25 = 62,
    TopEarlgreyIrqIdGpioGpio26 = 63,
    TopEarlgreyIrqIdGpioGpio27 = 64,
    TopEarlgreyIrqIdGpioGpio28 = 65,
    TopEarlgreyIrqIdGpioGpio29 = 66,
    TopEarlgreyIrqIdGpioGpio30 = 67,
    TopEarlgreyIrqIdGpioGpio31 = 68,
    TopEarlgreyIrqIdSpiDeviceUploadCmdfifoNotEmpty = 69,
    TopEarlgreyIrqIdSpiDeviceUploadPayloadNotEmpty = 70,
    TopEarlgreyIrqIdSpiDeviceUploadPayloadOverflow = 71,
    TopEarlgreyIrqIdSpiDeviceReadbufWatermark = 72,
    TopEarlgreyIrqIdSpiDeviceReadbufFlip = 73,
    TopEarlgreyIrqIdSpiDeviceTpmHeaderNotEmpty = 74,
    TopEarlgreyIrqIdSpiDeviceTpmRdfifoCmdEnd = 75,
    TopEarlgreyIrqIdSpiDeviceTpmRdfifoDrop = 76,
    TopEarlgreyIrqIdI2c0FmtThreshold = 77,
    TopEarlgreyIrqIdI2c0RxThreshold = 78,
    TopEarlgreyIrqIdI2c0AcqThreshold = 79,
    TopEarlgreyIrqIdI2c0RxOverflow = 80,
    TopEarlgreyIrqIdI2c0ControllerHalt = 81,
    TopEarlgreyIrqIdI2c0SclInterference = 82,
    TopEarlgreyIrqIdI2c0SdaInterference = 83,
    TopEarlgreyIrqIdI2c0StretchTimeout = 84,
    TopEarlgreyIrqIdI2c0SdaUnstable = 85,
    TopEarlgreyIrqIdI2c0CmdComplete = 86,
    TopEarlgreyIrqIdI2c0TxStretch = 87,
    TopEarlgreyIrqIdI2c0TxThreshold = 88,
    TopEarlgreyIrqIdI2c0AcqStretch = 89,
    TopEarlgreyIrqIdI2c0UnexpStop = 90,
    TopEarlgreyIrqIdI2c0HostTimeout = 91,
    TopEarlgreyIrqIdI2c1FmtThreshold = 92,
    TopEarlgreyIrqIdI2c1RxThreshold = 93,
    TopEarlgreyIrqIdI2c1AcqThreshold = 94,
    TopEarlgreyIrqIdI2c1RxOverflow = 95,
    TopEarlgreyIrqIdI2c1ControllerHalt = 96,
    TopEarlgreyIrqIdI2c1SclInterference = 97,
    TopEarlgreyIrqIdI2c1SdaInterference = 98,
    TopEarlgreyIrqIdI2c1StretchTimeout = 99,
    TopEarlgreyIrqIdI2c1SdaUnstable = 100,
    TopEarlgreyIrqIdI2c1CmdComplete = 101,
    TopEarlgreyIrqIdI2c1TxStretch = 102,
    TopEarlgreyIrqIdI2c1TxThreshold = 103,
    TopEarlgreyIrqIdI2c1AcqStretch = 104,
    TopEarlgreyIrqIdI2c1UnexpStop = 105,
    TopEarlgreyIrqIdI2c1HostTimeout = 106,
    TopEarlgreyIrqIdI2c2FmtThreshold = 107,
    TopEarlgreyIrqIdI2c2RxThreshold = 108,
    TopEarlgreyIrqIdI2c2AcqThreshold = 109,
    TopEarlgreyIrqIdI2c2RxOverflow = 110,
    TopEarlgreyIrqIdI2c2ControllerHalt = 111,
    TopEarlgreyIrqIdI2c2SclInterference = 112,
    TopEarlgreyIrqIdI2c2SdaInterference = 113,
    TopEarlgreyIrqIdI2c2StretchTimeout = 114,
    TopEarlgreyIrqIdI2c2SdaUnstable = 115,
    TopEarlgreyIrqIdI2c2CmdComplete = 116,
    TopEarlgreyIrqIdI2c2TxStretch = 117,
    TopEarlgreyIrqIdI2c2TxThreshold = 118,
    TopEarlgreyIrqIdI2c2AcqStretch = 119,
    TopEarlgreyIrqIdI2c2UnexpStop = 120,
    TopEarlgreyIrqIdI2c2HostTimeout = 121,
    TopEarlgreyIrqIdPattgenDoneCh0 = 122,
    TopEarlgreyIrqIdPattgenDoneCh1 = 123,
    TopEarlgreyIrqIdRvTimerTimerExpiredHart0Timer0 = 124,
    TopEarlgreyIrqIdOtpCtrlOtpOperationDone = 125,
    TopEarlgreyIrqIdOtpCtrlOtpError = 126,
    TopEarlgreyIrqIdAlertHandlerClassa = 127,
    TopEarlgreyIrqIdAlertHandlerClassb = 128,
    TopEarlgreyIrqIdAlertHandlerClassc = 129,
    TopEarlgreyIrqIdAlertHandlerClassd = 130,
    TopEarlgreyIrqIdSpiHost0Error = 131,
    TopEarlgreyIrqIdSpiHost0SpiEvent = 132,
    TopEarlgreyIrqIdSpiHost1Error = 133,
    TopEarlgreyIrqIdSpiHost1SpiEvent = 134,
    TopEarlgreyIrqIdUsbdevPktReceived = 135,
    TopEarlgreyIrqIdUsbdevPktSent = 136,
    TopEarlgreyIrqIdUsbdevDisconnected = 137,
    TopEarlgreyIrqIdUsbdevHostLost = 138,
    TopEarlgreyIrqIdUsbdevLinkReset = 139,
    TopEarlgreyIrqIdUsbdevLinkSuspend = 140,
    TopEarlgreyIrqIdUsbdevLinkResume = 141,
    TopEarlgreyIrqIdUsbdevAvOutEmpty = 142,
    TopEarlgreyIrqIdUsbdevRxFull = 143,
    TopEarlgreyIrqIdUsbdevAvOverflow = 144,
    TopEarlgreyIrqIdUsbdevLinkInErr = 145,
    TopEarlgreyIrqIdUsbdevRxCrcErr = 146,
    TopEarlgreyIrqIdUsbdevRxPidErr = 147,
    TopEarlgreyIrqIdUsbdevRxBitstuffErr = 148,
    TopEarlgreyIrqIdUsbdevFrame = 149,
    TopEarlgreyIrqIdUsbdevPowered = 150,
    TopEarlgreyIrqIdUsbdevLinkOutErr = 151,
    TopEarlgreyIrqIdUsbdevAvSetupEmpty = 152,
    TopEarlgreyIrqIdPwrmgrAonWakeup = 153,
    TopEarlgreyIrqIdSysrstCtrlAonEventDetected = 154,
    TopEarlgreyIrqIdAdcCtrlAonMatchPending = 155,
    TopEarlgreyIrqIdAonTimerAonWkupTimerExpired = 156,
    TopEarlgreyIrqIdAonTimerAonWdogTimerBark = 157,
    TopEarlgreyIrqIdSensorCtrlAonIoStatusChange = 158,
    TopEarlgreyIrqIdSensorCtrlAonInitStatusChange = 159,
    TopEarlgreyIrqIdFlashCtrlProgEmpty = 160,
    TopEarlgreyIrqIdFlashCtrlProgLvl = 161,
    TopEarlgreyIrqIdFlashCtrlRdFull = 162,
    TopEarlgreyIrqIdFlashCtrlRdLvl = 163,
    TopEarlgreyIrqIdFlashCtrlOpDone = 164,
    TopEarlgreyIrqIdFlashCtrlCorrErr = 165,
    TopEarlgreyIrqIdHmacHmacDone = 166,
    TopEarlgreyIrqIdHmacFifoEmpty = 167,
    TopEarlgreyIrqIdHmacHmacErr = 168,
    TopEarlgreyIrqIdKmacKmacDone = 169,
    TopEarlgreyIrqIdKmacFifoEmpty = 170,
    TopEarlgreyIrqIdKmacKmacErr = 171,
    TopEarlgreyIrqIdOtbnDone = 172,
    TopEarlgreyIrqIdKeymgrOpDone = 173,
    TopEarlgreyIrqIdCsrngCsCmdReqDone = 174,
    TopEarlgreyIrqIdCsrngCsEntropyReq = 175,
    TopEarlgreyIrqIdCsrngCsHwInstExc = 176,
    TopEarlgreyIrqIdCsrngCsFatalErr = 177,
    TopEarlgreyIrqIdEntropySrcEsEntropyValid = 178,
    TopEarlgreyIrqIdEntropySrcEsHealthTestFailed = 179,
    TopEarlgreyIrqIdEntropySrcEsObserveFifoReady = 180,
    TopEarlgreyIrqIdEntropySrcEsFatalErr = 181,
    TopEarlgreyIrqIdEdn0EdnCmdReqDone = 182,
    TopEarlgreyIrqIdEdn0EdnFatalErr = 183,
    TopEarlgreyIrqIdEdn1EdnCmdReqDone = 184,
    TopEarlgreyIrqIdEdn1EdnFatalErr = 185,
    TopEarlgreyIrqIdCount
  } interrupt_id_e;

  // Enumeration of IO power domains.
  // Only used in ASIC target.
  typedef enum logic [2:0] {
    IoBankVcc = 0,
    IoBankAvcc = 1,
    IoBankVioa = 2,
    IoBankViob = 3,
    IoBankCount = 4
  } pwr_dom_e;

  // Enumeration for MIO signals on the top-level.
  typedef enum int unsigned {
    MioInGpioGpio0 = 0,
    MioInGpioGpio1 = 1,
    MioInGpioGpio2 = 2,
    MioInGpioGpio3 = 3,
    MioInGpioGpio4 = 4,
    MioInGpioGpio5 = 5,
    MioInGpioGpio6 = 6,
    MioInGpioGpio7 = 7,
    MioInGpioGpio8 = 8,
    MioInGpioGpio9 = 9,
    MioInGpioGpio10 = 10,
    MioInGpioGpio11 = 11,
    MioInGpioGpio12 = 12,
    MioInGpioGpio13 = 13,
    MioInGpioGpio14 = 14,
    MioInGpioGpio15 = 15,
    MioInGpioGpio16 = 16,
    MioInGpioGpio17 = 17,
    MioInGpioGpio18 = 18,
    MioInGpioGpio19 = 19,
    MioInGpioGpio20 = 20,
    MioInGpioGpio21 = 21,
    MioInGpioGpio22 = 22,
    MioInGpioGpio23 = 23,
    MioInGpioGpio24 = 24,
    MioInGpioGpio25 = 25,
    MioInGpioGpio26 = 26,
    MioInGpioGpio27 = 27,
    MioInGpioGpio28 = 28,
    MioInGpioGpio29 = 29,
    MioInGpioGpio30 = 30,
    MioInGpioGpio31 = 31,
    MioInI2c0Sda = 32,
    MioInI2c0Scl = 33,
    MioInI2c1Sda = 34,
    MioInI2c1Scl = 35,
    MioInI2c2Sda = 36,
    MioInI2c2Scl = 37,
    MioInSpiHost1Sd0 = 38,
    MioInSpiHost1Sd1 = 39,
    MioInSpiHost1Sd2 = 40,
    MioInSpiHost1Sd3 = 41,
    MioInUart0Rx = 42,
    MioInUart1Rx = 43,
    MioInUart2Rx = 44,
    MioInUart3Rx = 45,
    MioInSpiDeviceTpmCsb = 46,
    MioInFlashCtrlTck = 47,
    MioInFlashCtrlTms = 48,
    MioInFlashCtrlTdi = 49,
    MioInSysrstCtrlAonAcPresent = 50,
    MioInSysrstCtrlAonKey0In = 51,
    MioInSysrstCtrlAonKey1In = 52,
    MioInSysrstCtrlAonKey2In = 53,
    MioInSysrstCtrlAonPwrbIn = 54,
    MioInSysrstCtrlAonLidOpen = 55,
    MioInUsbdevSense = 56,
    MioInCount = 57
  } mio_in_e;

  typedef enum {
    MioOutGpioGpio0 = 0,
    MioOutGpioGpio1 = 1,
    MioOutGpioGpio2 = 2,
    MioOutGpioGpio3 = 3,
    MioOutGpioGpio4 = 4,
    MioOutGpioGpio5 = 5,
    MioOutGpioGpio6 = 6,
    MioOutGpioGpio7 = 7,
    MioOutGpioGpio8 = 8,
    MioOutGpioGpio9 = 9,
    MioOutGpioGpio10 = 10,
    MioOutGpioGpio11 = 11,
    MioOutGpioGpio12 = 12,
    MioOutGpioGpio13 = 13,
    MioOutGpioGpio14 = 14,
    MioOutGpioGpio15 = 15,
    MioOutGpioGpio16 = 16,
    MioOutGpioGpio17 = 17,
    MioOutGpioGpio18 = 18,
    MioOutGpioGpio19 = 19,
    MioOutGpioGpio20 = 20,
    MioOutGpioGpio21 = 21,
    MioOutGpioGpio22 = 22,
    MioOutGpioGpio23 = 23,
    MioOutGpioGpio24 = 24,
    MioOutGpioGpio25 = 25,
    MioOutGpioGpio26 = 26,
    MioOutGpioGpio27 = 27,
    MioOutGpioGpio28 = 28,
    MioOutGpioGpio29 = 29,
    MioOutGpioGpio30 = 30,
    MioOutGpioGpio31 = 31,
    MioOutI2c0Sda = 32,
    MioOutI2c0Scl = 33,
    MioOutI2c1Sda = 34,
    MioOutI2c1Scl = 35,
    MioOutI2c2Sda = 36,
    MioOutI2c2Scl = 37,
    MioOutSpiHost1Sd0 = 38,
    MioOutSpiHost1Sd1 = 39,
    MioOutSpiHost1Sd2 = 40,
    MioOutSpiHost1Sd3 = 41,
    MioOutUart0Tx = 42,
    MioOutUart1Tx = 43,
    MioOutUart2Tx = 44,
    MioOutUart3Tx = 45,
    MioOutPattgenPda0Tx = 46,
    MioOutPattgenPcl0Tx = 47,
    MioOutPattgenPda1Tx = 48,
    MioOutPattgenPcl1Tx = 49,
    MioOutSpiHost1Sck = 50,
    MioOutSpiHost1Csb = 51,
    MioOutFlashCtrlTdo = 52,
    MioOutSensorCtrlAonAstDebugOut0 = 53,
    MioOutSensorCtrlAonAstDebugOut1 = 54,
    MioOutSensorCtrlAonAstDebugOut2 = 55,
    MioOutSensorCtrlAonAstDebugOut3 = 56,
    MioOutSensorCtrlAonAstDebugOut4 = 57,
    MioOutSensorCtrlAonAstDebugOut5 = 58,
    MioOutSensorCtrlAonAstDebugOut6 = 59,
    MioOutSensorCtrlAonAstDebugOut7 = 60,
    MioOutSensorCtrlAonAstDebugOut8 = 61,
    MioOutPwmAonPwm0 = 62,
    MioOutPwmAonPwm1 = 63,
    MioOutPwmAonPwm2 = 64,
    MioOutPwmAonPwm3 = 65,
    MioOutPwmAonPwm4 = 66,
    MioOutPwmAonPwm5 = 67,
    MioOutOtpMacroTest0 = 68,
    MioOutSysrstCtrlAonBatDisable = 69,
    MioOutSysrstCtrlAonKey0Out = 70,
    MioOutSysrstCtrlAonKey1Out = 71,
    MioOutSysrstCtrlAonKey2Out = 72,
    MioOutSysrstCtrlAonPwrbOut = 73,
    MioOutSysrstCtrlAonZ3Wakeup = 74,
    MioOutCount = 75
  } mio_out_e;

  // Enumeration for DIO signals, used on both the top and chip-levels.
  typedef enum int unsigned {
    DioUsbdevUsbDp = 0,
    DioUsbdevUsbDn = 1,
    DioSpiHost0Sd0 = 2,
    DioSpiHost0Sd1 = 3,
    DioSpiHost0Sd2 = 4,
    DioSpiHost0Sd3 = 5,
    DioSpiDeviceSd0 = 6,
    DioSpiDeviceSd1 = 7,
    DioSpiDeviceSd2 = 8,
    DioSpiDeviceSd3 = 9,
    DioSysrstCtrlAonEcRstL = 10,
    DioSysrstCtrlAonFlashWpL = 11,
    DioSpiDeviceSck = 12,
    DioSpiDeviceCsb = 13,
    DioSpiHost0Sck = 14,
    DioSpiHost0Csb = 15,
    DioCount = 16
  } dio_e;

  // Enumeration for the types of pads.
  typedef enum {
    MioPad,
    DioPad
  } pad_type_e;

  // Raw MIO/DIO input array indices on chip-level.
  // TODO: Does not account for target specific stubbed/added pads.
  // Need to make a target-specific package for those.
  typedef enum int unsigned {
    MioPadIoa0 = 0,
    MioPadIoa1 = 1,
    MioPadIoa2 = 2,
    MioPadIoa3 = 3,
    MioPadIoa4 = 4,
    MioPadIoa5 = 5,
    MioPadIoa6 = 6,
    MioPadIoa7 = 7,
    MioPadIoa8 = 8,
    MioPadIob0 = 9,
    MioPadIob1 = 10,
    MioPadIob2 = 11,
    MioPadIob3 = 12,
    MioPadIob4 = 13,
    MioPadIob5 = 14,
    MioPadIob6 = 15,
    MioPadIob7 = 16,
    MioPadIob8 = 17,
    MioPadIob9 = 18,
    MioPadIob10 = 19,
    MioPadIob11 = 20,
    MioPadIob12 = 21,
    MioPadIoc0 = 22,
    MioPadIoc1 = 23,
    MioPadIoc2 = 24,
    MioPadIoc3 = 25,
    MioPadIoc4 = 26,
    MioPadIoc5 = 27,
    MioPadIoc6 = 28,
    MioPadIoc7 = 29,
    MioPadIoc8 = 30,
    MioPadIoc9 = 31,
    MioPadIoc10 = 32,
    MioPadIoc11 = 33,
    MioPadIoc12 = 34,
    MioPadIor0 = 35,
    MioPadIor1 = 36,
    MioPadIor2 = 37,
    MioPadIor3 = 38,
    MioPadIor4 = 39,
    MioPadIor5 = 40,
    MioPadIor6 = 41,
    MioPadIor7 = 42,
    MioPadIor10 = 43,
    MioPadIor11 = 44,
    MioPadIor12 = 45,
    MioPadIor13 = 46,
    MioPadCount
  } mio_pad_e;

  typedef enum int unsigned {
    DioPadPorN = 0,
    DioPadUsbP = 1,
    DioPadUsbN = 2,
    DioPadCc1 = 3,
    DioPadCc2 = 4,
    DioPadFlashTestVolt = 5,
    DioPadFlashTestMode0 = 6,
    DioPadFlashTestMode1 = 7,
    DioPadOtpExtVolt = 8,
    DioPadSpiHostD0 = 9,
    DioPadSpiHostD1 = 10,
    DioPadSpiHostD2 = 11,
    DioPadSpiHostD3 = 12,
    DioPadSpiHostClk = 13,
    DioPadSpiHostCsL = 14,
    DioPadSpiDevD0 = 15,
    DioPadSpiDevD1 = 16,
    DioPadSpiDevD2 = 17,
    DioPadSpiDevD3 = 18,
    DioPadSpiDevClk = 19,
    DioPadSpiDevCsL = 20,
    DioPadIor8 = 21,
    DioPadIor9 = 22,
    DioPadCount
  } dio_pad_e;

  // List of peripheral instantiated in this chip.
  typedef enum {
    PeripheralAdcCtrlAon,
    PeripheralAes,
    PeripheralAlertHandler,
    PeripheralAonTimerAon,
    PeripheralAst,
    PeripheralClkmgrAon,
    PeripheralCsrng,
    PeripheralEdn0,
    PeripheralEdn1,
    PeripheralEntropySrc,
    PeripheralFlashCtrl,
    PeripheralGpio,
    PeripheralHmac,
    PeripheralI2c0,
    PeripheralI2c1,
    PeripheralI2c2,
    PeripheralKeymgr,
    PeripheralKmac,
    PeripheralLcCtrl,
    PeripheralOtbn,
    PeripheralOtpCtrl,
    PeripheralOtpMacro,
    PeripheralPattgen,
    PeripheralPinmuxAon,
    PeripheralPwmAon,
    PeripheralPwrmgrAon,
    PeripheralRomCtrl,
    PeripheralRstmgrAon,
    PeripheralRvCoreIbex,
    PeripheralRvDm,
    PeripheralRvPlic,
    PeripheralRvTimer,
    PeripheralSensorCtrlAon,
    PeripheralSpiDevice,
    PeripheralSpiHost0,
    PeripheralSpiHost1,
    PeripheralSramCtrlMain,
    PeripheralSramCtrlRetAon,
    PeripheralSysrstCtrlAon,
    PeripheralUart0,
    PeripheralUart1,
    PeripheralUart2,
    PeripheralUart3,
    PeripheralUsbdev,
    PeripheralCount
  } peripheral_e;

  // TODO: Enumeration for PLIC Interrupt source peripheral.

// MACROs for AST analog simulation support
`ifdef ANALOGSIM
  `define INOUT_AI input ast_pkg::awire_t
  `define INOUT_AO output ast_pkg::awire_t
`else
  `define INOUT_AI inout
  `define INOUT_AO inout
`endif

endpackage
