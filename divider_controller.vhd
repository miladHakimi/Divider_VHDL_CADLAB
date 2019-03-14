entity divider_controller is
  port (
	clk : in std_logic,
	rst : in std_logic,

	cnt_done : in std_logic,
	start : in std_logic, 
	pos : in std_logic,

	ld_5input : out std_logic,
	ldinput : out std_logic,
	shiftEn	: out std_logic,
	ser_en : out std_logic,
	done : out std_logic,
	ld2 : out std_logic
  ) ;
end entity ; -- divider_controller


architecture behavioral of divider_controller is
	
	type states is (A, B, C, D, E, F);
	signal ps: states;
	signal ns: states;	

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

end architecture ; -- behavioral