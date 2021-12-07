library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.all;

entity max_pool3 is
    Port ( clk : in STD_LOGIC;
           start_in : in STD_LOGIC;
           last_in : in STD_LOGIC;
           in_3 : in STD_LOGIC_VECTOR (191 downto 0);
           start_out : out STD_LOGIC := '0';
           max_pool_out3 : out STD_LOGIC_VECTOR (191 downto 0) );
end max_pool3;

architecture Behavioral of max_pool3 is

constant int : INTEGER := 3;
constant dec : INTEGER := -12;
signal cont : STD_LOGIC := '0';

constant up : INTEGER := 191;
constant down : INTEGER := 176;
constant bits : INTEGER := 16;

type mem is array (0 to 11) of STD_LOGIC_VECTOR (bits - 1 downto 0);
signal buff : mem := ( others => X"0000" ); 
        
begin

    process(clk, start_in, last_in, in_3)
    begin
    
        if rising_edge(clk) then
        
            if (start_in = '1') then
                
                if (cont = '0') then
                
                    buff(0) <= in_3(up downto down);
                    buff(1) <= in_3(up - bits downto down - bits);
                    buff(2) <= in_3(up - (bits * 2) downto down - (bits * 2));
                    buff(3) <= in_3(up - (bits * 3) downto down - (bits * 3));
                    buff(4) <= in_3(up - (bits * 4) downto down - (bits * 4));
                    buff(5) <= in_3(up - (bits * 5) downto down - (bits * 5));
                    buff(6) <= in_3(up - (bits * 6) downto down - (bits * 6));
                    buff(7) <= in_3(up - (bits * 7) downto down - (bits * 7));
                    buff(8) <= in_3(up - (bits * 8) downto down - (bits * 8));
                    buff(9) <= in_3(up - (bits * 9) downto down - (bits * 9));
                    buff(10) <= in_3(up - (bits * 10) downto down - (bits * 10));
                    buff(11) <= in_3(up - (bits * 11) downto down - (bits * 11));
                    
                    cont <= '1';
                    start_out <= '0';
                                    
                else
                
                    start_out <= '1';
                    
                    for i in 0 to 11 loop
                    
                        if(to_sfixed(buff(i), int, dec) > to_sfixed(in_3(up - (bits * i) downto down - (bits * i)), int, dec)) then
                            max_pool_out3(up - (bits * i) downto down - (bits * i)) <= STD_LOGIC_VECTOR(buff(i));
                        else
                            max_pool_out3(up - (bits * i) downto down - (bits * i)) <= in_3(up - (bits * i) downto down - (bits * i));
                        end if;
                        
                    end loop;
                    
                    cont <= '0';
                    
                end if;
                
            else
            
                start_out <= '0';
                
            end if;
                                                                     
         end if;
         
    end process;

end Behavioral;