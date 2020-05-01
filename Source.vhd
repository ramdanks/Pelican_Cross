library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity PELICAN is
	port
	(
		--Input Ports
		pButton	: in std_logic;
		pClk	   : in std_logic;
		--Output Ports
		pAlarm	: out std_logic;
		pSevseg	: inout std_logic_vector( 7 downto 0 );
		pYellow	: inout std_logic;
		pLCD     : out string (1 to 5);
		pRed	   : out std_logic
	);
end PELICAN;

architecture behaviour of PELICAN is

	type LightState is (IDLE, STOP, COUNTDOWN);
	
	signal state 		: LightState := IDLE;
	signal nextState 	: LightState := IDLE;
	signal counter		: integer := 9; 
	signal dec 			: std_logic_vector(3 downto 0) := "1001";  
	
	constant pWalk : string (1 to 5) := "GO   "; 
	constant pStop : string (1 to 5) := "STOP!";

begin



Control : process(pClk,pButton,counter) is begin
	
	if (state = COUNTDOWN and counter <= 0) then
	
		nextState <= STOP;
	
	elsif (state = STOP and counter <= 0) then
	
		nextState <= IDLE;
	
	end if;
	
	if (rising_edge(pClk)) then
		
		state <= nextState;
	
	end if;
	
	if (pButton = '1') then
	   
		if (state = IDLE) then
		
			nextState <= COUNTDOWN;
		end if;
	
	end if;

end process;

Light : process(pClk,pYellow,state) is begin

	if (rising_edge(pClk)) then
	
		case state is
		
			when IDLE  =>
			
				pYellow <= not pYellow;
				pRed <= '0';
			
			when STOP =>
			
				pRed <= '1';
				pYellow <= '0';
				pLCD    <= pStop; 
				
			when COUNTDOWN =>
			
				pYellow <= '1';
				pRed <= '0';
				pLCD <= pWalk;
		
		end case;
	
	end if;

end process;

procCounter : process(pClk,counter) is begin

	if (rising_edge(pClk) and state /= IDLE) then
		
		if ( counter < 1 ) 	then	
		counter <= 9;
		dec     <= "1001"; 
		else	
      		
		counter <= counter - 1;
		dec     <= std_logic_vector(unsigned(dec) - 1); 
		case dec is 
			when "0000" =>
			pSevseg <= "10111111"; ---0
			when "0001" =>
			pSevseg <= "10000110"; ---1
			when "0010" =>
			pSevseg <= "11011011"; ---2
			when "0011" =>
			pSevseg <= "11001111"; ---3
			when "0100" =>
			pSevseg <= "11100110"; ---4
			when "0101" =>
			pSevseg <= "11101101"; ---5
			when "0110" =>
			pSevseg <= "11111100"; ---6
			when "0111" =>
			pSevseg <= "10000111"; ---7
			when "1000" =>
			pSevseg <= "11111111"; ---8
			when "1001" =>
			pSevseg <= "11101111"; ---9
			when others =>
			pSevseg <= "10110111"; ---null
			end case;
		
		end if;
	
	end if;

end process;

end architecture;