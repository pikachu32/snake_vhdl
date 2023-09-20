library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity buttons is
  Port (
    clk65Mhz : in std_logic;
    button : in std_logic_vector(4 downto 0); -- up-0 right-1 down-2 left-3 stop-4
    current_direction: in std_logic_vector(1 downto 0);
    stop :out std_logic;
    direction : out std_logic_vector(1 downto 0) );
end buttons;

architecture Behavioral of buttons is
    signal old_button : std_logic_vector(4 downto 0) :=(others => '0');
    signal stop_next: std_logic :='0';
    signal direction_next : std_logic_vector(1 downto 0) :="00";

begin
    process(clk65Mhz)
    begin
        if rising_edge(clk65Mhz) then        
            if old_button(0)='0' and button(0)='1' and current_direction /="10" then
                direction_next<= "00" ;--up
            end if;
            if old_button(1)='0' and button(1)='1' and current_direction/="11" then
                direction_next<= "01" ;--right
            end if;
            if old_button(2)='0' and button(2)='1' and current_direction/="00" then
                direction_next<= "10" ;--down
            end if;
            if old_button(3)='0' and button(3)='1' and current_direction/="01" then
                direction_next<= "11" ;--left
            end if;
            if old_button(4)='0' and button(4)='1' then
                stop_next<= not stop_next;
            end if;
            old_button<=button;
        end if;
        stop<=stop_next;
        direction<=direction_next;
    end process;
end Behavioral;
