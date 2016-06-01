-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : my
-- Author      : Greentee5
-- Company     : solar
--
-------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\my\my\compile\shell.vhd
-- Generated   : Wed Jun  1 22:57:04 2016
-- From        : C:\My_Designs\my\my\src\shell.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library ieee;
        use ieee.std_logic_1164.all;
        use ieee.std_logic_unsigned.all;

entity shell is
  port(
       clk : in std_logic;
       rxdat : in std_logic;
       rxstb : in std_logic;
       txstb : in std_logic;
       xclk : in std_logic;
       ramcs : out std_logic;
       txdat : out std_logic;
       sevseg : out std_logic_vector(6 downto 0);
       rd : buffer std_logic;
       wr : buffer std_logic;
       addr : buffer std_logic_vector(15 downto 0);
       data : inout std_logic_vector(7 downto 0)
  );
end shell;

architecture one of shell is

---- Component declarations -----

component cpu
  port (
       clk : in STD_LOGIC;
       din : in STD_LOGIC_VECTOR(15 downto 0);
       dsel : in STD_LOGIC_VECTOR(1 downto 0);
       dout : out STD_LOGIC_VECTOR(7 downto 0);
       sevseg : out STD_LOGIC_VECTOR(6 downto 0);
       data : inout STD_LOGIC_VECTOR(7 downto 0);
       addr : buffer STD_LOGIC_VECTOR(15 downto 0);
       rd : buffer STD_LOGIC;
       wr : buffer STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal cpuclk : std_logic;
signal clkdiv : std_logic_vector (23 downto 0);
signal clksel : std_logic_vector (4 downto 0);
signal din : std_logic_vector (15 downto 0);
signal dout : std_logic_vector (7 downto 0);
signal dsel : std_logic_vector (1 downto 0);
signal rxshift : std_logic_vector (22 downto 0);
signal txshift : std_logic_vector (7 downto 0);
signal txshiftnext : std_logic_vector (7 downto 0);

begin

---- Processes ----

process
                       begin
                         wait until (clk'event and clk = '1');
                         clkdiv <= clkdiv + 1;
                       end process;                      

rx : process
                       begin
                         wait until (rxstb'event and rxstb = '1');
                         din <= rxshift(15 downto 0);
                         dsel <= rxshift(17 downto 16);
                         clksel <= rxshift(22 downto 18);
                       end process;                      

txrx : process
                       begin
                         wait until (xclk'event and xclk = '0');
                         rxshift <= rxshift(21 downto 0) & (not rxdat);
                         txshift <= txshiftnext;
                       end process;                      

---- User Signal Assignments ----
ramcs <= '0';
with txstb select txshiftnext <= txshift(6 downto 0) & '0' when '0', dout when others;
with clksel select cpuclk <= clk when "00000", clkdiv(0) when "00001", clkdiv(1) when "00010", clkdiv(2) when "00011", clkdiv(3) when "00100", clkdiv(4) when "00101", clkdiv(5) when "00110", clkdiv(6) when "00111", clkdiv(7) when "01000", clkdiv(8) when "01001", clkdiv(9) when "01010", clkdiv(10) when "01011", clkdiv(11) when "01100", clkdiv(12) when "01101", clkdiv(13) when "01110", clkdiv(14) when "01111", clkdiv(15) when "10000", clkdiv(16) when "10001", clkdiv(17) when "10010", clkdiv(18) when "10011", clkdiv(19) when "10100", clkdiv(20) when "10101", clkdiv(21) when "10110", clkdiv(22) when "10111", clkdiv(23) when "11000", '0' when "11110", '1' when "11111", '0' when others;

----  Component instantiations  ----

u1 : cpu
  port map(
       addr => addr,
       clk => cpuclk,
       data => data,
       din => din,
       dout => dout,
       dsel => dsel,
       rd => rd,
       sevseg => sevseg,
       wr => wr
  );


---- Terminal assignment ----

    -- Output\buffer terminals
	txdat <= txshift(7);


end one;
