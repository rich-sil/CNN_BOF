library IEEE, STD;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.ALL;
use STD.TEXTIO.ALL;

entity dense_1 is
    Port ( clk : in STD_LOGIC;
           start_in : in STD_LOGIC;
           in_1 : in STD_LOGIC_VECTOR (399 downto 0);
           w_in : in STD_LOGIC_VECTOR (224 downto 0);
           get_in : in STD_LOGIC;
           addra_1 : out STD_LOGIC_VECTOR ( 9 downto 0 ) := "0000000000";
           start_out : out STD_LOGIC := '0';
           dense1_out : out STD_LOGIC_VECTOR (287 downto 0) );
end dense_1; 

architecture Behavioral of dense_1 is

constant int : INTEGER := 1;
constant dec : INTEGER := -7;

constant int_2 : INTEGER := 3;
constant dec_2 : INTEGER := -12;

constant int_out : INTEGER := 8;
constant dec_out : INTEGER := -7;

constant up_w : INTEGER := 224;
constant down_w : INTEGER := 216;
constant bits_w : INTEGER := 9;

constant up : INTEGER := 399;
constant down : INTEGER := 384;
constant bits : INTEGER := 16;

type b is array (0 to 89) of sfixed (int downto dec);
signal bias : b :=        ( "111110101", "111110110", "111111110", "111111101", "111111001", "111001100", "111111111", "111111001", 
                            "111111100", "000000110", "111110110", "000000011", "000000011", "111010101", "000000101", "000011001", 
                            "111010010", "111111101", "111111000", "111111011", "111111101", "111110101", "111111101", "000001001", 
                            "111111000", "111101111", "111111101", "111111111", "111010110", "000101011", "000010010", "111111011", 
                            "111111010", "111111110", "111100001", "000010100", "000111110", "000001000", "111111011", "111111011", 
                            "111011011", "111110100", "111111110", "111111010", "111111100", "000001110", "000000000", "000100101", 
                            "111111011", "111111011", "000001110", "111011110", "111101110", "000011100", "111111100", "000011101", 
                            "111111101", "000000001", "111111111", "000010100", "111111111", "111101111", "111111100", "111001011", 
                            "111111011", "000000010", "000000011", "111111011", "000000010", "111111001", "111110111", "000001010", 
                            "000001100", "000011011", "000001111", "111100110", "000001010", "111100101", "000010011", "111100110", 
                            "111111001", "000000101", "000011101", "000100001", "111111100", "111110010", "111110100", "000011101", 
                            "111110110", "111111001" );

type buff is array (0 to 89) of sfixed (int_out downto dec_out);
signal buff_1 : buff :=     ( others => X"0000" );

type buff_t is array (0 to 89) of sfixed (int_out downto dec_out);
signal temp : buff_t :=     ( others => X"0000" );

signal aux : UNSIGNED (3 downto 0) := "0000";
signal address : UNSIGNED (9 downto 0) := "0000000000";
signal flag : STD_LOGIC := '0';
signal k_cont : UNSIGNED (6 downto 0) := "0000000";
signal espera : STD_LOGIC := '0';
signal send_data : STD_LOGIC := '0';
constant zero_out : STD_LOGIC_VECTOR := X"0000";

--type p is array (0 to 24) of STD_LOGIC_VECTOR (8 downto 0);
--signal pesos : p :=     ( others => "000000000" );

--type m is array (0 to 24) of sfixed (int_out downto dec_out);
--signal mults : m :=     ( others => X"0000");
        
begin

    process(clk, start_in, in_1, w_in, get_in)
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
            
                else
                    
                    if ( k_cont < 90 ) then
                
                        k_cont <= k_cont + 1;
                        
                        if ( address < 629 ) then
                        
                            address <= address + 1;
                            
                        end if;
                        
                        
                        buff_1(to_integer(k_cont)) <= resize (  to_sfixed(in_1(up downto down), int_2, dec_2) * to_sfixed(w_in(up_w downto down_w), int, dec) +
                                                                to_sfixed(in_1(up - bits downto down - bits), int_2, dec_2) * to_sfixed(w_in(up_w - bits_w downto down_w - bits_w), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 2) downto down_w - (bits_w * 2)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 3) downto down_w - (bits_w * 3)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 4) downto down_w - (bits_w * 4)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 5) downto down - (bits * 5)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 5) downto down_w - (bits_w * 5)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 6) downto down - (bits * 6)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 6) downto down_w - (bits_w * 6)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 7) downto down - (bits * 7)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 7) downto down_w - (bits_w * 7)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 8) downto down - (bits * 8)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 8) downto down_w - (bits_w * 8)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 9) downto down - (bits * 9)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 9) downto down_w - (bits_w * 9)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 10) downto down - (bits * 10)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 10) downto down_w - (bits_w * 10)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 11) downto down - (bits * 11)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 11) downto down_w - (bits_w * 11)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 12) downto down - (bits * 12)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 12) downto down_w - (bits_w * 12)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 13) downto down - (bits * 13)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 13) downto down_w - (bits_w * 13)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 14) downto down - (bits * 14)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 14) downto down_w - (bits_w * 14)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 15) downto down - (bits * 15)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 15) downto down_w - (bits_w * 15)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 16) downto down - (bits * 16)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 16) downto down_w - (bits_w * 16)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 17) downto down - (bits * 17)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 17) downto down_w - (bits_w * 17)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 18) downto down - (bits * 18)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 18) downto down_w - (bits_w * 18)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 19) downto down - (bits * 19)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 19) downto down_w - (bits_w * 19)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 20) downto down - (bits * 20)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 20) downto down_w - (bits_w * 20)), int, dec) + 
                                                                to_sfixed(in_1(up - (bits * 21) downto down - (bits * 21)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 21) downto down_w - (bits_w * 21)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 22) downto down - (bits * 22)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 22) downto down_w - (bits_w * 22)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 23) downto down - (bits * 23)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 23) downto down_w - (bits_w * 23)), int, dec) +
                                                                to_sfixed(in_1(up - (bits * 24) downto down - (bits * 24)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 24) downto down_w - (bits_w * 24)), int, dec) + 
                                                                buff_1(to_integer(k_cont)), int_out, dec_out, fixed_saturate, fixed_truncate );
                                                                
--                     pesos(0) <= w_in(up_w downto down_w);
--                     pesos(1) <= w_in(up_w - bits_w downto down_w - bits_w);
--                     pesos(2) <= w_in(up_w - (bits_w * 2) downto down_w - (bits_w * 2));
--                     pesos(3) <= w_in(up_w - (bits_w * 3) downto down_w - (bits_w * 3));
--                     pesos(4) <= w_in(up_w - (bits_w * 4) downto down_w - (bits_w * 4));
--                     pesos(5) <= w_in(up_w - (bits_w * 5) downto down_w - (bits_w * 5));
--                     pesos(6) <= w_in(up_w - (bits_w * 6) downto down_w - (bits_w * 6));
--                     pesos(7) <= w_in(up_w - (bits_w * 7) downto down_w - (bits_w * 7));
--                     pesos(8) <= w_in(up_w - (bits_w * 8) downto down_w - (bits_w * 8));
--                     pesos(9) <= w_in(up_w - (bits_w * 9) downto down_w - (bits_w * 9));
--                     pesos(10) <= w_in(up_w - (bits_w * 10) downto down_w - (bits_w * 10));
--                     pesos(11) <= w_in(up_w - (bits_w * 11) downto down_w - (bits_w * 11));
--                     pesos(12) <= w_in(up_w - (bits_w * 12) downto down_w - (bits_w * 12));
--                     pesos(13) <= w_in(up_w - (bits_w * 13) downto down_w - (bits_w * 13));
--                     pesos(14) <= w_in(up_w - (bits_w * 14) downto down_w - (bits_w * 14));
--                     pesos(15) <= w_in(up_w - (bits_w * 15) downto down_w - (bits_w * 15));
--                     pesos(16) <= w_in(up_w - (bits_w * 16) downto down_w - (bits_w * 16));
--                     pesos(17) <= w_in(up_w - (bits_w * 17) downto down_w - (bits_w * 17));
--                     pesos(18) <= w_in(up_w - (bits_w * 18) downto down_w - (bits_w * 18));
--                     pesos(19) <= w_in(up_w - (bits_w * 19) downto down_w - (bits_w * 19));
--                     pesos(20) <= w_in(up_w - (bits_w * 20) downto down_w - (bits_w * 20));
--                     pesos(21) <= w_in(up_w - (bits_w * 21) downto down_w - (bits_w * 21));
--                     pesos(22) <= w_in(up_w - (bits_w * 22) downto down_w - (bits_w * 22));
--                     pesos(23) <= w_in(up_w - (bits_w * 23) downto down_w - (bits_w * 23));
--                     pesos(24) <= w_in(up_w - (bits_w * 24) downto down_w - (bits_w * 24));

--                     mults(0) <= resize ( to_sfixed(in_1(up downto down), int_2, dec_2) * to_sfixed(w_in(up_w downto down_w), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(1) <= resize ( to_sfixed(in_1(up - bits downto down - bits), int_2, dec_2) * to_sfixed(w_in(up_w - bits_w downto down_w - bits_w), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(2) <= resize ( to_sfixed(in_1(up - (bits * 2) downto down - (bits * 2)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 2) downto down_w - (bits_w * 2)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(3) <= resize ( to_sfixed(in_1(up - (bits * 3) downto down - (bits * 3)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 3) downto down_w - (bits_w * 3)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(4) <= resize ( to_sfixed(in_1(up - (bits * 4) downto down - (bits * 4)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 4) downto down_w - (bits_w * 4)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(5) <= resize ( to_sfixed(in_1(up - (bits * 5) downto down - (bits * 5)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 5) downto down_w - (bits_w * 5)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(6) <= resize ( to_sfixed(in_1(up - (bits * 6) downto down - (bits * 6)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 6) downto down_w - (bits_w * 6)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(7) <= resize ( to_sfixed(in_1(up - (bits * 7) downto down - (bits * 7)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 7) downto down_w - (bits_w * 7)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(8) <= resize ( to_sfixed(in_1(up - (bits * 8) downto down - (bits * 8)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 8) downto down_w - (bits_w * 8)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(9) <= resize ( to_sfixed(in_1(up - (bits * 9) downto down - (bits * 9)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 9) downto down_w - (bits_w * 9)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(10) <= resize ( to_sfixed(in_1(up - (bits * 10) downto down - (bits * 10)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 10) downto down_w - (bits_w * 10)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(11) <= resize ( to_sfixed(in_1(up - (bits * 11) downto down - (bits * 11)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 11) downto down_w - (bits_w * 11)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(12) <= resize ( to_sfixed(in_1(up - (bits * 12) downto down - (bits * 12)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 12) downto down_w - (bits_w * 12)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(13) <= resize ( to_sfixed(in_1(up - (bits * 13) downto down - (bits * 13)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 13) downto down_w - (bits_w * 13)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(14) <= resize ( to_sfixed(in_1(up - (bits * 14) downto down - (bits * 14)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 14) downto down_w - (bits_w * 14)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(15) <= resize ( to_sfixed(in_1(up - (bits * 15) downto down - (bits * 15)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 15) downto down_w - (bits_w * 15)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(16) <= resize ( to_sfixed(in_1(up - (bits * 16) downto down - (bits * 16)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 16) downto down_w - (bits_w * 16)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(17) <= resize ( to_sfixed(in_1(up - (bits * 17) downto down - (bits * 17)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 17) downto down_w - (bits_w * 17)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(18) <= resize ( to_sfixed(in_1(up - (bits * 18) downto down - (bits * 18)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 18) downto down_w - (bits_w * 18)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(19) <= resize ( to_sfixed(in_1(up - (bits * 19) downto down - (bits * 19)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 19) downto down_w - (bits_w * 19)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(20) <= resize ( to_sfixed(in_1(up - (bits * 20) downto down - (bits * 20)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 20) downto down_w - (bits_w * 20)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(21) <= resize ( to_sfixed(in_1(up - (bits * 21) downto down - (bits * 21)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 21) downto down_w - (bits_w * 21)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(22) <= resize ( to_sfixed(in_1(up - (bits * 22) downto down - (bits * 22)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 22) downto down_w - (bits_w * 22)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(23) <= resize ( to_sfixed(in_1(up - (bits * 23) downto down - (bits * 23)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 23) downto down_w - (bits_w * 23)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
--                     mults(24) <= resize ( to_sfixed(in_1(up - (bits * 24) downto down - (bits * 24)), int_2, dec_2) * to_sfixed(w_in(up_w - (bits_w * 24) downto down_w - (bits_w * 24)), int, dec), int_out, dec_out, fixed_saturate, fixed_truncate );
                    
                    elsif ( aux < 7 ) then
                    
                        aux <= aux + 1;
                        flag <= '0';
                        address <= address - 2;
                        k_cont <= "0000000";
                        espera <= '0';
                        
                    end if;
                    
                end if;
                        
            elsif ( aux = 7 ) then
            
                aux <= aux + 1;
                flag <= '0';
                address <= "0000000000";
                k_cont <= "0000000";
                buff_1 <= (others => X"0000");
                
                send_data <= '1';
                start_out <= '1';
                
                for j in 0 to 89 loop
                
                    temp(j) <= resize( buff_1(j) + bias(j), int_out, dec_out, fixed_saturate, fixed_truncate);
--                    report "capa5 " & to_hstring(STD_LOGIC_VECTOR ( resize( buff_1(j) + bias(j), int_out, dec_out, fixed_saturate, fixed_truncate) )); 
                
                end loop;
                          
            elsif ( send_data = '1' ) then
            
                start_out <= '0';
            
                if ( get_in = '1' and k_cont < 4 ) then
                
                    k_cont <= k_cont + 1;
                    
                elsif ( k_cont = 4 ) then
                
                    send_data <= '0';
                    k_cont <= "0000000";
                    start_out <= '0';
                    aux <= "0000";
                
                end if;
                
                for i in 0 to 17 loop
                
                    if ( temp( i + (to_integer(k_cont * 18)) ) > 0 ) then
                    
                        dense1_out(287 - (i * 16) downto 272 - (i * 16)) <= STD_LOGIC_VECTOR( temp(i + (to_integer(k_cont * 18))) );
                    
                    else
                    
                        dense1_out(287 - (i * 16) downto 272 - (i * 16)) <= zero_out;
                    
                    end if;
                    
                end loop;
            
            end if;
        
        end if;
    
    addra_1 <= STD_LOGIC_VECTOR( address );
        
    end process;
    
end Behavioral;