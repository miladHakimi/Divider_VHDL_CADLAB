Library work;
Library IEEE;


Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity divider_DP is
  generic(
  	divisor_size: integer := 5;
  	dividend_size: integer := 9;
  	quotient_size: integer := 5;
  	remainder_size: integer := 5
  );
  port (
	clk: in std_logic;
	rst: in std_logic;
	
	dividend: in signed(dividend_size-1 downto 0);
	divisor: in signed(divisor_size-1 downto 0);

	ld_remainder : in std_logic;
	divisor_ld : in std_logic;
	ldinput : in std_logic;
	shiftEn	: in std_logic;
	cnt_en : in std_logic;
	ser_en : in std_logic;

	cnt_done : out std_logic;
	
	remainder: out signed(remainder_size-1 downto 0);
	quotient: out signed(quotient_size-1 downto 0);
	overflow: out std_logic;

	comp : inout std_logic

  ) ;
end entity ; -- divider

architecture behavioral of divider_DP is

	signal regOut: unsigned(7 downto 0);
	signal five_input: unsigned(3 downto 0);
	signal counterOut, counterIn: unsigned(4 downto 0);
	signal divisorOut: unsigned(divisor_size-2 downto 0);
	signal ser_in: unsigned(3 downto 0);
	signal posDividend: unsigned(dividend_size-2 downto 0);
	signal posDivisor: unsigned(divisor_size-2 downto 0);
	signal signInput, signOutput : unsigned(0 downto 0);

begin
------------------------------- Data path ---------------------------------
	
	comp <= '1' when regOut(7 downto 4) >= divisorOut else '0';
	cnt_done <= '1' when (counterOut = to_unsigned(4, 5)) else '0';
	five_input <= regOut(7 downto 4) - divisorOut(3 downto 0);
	counterIn <= counterOut + 1;
	overflow <=  '1' when regOut(7 downto 4) >= posDivisor else
		'0';
	quotient <= signed('0' & regOut(3 downto 0)) when signOutput(0) ='0'  else
		signed('1' & (not regOut(3 downto 0)+1));
	
	remainder <= signed('0' & regOut(7 downto 4)) when (signOutput(0) = '0' or regOut(7 downto 4)=to_unsigned(0, 4)) else
		signed('1' & (not regOut(7 downto 4)+1));

	posDividend <= unsigned(std_logic_vector(dividend(dividend_size-2 downto 0))) when dividend(dividend_size-1) = '0' else 
		unsigned(
			std_logic_vector((not dividend(dividend_size-2 downto 0)+1)));
	posDivisor <= unsigned(std_logic_vector(divisor(divisor_size-2 downto 0))) when divisor(divisor_size-1) = '0' else 
		unsigned(
			std_logic_vector((not divisor(divisor_size-2 downto 0)+1)));

	shifReg : entity work.shiftRegister
	port map(
		clk => clk,
		rst => rst,

		load => ldinput,
		shiftEn => shiftEn,
		serialEn => ser_en,
		five_input_en => ld_remainder,

		five_input_in => five_input,
		dataIn => posDividend,
		serialIn => comp,

		dataOut => regOut
	);
	
	Divisor_reg: entity work.Reg
	generic map(
		size => divisor_size-1
		)
	port map(
		clk => clk, 
		rst => rst, 

		load => divisor_ld,
		dataIn => posDivisor,
		dataOut => divisorOut
	);

	signInput(0) <= dividend(dividend_size-1) xor divisor(divisor_size-1);

	sign_reg: entity work.Reg
	generic map(
		size => 1
	)
	port map(
		clk => clk,
		rst => rst,
		load => divisor_ld,

		dataIn => signInput,
		dataOut => signOutput
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