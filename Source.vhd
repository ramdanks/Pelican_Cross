library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
;
entity PELICAN is
	port
	(
		--Input Ports
		pButton	: in std_logic;
		pClk	: in std_logic;
		--Output Ports
		pAlarm	: out std_logic;
		pSevseg	: out std_logic_vector( 6 downto 0 );
		pYellow	: inout std_logic;
		pRed	: out std_logic
	);
end PELICAN;

architecture behaviour of PELICAN is

	type LightState is (IDLE, STOP, COUNTDOWN);
	
	signal state 		: LightState := IDLE;
	signal nextState 	: LightState := IDLE;
	signal counter		: integer := 9;

begin

Control : process(pClk,pButton,counter) is begin
	
	if (state = COUNTDOWN and counter <= 0) then 	nextState <= STOP;
	elsif (state = STOP and counter <= 0) then 		nextState <= IDLE;
	end if;
	
	if (rising_edge(pClk)) then
	
		state <= nextState;
		
	end if;
	
	if (pButton = '1' and state = IDLE) then

			nextState <= COUNTDOWN;

	end if;

end process;

Light : process(pClk,pYellow,state) is begin

	if (rising_edge(pClk)) then
	
		case state is
		
			when IDLE  =>
							pYellow <= not pYellow;
							pRed <= '0';
							pAlarm <= '0';
			when STOP =>
							pRed <= '1';
							pYellow <= '0';
							pAlarm <= '1';
			when COUNTDOWN =>
							pYellow <= '1';
							pRed <= '0';
							pAlarm <= '0';
							
		end case;
		
	end if;

end process;

procCounter : process(pClk,counter) is begin

	if (rising_edge(pClk) and state /= IDLE) then

		if ( counter < 1 ) 	then	counter <= 9;
		else						counter <= counter - 1;
		end if;
	
	end if;

end process;

end architecture;