% if false:
<!-- githubvisible=true -->
<!-- The GitHub visible tag is removed by mako so the file in the objects folder does not have it -->
% endif
<?xml version="1.0" encoding="UTF-8"?>
<Target>
% if custom_target:   
  <FPGASourceFilesDirPath>Targets/NI/FPGA/RIO/79XXR/${lv_target_name}/FpgaFiles</FPGASourceFilesDirPath>
% else:
  <FPGASourceFilesDirPath>Targets/NI/FPGA/RIO/79XXR/PXIe-7903/FpgaFiles</FPGASourceFilesDirPath>
% endif
  <DeviceIDs>0x7AEC</DeviceIDs>
  <FPGASynthesisSourceFileList>
    <Path>Targets/NI/FPGA/RIO/79XXR/HMB/VHDL</Path>
  </FPGASynthesisSourceFileList>
  <RequiredNICoresFiles>SingleClkFifo.vhd</RequiredNICoresFiles>
  <:Include what="children">Targets/NI/FPGA/RIO/79XXR/Common/Resource/AppletonCommon.xml</:Include>
  <:Include what="children">Targets/NI/FPGA/RIO/79XXR/Common/Resource/MacallanCommonPxi.xml</:Include>

  <!-- Compilation -->
  <FPGACompilation>
    <:Include what="children">Targets/NI/FPGA/RIO/79XXR/Common/Resource/SasquatchCompileOptions.xml</:Include>
    <FPGADevice>xcvu11p</FPGADevice>
    <SpeedGrade>-2</SpeedGrade>
    <Package>flgb2104</Package>
    <PartNumber>xcvu11p-flgb2104-2-e</PartNumber>
    <ProcessPropertyList>
      <Process name="Place">
% if custom_target:   
        <XdcFilePath>Targets/NI/FPGA/RIO/79XXR/${lv_target_name}/FpgaFiles/constraints_place.xdc</XdcFilePath>
% else:
        <XdcFilePath>Targets/NI/FPGA/RIO/79XXR/PXIe-7903/FpgaFiles/constraints_place.xdc</XdcFilePath>
% endif      
      </Process>
    </ProcessPropertyList>
  </FPGACompilation>

  <!-- Optional Features -->
  <:Include what="children">Targets/NI/FPGA/RIO/79XXR/Common/Resource/AppletonDramUtilities.xml</:Include>

  <!-- Clocks -->
  <ClockList>
    <:Include what="children">Targets/NI/FPGA/RIO/79XXR/Common/Resource/AppletonClocks.xml</:Include>
    <:Include what="children">Targets/NI/FPGA/RIO/79XXR/Common/Resource/MacallanDramClocks.xml</:Include>
    <:Include what="children">Targets/NI/FPGA/RIO/79XXR/HMB/resource/Dram2DPClocks.xml</:Include>
% if include_custom_io:    
    <:Include what="children">Targets/NI/FPGA/RIO/79XXR/${lv_target_name}/${custom_clock}</:Include>
% endif
  </ClockList>

  <!-- CLIPs -->
  <CLIPSocketTypeList>
% if include_clip_socket:
    <:Include what="children">Targets/NI/FPGA/RIO/79XXR/Common/Resource/SasquatchMgtSocket.xml</:Include>
% endif
    <:Include what="children">Targets/NI/FPGA/RIO/79XXR/Common/Resource/SasquatchDramSocketType.xml</:Include>
    <:Include what="children">Targets/NI/FPGA/RIO/79XXR/Common/Resource/RoutingSocket.xml</:Include>
  </CLIPSocketTypeList>

% if include_custom_io:
  <:Include what="children">Targets/NI/FPGA/RIO/79XXR/${lv_target_name}/${custom_boardio}</:Include>  
% endif

    <SkipTopCompilationFileCheck/>
    <FlexRIOPortMappingList>
        <source name="SasquatchTopTemplate.vhd" >
            <constraintsSource>constraints.xdc_template</constraintsSource>
            <constraintsTarget>constraints.xdc</constraintsTarget>
            <target>SasquatchTop.vhd</target>
            
            <port names="MgtPortTxLane[index=0..47]_p"> <!-- top level port name -->
                <change_type>RemoveIfUnused</change_type>
                <component_port>MgtPortTx_p(#{index})</component_port>
                <clip_attribute>IOModuleTx#{index}</clip_attribute>
            </port>
            <port names="MgtPortTxLane[index=0..47]_n"> <!-- top level port name -->
                <change_type>RemoveIfUnused</change_type>
                <component_port>MgtPortTx_n(#{index})</component_port>
                <clip_attribute>IOModuleTx#{index}</clip_attribute>
            </port>
            
            <port names="MgtPortRxLane[index=0..47]_p"> <!-- top level port name -->
                <change_type>RemoveIfUnused</change_type>
                <component_port>MgtPortRx_p(#{index})</component_port>
                <clip_attribute>IOModuleRx#{index}</clip_attribute>
            </port>
            <port names="MgtPortRxLane[index=0..47]_n"> <!-- top level port name -->
                <change_type>RemoveIfUnused</change_type>
                <component_port>MgtPortRx_n(#{index})</component_port>
                <clip_attribute>IOModuleRx#{index}</clip_attribute>
            </port>
        </source>
    </FlexRIOPortMappingList>

</Target>
