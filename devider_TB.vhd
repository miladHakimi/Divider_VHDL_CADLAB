entity devider_TB is
end entity ; -- devider_TB

architecture behavioral of devider_TB is
	constant half_period : time := 50 ns;
	signal f :	integer := 0;
	signal clk  : std_logic := '0';
  	signal rst  : std_logic := '0';
begin
	clk <= not clk after half_period;
	Devider: entity work.devider
	port map(
			clk => clk,
			rst => rst,
			start => start,
			m => std_logic_vector(to_unsigned(869, 16)),
			n => std_logic_vector(to_unsigned(869, 16))
,		) 

end architecture ; -- behavioral