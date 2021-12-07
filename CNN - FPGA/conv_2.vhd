library IEEE, STD;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.ALL;
use STD.TEXTIO.ALL;

entity conv_2 is
    Port ( clk : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           in_2 : in STD_LOGIC_VECTOR (79 downto 0);
           start_out : out STD_LOGIC := '0';
           last_out : out STD_LOGIC := '0';
           pop_out : out STD_LOGIC := '0';
           conv2_out : out STD_LOGIC_VECTOR (127 downto 0) );
end conv_2;

architecture Behavioral of conv_2 is

constant int : INTEGER := 1;
constant dec : INTEGER := -7;

constant int_2 : INTEGER := 3;
constant dec_2 : INTEGER := -12;

constant int_buff : INTEGER := 3;
constant dec_buff : INTEGER := -12;

constant up : INTEGER := 79;
constant down : INTEGER := 64;
constant bits : INTEGER := 16;

type w is array (0 to 199) of sfixed (int downto dec);
signal weights : w :=     (
                            "000001110", "000010101", "000011100", "111100100", "000000000", "000001100", "000011010", "111100010", 
                            "111111001", "111101001", "111111010", "000010100", "111101001", "111011101", "111111100", "000000111", 
                            "000001110", "111101010", "111111111", "000000100", "111110000", "111011111", "111011010", "111110000", 
                            "111110101", "111111101", "111101101", "000010100", "111101100", "111011101", "000000000", "000011100", 
                            "111100110", "000100111", "000100010", "000000111", "000010000", "000001010", "111110010", "000010110", 
                            "000010111", "000010011", "111100110", "000110110", "000110000", "111011011", "000011010", "111111010", 
                            "000010111", "000011010", "000010110", "001001001", "111110000", "111100011", "001011000", "111101010", 
                            "000100100", "000001100", "000010100", "000100001", "111111001", "111001101", "000010100", "000000011", 
                            "111101011", "000010111", "111100101", "111011011", "000000111", "111001010", "111011100", "111101000", 
                            "111111010", "000001001", "111011010", "000011100", "000100111", "000100101", "000001100", "000011010", 
                            "000010101", "000010010", "000010101", "000000101", "000100110", "000011001", "000001010", "000011100", 
                            "000001111", "000100000", "111111101", "111000111", "000000000", "000001011", "111011110", "000011111", 
                            "111000110", "111100111", "111100110", "111101110", "111111110", "000010100", "111111110", "111111110", 
                            "000101100", "000100100", "111111010", "000001001", "000100000", "111100100", "111111100", "111101111", 
                            "111101100", "000011000", "111100100", "111110010", "111100111", "111110101", "000001100", "000000000", 
                            "111101110", "111100001", "000100110", "000001010", "111111110", "000001101", "111100000", "111100001", 
                            "111101111", "111110100", "111111110", "000010011", "111110110", "000000100", "111011010", "111011011", 
                            "000100101", "000000000", "000010011", "111111111", "000100100", "111111111", "111101100", "000010101", 
                            "111100110", "000010000", "000100010", "111101010", "000001110", "111010101", "000011011", "111110011", 
                            "111100011", "111100101", "111110101", "000000001", "000000110", "111101110", "000100100", "000000011", 
                            "111101001", "111111101", "111100000", "111110101", "000000010", "000000100", "111100010", "000000000", 
                            "111110101", "111100100", "000001111", "111111000", "000010001", "111111010", "111111011", "111101000", 
                            "000100000", "111111010", "000010000", "111110000", "000010100", "000000110", "000001000", "000011001", 
                            "111110010", "111101110", "000011011", "111101011", "111110001", "111100110", "000010011", "000100100", 
                            "000011011", "111010111", "111100010", "000010101", "111111101", "000010111", "000011111", "111100100" );
                            
type b is array (0 to 7) of sfixed (int downto dec);
signal bias : b :=        ( "111111001", "111011011", "000100001", "111110101", "000110110", "111110111", "000000000", "111111101" );

type buff is array (0 to 7) of sfixed (int_buff downto dec_buff);
signal buff_1 : buff :=     ( others => X"0000" );

signal aux : UNSIGNED (2 downto 0) := "000";
signal cont : UNSIGNED (6 downto 0) := "0000000";
signal k_cont : UNSIGNED (3 downto 0) := "0000";
signal temp : STD_LOGIC_VECTOR (up downto 0);
constant zero_out : STD_LOGIC_VECTOR := X"0000";
        
begin

    process(clk, ready_in, in_2)
    begin
    
        if rising_edge(clk) then
        
            if ( ready_in = '1' ) then
            
                if ( cont < 84 ) then
                    
                    if ( k_cont = 0 ) then
                    
                        pop_out <= '1';
                        start_out <= '0';
                        k_cont <= k_cont + 1;
                        
                        if ( aux = 4 ) then
                        
                            buff_1(to_integer(k_cont)) <= resize (  to_sfixed(in_2(up downto down), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5)) + 
                                                                    to_sfixed(in_2(up - bits downto down - bits), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 1) +
                                                                    to_sfixed(in_2(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 2) +
                                                                    to_sfixed(in_2(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 3) +
                                                                    to_sfixed(in_2(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 4) + 
                                                                    buff_1(to_integer(k_cont)) + bias(0), int_buff, dec_buff, fixed_saturate, fixed_truncate );
                                                                    
                        else
                        
                            buff_1(to_integer(k_cont)) <= resize (  to_sfixed(in_2(up downto down), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5)) + 
                                                                    to_sfixed(in_2(up - bits downto down - bits), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 1) +
                                                                    to_sfixed(in_2(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 2) +
                                                                    to_sfixed(in_2(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 3) +
                                                                    to_sfixed(in_2(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 4) + 
                                                                    buff_1(to_integer(k_cont)), int_buff, dec_buff, fixed_saturate, fixed_truncate );
                                                                    
                       end if;
                                                                    
                        temp <=     in_2(up downto down) &  
                                    in_2(up - bits downto down - bits) & 
                                    in_2(up - (bits * 2) downto down - (bits * 2)) & 
                                    in_2(up - (bits * 3) downto down - (bits * 3)) & 
                                    in_2(up - (bits * 4) downto down - (bits * 4));
                                 
                                    
                    elsif ( (k_cont < 8) and (k_cont > 0) ) then
                    
                        k_cont <= k_cont + 1;
                        start_out <= '0';
                        pop_out <= '0';
                        
                        if ( aux = 4 ) then
                        
                            buff_1(to_integer(k_cont)) <= resize (  to_sfixed(temp(up downto down), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5)) + 
                                                                    to_sfixed(temp(up - bits downto down - bits), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 1) +
                                                                    to_sfixed(temp(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 2) +
                                                                    to_sfixed(temp(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 3) +
                                                                    to_sfixed(temp(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 4) + 
                                                                    buff_1(to_integer(k_cont)) + bias(to_integer(k_cont)), int_buff, dec_buff, fixed_saturate, fixed_truncate );
                                                                    
                        else
                        
                            buff_1(to_integer(k_cont)) <= resize (  to_sfixed(temp(up downto down), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5)) + 
                                                                    to_sfixed(temp(up - bits downto down - bits), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 1) +
                                                                    to_sfixed(temp(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 2) +
                                                                    to_sfixed(temp(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 3) +
                                                                    to_sfixed(temp(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * weights((to_integer(k_cont) * 25) + (to_integer(aux) * 5) + 4) + 
                                                                    buff_1(to_integer(k_cont)), int_buff, dec_buff, fixed_saturate, fixed_truncate );
                    
                        end if;

                    elsif (k_cont = 8 ) then
                       
                        k_cont <= "0000";
                        
                        if ( aux = 4 ) then
                        
                            aux <= "000";
                            cont <= cont + 1;
                            start_out <= '1';
                            buff_1 <= (others => X"0000");
                            
                            for i in 0 to 7 loop
                            
--                                report "capa2 " & to_hstring(STD_LOGIC_VECTOR ( buff_1(i) )); 
                    
                                if ( buff_1 (i) > 0 ) then
                                
                                    conv2_out((127 - (i * bits)) downto (112 - (i * bits))) <= STD_LOGIC_VECTOR ( buff_1(i) );
                                    
                                else
                                    
                                    conv2_out((127 - (i * bits)) downto (112 - (i * bits))) <= zero_out; 
                                    
                                end if;
                            
                            end loop;                         
                        
                        else
                       
                            aux <= aux + 1;
                            start_out <= '0';
                        
                        end if;
                        
                    end if; 
                    
                else
                    
                    start_out <= '0';
                    last_out <= '1';
                    
                end if;
                
            end if;

        end if;
        
    end process;
    
end Behavioral;