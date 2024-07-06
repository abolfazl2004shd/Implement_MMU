library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity Address_Translation is
end Address_Translation;

architecture TB_ARCHITECTURE of Address_Translation is
	-- Component declaration of the tested unit
	component mmu
	port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		virtual_address : in STD_LOGIC_VECTOR(11 downto 0);
		physical_address : out STD_LOGIC_VECTOR(9 downto 0);
		page_fault : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal reset : STD_LOGIC;
	signal virtual_address : STD_LOGIC_VECTOR(11 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal physical_address : STD_LOGIC_VECTOR(9 downto 0);
	signal page_fault : STD_LOGIC;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : mmu
		port map (
			clk => clk,
			reset => reset,
			virtual_address => virtual_address,
			physical_address => physical_address,
			page_fault => page_fault
		);

	-- Add your stimulus here ...
					
    clk_process :process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    stim_proc: process
    begin		
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        
        virtual_address <= "000000000001";
        wait for 20 ns;	 
        assert (page_fault = '1') report "Page fault when expected" severity error;
        assert (physical_address = "1111100001") report "Incorrect physical address" severity error;

        wait;
    end process;
	
	
	
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_mmu of Address_Translation is
	for TB_ARCHITECTURE
		for UUT : mmu
			use entity work.mmu(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_mmu;

