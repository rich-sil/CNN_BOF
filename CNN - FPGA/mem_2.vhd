library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem_2 is
    Port ( clk : in STD_LOGIC;
           start_in : in STD_LOGIC;
           pop_in : in STD_LOGIC;
           in_2 : in STD_LOGIC_VECTOR (127 downto 0);
           ready_out : out STD_LOGIC := '0';
           mem2_out : out STD_LOGIC_VECTOR (127 downto 0) );
end mem_2;

architecture Behavioral of mem_2 is

type buff is array (0 to 41) of STD_LOGIC_VECTOR (127 downto 0);
signal buff_1 : buff :=     ( others => X"00000000000000000000000000000000" );

signal cont : UNSIGNED (5 downto 0) := "000000";
signal cont_pop : UNSIGNED (5 downto 0) := "000000";
signal aux : UNSIGNED (2 downto 0) := "000";
signal cont_k : UNSIGNED (5 downto 0) := "000000";
        
begin

    process(clk, in_2, start_in, pop_in)
    begin
    
        if rising_edge(clk) then
        
            if ( start_in = '1' ) then
            
                    if ( cont < 42 ) then
                    
                        cont <= cont + 1;
                        buff_1(to_integer(cont)) <= in_2;
                        
                    --else
                    
                        --cont <= "0000000";
                        
                    end if;
            
            end if;
            
            if ( (cont > 14) and (cont_k < 38) ) then
            
                ready_out <= '1';
                
                if ( pop_in = '1') then
            
                    if ( aux < 4 ) then
                            
                        cont_pop <= cont_pop + 1; 
                        aux <= aux + 1;
                            
                    else
                        
                        aux <= "000";
                        cont_pop <= cont_pop - 3;
                        cont_k <= cont_k + 1;
                        
                    end if;
                    
                end if;
            
            else
                
--                ready_out <= '0';
--                cont_pop <= "0000000";
--                aux <= "000";
--                cont_k <= "0000000";
                
            end if;
            
            mem2_out <= buff_1(to_integer(cont_pop));
            
        end if;
        
    end process;
    
end Behavioral;