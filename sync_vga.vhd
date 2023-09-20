library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity Sync_VGA is Generic (
    HVisibleArea: integer := 1024; 
    HFrontPorch_Dim: integer := 24; 
    HSync_Dim: integer := 136; 
    HBackPorch_Dim: integer := 160; 
    VVisibleArea: integer := 768; 
    VFrontPorch_Dim: integer := 3; 
    VSync_Dim: integer := 6; 
    VBackPorch_Dim: integer := 29);
Port ( clk : in STD_LOGIC;
    HSync : out STD_LOGIC;
    HAddr : out STD_LOGIC_VECTOR (15 downto 0); 
    VSync : out STD_LOGIC;
    VAddr : out STD_LOGIC_VECTOR (15 downto 0); 
    en_q : out STD_LOGIC);
end Sync_VGA;

architecture Behavioral of Sync_VGA is

signal HAddr_buf: STD_LOGIC_VECTOR (15 downto 0) := (others => '0'); 
signal VAddr_buf: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
 
begin

HAddr <= HAddr_buf;
VAddr <= VAddr_buf;

H_CNT: process(clk) begin
if rising_edge(clk) then
    if HAddr_buf = (HVisibleArea + HFrontPorch_Dim + HSync_Dim + HBackPorch_Dim - 1) then 
        HAddr_buf <= x"0000";
    else
        HAddr_buf <= HAddr_buf + '1'; 
    end if;
end if; 
end process;

V_CNT: process(clk) begin
if rising_edge(clk) then
    if HAddr_buf = HVisibleArea + HFrontPorch_Dim + HSync_Dim + HBackPorch_Dim - 1 then 
        if VAddr_buf = VVisibleArea + VFrontPorch_Dim + VSync_Dim + VBackPorch_Dim - 1 then
            VAddr_buf <= x"0000"; else
            VAddr_buf <= VAddr_buf + '1'; 
        end if;
    end if; 
end if;
end process;

HSync <= '0' when HAddr_buf > HVisibleArea + HFrontPorch_Dim - 1 and HAddr_buf < HVisibleArea + HFrontPorch_Dim + HSync_Dim else
'1';

en_q <= '0' when VAddr_buf > VVisibleArea - 1 else '0' when HAddr_buf > HVisibleArea - 1 else
'1';

VSync <= '0' when VAddr_buf > VVisibleArea + VFrontPorch_Dim - 1 and VAddr_buf < VVisibleArea + VFrontPorch_Dim + VSync_Dim else
'1';

end Behavioral;
