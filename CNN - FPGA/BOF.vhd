library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BOF is
  Port ( clk : in STD_LOGIC;
         start_bof : in STD_LOGIC;
         out_M : out STD_LOGIC_VECTOR (44 downto 0));
end BOF;

architecture Behavioral of BOF is

type mem is array (0 to 179) of STD_LOGIC_VECTOR (8 downto 0);
signal bof_mem : mem :=   ( "001100000", "001100001", "001100001", "001100011", "001100011", "001100011", "001100001", "001011101", "001011001", "001010101", "001010001", "001001110", "001001010", "001000111", "001000100", "001000110", "001001000", "001001010", "001001100", "001001110", "001010001", "001010011", "001010110", "001011001", "001011100", "001011111", "001100001", "001100100", "001100111", "001101010", "001101101", "001110001", "001110100", "001110111", "001111010", "001111101", "010000000", "001111111", "001111101", "001111011", "001111010", "001111000", "001110110", "001110101", "001110100", "001110011", "001110001", "001110001", "001110001", "001110001", "001110001", "001110000", "001101110", "001101011", "001101010", "001100111", "001100110", "001100100", "001100001", "001100000", "001011101", "001011001", "001010110", "001010011", "001010000", "001001110", "001001111", "001010001", "001010100", "001010110", "001011001", "001011100", "001011111", "001100011", "001100101", "001100110", "001101000", "001101001", "001101011", "001101101", "001101111", "001110010", "001110100", "001110111", "001111010", "001111010", "001111010", "001111000", "001110111", "001110100", "001110000", "001101100", "001100111", "001100011", "001011111", "001011011", "001010111", "001010011", "001010000", "001001101", "001001011", "001001000", "001000110", "001000101", "001000101", "001000110", "001001010", "001010000", "001010101", "001011001", "001011101", "001100010", "001100110", "001101001", "001101100", "001101110", "001101111", "001101111", "001101110", "001101100", "001101011", "001101001", "001100111", "001100101", "001100100", "001100011", "001100010", "001100001", "001100001", "001100000", "001100000", "001011111", "001011111", "001100000", "001011111", "001100011", "001100111", "001101001", "001101010", "001101100", "001101100", "001101101", "001101110", "001110000", "001110001", "001110011", "001110110", "001110111", "001111001", "001111100", "001111110", "001111110", "001111110", "001111110", "001111100", "001111010", "001111000", "001110101", "001110010", "001101111", "001101100", "001101001", "001100110", "001100011", "001011111", "001011100", "001011010", "001011000", "001011000", "001011001", "001011000", "001011001", "001011001", "001011001", "001011010", "001011011", "001011011", "001011101", "001011101", "001011110" );
attribute ram_style : string;
attribute ram_style of bof_mem : signal is "block";

signal cont : UNSIGNED (7 downto 0) := X"00";

begin

    process(clk, start_bof)
    begin
        if rising_edge(clk) then
        
            if ( start_bof = '1') then
        
                if(cont < 175) then
            
                    cont <= cont + 1;
                                        
                else
                
                    cont <= X"00";
            
                end if;
                
            end if; 
            
        end if;
        
        out_M <= bof_mem(to_integer(cont)) & bof_mem(to_integer(cont + 1)) & bof_mem(to_integer(cont + 2)) & 
                         bof_mem(to_integer(cont + 3)) & bof_mem(to_integer(cont + 4));
        
    end process;

end Behavioral;