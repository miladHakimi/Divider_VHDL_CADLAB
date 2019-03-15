Library work;
Library IEEE;

Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity ShiftRegister is
  generic(
  	size: integer := 8
  	);
  port (
	clk: in std_logic;
	rst: in std_logic;
	load: in std_logic;
	
	shiftEn: in std_logic;
	serialEn: in std_logic;
	five_input_en: in std_logic;

	five_input_in: in unsigned(3 downto 0);
	dataIn: in unsigned(size-1 downto 0);
	serialIn: in std_logic;

	dataOut: inout unsigned(size-1 downto 0)
  ) ;
end entity ; -- ShiftRegister

architecture behavioral of ShiftRegister is
begin
	g : process( clk, rst )
	begin
		if (rising_edge(rst)) then
			dataOut <= to_unsigned(0, size);
		end if;
		if rising_edge(clk) then
			if (load='1') then
			dataOut <= dataIn;
			end if;
			if (shiftEn='1') then
				dataOut <= dataOut(size-2 downto 0) & '0';
			end if;
			if serialEn='1' then
				dataOut(0) <= serialIn;
			end if ;
			if five_input_en='1' then
				dataOut(size-1 downto size-4) <= five_input_in(3 downto 0);
			end if ;
		end if ;
	end process ; -- g
end architecture ; -- behavioral