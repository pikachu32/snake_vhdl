library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity game is
  Port (
    clk100Mhz : in std_logic;
    button:in std_logic_vector(4 downto 0); -- up-0 right-1 down-2 left-3 stop-4
    HSync: out std_logic;
    VSync: out std_logic;
    vgaRed : out std_logic_vector(3 downto 0);
    vgaGreen : out std_logic_vector(3 downto 0); 
    vgaBlue : out std_logic_vector(3 downto 0));
end game;

architecture Behavioral of game is
    component clk_wiz_0 is
        Port ( clk_in1 : in STD_LOGIC; 
            clk_out1: out STD_LOGIC);
        end component;
        
    component buttons is
        Port (
            clk65Mhz : in std_logic;
            button : in std_logic_vector(4 downto 0); -- up-0 right-1 down-2 left-3 stop-4
            current_direction: in std_logic_vector(1 downto 0);
            stop :out std_logic;
            direction : out std_logic_vector(1 downto 0) );
    end component;
    
    component Sync_VGA is 
        Generic(
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
    end component;
        
    component game_logic is 
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
     end component;
     
     component draw is
        port(
        is_body, is_food, is_head, is_score : in std_logic;
        vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0)
    );
    end component;
    
    component score is
      Port (
        score: in std_logic_vector(11 downto 0);    
        row, col : in  std_logic_vector(15 downto 0);
        is_score: out std_logic
         );
    end component;
     
     signal clk65Mhz: std_logic;
     signal stop_reg: std_logic;
     signal direction_reg:std_logic_vector(1 downto 0);
     signal en_reg:std_logic;
     signal HAddr_reg:std_logic_vector(15 downto 0);
     signal VAddr_reg:std_logic_vector(15 downto 0);
     signal is_body, is_head, is_food, is_score:std_logic;
     signal score_reg:std_logic_vector(11 downto 0);
             
begin

    clk_gen:clk_wiz_0
        Port Map(
            clk_in1=>clk100Mhz,
            clk_out1=>clk65Mhz);
    
    Btn: buttons
        Port Map(
            clk65Mhz => clk65Mhz,
            button => button,
            current_direction =>direction_reg,
            stop=>stop_reg,
            direction=>direction_reg);
            
    SyncVGA : Sync_VGA
        Port Map(
            clk=>clk65Mhz,
            HSync=>HSync,
            VSync=>VSync,
            VAddr=>VAddr_reg,
            HAddr=>HAddr_reg,
            en_q=>en_reg);
            
    GameLogic: game_logic
        generic map(
            screen_width =>1024,
            screen_height =>768,
            food_width =>16,
            head_width=>16,
            snake_begin_x=>300,
            snake_begin_y=>450,
            snake_length_begin=>4,
            snake_length_max=>50,
            food_begin_x=>800,
            food_begin_y=>500)
        Port Map(
            clk65Mhz=>clk65Mhz,
            direction=>direction_reg,
            stop=>stop_reg,
            reset=>'0',
            en=>en_reg,
            row=>VAddr_reg,
            col=>HAddr_reg,
            is_body=>is_body,
            is_head=>is_head,
            is_food=>is_food,
            score=>score_reg);
            
    Drawing: draw
        Port Map(
            is_body=>is_body,
            is_food=> is_food,
            is_head =>is_head,
            is_score=>is_score,
            vgaRed=>vgaRed, 
            vgaGreen=>vgaGreen, 
            vgaBlue=>vgaBlue);
            
    Scoring: score
          Port map (
            score =>score_reg,  
            row=>VAddr_reg, 
            col=>HAddr_reg,
            is_score=>is_score);

end Behavioral;
