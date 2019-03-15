Library work;
Library IEEE;

Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity divider_controller is
  port (
	clk : in std_logic;
	rst : in std_logic;

	cnt_done : in std_logic;
	start : in std_logic; 
	cpm_res : in std_logic;

	ld_remainder : out std_logic;
	ldinput : out std_logic;
	shiftEn	: out std_logic;
	ser_en : out std_logic;
	done : out std_logic;
	divisor_ld : out std_logic;
	cnt_en : out std_logic
  ) ;
end entity ; -- divider_controller


architecture behavioral of divider_controller is
	
	type states is (IDLE, INIT, SHIFT, COMPARE, SUB, LD_RES, FINISH);
	signal ps: states;
	signal ns: states;	

begin

-------------------- controller --------------------------
	identifier : process( clk, rst )
	begin
		if rst='1' then
			ps <= IDLE;
		end if ;
		if (rising_edge(clk)) then
			ps <= ns;
		end if;
	end process ; -- identifier
	assign_ns : process( ps, start, cpm_res, cnt_done)
	begin
		case( ps ) is
			when IDLE =>
				if start='1' then
					ns <= INIT;
				end if ;
			when INIT => 
				ns <= SHIFT;
			when SHIFT =>
				if cnt_done='1' then
					ns <= FINISH;
				else
					ns <= LD_RES;
				end if ;
			when LD_RES =>
				ns <= COMPARE;
			when COMPARE =>
				if cpm_res='1' then
					ns <= SUB;
				else
					if cnt_done='1' then
						ns <= FINISH;
					else
						ns <= SHIFT;
					end if;
				end if ;
			when SUB =>
				if cnt_done='1' then
					ns <= FINISH;
				else
					ns <= SHIFT;
				end if;
			when others => 
				ns <= IDLE;
		end case ;
	end process ; -- assign_ns

	outputs : process( ps )
	begin
		ldinput <= '0';
		divisor_ld <= '0';
		shiftEN <= '0';
		ld_remainder <= '0';
		ser_en <= '0';
		cnt_en <= '0';
		done <= '0';
		case( ps ) is

			when INIT => 
				ldinput <= '1';
				divisor_ld <= '1';			
			when SHIFT => 
				shiftEN <= '1';
			when SUB =>
				ld_remainder <= '1';
			when LD_RES =>
				ser_en <= '1';
				cnt_en <= '1';
			when FINISH => 
				done <= '1';
			when others => 
				null;
		end case ;
	end process ; -- outputs

end architecture ; -- behavioral