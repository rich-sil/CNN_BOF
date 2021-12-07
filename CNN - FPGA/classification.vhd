library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.ALL;

entity classification is
  Port (   clk : in STD_LOGIC;
           ap_vld : in STD_LOGIC;
           exp_in : in STD_LOGIC_VECTOR (31 downto 0);
           dense3_in : in STD_LOGIC_VECTOR (15 downto 0);
           ap_ready : in STD_LOGIC;
           clase_vld : out STD_LOGIC := '0';
           clase : out STD_LOGIC_VECTOR (4 downto 0) := "00000" );
end classification;

architecture Behavioral of classification is

constant int : INTEGER := 23;
constant dec : INTEGER := -8;

constant int_2 : INTEGER := 1;
constant dec_2 : INTEGER := -30;

constant int_buff : INTEGER := 8;
constant dec_buff : INTEGER := -7;

type buff is array (0 to 19) of sfixed (int downto dec);
signal buff_1 : buff :=     ( others => X"00000000" );

signal suma : sfixed (int downto dec) := X"00000000";

type buff1 is array (0 to 19) of sfixed (int_2 downto dec_2);
signal buff_2 : buff1 :=     ( others => X"00000000" );

type buff2 is array (0 to 18) of sfixed (int_buff downto dec_buff);
signal buff_3 : buff2 :=     ( others => X"0000" );

type clases is array (0 to 18) of STD_LOGIC_VECTOR ( 4 downto 0);
signal indice : clases :=   ( "00000", "00001", "00010", "00011", "00100", "00101", "00110", "00111", "01000", "01001",
                              "01010", "01011", "01100", "01101", "01110", "01111", "10000", "10001", "10010" );

signal temp : sfixed (int_2 downto dec_2) := X"00000000";

signal cont : UNSIGNED (4 downto 0) := "00000";
signal cont_c : UNSIGNED (4 downto 0) := "00000";
signal cont_div : UNSIGNED (4 downto 0) := "00000";

begin

    process (clk, exp_in, ap_vld, ap_ready, dense3_in)
    
        begin
        
            if ( rising_edge (clk) ) then
            
                if ( ap_ready = '1' and cont_c < 19) then
                
                    cont_c <= cont_c + 1;
                    buff_3(to_integer(cont_c)) <= to_sfixed( dense3_in, int_buff, dec_buff);
                    
                end if;
            
                if ( ap_vld = '1' and cont < 19 ) then
                
                    cont <= cont + 1;
                    
                    clase_vld <= '0';
                    
                    buff_1(to_integer(cont)) <= to_sfixed(exp_in, int, dec);
                    
--                    report "capa8 " & to_hstring(STD_LOGIC_VECTOR ( to_sfixed(exp_in, int, dec) ));
                    
                    suma <= resize(suma + to_sfixed(exp_in, int, dec), int, dec, fixed_saturate, fixed_truncate);
                    
                end if;
                
                if ( cont = 19 ) then
                    
                    if ( cont_div < 20 ) then

                        buff_2(to_integer(cont_div + 0)) <= resize(buff_1(to_integer(cont_div)) / suma, int_2, dec_2, fixed_saturate, fixed_truncate);
                        buff_2(to_integer(cont_div + 1)) <= resize(buff_1(to_integer(cont_div + 1)) / suma, int_2, dec_2, fixed_saturate, fixed_truncate);
                        buff_2(to_integer(cont_div + 2)) <= resize(buff_1(to_integer(cont_div + 2)) / suma, int_2, dec_2, fixed_saturate, fixed_truncate);
                        buff_2(to_integer(cont_div + 3)) <= resize(buff_1(to_integer(cont_div + 3)) / suma, int_2, dec_2, fixed_saturate, fixed_truncate);
                        
                        cont_div <= cont_div + 4;
                        
                        if ( cont_div = 16 ) then
                        
                            cont <= cont + 1;
                            
                            buff_1(19) <= buff_2(0);
                            buff_2(19) <= buff_1(0);
                            
                        end if;
                        
                    end if;
                    
                    
                elsif ( cont = 20) then
                
                    if ( (buff_2(9) >  buff_2(0)) or (buff_3(9) >  buff_3(0)) ) then
                        
                        buff_2(0) <= buff_2(9);
                        buff_3(0) <= buff_3(9);
                        indice(0) <= indice(9);
                        
                    end if;
                    
                    if ( (buff_2(10) >  buff_2(1)) or (buff_3(10) >  buff_3(1)) ) then
                        
                        buff_2(1) <= buff_2(10);
                        buff_3(1) <= buff_3(10);
                        indice(1) <= indice(10);
                            
                    end if;
                    
                    if ( (buff_2(11) >  buff_2(2)) or (buff_3(11) >  buff_3(2)) ) then
                        
                        buff_2(2) <= buff_2(11);
                        buff_3(2) <= buff_3(11);
                        indice(2) <= indice(11);
                            
                    end if;
                    
                    if ( (buff_2(12) >  buff_2(3)) or (buff_3(12) >  buff_3(3)) ) then
                        
                        buff_2(3) <= buff_2(12);
                        buff_3(3) <= buff_3(12);
                        indice(3) <= indice(12);
                            
                    end if;
                    
                    if ( (buff_2(13) >  buff_2(4)) or (buff_3(13) >  buff_3(4)) ) then
                        
                        buff_2(4) <= buff_2(13);
                        buff_3(4) <= buff_3(13);
                        indice(4) <= indice(13);
                            
                    end if;
                    
                    if ( (buff_2(14) >  buff_2(5)) or (buff_3(14) >  buff_3(5)) ) then
                        
                        buff_2(5) <= buff_2(14);
                        buff_3(5) <= buff_3(14);
                        indice(5) <= indice(14);
                            
                    end if;
                    
                    if ( (buff_2(15) >  buff_2(6)) or (buff_3(15) >  buff_3(6)) ) then
                        
                        buff_2(6) <= buff_2(15);
                        buff_3(6) <= buff_3(15);
                        indice(6) <= indice(15);
                            
                    end if;
                    
                    if ( (buff_2(16) >  buff_2(7)) or (buff_3(16) >  buff_3(7)) ) then
                        
                        buff_2(7) <= buff_2(16);
                        buff_3(7) <= buff_3(16);
                        indice(7) <= indice(16);
                            
                    end if;
                    
                    if ( (buff_2(17) >  buff_2(8)) or (buff_3(17) >  buff_3(8)) ) then
                        
                        buff_2(8) <= buff_2(17);
                        buff_3(8) <= buff_3(17);
                        indice(8) <= indice(17);
                            
                    end if;
                    
                    cont <= cont + 1;

                elsif ( cont = 21 ) then
                
                    if ( (buff_2(8) >  buff_2(0)) or (buff_3(8) >  buff_3(0)) ) then
                        
                        buff_2(0) <= buff_2(8);
                        buff_3(0) <= buff_3(8);
                        indice(0) <= indice(8);
                            
                    end if;
                    
                    if ( (buff_2(7) >  buff_2(1)) or (buff_3(7) >  buff_3(1)) ) then
                        
                        buff_2(1) <= buff_2(7);
                        buff_3(1) <= buff_3(7);
                        indice(1) <= indice(7);
                            
                    end if;
                    
                    if ( (buff_2(6) >  buff_2(2)) or (buff_3(6) >  buff_3(2)) ) then
                        
                        buff_2(2) <= buff_2(6);
                        buff_3(2) <= buff_3(6);
                        indice(2) <= indice(6);
                            
                    end if;
                    
                    if ( (buff_2(5) >  buff_2(3)) or (buff_3(5) >  buff_3(3)) ) then
                        
                        buff_2(3) <= buff_2(5);
                        buff_3(3) <= buff_3(5);
                        indice(3) <= indice(5);
                            
                    end if;
                    
                    if ( (buff_2(18) >  buff_2(4)) or (buff_3(18) >  buff_3(4)) ) then
                        
                        buff_2(4) <= buff_2(18);
                        buff_3(4) <= buff_3(18);
                        indice(4) <= indice(18);
                            
                    end if;
                
                    cont <= cont + 1;
                    
                elsif ( cont = 22 ) then
                
                    if ( (buff_2(4) >  buff_2(0)) or (buff_3(4) >  buff_3(0)) ) then
                        
                        buff_2(0) <= buff_2(4);
                        buff_3(0) <= buff_3(4);
                        indice(0) <= indice(4);
                            
                    end if;
                    
                    if ( (buff_2(3) >  buff_2(1)) or (buff_3(3) >  buff_3(1)) ) then
                        
                        buff_2(1) <= buff_2(3);
                        buff_3(1) <= buff_3(3);
                        indice(1) <= indice(3);
                            
                    end if;
                    
                    cont <= cont + 1;
                    
                elsif ( cont = 23 ) then
                
                    if ( (buff_2(2) >  buff_2(0)) or (buff_3(2) >  buff_3(0)) ) then
                        
                        buff_2(0) <= buff_2(2);
                        buff_3(0) <= buff_3(2);
                        indice(0) <= indice(2);
                            
                    end if;
                    
                    cont <= cont + 1;
                    
                elsif ( cont = 24 ) then
                
                    clase_vld <= '1';
                    cont <= "00000";
                    cont_c <= "00000";
                    buff_1 <= (others => X"00000000");
                    buff_2 <= (others => X"00000000");
                    buff_3 <= (others => X"0000");
                    cont_div <= "00000";
                    indice <= ( "00000", "00001", "00010", "00011", "00100", "00101", "00110", "00111", "01000", "01001",
                                "01010", "01011", "01100", "01101", "01110", "01111", "10000", "10001", "10010" );
                
                    if ( (buff_2(1) > buff_2(0)) or (buff_3(1) > buff_3(0)) ) then
                    
                        clase <= indice(1);
                        
                    else
                    
                        clase <= indice(0);
                        
                    end if;
                
                end if;
                
            end if;
            
    end process;


end Behavioral;
