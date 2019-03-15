Library work;
Library IEEE;

Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity devider_TB is
end entity ; -- devider_TB

architecture behavioral of devider_TB is
	constant half_period : time := 50 ns;
	signal f :	integer := 0;
	signal clk  : std_logic := '0';
  	signal rst  : std_logic := '0';
  	signal done, start : std_logic;
  	signal dividend : unsigned(8-1 downto 0);
	signal divisor, quotient, remainder: unsigned(4-1 downto 0);

begin
	clk <= not clk after half_period when done/='1' else
		'0';

	Devider: entity work.divider
	port map(
		clk => clk,
		rst => rst,
		start => start,

		dividend => dividend,
		divisor => divisor,

		quotient => quotient,
		remainder => remainder,
		done => done
	);

	sim_process: process is
	begin
		wait for 30 ns;
		rst <= '1';
		wait for 30 ns;
		rst <= '0';
		wait for 1000 ns;
		start <= '1';
		wait for 120 ns;
		start <= '0';
		dividend <= to_unsigned(73, 8);
		divisor <= to_unsigned(6, 4);
		wait;      
	end process;

end architecture ; -- behavioral