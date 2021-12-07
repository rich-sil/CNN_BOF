library IEEE, STD;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.ALL;
use STD.TEXTIO.ALL;

entity conv_1 is
    Port ( clk : in STD_LOGIC;
           in_1 : in STD_LOGIC_VECTOR (44 downto 0);
           start_out : out STD_LOGIC := '0';
           last_out : out STD_LOGIC := '0';
           start_bof : out STD_LOGIC := '0';
           conv1_out : out STD_LOGIC_VECTOR (79 downto 0) );
end conv_1;

architecture Behavioral of conv_1 is

constant int : INTEGER := 1;
constant dec : INTEGER := -7;

constant int_2 : INTEGER := 3;
constant dec_2 : INTEGER := -12;

constant int_buff : INTEGER := 3;
constant dec_buff : INTEGER := -12;

constant up : INTEGER := 79;
constant down : INTEGER := 64;
constant bits : INTEGER := 16;

type w is array (0 to 24) of sfixed (int downto dec);
signal weights : w :=       ( 
                              "111110101", "000010110", "111010011", "111010000", "000110100", 
                              "111101000", "001000101", "000010100", "111100011", "000110000", 
                              "111010100", "111001000", "000011110", "000101010", "111010001", 
                              "000010011", "000001110", "111101010", "111000000", "000000011", 
                              "000111110", "001000001", "000110011", "000011001", "000110000" );
                            
type b is array (0 to 4) of sfixed (int downto dec);
signal bias : b :=          ( "000000000", "111100110", "000000000", "000010111", "110110101" );

type buff is array (0 to 4) of sfixed (int_buff downto dec_buff);
signal buff_1 : buff :=     ( others => X"0000" );

signal cont : UNSIGNED (7 downto 0) := "00000000";
signal k_cont : UNSIGNED (2 downto 0) := "000";
signal fin : STD_LOGIC := '0';

constant zero_out : STD_LOGIC_VECTOR := X"0000";
        
begin

    process(clk, in_1)
    begin
    
        if rising_edge(clk) then
            
            if ( fin = '1' ) then
            
                start_out <= '0';
            
            elsif ( cont = 0 ) then
            
                start_bof <= '0';
                start_out <= '0';
                cont <= cont + 1;
                last_out <= '0';
                k_cont <= k_cont + 1;
                
                buff_1(to_integer(k_cont)) <= resize(   to_sfixed(in_1(44 downto 36), int, dec) * weights(0) + 
                                                        to_sfixed(in_1(35 downto 27), int, dec) * weights(1) + 
                                                        to_sfixed(in_1(26 downto 18), int, dec) * weights(2) + 
                                                        to_sfixed(in_1(17 downto 9), int, dec) * weights(3) + 
                                                        to_sfixed(in_1(8 downto 0), int, dec) * weights(4) + 
                                                        bias(to_integer(k_cont)), int_buff, dec_buff, fixed_saturate, fixed_truncate );                                       
                                                        
                
            elsif ( (k_cont < 5) and (cont < 177) ) then
            
                start_bof <= '0';
                start_out <= '0';
                k_cont <= k_cont + 1;
                last_out <= '0';
                
                buff_1(to_integer(k_cont)) <= resize(   to_sfixed(in_1(44 downto 36), int, dec) * weights(to_integer(k_cont) * 5) + 
                                                        to_sfixed(in_1(35 downto 27), int, dec) * weights((to_integer(k_cont) * 5) + 1) + 
                                                        to_sfixed(in_1(26 downto 18), int, dec) * weights((to_integer(k_cont) * 5) + 2) + 
                                                        to_sfixed(in_1(17 downto 9), int, dec) * weights((to_integer(k_cont) * 5) + 3) + 
                                                        to_sfixed(in_1(8 downto 0), int, dec) * weights((to_integer(k_cont) * 5) + 4) + 
                                                        bias(to_integer(k_cont)), int_buff, dec_buff, fixed_saturate, fixed_truncate ); 
                                                        
            elsif ( k_cont = 5 ) then
            
                start_out <= '1';
                
                for i in 0 to 4 loop
                
--                    report "capa1 " & to_hstring(STD_LOGIC_VECTOR(buff_1(i)));
                    
                    if ( buff_1 (i) > 0 ) then
                    
                        conv1_out((up - (i * bits)) downto (down - (i * bits))) <= STD_LOGIC_VECTOR( buff_1(i) );
                        
                    else
                        
                        conv1_out((up - (i * bits)) downto (down - (i * bits))) <= zero_out; 
                        
                    end if;
                    
                end loop;
                                
               if ( cont = 176) then
               
                   cont <= X"00";
                   k_cont <= "000"; 
                   start_bof <= '0';
                   last_out <= '1';
                   fin <= '1';
                   buff_1 <= (others => X"0000");
               
               else
                                
                   start_bof <= '1';
                   cont <= cont + 1;
                   k_cont <= "000";
                   last_out <= '0';
                   buff_1 <= (others => X"0000");
                   
               end if;
                
            end if;
            
        end if;
        
    end process;
    
end Behavioral;