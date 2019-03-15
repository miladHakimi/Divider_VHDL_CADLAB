Library work;
Library IEEE;


Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity divider_DP is
  generic(
  	divisor_size: integer := 4;
  	dividend_size: integer := 8;
  	quotient_size: integer := 4;
  	remainder_size: integer := 4
  );
  port (
	clk: in std_logic;
	rst: in std_logic;
	
	dividend: in unsigned(dividend_size-1 downto 0);
	divisor: in unsigned(divisor_size-1 downto 0);

	ld_remainder : in std_logic;
	divisor_ld : in std_logic;
	ldinput : in std_logic;
	shiftEn	: in std_logic;
	cnt_en : in std_logic;
	ser_en : in std_logic;

	cnt_done : out std_logic;
	
	remainder: out unsigned(remainder_size-1 downto 0);
	quotient: out unsigned(quotient_size-1 downto 0);

	comp : inout std_logic
  ) ;
end entity ; -- divider

architecture behavioral of divider_DP is

	signal regOut: unsigned(7 downto 0);
	signal five_input: unsigned(3 downto 0);
	signal counterOut, counterIn: unsigned(4 downto 0);
	signal divisorOut: unsigned(divisor_size-1 downto 0);
	signal ser_in: unsigned(3 downto 0);
begin
------------------------------- Data path ---------------------------------
	
	comp <= '1' when regOut(7 downto 4) >= divisorOut else '0';
	cnt_done <= '1' when (counterOut = to_unsigned(4, 5)) else '0';
	five_input <= regOut(7 downto 4) - divisorOut(3 downto 0);
	counterIn <= counterOut + 1;

	quotient <= regOut(3 downto 0);
	remainder <= regOut(7 downto 4);
	
	shifReg : entity work.shiftRegister
	port map(
		clk => clk,
		rst => rst,

		load => ldinput,
		shiftEn => shiftEn,
		serialEn => ser_en,
		five_input_en => ld_remainder,

		five_input_in => five_input,
		dataIn => dividend,
		serialIn => comp,

		dataOut => regOut
	);
	
	Divisor_reg: entity work.Reg
	generic map(
		size => divisor_size
		)
	port map(
		clk => clk, 
		rst => rst, 

		load => divisor_ld,
		dataIn => divisor,
		dataOut => divisorOut
	);
	counter: entity work.Reg
	generic map(
		size => 5
		)
	port map(
		clk => clk,
		rst => rst,
		load => cnt_en,

		dataIn => counterIn,
		dataOut => counterOut
	);


end architecture ; -- behavioral