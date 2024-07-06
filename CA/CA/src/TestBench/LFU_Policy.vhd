library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity LFU_Policy is
end LFU_Policy;

architecture TB_ARCHITECTURE of LFU_Policy is
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
        
     
        virtual_address <= "000000100000"; 
        wait for 20 ns;
        virtual_address <= "000001000000"; 
        wait for 20 ns;
        virtual_address <= "000001100000"; 
        wait for 20 ns;
        virtual_address <= "000010000000"; 
        wait for 20 ns;
        virtual_address <= "000010100000"; 
        wait for 20 ns;
	    virtual_address <= "000011000000"; 
        wait for 20 ns;
        virtual_address <= "000011100000"; 
        wait for 20 ns;
        virtual_address <= "000000001000"; 
        wait for 20 ns;
        virtual_address <= "000100100000"; 
        wait for 20 ns;
        virtual_address <= "000101000000"; 
        wait for 20 ns;
        virtual_address <= "000101100000"; 
        wait for 20 ns;
        virtual_address <= "000110000000"; 
        wait for 20 ns;
        virtual_address <= "000110100000"; 
        wait for 20 ns;
        virtual_address <= "000111000000"; 
        wait for 20 ns;
        virtual_address <= "000111100000"; 
        wait for 20 ns;
	    virtual_address <= "001000000000"; 
        wait for 20 ns;
        virtual_address <= "001000100000"; 
        wait for 20 ns;
        virtual_address <= "001001000000"; 
        wait for 20 ns;
        virtual_address <= "001001100000"; 
        wait for 20 ns;
        virtual_address <= "001010000000"; 
        wait for 20 ns;
        virtual_address <= "001010100000"; 
        wait for 20 ns;
        virtual_address <= "001011100000"; 
        wait for 20 ns;
        virtual_address <= "000000011000"; 
        wait for 20 ns;
        virtual_address <= "001100100000"; 
        wait for 20 ns;
        virtual_address <= "000000011010"; 
        wait for 20 ns;
	    virtual_address <= "001101100000"; 
        wait for 20 ns;
        virtual_address <= "001110000000"; 
        wait for 20 ns;
        virtual_address <= "001110100000"; 
        wait for 20 ns;
        virtual_address <= "001111000000"; 
        wait for 20 ns;
        virtual_address <= "001111100000"; 
        wait for 20 ns;
        virtual_address <= "100000000000"; 
        wait for 20 ns;
       
		
	   
       

        virtual_address <= "000000000100";
        wait for 20 ns;
        assert (page_fault = '1') report "LFU replacement failed" severity error;

        wait;
    end process;
	
	
	
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_mmu of LFU_Policy is
	for TB_ARCHITECTURE
		for UUT : mmu
			use entity work.mmu(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_mmu;

