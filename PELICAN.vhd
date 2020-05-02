library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity PELICAN is
	port
	(
		--Input Ports
		pButton	: in std_logic;
		
		--Output Ports
		pAlarm	: out std_logic := '0';
		pSevseg	: out std_logic_vector( 7 downto 0 ) := "11111111";
		pLCD    : out string (1 to 5) := "STOP!";
		pYellow	: inout std_logic := '1';
		pRed	: out std_logic	:= '0'
	);
end PELICAN;

architecture behaviour of PELICAN is

component timer_1sec is
	Port (reset, clk : in std_logic := '0';
		  start		 : in std_logic := '0';
		  timer   	 : out std_logic);
		  
end component;

	type LightState is (IDLE, STOP, COUNTDOWN);
	
	signal state 		: LightState := IDLE;
	signal nextState 	: LightState := IDLE;
	signal counter		: integer := 9; 
	signal pClk			: std_logic;
	
	constant pWalk : string (1 to 5) := "GO   "; 
	constant pStop : string (1 to 5) := "STOP!";
	
begin

timer_clock: timer_1sec PORT MAP (timer => pClk);



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
				pRed    <= '0';
				pAlarm  <= '0';
				pLCD 	<= pStop;
			
			when STOP =>
			
				pRed    <= '1';
				pYellow <= '0';
				pLCD    <= pWalk;
				pAlarm  <= '1';
				
			when COUNTDOWN =>
			
				pYellow <= '1';
				pRed    <= '0';
				pLCD    <= pStop;
				pAlarm  <= '0';
		
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

SegmentProc : process(state,counter) is begin

	if (state /= IDLE) then
		case counter is 
			when 0 => 		pSevseg <= "10111111"; --0
			when 1 => 		pSevseg <= "10000110"; --1
			when 2 => 		pSevseg <= "11011011"; --2
			when 3 => 		pSevseg <= "11001111"; --3
			when 4 => 		pSevseg <= "11100110"; --4
			when 5 => 		pSevseg <= "11101101"; --5
			when 6 => 		pSevseg <= "11111100"; --6
			when 7 => 		pSevseg <= "10000111"; --7
			when 8 => 		pSevseg <= "11111111"; --8
			when 9 => 		pSevseg <= "11101111"; --9
			when others =>	pSevseg <= "11111111";--Shut
		end case;
	else					pSevseg <= "11111111";--Shut
	end if;
	
end process;

end architecture;