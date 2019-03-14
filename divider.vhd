entity divider_DP is
  generic(
  	divisor_size: integer := 4,
  	dividend_size: integer := 8,
  	quotient_size: integer := 4,
  	remainder_size: integer := 4
  );
  port (
	clk: in std_logic,
	rst: in std_logic,
	
	dividend: in signed(dividend_size-1 downto 0),
	divisor: in signed(divisor_size-1 downto 0),

	ld_5input : in std_logic,
	ldinput : in std_logic,
	shiftEn	: in std_logic,
	ser_en : in std_logic,
	done : in std_logic,
	ld2 : in std_logic,

	cnt_done : in std_logic,
	pos : in std_logic,

	remainder: out unsigned(remainder_size-1 downto 0),
	quotient: out unsigned(quotient_size-1 downto 0),

	overflow: out std_logic,
	done: out std_logic

  ) ;
end entity ; -- divider

architecture behavioral of divider is

	signal comp: signed(4 downto 0);
	signal regOut: signed(8 downto 0);
	signal 5inputs: signed(4 downto 0);
	signal signed(8 downto 0);
begin

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

		5inputIn => 5inputs,
		dataIn => init_data,
		serialIn => ser_in,

		dataOut => regOut
	  ) ;
	  
end architecture ; -- behavioral