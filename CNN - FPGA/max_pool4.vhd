library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.FIXED_PKG.all;

entity max_pool4 is
    Port ( clk : in STD_LOGIC;
           start_in : in STD_LOGIC;
           last_in : in STD_LOGIC;
           in_4 : in STD_LOGIC_VECTOR (399 downto 0);
           start_out : out STD_LOGIC := '0';
           max_pool_out4 : out STD_LOGIC_VECTOR (399 downto 0) );
end max_pool4;

architecture Behavioral of max_pool4 is

constant int : INTEGER := 3;
constant dec : INTEGER := -12;
signal cont : STD_LOGIC := '0';

constant up : INTEGER := 399;
constant down : INTEGER := 384;
constant bits : INTEGER := 16;

type mem is array (0 to 24) of STD_LOGIC_VECTOR (bits - 1 downto 0);
signal buff : mem := ( (others => X"0000") ); 
        
begin

    process(clk, start_in, last_in, in_4)
    begin
    
        if rising_edge(clk) then
        
            if (start_in = '1') then
                
                if (cont = '0') then
                
                    buff(0) <= in_4(up downto down);
                    buff(1) <= in_4(up - bits downto down - bits);
                    buff(2) <= in_4(up - (bits * 2) downto down - (bits * 2));
                    buff(3) <= in_4(up - (bits * 3) downto down - (bits * 3));          
                    buff(4) <= in_4(up - (bits * 4) downto down - (bits * 4));
                    buff(5) <= in_4(up - (bits * 5) downto down - (bits * 5));
                    buff(6) <= in_4(up - (bits * 6) downto down - (bits * 6));               
                    buff(7) <= in_4(up - (bits * 7) downto down - (bits * 7));
                    buff(8) <= in_4(up - (bits * 8) downto down - (bits * 8));
                    buff(9) <= in_4(up - (bits * 9) downto down - (bits * 9));                
                    buff(10) <= in_4(up - (bits * 10) downto down - (bits * 10));
                    buff(11) <= in_4(up - (bits * 11) downto down - (bits * 11));
                    buff(12) <= in_4(up - (bits * 12) downto down - (bits * 12));               
                    buff(13) <= in_4(up - (bits * 13) downto down - (bits * 13));
                    buff(14) <= in_4(up - (bits * 14) downto down - (bits * 14));
                    buff(15) <= in_4(up - (bits * 15) downto down - (bits * 15));
                    buff(16) <= in_4(up - (bits * 16) downto down - (bits * 16));
                    buff(17) <= in_4(up - (bits * 17) downto down - (bits * 17));
                    buff(18) <= in_4(up - (bits * 18) downto down - (bits * 18));
                    buff(19) <= in_4(up - (bits * 19) downto down - (bits * 19));
                    buff(20) <= in_4(up - (bits * 20) downto down - (bits * 20));
                    buff(21) <= in_4(up - (bits * 21) downto down - (bits * 21));
                    buff(22) <= in_4(up - (bits * 22) downto down - (bits * 22));
                    buff(23) <= in_4(up - (bits * 23) downto down - (bits * 23));
                    buff(24) <= in_4(up - (bits * 24) downto down - (bits * 24));
                    
                    cont <= '1';
                    start_out <= '0';
                                    
                else
                
                    start_out <= '1';
                    
                    for i in 0 to 24 loop
                    
                        if(to_sfixed(buff(i), int, dec) > to_sfixed(in_4(up - (bits * i) downto down - (bits * i)), int, dec)) then
                            max_pool_out4(up - (bits * i) downto down - (bits * i)) <= STD_LOGIC_VECTOR(buff(i));
                        else
                            max_pool_out4(up - (bits * i) downto down - (bits * i)) <= in_4(up - (bits * i) downto down - (bits * i));
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