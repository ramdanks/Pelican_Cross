library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity PELICAN is
	port
	(
		--Input Ports
		pButton	: in std_logic;
		pClk	: in std_logic;
		--Output Ports
		pAlarm	: out std_logic;
		pSevseg	: out std_logic_vector( 6 downto 0 );
		pYellow	: out std_logic;
		pRed	: out std_logic
	);
end PELICAN;

architecture behaviour of PELICAN is

	type LightState is (IDLE, STOP, COUNTDOWN);
	
	signal state 		: LightState := IDLE;
	signal nextState 	: LightState := IDLE; 

begin



end architecture;