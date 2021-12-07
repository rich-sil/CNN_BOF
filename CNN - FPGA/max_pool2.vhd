library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.all;

entity max_pool2 is
    Port ( clk : in STD_LOGIC;
           start_in : in STD_LOGIC;
           last_in : in STD_LOGIC;
           in_2 : in STD_LOGIC_VECTOR (127 downto 0);
           start_out : out STD_LOGIC := '0';
           max_pool_out2 : out STD_LOGIC_VECTOR (127 downto 0) );
end max_pool2;

architecture Behavioral of max_pool2 is

constant int : INTEGER := 3;
constant dec : INTEGER := -12;
signal cont : STD_LOGIC := '0';

constant up : INTEGER := 127;
constant down : INTEGER := 112;
constant bits : INTEGER := 16;

type mem is array (0 to 7) of STD_LOGIC_VECTOR (bits - 1 downto 0);
signal buff : mem := ( others => X"0000" ); 
        
begin

    process(clk, start_in, last_in, in_2)
    begin
    
        if rising_edge(clk) then
        
            if (start_in = '1') then
                
                if (cont = '0') then
                
                    buff(0) <= in_2(up downto down);
                    buff(1) <= in_2(up - bits downto down - bits);
                    buff(2) <= in_2(up - (bits * 2) downto down - (bits * 2));
                    buff(3) <= in_2(up - (bits * 3) downto down - (bits * 3));
                    buff(4) <= in_2(up - (bits * 4) downto down - (bits * 4));
                    buff(5) <= in_2(up - (bits * 5) downto down - (bits * 5));
                    buff(6) <= in_2(up - (bits * 6) downto down - (bits * 6));
                    buff(7) <= in_2(up - (bits * 7) downto down - (bits * 7));
                    
                    cont <= '1';
                    start_out <= '0';
                                    
                else
                
                    start_out <= '1';
                    
                    for i in 0 to 7 loop
                    
                        if(to_sfixed(buff(i), int, dec) > to_sfixed(in_2(up - (bits * i) downto down - (bits * i)), int, dec)) then
                            max_pool_out2(up - (bits * i) downto down - (bits * i)) <= STD_LOGIC_VECTOR(buff(i));
                        else
                            max_pool_out2(up - (bits * i) downto down - (bits * i)) <= in_2(up - (bits * i) downto down - (bits * i));
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