library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity mmu_tb is
end mmu_tb;

architecture TB_ARCHITECTURE of mmu_tb is
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

	-- Add your stimulus here .	 
	
	
	
	
	
	stimulus_process : PROCESS
    BEGIN
        -- Initialize the system
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        WAIT FOR 20 ns;

        -- Test 1: Page hit scenario
        virtual_address <= x"001"; -- Assuming this address will be a hit
        WAIT FOR clk_period;
        assert page_fault = '0' report "Page hit test failed" severity error;

        -- Test 2: Page fault scenario
        virtual_address <= x"800"; -- Assuming this address will cause a page fault
        WAIT FOR clk_period;
        assert page_fault = '1' report "Page fault test failed" severity error;

        -- Test 3: LFU Replacement
        -- Accessing multiple pages to trigger LFU replacement
        FOR i IN 0 TO 5 LOOP
            virtual_address <= std_logic_vector(to_unsigned(i, 12));
            WAIT FOR clk_period;
        END LOOP;

        virtual_address <= std_logic_vector(to_unsigned(6, 12));
        WAIT FOR clk_period;
        assert page_fault = '0' report "LFU Replacement test failed" severity error;

        WAIT FOR 100 ns;

        -- Test complete
        assert false report "Simulation finished" severity note;
        WAIT;
    END PROCESS;
	
	
	
	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_mmu of mmu_tb is
	for TB_ARCHITECTURE
		for UUT : mmu
			use entity work.mmu(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_mmu;

