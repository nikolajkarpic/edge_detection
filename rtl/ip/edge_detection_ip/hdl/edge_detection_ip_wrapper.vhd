--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
--Date        : Wed Jul 13 17:51:20 2022
--Host        : DESKTOP-DMI0M5P running 64-bit major release  (build 9200)
--Command     : generate_target edge_detection_ip_wrapper.bd
--Design      : edge_detection_ip_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity edge_detection_ip_wrapper is
end edge_detection_ip_wrapper;

architecture STRUCTURE of edge_detection_ip_wrapper is
  component edge_detection_ip is
  end component edge_detection_ip;
begin
edge_detection_ip_i: component edge_detection_ip
 ;
end STRUCTURE;
