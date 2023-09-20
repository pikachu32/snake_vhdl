library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity score is
  Port (
    score: in std_logic_vector(11 downto 0);    
    row, col : in  std_logic_vector(15 downto 0);
    is_score: out std_logic
     );
end score;

architecture Behavioral of score is
    signal score_int: integer range 0 to 999:=to_integer(unsigned(score));
    signal digit0: integer range 0 to 9;
    signal digit1: integer range 0 to 9;
    signal digit2: integer range 0 to 9;
    
    type mem is array ( 0 to 191) of std_logic_vector(15 downto 0); 
    constant my_Rom : mem := (
         
        "0000000000000000"
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
                
        ,"0000000000000000"        
        ,"0000011111100000"        
        ,"0000110000110000"        
        ,"0001110000111000"        
        ,"0011100000011100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011100000011100"        
        ,"0001110000111000"        
        ,"0000110000110000"        
        ,"0000011111100000"        
        ,"0000000000000000"        
                
        ,"0000000000000000"        
        ,"0000000110000000"        
        ,"0000000111000000"        
        ,"0000000111100000"        
        ,"0000000110110000"        
        ,"0000000110011000"        
        ,"0000000110000000"        
        ,"0000000110000000"        
        ,"0000000110000000"        
        ,"0000000110000000"        
        ,"0000000110000000"        
        ,"0000000110000000"        
        ,"0000000110000000"        
        ,"0000000110000000"        
        ,"0001111111111000"        
        ,"0000000000000000"        
                
        ,"0000000000000000"        
        ,"0000111111100000"        
        ,"0001100000110000"        
        ,"0011000000011000"        
        ,"0011000000000000"        
        ,"0001100000000000"        
        ,"0000110000000000"        
        ,"0000011000000000"        
        ,"0000001100000000"        
        ,"0000000110000000"        
        ,"0000000011000000"        
        ,"0000000001100000"        
        ,"0000000000110000"        
        ,"0000000000011000"        
        ,"0001111111111000"        
        ,"0000000000000000"        
                
        ,"0000000000000000"        
        ,"0000111111100000"        
        ,"0001100000110000"        
        ,"0011000000011000"        
        ,"0011000000000000"        
        ,"0001100000000000"        
        ,"0000110000000000"        
        ,"0000011110000000"        
        ,"0000110000000000"        
        ,"0001100000000000"        
        ,"0011000000000000"        
        ,"0011000000000000"        
        ,"0011000000011000"        
        ,"0001100000110000"        
        ,"0000111111100000"        
        ,"0000000000000000"        
                 
        ,"0000000000000000"        
        ,"0000110000000000"        
        ,"0000111000000000"        
        ,"0000111100000000"        
        ,"0000110110000000"        
        ,"0000110011000000"        
        ,"0000110001100000"        
        ,"0000110000110000"        
        ,"0000110000011000"        
        ,"0001111111111000"        
        ,"0000110000000000"        
        ,"0000110000000000"        
        ,"0000110000000000"        
        ,"0000110000000000"        
        ,"0001111100000000"        
        ,"0000000000000000"        
                
        ,"0000000000000000"        
        ,"0001111111111100"        
        ,"0000000000001100"        
        ,"0000000000001100"        
        ,"0000000000001100"        
        ,"0000000000001100"        
        ,"0000111111111100"        
        ,"0001100000000000"        
        ,"0011000000000000"        
        ,"0011000000000000"        
        ,"0011000000000000"        
        ,"0011000000000000"        
        ,"0011000000000000"        
        ,"0001100000000000"        
        ,"0000111111111100"        
        ,"0000000000000000"        
                
        ,"0000000000000000"        
        ,"0000111111110000"        
        ,"0000000000011000"        
        ,"0000000000001100"        
        ,"0000000000001100"        
        ,"0000000000001100"        
        ,"0000111111101100"        
        ,"0001100000111100"        
        ,"0011000000011100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0001100000011000"        
        ,"0000111111110000"        
        ,"0000000000000000"        
                
        ,"0000000000000000"        
        ,"0001111111110000"        
        ,"0001100000010000"        
        ,"0001100000000000"        
        ,"0000110000000000"        
        ,"0000110000000000"        
        ,"0000011000000000"        
        ,"0000011000000000"        
        ,"0000001100000000"        
        ,"0000001100000000"        
        ,"0000001100000000"        
        ,"0000001100000000"        
        ,"0000001100000000"        
        ,"0000001100000000"        
        ,"0000001100000000"        
        ,"0000000000000000"        
                
                
        ,"0000000000000000"        
        ,"0000111111110000"        
        ,"0001100000011000"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0001100000011000"        
        ,"0000111111110000"        
        ,"0001100000011000"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0001100000011000"        
        ,"0000111111110000"        
        ,"0000000000000000"        
                
        ,"0000000000000000"        
        ,"0000111111110000"        
        ,"0001100000011000"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011000000001100"        
        ,"0011100000011000"        
        ,"0011111111110000"        
        ,"0011000000000000"        
        ,"0011000000000000"        
        ,"0011000000000000"        
        ,"0011000000000000"        
        ,"0011000000001100"        
        ,"0001100000011000"        
        ,"0000111111110000"        
        ,"0000000000000000"        
                
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        
        ,"0000000011000000"        
        ,"0000000011000000"        
        ,"0000000000000000"        
        ,"0000000000000000"        


    );

begin
    
    process(row, col, score)
        variable r : integer := 0;
        variable c : natural := 0;   
        variable temp_score: std_logic := '0'; 
        
    begin
        temp_score:= '0';
        if (row >= "0000000000001000" and row <= "0000000000011000") and
           (col >= "0000001111101000" and col <= "0000001111111000") then
            r := 16 + (score_int mod 10) * 16 + to_integer(unsigned(row) - "0000000000001000");
            c := to_integer(unsigned(col) - "0000001111101000");
            temp_score := my_Rom(r)(c);
        end if;
        
        if (row >= "0000000000001000" and row <= "0000000000011000") and
           (col >= "0000001111011000" and col <= "0000001111101000") then
            r := 16 + ((score_int/10) mod 10) * 16 + to_integer(unsigned(row) - "0000000000001000");
            c := to_integer(unsigned(col) - "0000001111011000");
            temp_score := my_Rom(r)(c);
        end if;
        
        if (row >= "0000000000001000" and row <= "0000000000011000") and
           (col >= "0000001111001000" and col <= "0000001111011000") then
            r := 16 + ((score_int/100) mod 10) * 16 + to_integer(unsigned(row) - "0000000000001000");
            c := to_integer(unsigned(col) - "0000001111001000");
            temp_score := my_Rom(r)(c);
        end if;
        is_score <= temp_score;
    end process;
        
end Behavioral;
