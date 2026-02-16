<?xml version="1.0" encoding="UTF-8"?>
% if custom_target:   
<Target name="${lv_target_name}" version="1.0" arbitrationDefault="NeverArbitrate">
% else:
<Target name="PXIe-7903" version="1.0" arbitrationDefault="NeverArbitrate">
% endif
  <Protocols>NI-FlexRIO</Protocols>
  <DeviceCategory>FlexRIO Coprocessor Modules</DeviceCategory>
%if custom_target:
  <FPGAItemSubType>{${lv_target_guid}}</FPGAItemSubType>
%else:
  <FPGAItemSubType>{4477488c-da3b-44e9-8c54-1f52387c97ff}</FPGAItemSubType>
%endif
%if custom_target:
  <TargetClass>COM.NI.FPGA.RIO.FlexRIO.79XXR.798X.7903.${lv_target_name}_VU11P</TargetClass>
% else:
  <TargetClass>COM.NI.FPGA.RIO.FlexRIO.79XXR.798X.7903.PXIe-7903_VU11P</TargetClass>
% endif
  <IOModuleID>0x10937AEC</IOModuleID>
%if custom_target:
  <:Include what="children">Targets/NI/FPGA/RIO/79XXR/${lv_target_name}/Sasquatch7903.xml</:Include>
% else:
  <:Include what="children">Targets/NI/FPGA/RIO/79XXR/PXIe-7903/Sasquatch7903.xml</:Include>
% endif  
</Target>
<!-- githubvisible=true -->
