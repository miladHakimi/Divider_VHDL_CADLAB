entity Reg is
  generic(
  	size: integer := 10
  	);
  port (
	clk: in std_logic,
	rst: in std_logic,

	dataIn: in signed(size-1 downto 0),
	dataOut: out signed(size-1 downto 0)
  ) ;
end entity ; -- Reg

architecture behavioral of Reg is

	signal 

begin
	g : process( clk, rst )
	begin
		if (rising_edge(rst)) then
			dataOut <= to_signed('0', size-1);
		end if;
		if (rising_edge(clk)) then
			dataOut <= dataIn;
		end if;
	end process ; -- g
end architecture ; -- behavioral