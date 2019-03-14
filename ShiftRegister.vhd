entity Reg is
  generic(
  	size: integer := 10
  	);
  port (
	clk: in std_logic,
	rst: in std_logic,
	load: in std_logic,
	shiftEn: in std_logic,
	serialEn: in std_logic,
	5inputEn: in std_logic,

	5inputIn: in signed(4 downto 0);
	dataIn: in signed(size-1 downto 0),
	serialIn: in signed(size-1 downto 0),

	dataOut: out signed(size-1 downto 0)
  ) ;
end entity ; -- Reg

architecture behavioral of Reg is
begin
	g : process( clk, rst )
	begin
		if (rising_edge(rst)) then
			dataOut <= to_signed('0', size-1);
		end if;
		if rising_edge(clk) then
			if (load='1') then
			dataOut <= dataIn;
			end if;
			if (shiftEn='1') then
				dataOut <= dataOut(size-2 downto 0) & '0';
			end if;
			if serialEn then
				dataOut(0) <= serialIn;
			end if ;
			if 5inputEn then
				dataOut(size-1 downto size-5) <= 5inputIn;
			end if ;
		end if ;
	end process ; -- g
end architecture ; -- behavioral