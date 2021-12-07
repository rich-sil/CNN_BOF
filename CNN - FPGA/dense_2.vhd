library IEEE, STD;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.ALL;
use STD.TEXTIO.ALL;

entity dense_2 is
    Port ( clk : in STD_LOGIC;
           start_in : in STD_LOGIC;
           in_2 : in STD_LOGIC_VECTOR (287 downto 0);
           w_in : in STD_LOGIC_VECTOR (161 downto 0);
           get_in : in STD_LOGIC;
           get_out : out STD_LOGIC := '0';
           addra_2 : out STD_LOGIC_VECTOR (8 downto 0 ) := "000000000";
           start_out : out STD_LOGIC := '0';
           dense2_out : out STD_LOGIC_VECTOR (223 downto 0) );
end dense_2; 

architecture Behavioral of dense_2 is

constant int : INTEGER := 1;
constant dec : INTEGER := -7;

constant int_2 : INTEGER := 8;
constant dec_2 : INTEGER := -7;

constant up_w : INTEGER := 161;
constant down_w : INTEGER := 153;
constant bits_w : INTEGER := 9;

constant up : INTEGER := 287;
constant down : INTEGER := 272;
constant bits : INTEGER := 16;

type b is array (0 to 83) of sfixed (int downto dec);
signal bias : b :=        ( "000100001", "001000010", "000000101", "001011100", "000000000", "111111100", "000000111", "001011110", 
                            "000001101", "000011110", "010001110", "110011100", "111101011", "000011110", "000000111", "000111011", 
                            "010010111", "001101000", "000100101", "000101001", "000101101", "000000000", "010010100", "110111011", 
                            "000010001", "111111011", "000101010", "001011010", "001100011", "000001111", "000110000", "110100101", 
                            "101101110", "001001011", "001100000", "000110111", "000101100", "000111101", "000111110", "010001000", 
                            "010100100", "001000100", "000010111", "111101111", "000011001", "001000111", "110111001", "000001010", 
                            "001010100", "010001010", "000111101", "001000100", "001010110", "110000001", "000000011", "000101001", 
                            "010011000", "000100010", "010001000", "111011010", "001100001", "000100110", "001001111", "111010000", 
                            "010000001", "111111011", "111011010", "001101001", "110011101", "001010110", "001011010", "000001110", 
                            "111001001", "001111100", "110010100", "001000111", "000110001", "001001111", "000101001", "010101011", 
                            "001111010", "111111100", "100111110", "110010111" );

type buff is array (0 to 83) of sfixed (int_2 downto dec_2);
signal buff_1 : buff :=     ( others => X"0000" );

type buff_t is array (0 to 83) of sfixed (int_2 downto dec_2);
signal temp : buff_t :=     ( others => X"0000" );

signal aux : UNSIGNED (3 downto 0) := "0000";
signal address : UNSIGNED (8 downto 0) := "000000000";
signal flag : STD_LOGIC := '0';
signal k_cont : UNSIGNED (6 downto 0) := "0000000";
signal espera : STD_LOGIC := '0';
constant zero_out : STD_LOGIC_VECTOR := X"0000";
        
begin

    process(clk, start_in, in_2, w_in, get_in)
    begin
    
        if rising_edge(clk) then
        
            if ( start_in = '1' ) then
            
                flag <= '1';
                start_out <= '0';
            
                if ( k_cont = 0 ) then
            
                    address <= address + 1;
                                        
                end if;

            elsif ( (address > 0) and (flag = '1') ) then

                if ( espera = '0' ) then
    
                    espera <= '1';
                    address <= address + 1;
            
                elsif ( aux < 5 ) then
                    
                    if ( k_cont = 83 ) then
                
                        k_cont <= "0000000";
                        aux <= aux + 1;
                        
                    else
                                                
                        k_cont <= k_cont + 1;
                            
                    end if;
                        
                    if ( address < 419 ) then
                        
                       address <= address + 1;
                            
                    end if;
                    
                    buff_1(to_integer(k_cont)) <= resize (  to_sfixed(in_2(up downto down), int_2, dec_2) * to_sfixed(w_in(up_w downto down_w), int, dec) +
                                                            to_sfixed(in_2(up - bits downto down - bits), int_2, dec_2) * to_sfixed(w_in(up_w - bits_w downto down_w - bits_w), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 2) downto down_w - (bits_w * 2)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 3) downto down_w - (bits_w * 3)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 4) downto down_w - (bits_w * 4)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 5) downto down - (bits * 5)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 5) downto down_w - (bits_w * 5)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 6) downto down - (bits * 6)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 6) downto down_w - (bits_w * 6)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 7) downto down - (bits * 7)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 7) downto down_w - (bits_w * 7)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 8) downto down - (bits * 8)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 8) downto down_w - (bits_w * 8)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 9) downto down - (bits * 9)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 9) downto down_w - (bits_w * 9)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 10) downto down - (bits * 10)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 10) downto down_w - (bits_w * 10)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 11) downto down - (bits * 11)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 11) downto down_w - (bits_w * 11)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 12) downto down - (bits * 12)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 12) downto down_w - (bits_w * 12)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 13) downto down - (bits * 13)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 13) downto down_w - (bits_w * 13)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 14) downto down - (bits * 14)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 14) downto down_w - (bits_w * 14)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 15) downto down - (bits * 15)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 15) downto down_w - (bits_w * 15)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 16) downto down - (bits * 16)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 16) downto down_w - (bits_w * 16)), int, dec) +
                                                            to_sfixed(in_2(up - (bits * 17) downto down - (bits * 17)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 17) downto down_w - (bits_w * 17)), int, dec) +
                                                            buff_1(to_integer(k_cont)), int_2, dec_2, fixed_saturate, fixed_truncate );
                    
                        if (k_cont = 81 ) then
                        
                            get_out <= '1';
                            
                        else
                        
                            get_out <= '0';
                            
                        end if;
                    
                elsif ( aux = 5 ) then
            
                    aux <= aux + 1;
                    --flag <= '0';
                    --address <= "000000000";
                    k_cont <= "0000000";
                    get_out <= '0';
                    buff_1 <= (others => X"0000");
                    
                    start_out <= '1';
                    
                    for j in 0 to 83 loop
                
                        temp(j) <= resize( buff_1(j) + bias(j), int_2, dec_2, fixed_saturate, fixed_truncate);
--                        report "capa6 " & to_hstring(STD_LOGIC_VECTOR ( resize( buff_1(j) + bias(j), int_2, dec_2, fixed_saturate, fixed_truncate) ));
                
                    end loop;
        
                else
                
                    start_out <= '0';
                    
                    if ( get_in = '1' and k_cont < 5 ) then
                
                        k_cont <= k_cont + 1;
                    
                    elsif ( k_cont = 5 ) then
                
                        k_cont <= "0000000";
                        start_out <= '0';
                        flag <= '0';
                        address <= "000000000";
                        aux <= "0000";
                
                    end if;
                
                    for i in 0 to 13 loop 
                    
                        if ( temp( i + (to_integer(k_cont * 14)) ) > 0 ) then
                    
                            dense2_out(223 - (i * 16) downto 208 - (i * 16)) <= STD_LOGIC_VECTOR( temp(i + (to_integer(k_cont * 14))) );
                        
                        else
                        
                            dense2_out(223 - (i * 16) downto 208 - (i * 16)) <= zero_out;
                        
                        end if;
                        
                    end loop;
        
                end if;
        
            end if;
        
        end if;
    
    addra_2 <= STD_LOGIC_VECTOR( address );
        
    end process;
    
end Behavioral;