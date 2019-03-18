Library work;
Library IEEE;


Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity divider is
  generic(
  		dividend_size : integer := 9;
  		divisor_size : integer := 5
  	);
  port (
	clk : in std_logic;
	rst : in std_logic;

	start : in std_logic;

	dividend : in signed(dividend_size-1 downto 0);
	divisor: in signed(divisor_size-1 downto 0);

	quotient : out signed(4 downto 0);
	remainder : out signed(4 downto 0);
	overflow : out std_logic;
	done : out std_logic
  ) ;
end entity ; -- divider

architecture behavioral of divider is

	signal cnt_done, cpm_res, dividend_ld, shiftEn, ser_en, divisor_ld, ld_remainder, cnt_en, ld_divisor: std_logic;

begin
	datapath: entity work.divider_DP
	port map(
		clk => clk,
		rst => rst,
		
		dividend => dividend,
		divisor => divisor,

		divisor_ld => divisor_ld,
		ld_remainder => ld_remainder,
		ldinput => dividend_ld,
		shiftEn	=> shiftEn,
		cnt_en => cnt_en,
		ser_en => ser_en,

		cnt_done => cnt_done,
		
		remainder => remainder,
		quotient => quotient,
		overflow => overflow,
		comp => cpm_res
  	);

	controller_divider: entity work.divider_controller
	port map (
		clk => clk,
		rst => rst,

		cnt_done => cnt_done,
		start => start, 
		cpm_res => cpm_res,

		ld_remainder => ld_remainder,
		ldinput => dividend_ld,
		shiftEn	=> shiftEn,
		ser_en => ser_en,

		done => done, 
		divisor_ld => divisor_ld,
		cnt_en => cnt_en
  );
end architecture ; -- behavioral