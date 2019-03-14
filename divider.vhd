entity divider is
  generic(
  	divisor_size: integer := 4,
  	dividend_size: integer := 8,
  	quotient_size: integer := 4,
  	remainder_size: integer := 4
  );
  port (
	clk: in std_logic,
	rst: in std_logic,
	start: in std_logic,

	dividend: in signed(dividend_size-1 downto 0),
	divisor: in signed(divisor_size-1 downto 0),

	quotient: out unsigned(quotient_size-1 downto 0),
	remainder: out unsigned(remainder_size-1 downto 0),

	overflow: out std_logic,
	done: out std_logic
  ) ;
end entity ; -- divider

architecture behavioral of divider is
	signal ps, ns: unsigned(2 downto 0);
	type states is (A, B, C, D, E, F);
	signal ps: states;
	signal ns: states;
	signal comp: signed(4 downto 0);
	signal regOut: signed(8 downto 0);
begin
-------------------- controller --------------------------
	identifier : process( clk )
	begin
		if rst then
			ps <= A;
		end if ;
		if (rising_edge(clk)) then
			ps <= ns;
		end if;
	end process ; -- identifier
	assign_ns : process( start, pos, cnt_done)
	begin
		case( ps ) is
		
			when A =>
				if start='1' then
					ns <= B;
				end if ;
			when B => 
				ns <= C;
			when C =>
				if pos='1' then
					ns <= D;
				else
					ns <= E;
				end if ;
			when D =>
				if cnt_done='1' then
					ns <= F;
				else
					ns <= C;
				end if ;
			when E =>
				ns <= D;
			when F =>
				ns <= A;
		end case ;
	end process ; -- assign_ns

	outputs : process( ps )
	begin
		case( ps ) is
			when B =>
				ldinput <= '1';
				ld2 <= '1';			
			when C => 
				shiftEN <= '1';
			when D => 
				ser_en <= '1';
			when E =>
				ld_5input <= '1';
			when F =>
				done => '1';		
		end case ;
	end process ; -- outputs

------------------------------- Data path ---------------------------------
	comp <= not divisor+1;
	shifReg : entity work.shiftRegister
	  port (
		clk => clk,
		rst => rst,
		load => ldinput,
		shiftEn => shiftEn,
		serialEn => ser_en,
		5inputEn => ld_5input,

		5inputIn => ,
		dataIn => ,
		serialIn => ,

		dataOut => regOut
	  ) ;
	  
end architecture ; -- behavioral