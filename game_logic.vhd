library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_logic is
    generic(
        --sreen resolution for vga
        screen_width : integer:=1024;
        screen_height : integer:=768;
        food_width :integer:=16;
        head_width:integer:=16;
        snake_begin_x:integer:=300;
        snake_begin_y:integer:=450;
        snake_length_begin:integer:=4;
        snake_length_max:integer:=50;
        food_begin_x:integer:=800;
        food_begin_y:integer:=500);
    port(
        --game logic part
        clk65Mhz            : in  std_logic;
        direction           : in  std_logic_vector(1 downto 0);
        stop                : in  std_logic;
        reset               : in  std_logic;
        --rgb generation part
        en                  : in  std_logic;
        row, col            : in  std_logic_vector(15 downto 0);
        is_body, is_food, is_head: out std_logic;
        score: out std_logic_vector(11 downto 0));
end entity;

architecture Behavioral of game_logic is
    --components of 32 bit body part: | 16bit: x position | 16bit: y position |
    subtype xy is std_logic_vector(31 downto 0);
    type xys is array (integer range <>) of xy;

    signal snake_length         : integer range 0 to snake_length_max;
    signal snake_body_xy        : xys(0 to snake_length_max - 1);
    signal food_xy              : xy;
    signal random_xy            : unsigned(31 downto 0);   
    signal score_reg: integer range 0 to 999; 
    
    signal delay:integer:=0;
    signal count:integer:=0;
begin

snake_move:
    process(clk65Mhz, reset, random_xy)
        variable inited                     : std_logic := '0';
        variable snake_head_xy_next       : xy := (others => '0');
        variable food_xy_next             : xy := (others => '0');
        variable snake_length_next        : integer := 0;
        variable dx, dy                     : signed(15 downto 0) := (others => '0');
    begin
        food_xy         <= food_xy_next;
        snake_length    <= snake_length_next;
        score<=std_logic_vector(to_signed(score_reg, 12));
        if (reset = '1' or inited = '0') then
            --reset speed
            delay<=6000000;
            
            --reset snake length
            snake_length_next := snake_length_begin;

            --set food position
            food_xy_next(31 downto 16) := std_logic_vector(to_signed(food_begin_x, 16));
            food_xy_next(15 downto 0) := std_logic_vector(to_signed(food_begin_y, 16));

            --set head position
            snake_head_xy_next(31 downto 16)  := std_logic_vector(to_signed(snake_begin_x , 16));
            snake_head_xy_next(15 downto 0)   := std_logic_vector(to_signed(snake_begin_y , 16));

            --set snake position
            for i in 0 to snake_length_max - 1 loop
                snake_body_xy(i) <= snake_head_xy_next;
            end loop;
            
            --reset score
            score_reg<=0;
            
            inited := '1';
        elsif (rising_edge(clk65Mhz)) then
            if (stop = '0') then
                --move
                count<=count+1;
                if count>=delay then
                case direction is
                    when("00") =>       --up
                        snake_head_xy_next(15 downto 0) := std_logic_vector(signed(snake_head_xy_next(15 downto 0)) - head_width);
                    when("01") =>       --right
                        snake_head_xy_next(31 downto 16) := std_logic_vector(signed(snake_head_xy_next(31 downto 16)) + head_width);
                    when("10") =>       --down
                        snake_head_xy_next(15 downto 0) := std_logic_vector(signed(snake_head_xy_next(15 downto 0)) + head_width);
                    when("11") =>       --left
                        snake_head_xy_next(31 downto 16) := std_logic_vector(signed(snake_head_xy_next(31 downto 16)) - head_width);
                    when others =>
                        snake_head_xy_next(15 downto 0) := std_logic_vector(signed(snake_head_xy_next(15 downto 0)) - head_width);
                end case;
                for i in snake_length_max - 1 downto 1 loop
                    snake_body_xy(i) <= snake_body_xy(i - 1);
                end loop;
                snake_body_xy(0) <= snake_head_xy_next; --push new head to snake body queue
                count<=0;
            end if;

                --boundary check
                if (signed(snake_head_xy_next(31 downto 16)) < 0 or 
                    signed(snake_head_xy_next(31 downto 16)) >= screen_width or
                    signed(snake_head_xy_next(15 downto 0)) < 0 or
                    signed(snake_head_xy_next(15 downto 0)) >= screen_height) then
                    inited := '0';
                end if;
                
                --body check
                for i in snake_length_max - 1 downto 1 loop
                    dx := abs(signed(snake_head_xy_next(31 downto 16)) - signed(snake_body_xy(i)(31 downto 16)));
                    dy := abs(signed(snake_head_xy_next(15 downto 0))  - signed(snake_body_xy(i)(15 downto 0)));
                    if(i<snake_length)then
                        if(dx<head_width and dy<head_width)then
                            inited:='0';
                        end if;
                    end if;
                end loop;

                --food check
                --x and y distance from body part or food
                dx := abs(signed(snake_head_xy_next(31 downto 16)) - signed(food_xy_next(31 downto 16)));
                dy := abs(signed(snake_head_xy_next(15 downto 0))  - signed(food_xy_next(15 downto 0)));
                if (dy < (food_width + head_width) / 2 and dx < (food_width + head_width) / 2) then
                    snake_length_next := snake_length_next + 1;
                    --change food position 
                    food_xy_next := std_logic_vector(random_xy);
                    
                    --increse speed
                    delay<=delay-1000;
                    
                    --increase score
                    score_reg<=score_reg+1;
                end if;
            end if;
        end if;
    end process;

    
ramdom_number_gen:
    process(clk65Mhz)
        variable random_x : unsigned(15 downto 0) := (others => '0');
        variable random_y : unsigned(15 downto 0) := (others => '0');
    begin
        if (rising_edge(clk65Mhz)) then
            if (random_x = to_unsigned(screen_width - 14, 16)) then 
                random_x := (others => '0');
            end if;
            if (random_y = to_unsigned(screen_height - 14, 16)) then 
                random_y := (others => '0');
            end if;
            random_x := random_x + 1;
            random_y := random_y + 1;
            random_xy(31 downto 16) <= random_x + 7;
            random_xy(15 downto 0) <= random_y + 7;
        end if;
    end process;

draw:
    process(snake_length, snake_body_xy, food_xy, row, col, en)
        --x and y distance from body part or food
        variable dx, dy             : signed(15 downto 0) := (others => '0');
    begin
        if (en = '1') then 
            --draw head
            is_head<='0';
            dx := abs(signed(col) - signed(snake_body_xy(0)(31 downto 16)));
            dy := abs(signed(row) - signed(snake_body_xy(0)(15 downto 0)));
            if (dx < head_width / 2 and dy < head_width / 2) then
                    is_head <= '1';
                end if;
            --draw body
            is_body <= '0';
            for i in 1 to snake_length_max - 1 loop
                dx := abs(signed(col) - signed(snake_body_xy(i)(31 downto 16)));
                dy := abs(signed(row) - signed(snake_body_xy(i)(15 downto 0)));
                if (i < snake_length) then  --if is valid snake body
                    if (dx < head_width / 2 and dy < head_width / 2) then
                        is_body <= '1';
                    end if;
                end if;
            end loop;
            --draw food
            dx := abs(signed(col) - signed(food_xy(31 downto 16)));--x and y distance from body part or food
            dy := abs(signed(row) - signed(food_xy(15 downto 0)));
            if ( (dx * dx + dy * dy) < (food_width/2)* (food_width/2) ) then --circle ecuation x^2+y^2=r^2
                is_food <= '1';
            else 
                is_food <= '0';
            end if;

            
        end if;
    end process;
end Behavioral;
