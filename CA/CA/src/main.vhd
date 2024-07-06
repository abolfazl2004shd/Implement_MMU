LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MMU IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        virtual_address : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- 12 bit
        physical_address : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- 10 bit
        page_fault : OUT STD_LOGIC
    );
END MMU;

ARCHITECTURE Behavioral OF MMU IS

    TYPE page_table_entry IS RECORD
        valid : STD_LOGIC;
        frame_number : STD_LOGIC_VECTOR(4 DOWNTO 0);
        frequency : INTEGER;
    END RECORD;

    TYPE page_table_type IS ARRAY (0 TO 127) OF page_table_entry;
    SIGNAL page_table : page_table_type;

    TYPE memory_array IS ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ram : memory_array;
    TYPE disk_array IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL disk : disk_array;

    SIGNAL frame_num : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL page_number : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL offset : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL counter : INTEGER := 31;
   

BEGIN

    PROCESS (clk, reset) 
		VARIABLE lfu_page_index : INTEGER := 0;
		VARIABLE frame : STD_LOGIC_VECTOR(4 DOWNTO 0);
    		VARIABLE min_freq : INTEGER := INTEGER'HIGH; 
	
    BEGIN	   
        IF reset = '1' THEN
            FOR i IN 0 TO 127 LOOP
                page_table(i).valid <= '0';
                page_table(i).frequency <= 0;
                page_table(i).frame_number <= (OTHERS => '0');
            END LOOP;

            physical_address <= (OTHERS => '0');
            page_fault <= '0';
            counter <= 31;

            FOR i IN 0 TO 1023 LOOP
                ram(i) <= (OTHERS => '0'); -- assigns the value of '0' to all elements 
            END LOOP;

            -- Initialize Disk
            FOR i IN 0 TO 4095 LOOP
                disk(i) <= (OTHERS => '0'); -- assigns the value of '0' to all elements 
            END LOOP;
        ELSIF rising_edge(clk) THEN
            -- Extract page number and offset from virtual address
            page_number <= virtual_address(11 DOWNTO 5);
            offset <= virtual_address(4 DOWNTO 0);

            IF page_table(to_integer(unsigned(page_number))).valid = '1' THEN
                -- Page hit
                frame_num <= page_table(to_integer(unsigned(page_number))).frame_number;
                page_table(to_integer(unsigned(page_number))).frequency <= page_table(to_integer(unsigned(page_number))).frequency + 1; -- increment frequency

                physical_address <= frame_num & offset;
                page_fault <= '0';
            ELSE
                -- Page fault
                physical_address <= (OTHERS => '0');
                page_fault <= '1';

                IF counter /= - 1 THEN
                    frame := STD_LOGIC_VECTOR(to_unsigned(counter, 5));
                    counter <= counter - 1;
                ELSE
                    FOR i IN 0 TO 127 LOOP
                        IF page_table(i).valid = '1' AND page_table(i).frequency < min_freq THEN
                            min_freq := page_table(i).frequency;
                            lfu_page_index := i;
                        END IF;
                    END LOOP;
                    frame := page_table(lfu_page_index).frame_number;
                    page_table(lfu_page_index).valid <= '0';
                END IF;

                FOR i IN 0 TO 31 LOOP
                    ram(to_integer(unsigned(frame & STD_LOGIC_VECTOR(to_unsigned(i, 5))))) <= disk(to_integer(unsigned(page_number & STD_LOGIC_VECTOR(to_unsigned(i, 5)))));
                END LOOP;

                page_table(to_integer(unsigned(page_number))).valid <= '1';
                page_table(to_integer(unsigned(page_number))).frame_number <= frame;
                page_table(to_integer(unsigned(page_number))).frequency <= 1; -- Reset frequency for new page
            END IF;
        END IF;
    END PROCESS;

END Behavioral;