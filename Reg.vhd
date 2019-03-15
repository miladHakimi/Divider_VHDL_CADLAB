Library work;
Library IEEE;

Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity Reg is
  generic(
  	size: integer := 10
  	);
  port (
	clk: in std_logic;
	rst: in std_logic;

	load: in std_logic;

	dataIn: in unsigned(size-1 downto 0);
	dataOut: out unsigned(size-1 downto 0)
  ) ;
end entity ; -- Reg

architecture behavioral of Reg is

begin
	g : process( clk, rst )
	begin
		if (rising_edge(rst)) then
			dataOut <= to_unsigned(0, size);
		end if;
		if (rising_edge(clk) and load='1') then
			dataOut <= dataIn;
		end if;
	end process ; -- g
end architecture ; -- behavioral