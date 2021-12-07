library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.ALL;

entity dense_3 is
    Port ( clk : in STD_LOGIC;
           start_in : in STD_LOGIC;
           in_3 : in STD_LOGIC_VECTOR (223 downto 0);
           w_in : in STD_LOGIC_VECTOR (125 downto 0);
           ap_ready : in STD_LOGIC;
           get_out : out STD_LOGIC := '0';
           addra_3 : out STD_LOGIC_VECTOR (6 downto 0 ) := "0000000";
           ap_start : out STD_LOGIC := '0';
           dense3_out : out STD_LOGIC_VECTOR (15 downto 0) );
end dense_3; 

architecture Behavioral of dense_3 is

constant int : INTEGER := 1;
constant dec : INTEGER := -7;

constant int_2 : INTEGER := 8;
constant dec_2 : INTEGER := -7;

constant up_w : INTEGER := 125;
constant down_w : INTEGER := 117;
constant bits_w : INTEGER := 9;

constant up : INTEGER := 223;
constant down : INTEGER := 208;
constant bits : INTEGER := 16;

type b is array (0 to 18) of sfixed (int downto dec);
signal bias : b :=        ( "000010000", "000110101", "110100001", "000011111", "000101111", "101101110", "000011100", "001100001", 
                            "110110101", "111001100", "110000010", "001101001", "001000111", "000010100", "000100011", "111000010", 
                            "110100111", "000010000", "111110110" );

type buff is array (0 to 18) of sfixed (int_2 downto dec_2);
signal buff_1 : buff :=     ( others => X"0000" );

signal aux : UNSIGNED (3 downto 0) := "0000";
signal address : UNSIGNED (6 downto 0) := "0000000";
signal flag : STD_LOGIC := '0';
signal k_cont : UNSIGNED (4 downto 0) := "00000";
signal espera : STD_LOGIC := '0';
signal cont_out : UNSIGNED (4 downto 0) := "00000";
        
begin

    process(clk, start_in, in_3, w_in, ap_ready)
    begin
    
        if rising_edge(clk) then
        
            if ( start_in = '1' ) then
            
                flag <= '1';
                ap_start <= '0';
            
                if ( k_cont = 0 ) then
            
                    address <= address + 1;
                                        
                end if;

            elsif ( (address > 0) and (flag = '1') ) then

                if ( espera = '0' ) then
    
                    espera <= '1';
                    address <= address + 1;
            
                elsif ( aux < 6 ) then
                    
                    if ( k_cont = 18 ) then
                
                        k_cont <= "00000";
                        aux <= aux + 1;
                        
                    else
                                                
                        k_cont <= k_cont + 1;
                            
                    end if;
                        
                    if ( address < 113 ) then
                        
                       address <= address + 1;
                            
                    end if;
                    
                    buff_1(to_integer(k_cont)) <= resize (  to_sfixed(in_3(up downto down), int_2, dec_2) * to_sfixed(w_in(up_w downto down_w), int, dec) +
                                                            to_sfixed(in_3(up - bits downto down - bits), int_2, dec_2) * to_sfixed(w_in(up_w - bits_w downto down_w - bits_w), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 2) downto down_w - (bits_w * 2)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 3) downto down_w - (bits_w * 3)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 4) downto down_w - (bits_w * 4)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 5) downto down - (bits * 5)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 5) downto down_w - (bits_w * 5)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 6) downto down - (bits * 6)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 6) downto down_w - (bits_w * 6)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 7) downto down - (bits * 7)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 7) downto down_w - (bits_w * 7)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 8) downto down - (bits * 8)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 8) downto down_w - (bits_w * 8)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 9) downto down - (bits * 9)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 9) downto down_w - (bits_w * 9)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 10) downto down - (bits * 10)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 10) downto down_w - (bits_w * 10)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 11) downto down - (bits * 11)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 11) downto down_w - (bits_w * 11)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 12) downto down - (bits * 12)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 12) downto down_w - (bits_w * 12)), int, dec) +
                                                            to_sfixed(in_3(up - (bits * 13) downto down - (bits * 13)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 13) downto down_w - (bits_w * 13)), int, dec) +
                                                            buff_1(to_integer(k_cont)), int_2, dec_2, fixed_saturate, fixed_truncate );
                    
                        if (k_cont = 16 ) then
                        
                            get_out <= '1';
                            
                        else
                        
                            get_out <= '0';
                            
                        end if;
                    
                elsif ( aux = 6 ) then
            
                    aux <= aux + 1;
                    --flag <= '0';
                    --address <= "0000000";
                    k_cont <= "00000";
                    get_out <= '0';
                    --buff_1 <= (others => "000000000000");
                    --start_out <= '1';
                    
                    buff_1(0) <= resize(buff_1(0) + bias(0), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(1) <= resize(buff_1(1) + bias(1), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(2) <= resize(buff_1(2) + bias(2), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(3) <= resize(buff_1(3) + bias(3), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(4) <= resize(buff_1(4) + bias(4), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(5) <= resize(buff_1(5) + bias(5), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(6) <= resize(buff_1(6) + bias(6), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(7) <= resize(buff_1(7) + bias(7), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(8) <= resize(buff_1(8) + bias(8), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(9) <= resize(buff_1(9) + bias(9), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(10) <= resize(buff_1(10) + bias(10), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(11) <= resize(buff_1(11) + bias(11), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(12) <= resize(buff_1(12) + bias(12), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(13) <= resize(buff_1(13) + bias(13), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(14) <= resize(buff_1(14) + bias(14), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(15) <= resize(buff_1(15) + bias(15), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(16) <= resize(buff_1(16) + bias(16), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(17) <= resize(buff_1(17) + bias(17), int_2, dec_2, fixed_saturate, fixed_truncate);
                    buff_1(18) <= resize(buff_1(18) + bias(18), int_2, dec_2, fixed_saturate, fixed_truncate);
        
                else
                
                    if (cont_out = 0) then
                    
                        ap_start <= '1';
                        cont_out <= cont_out + 1;
                        
                        dense3_out <= STD_LOGIC_VECTOR(buff_1(to_integer(cont_out)));
--                        report "capa7 " & to_hstring(STD_LOGIC_VECTOR ( buff_1(to_integer(cont_out))));
                        
                    elsif ( cont_out < 19 ) then
                    
                        if ( ap_ready = '1' ) then
                        
                            cont_out <= cont_out + 1;
                            dense3_out <= STD_LOGIC_VECTOR(buff_1(to_integer(cont_out)));
--                            report "capa7 " & to_hstring(STD_LOGIC_VECTOR ( buff_1(to_integer(cont_out))));
                                                  
                        end if;
                        
                    elsif ( cont_out = 19 ) then
                    
                        ap_start <= '0'; 
                        aux <= "0000";
                        flag <= '0';
                        address <= "0000000";
                        cont_out <= "00000";
                        buff_1 <= (others => X"0000");
                        
                    end if;                    
                
                end if;
        
            end if;
        
        end if;
    
    addra_3 <= STD_LOGIC_VECTOR( address );
        
    end process;
    
end Behavioral;