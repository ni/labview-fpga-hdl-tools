-- 
-- This file was automatically processed for release on GitHub
-- All comments were removed and this header was added
-- 
-- 
-- Copyright (c) 2025 National Instruments Corporation
-- 
-- SPDX-License-Identifier: MIT
-- 
-- 



















library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;


library unisim;
  use unisim.vcomponents.all;



entity MgtTest_DRP_bridge is
generic(
    kNUM_LANES : integer := 4;
    kADDR_SIZE : integer := 9
);
port (
    
    
    
    aResetSl     : in  std_logic;




    gtwiz_drpclk     : out std_logic_vector(kNUM_LANES-1 downto 0);
    gtwiz_drpaddr_in : out std_logic_vector(kNUM_LANES*kADDR_SIZE-1 downto 0);
    gtwiz_drpdi_in   : out std_logic_vector(kNUM_LANES*16-1 downto 0);
    gtwiz_drpdo_out  : in  std_logic_vector(kNUM_LANES*16-1 downto 0);
    gtwiz_drpen_in   : out std_logic_vector(kNUM_LANES-1 downto 0);
    gtwiz_drpwe_in   : out std_logic_vector(kNUM_LANES-1 downto 0);
    gtwiz_drprdy_out : in  std_logic_vector(kNUM_LANES-1 downto 0);




    s_aclk : in  std_logic;

    
    drp_s_axi_awaddr  : in  std_logic_vector(31 downto 0);
    drp_s_axi_awvalid : in  std_logic;
    drp_s_axi_awready : out std_logic;
    drp_s_axi_wdata   : in  std_logic_vector(31 downto 0);
    drp_s_axi_wstrb   : in  std_logic_vector(3 downto 0);
    drp_s_axi_wvalid  : in  std_logic;
    drp_s_axi_wready  : out std_logic;
    drp_s_axi_bresp   : out std_logic_vector(1 downto 0);
    drp_s_axi_bvalid  : out std_logic;
    drp_s_axi_bready  : in  std_logic;
    drp_s_axi_araddr  : in  std_logic_vector(31 downto 0);
    drp_s_axi_arvalid : in  std_logic;
    drp_s_axi_arready : out std_logic;
    drp_s_axi_rdata   : out std_logic_vector(31 downto 0);
    drp_s_axi_rresp   : out std_logic_vector(1 downto 0);
    drp_s_axi_rvalid  : out std_logic;
    drp_s_axi_rready  : in  std_logic
);

end MgtTest_DRP_bridge;

architecture rtl of MgtTest_DRP_bridge is
    signal aReset_n : std_logic;

    
    subtype AxiData_t is std_logic_vector(31 downto 0);
    type AxiDataAry_t is array(natural range <>) of AxiData_t;
    signal drp_s_axi_rdata_lane   : AxiDataAry_t(kNUM_LANES-1 downto 0);
    signal drp_s_axi_rdata_lcl    : AxiData_t;

    
    subtype DrpMgtAddr_t is std_logic_vector(kADDR_SIZE-1 downto 0);
    type DrpMgtAddrAry_t is array(natural range <>) of DrpMgtAddr_t;
    signal gtwiz_lane_drpaddr_in : DrpMgtAddrAry_t(kNUM_LANES-1 downto 0);

    
    subtype DrpData_t is std_logic_vector(15 downto 0);
    type DrpDataAry_t is array(natural range <>) of DrpData_t;
    signal gtwiz_lane_drpdi_in, gtwiz_lane_drpdo_out : DrpDataAry_t(kNUM_LANES-1 downto 0);

    
    signal drp_s_axi_awvalid_slv, drp_s_axi_awready_slv, drp_s_axi_wvalid_slv, drp_s_axi_wready_slv,
           drp_s_axi_bvalid_slv,  drp_s_axi_arvalid_slv, drp_s_axi_arready_slv,
           drp_s_axi_rvalid_slv,  drp_s_axi_rready_slv,  drp_s_axi_bready_slv : std_logic_vector(kNUM_LANES-1 downto 0);

    function to_StdLogic(b : boolean) return std_logic is
    begin
        if b then
            return '1';
        else
            return '0';
        end if;
    end to_StdLogic;

begin
    
    
    
    
    AXI4_Lite_Address_Map_drp_gtwiz_ch : entity work.PXIe659XR_AXI4_Lite_Address_Map(rtl)
    generic map (
        kNumEndpoints  => kNUM_LANES,
        kAddrSelectLsb => kADDR_SIZE
    )
    port map (
        s_aclk            => s_aclk,
        aReset_n          => aReset_n,
        s_axi_awaddr      => drp_s_axi_awaddr,
        s_axi_awvalid     => drp_s_axi_awvalid,
        s_axi_awready     => drp_s_axi_awready,
        s_axi_wvalid      => drp_s_axi_wvalid,
        s_axi_wready      => drp_s_axi_wready,
        s_axi_bvalid      => drp_s_axi_bvalid,
        s_axi_bready      => drp_s_axi_bready,
        s_axi_araddr      => drp_s_axi_araddr,
        s_axi_arvalid     => drp_s_axi_arvalid,
        s_axi_arready     => drp_s_axi_arready,
        s_axi_rdata       => drp_s_axi_rdata,
        s_axi_rvalid      => drp_s_axi_rvalid,
        s_axi_rready      => drp_s_axi_rready,
        s_axi_awvalid_slv => drp_s_axi_awvalid_slv,
        s_axi_awready_slv => drp_s_axi_awready_slv,
        s_axi_wvalid_slv  => drp_s_axi_wvalid_slv,
        s_axi_wready_slv  => drp_s_axi_wready_slv,
        s_axi_bvalid_slv  => drp_s_axi_bvalid_slv,
        s_axi_bready_slv  => drp_s_axi_bready_slv,
        s_axi_arvalid_slv => drp_s_axi_arvalid_slv,
        s_axi_arready_slv => drp_s_axi_arready_slv,
        s_axi_rdata_in    => drp_s_axi_rdata_lcl,
        s_axi_rvalid_slv  => drp_s_axi_rvalid_slv,
        s_axi_rready_slv  => drp_s_axi_rready_slv
    );
    
    GenGtwizAxiDrp : for i in 0 to kNUM_LANES-1 generate
        
        gtwiz_drpclk        (i) <= s_aclk;
        gtwiz_drpaddr_in    ((i+1)*kADDR_SIZE-1 downto i*kADDR_SIZE) <= gtwiz_lane_drpaddr_in(i);
        gtwiz_drpdi_in      ((i+1)*16-1 downto i*16) <= gtwiz_lane_drpdi_in  (i);
        gtwiz_lane_drpdo_out(i) <= gtwiz_drpdo_out(i*16+15 downto i*16);
        
        AXI4_Lite_to_drp_gtwiz_i : entity work.AXI4_Lite_to_DRP(rtl)
        generic map (
            kADDR_SIZE => kADDR_SIZE
        )
        port map (
            s_aclk            => s_aclk,
            aReset_n          => aReset_n,
            s_axi_awaddr      => drp_s_axi_awaddr,
            s_axi_awvalid     => drp_s_axi_awvalid_slv(i),
            s_axi_awready     => drp_s_axi_awready_slv(i),
            s_axi_wdata       => drp_s_axi_wdata,
            s_axi_wvalid      => drp_s_axi_wvalid_slv(i),
            s_axi_wready      => drp_s_axi_wready_slv(i),
            s_axi_bready      => drp_s_axi_bready_slv(i),
            s_axi_bvalid      => drp_s_axi_bvalid_slv(i),
            s_axi_araddr      => drp_s_axi_araddr,
            s_axi_arvalid     => drp_s_axi_arvalid_slv(i),
            s_axi_arready     => drp_s_axi_arready_slv(i),
            s_axi_rdata       => drp_s_axi_rdata_lane(i),
            s_axi_rready      => drp_s_axi_rready_slv(i),
            s_axi_rvalid      => drp_s_axi_rvalid_slv(i),
            drpaddr_in        => gtwiz_lane_drpaddr_in(i),
            drpdi_in          => gtwiz_lane_drpdi_in(i),
            drpdo_out         => gtwiz_lane_drpdo_out(i),
            drprdy_out        => gtwiz_drprdy_out(i),
            drpen_in          => gtwiz_drpen_in(i),
            drpwe_in          => gtwiz_drpwe_in(i)
        );
    end generate;
    drp_s_axi_rresp <= "00";
    drp_s_axi_bresp <= "00";

    process(drp_s_axi_rdata_lane)
        variable drp_s_axi_rdata_temp : AxiData_t;
    begin
        drp_s_axi_rdata_temp := (others => '0');
        for i in 0 to kNUM_LANES-1 loop
            drp_s_axi_rdata_temp := drp_s_axi_rdata_temp or drp_s_axi_rdata_lane(i);
        end loop;
        drp_s_axi_rdata_lcl <= drp_s_axi_rdata_temp;
    end process;
        
    
    aReset_n <= not aResetSl;

end rtl;