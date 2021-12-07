library IEEE, STD;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.ALL;
use STD.TEXTIO.ALL;

entity conv_3 is
    Port ( clk : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           in_3 : in STD_LOGIC_VECTOR (127 downto 0);
           start_out : out STD_LOGIC := '0';
           last_out : out STD_LOGIC := '0';
           pop_out : out STD_LOGIC := '0';
           conv3_out : out STD_LOGIC_VECTOR (191 downto 0) );
end conv_3;

architecture Behavioral of conv_3 is

constant int : INTEGER := 1;
constant dec : INTEGER := -7;

constant int_2 : INTEGER := 3;
constant dec_2 : INTEGER := -12;

constant int_buff : INTEGER := 3;
constant dec_buff : INTEGER := -12;

constant up : INTEGER := 127;
constant down : INTEGER := 112;
constant bits : INTEGER := 16;

type w is array (0 to 479) of sfixed (int downto dec);
signal weights : w :=     (
                            "111101000", "111110010", "000110010", "000011001", "000100001", "000000110", "111111011", "000001111", "000011001", 
                            "111110000", "000000100", "000010100", "000100000", "000010011", "111110101", "000001100", "000010101", "111110101", 
                            "111100110", "000010010", "000011111", "000000101", "000000011", "111100100", "000000001", "111111111", "000000111", 
                            "111101110", "111111001", "000000101", "111100011", "000011000", "000000110", "111100011", "111100010", "000001100", 
                            "000100100", "000010011", "000000010", "000000101", "000000110", "111111011", "000100011", "000010110", "111111000", 
                            "111110111", "000010011", "000000000", "111100011", "000010100", "111110110", "000001100", "000011111", "111100100", 
                            "111101110", "111111000", "111111011", "000000000", "000000001", "000010011", "111100111", "111110100", "111101010", 
                            "000001100", "111101100", "000011001", "111111001", "000100001", "111110001", "000011101", "000000111", "111101001", 
                            "111101110", "000100101", "000010110", "000000011", "111110011", "000000001", "111110001", "000000101", "000000000", 
                            "111011000", "001100110", "000011111", "000111111", "000000110", "000010101", "111101111", "111111000", "111100001", 
                            "001001010", "000010101", "000111110", "111101011", "111100001", "111100100", "000010010", "000010000", "110111000", 
                            "111010000", "000010010", "000000000", "111111001", "111101000", "000011011", "111110011", "110101000", "111110111", 
                            "111001011", "111101011", "111101111", "000011010", "111100010", "000011000", "111111111", "000001110", "111001100", 
                            "000000000", "000000000", "111101000", "111111001", "000011101", "111000010", "111110100", "110110110", "000000101", 
                            "000010100", "000000001", "111110001", "000011010", "111010001", "111101001", "111101001", "111110010", "111100010", 
                            "111100110", "000000011", "000001100", "111100111", "000010100", "000100110", "000010001", "111101010", "000011111", 
                            "000010001", "111110011", "000110011", "000001010", "001010101", "000001011", "000010010", "000001100", "000011011", 
                            "111010100", "000000011", "111011101", "001011011", "000000100", "000011010", "000011101", "111110100", "000000110", 
                            "111001100", "000010011", "110110111", "111101010", "000011100", "000001000", "000001101", "000101000", "111111011", 
                            "000010001", "111011000", "000000011", "000010111", "000011011", "000010001", "000100011", "000110001", "000101011", 
                            "111111110", "111100010", "111110111", "111111101", "111111111", "111101000", "000100111", "111100111", "000100011", 
                            "000010100", "000010000", "111101000", "000100001", "000010000", "000001110", "111100000", "001000111", "111111000", 
                            "000001001", "111101011", "111010111", "111001100", "001001110", "000100000", "001000100", "000100011", "111111010", 
                            "000001010", "111011111", "000000110", "111111111", "111011111", "000101110", "000000000", "111110100", "000000000", 
                            "111101110", "000000011", "110101010", "111101110", "111001010", "000000101", "111111111", "111100110", "000001100", 
                            "000100001", "111111101", "000111011", "111100111", "000010111", "000011100", "111110000", "000000000", "111111100", 
                            "001010010", "000110110", "000010010", "111100111", "111100110", "000000110", "000011001", "000100011", "111101010", 
                            "000000011", "111001000", "000010111", "111111001", "111111111", "000000011", "000001010", "000100111", "000011100", 
                            "111110111", "111110111", "111110100", "111110011", "111111110", "111101100", "000101100", "000101010", "111101111", 
                            "000010001", "111101010", "000010100", "111101010", "111001111", "000010001", "000001001", "000110000", "000000110", 
                            "111111101", "000000000", "000010000", "111011011", "111101111", "111011110", "000011010", "000010111", "111111110", 
                            "000000011", "000010010", "111101011", "111101001", "000010000", "111110111", "111100101", "000000101", "111110101", 
                            "111101011", "111110001", "111011111", "111111110", "111111001", "000010101", "111111011", "000010101", "000010101", 
                            "111110000", "111011010", "111100001", "000010001", "000010100", "000001110", "000011100", "000010111", "000001010", 
                            "111101001", "111110111", "000001000", "111101100", "000001110", "111110101", "111100111", "000100011", "000000000", 
                            "111101001", "111011110", "000001110", "111110101", "000011110", "111110101", "111110000", "111111111", "000010011", 
                            "111101110", "000001000", "000001010", "111110111", "111111110", "000000111", "000000000", "111110111", "000011001", 
                            "111100110", "111111010", "111110100", "000000001", "111111110", "111101100", "111101110", "111110110", "111101110", 
                            "111110001", "111101011", "111110111", "111100101", "000000011", "000010011", "111110011", "000011001", "000010100", 
                            "111111001", "111111011", "000000101", "111100011", "111100110", "111101000", "111110111", "000011100", "000010001", 
                            "000000101", "000010100", "111110010", "111101101", "111100101", "000000000", "111101000", "000011001", "000000111", 
                            "000001001", "111100010", "111011100", "000001101", "000001111", "111110010", "111100110", "111111110", "111100111", 
                            "000000110", "111110000", "111111101", "000001111", "111111010", "000000000", "000000100", "111111111", "000000011", 
                            "111011101", "111110111", "000010001", "000001010", "111110000", "000010001", "000001000", "111110010", "111110000", 
                            "111101000", "000010011", "111101111", "111101000", "000011000", "000001111", "111100100", "111110001", "111101101", 
                            "111110011", "111100111", "111110111", "000011101", "000100101", "000000000", "111100110", "111111110", "000010111", 
                            "000000000", "111100100", "111101010", "000000001", "111101110", "000100011", "111101010", "000000111", "000010111", 
                            "111100110", "000001100", "000110011", "000100011", "000011011", "111100010", "000001101", "111110001", "000011101", 
                            "111110101", "000110111", "111111001", "000011011", "111101011", "000011100", "000001100", "111111100", "000000011", 
                            "000000010", "000101011", "111101101", "001100010", "111110111", "000000000", "000001010", "111100010", "111010000", 
                            "000011100", "111111001", "001110101", "111110110", "111101101", "000000101", "000001011", "111110010", "111011100", 
                            "111110110", "000011100", "111110001", "111101111", "111101110", "000001111", "000111011", "110100001", "111101100", 
                            "100111101", "111111000", "111101101", "000000011", "111110010", "001000111", "000001101", "000110111", "101010101", 
                            "000010001", "000010000", "000010001" );
                            
type b is array (0 to 11) of sfixed (int downto dec);
signal bias : b :=        ( "000101011", "111110110", "000000111", "000101100", "111100111", "111011001", "000011101", "000000100", 
                            "000000000", "111111001", "111100011", "111111010" );

type buff is array (0 to 11) of sfixed (int_buff downto dec_buff);
signal buff_1 : buff :=     ( others => X"0000" );

signal aux : UNSIGNED (2 downto 0) := "000";
signal cont : UNSIGNED (5 downto 0) := "000000";
signal k_cont : UNSIGNED (3 downto 0) := "0000";
signal temp : STD_LOGIC_VECTOR (up downto 0);
constant zero_out : STD_LOGIC_VECTOR := X"0000";

--type p is array (0 to 7) of STD_LOGIC_VECTOR (8 downto 0);
--signal pesos : p :=     ( others => "000000000" );
--signal bi : STD_LOGIC_VECTOR (8 downto 0);
--type m is array (0 to 7) of sfixed (int_2 downto dec_2);
--signal mults : m :=     ( others => X"0000");
--signal sum : sfixed (int_2 downto dec_2);
        
begin

    process(clk, ready_in, in_3)
    begin
    
        if rising_edge(clk) then
        
            if ( ready_in = '1' ) then
            
                if ( cont < 38 ) then
                    
                    if ( k_cont = 0 ) then
                    
                        pop_out <= '1';
                        start_out <= '0';
                        k_cont <= k_cont + 1;
                        
                        if ( aux = 4 ) then
                        
                            buff_1(to_integer(k_cont)) <= resize (  to_sfixed(in_3(up downto down), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)) +
                                                                    to_sfixed(in_3(up - bits downto down - bits), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 1) +
                                                                    to_sfixed(in_3(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 2) +
                                                                    to_sfixed(in_3(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 3) + 
                                                                    to_sfixed(in_3(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 4) +
                                                                    to_sfixed(in_3(up - (bits * 5) downto down - (bits * 5)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 5) +
                                                                    to_sfixed(in_3(up - (bits * 6) downto down - (bits * 6)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 6) +
                                                                    to_sfixed(in_3(up - (bits * 7) downto down - (bits * 7)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 7) + 
                                                                    buff_1(to_integer(k_cont)) + bias(0), int_buff, dec_buff, fixed_saturate, fixed_truncate );
                                                                    
                         else
                         
                            buff_1(to_integer(k_cont)) <= resize (  to_sfixed(in_3(up downto down), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)) +
                                                                    to_sfixed(in_3(up - bits downto down - bits), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 1) +
                                                                    to_sfixed(in_3(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 2) +
                                                                    to_sfixed(in_3(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 3) + 
                                                                    to_sfixed(in_3(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 4) +
                                                                    to_sfixed(in_3(up - (bits * 5) downto down - (bits * 5)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 5) +
                                                                    to_sfixed(in_3(up - (bits * 6) downto down - (bits * 6)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 6) +
                                                                    to_sfixed(in_3(up - (bits * 7) downto down - (bits * 7)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 7) + 
                                                                    buff_1(to_integer(k_cont)), int_buff, dec_buff, fixed_saturate, fixed_truncate );
                         
                         end if;
                                                                    
                         temp <=    in_3(up downto down) &  
                                    in_3(up - bits downto down - bits) & 
                                    in_3(up - (bits * 2) downto down - (bits * 2)) &                         
                                    in_3(up - (bits * 3) downto down - (bits * 3)) &  
                                    in_3(up - (bits * 4) downto down - (bits * 4)) & 
                                    in_3(up - (bits * 5) downto down - (bits * 5)) & 
                                    in_3(up - (bits * 6) downto down - (bits * 6)) & 
                                    in_3(up - (bits * 7) downto down - (bits * 7));                      
                                    
                    elsif ( (k_cont < 12) and (k_cont > 0) ) then
                    
                        k_cont <= k_cont + 1;
                        start_out <= '0';
                        pop_out <= '0';
                    
                        if ( aux = 4 ) then
                        
                            buff_1(to_integer(k_cont)) <= resize (  to_sfixed(temp(up downto down), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)) +
                                                                    to_sfixed(temp(up - bits downto down - bits), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 1) +
                                                                    to_sfixed(temp(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 2) +
                                                                    to_sfixed(temp(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 3) + 
                                                                    to_sfixed(temp(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 4) +
                                                                    to_sfixed(temp(up - (bits * 5) downto down - (bits * 5)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 5) +
                                                                    to_sfixed(temp(up - (bits * 6) downto down - (bits * 6)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 6) +
                                                                    to_sfixed(temp(up - (bits * 7) downto down - (bits * 7)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 7) + 
                                                                    buff_1(to_integer(k_cont)) + bias(to_integer(k_cont)), int_buff, dec_buff, fixed_saturate, fixed_truncate );
                                                                    
                         else
                         
                            buff_1(to_integer(k_cont)) <= resize (  to_sfixed(temp(up downto down), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)) +
                                                                    to_sfixed(temp(up - bits downto down - bits), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 1) +
                                                                    to_sfixed(temp(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 2) +
                                                                    to_sfixed(temp(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 3) + 
                                                                    to_sfixed(temp(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 4) +
                                                                    to_sfixed(temp(up - (bits * 5) downto down - (bits * 5)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 5) +
                                                                    to_sfixed(temp(up - (bits * 6) downto down - (bits * 6)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 6) +
                                                                    to_sfixed(temp(up - (bits * 7) downto down - (bits * 7)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 7) + 
                                                                    buff_1(to_integer(k_cont)), int_buff, dec_buff, fixed_saturate, fixed_truncate );
                         end if;
                         
--                         if (k_cont = 1) then
                         
--                             pesos(0) <= STD_LOGIC_VECTOR(weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)));
--                             pesos(1) <= STD_LOGIC_VECTOR(weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 1));
--                             pesos(2) <= STD_LOGIC_VECTOR(weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 2));
--                             pesos(3) <= STD_LOGIC_VECTOR(weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 3));
--                             pesos(4) <= STD_LOGIC_VECTOR(weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 4));
--                             pesos(5) <= STD_LOGIC_VECTOR(weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 5));
--                             pesos(6) <= STD_LOGIC_VECTOR(weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 6));
--                             pesos(7) <= STD_LOGIC_VECTOR(weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8) + 7));
                             
--                             mults(0) <= resize ( to_sfixed(temp(up downto down), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)), int_2, dec_2, fixed_saturate, fixed_round );
--                             mults(1) <= resize ( to_sfixed(temp(up - bits downto down - bits), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)), int_2, dec_2, fixed_saturate, fixed_round );
--                             mults(2) <= resize ( to_sfixed(temp(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)), int_2, dec_2, fixed_saturate, fixed_round );
--                             mults(3) <= resize ( to_sfixed(temp(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)), int_2, dec_2, fixed_saturate, fixed_round );
--                             mults(4) <= resize ( to_sfixed(temp(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)), int_2, dec_2, fixed_saturate, fixed_round );
--                             mults(5) <= resize ( to_sfixed(temp(up - (bits * 5) downto down - (bits * 5)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)), int_2, dec_2, fixed_saturate, fixed_round );
--                             mults(6) <= resize ( to_sfixed(temp(up - (bits * 6) downto down - (bits * 6)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)), int_2, dec_2, fixed_saturate, fixed_round );
--                             mults(7) <= resize ( to_sfixed(temp(up - (bits * 7) downto down - (bits * 7)), int_2, dec_2) * weights((to_integer(k_cont) * 40) + (to_integer(aux) * 8)), int_2, dec_2, fixed_saturate, fixed_round );
                             
--                        end if;
                                                                 
                                                                                                  
                    elsif (k_cont = 12 ) then
                       
                        k_cont <= "0000";
                        
                        if ( aux = 4 ) then
                        
                            aux <= "000";
                            cont <= cont + 1;
                            start_out <= '1';
                            buff_1 <= (others => X"0000");
                            
                            for i in 0 to 11 loop
                            
--                                report "capa3 " & to_hstring(STD_LOGIC_VECTOR ( buff_1(i) ));
                    
                                if ( buff_1(i) > 0 ) then
                                
                                    conv3_out((191 - (i * bits)) downto (176 - (i * bits))) <= STD_LOGIC_VECTOR ( buff_1(i) );
                                    
                                else
                                    
                                    conv3_out((191 - (i * bits)) downto (176 - (i * bits))) <= zero_out; 
                                    
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