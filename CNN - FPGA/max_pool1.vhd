library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.ALL;


entity max_pool1 is
    Port ( clk : in STD_LOGIC;
           start_in : in STD_LOGIC;
           last_in : in STD_LOGIC;
           in_1 : in STD_LOGIC_VECTOR (79 downto 0);
           start_out : out STD_LOGIC := '0';
           max_pool_out1 : out STD_LOGIC_VECTOR (79 downto 0) );
end max_pool1;

architecture Behavioral of max_pool1 is

constant int : INTEGER := 3;
constant dec : INTEGER := -12;
signal cont : STD_LOGIC := '0';

constant up : INTEGER := 79;
constant down : INTEGER := 64;
constant bits : INTEGER := 16;

type mem is array (0 to 4) of STD_LOGIC_VECTOR (bits - 1 downto 0);
signal buff : mem := ( others => X"0000" );
        
begin

    process(clk, start_in, last_in, in_1)
    begin
    
        if rising_edge(clk) then
        
            if (start_in = '1') then
                
                if (cont = '0') then
                
                    buff(0) <= in_1(up downto down);
                    buff(1) <= in_1(up - bits downto down - bits);
                    buff(2) <= in_1(up - (bits * 2) downto down - (bits * 2));
                    buff(3) <= in_1(up - (bits * 3) downto down - (bits * 3));
                    buff(4) <= in_1(up - (bits * 4) downto down - (bits * 4));
                    
                    cont <= '1';
                    start_out <= '0';
                                    
                else
                
                    start_out <= '1';
                    
                    for i in 0 to 4 loop
                    
                        if(to_sfixed(buff(i), int, dec) > to_sfixed(in_1(up - (bits * i) downto down - (bits * i)), int, dec)) then
                            max_pool_out1(up - (bits * i) downto down - (bits * i)) <= buff(i);
                        else
                            max_pool_out1(up - (bits * i) downto down - (bits * i)) <= in_1(up - (bits * i) downto down - (bits * i));
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