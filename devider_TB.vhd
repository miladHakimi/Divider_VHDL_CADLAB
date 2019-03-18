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
  	signal done, start, overflow : std_logic;
  	signal dividend : signed(8 downto 0);
	signal  quotient, remainder: signed(4 downto 0);
	signal divisor : signed(4 downto 0);

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
		overflow => overflow,
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
		dividend <= to_signed(-99, 9);
		divisor <= to_signed(-6, 5);
		wait;      
	end process;

end architecture ; -- behavioral