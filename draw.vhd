library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity draw is
    port(
        is_body, is_food, is_head, is_score : in std_logic;
        vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0)
    );
end entity;

architecture Behavioral of draw is
begin
    process(is_body, is_head, is_food)
    begin
        if(is_head = '1') then
            vgaRed <= "1111";
            vgaGreen <= "0000";
            vgaBlue <= "1111";
        elsif (is_body = '1') then
            vgaRed <= "0000";
            vgaGreen <= "1111";
            vgaBlue <= "0000";
        elsif (is_food = '1') then
            vgaRed <= "1111";
            vgaGreen <= "0000";
            vgaBlue <= "0000";
        elsif (is_score = '1') then
            vgaRed <= "1111";
            vgaGreen <= "1111";
            vgaBlue <= "1111";
        else 
            vgaRed <= "0000";
            vgaGreen <= "0000";
            vgaBlue <= "0000";
        end if;
    end process;
end Behavioral;
