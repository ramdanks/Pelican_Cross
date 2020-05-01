library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

--entitiy for 1 second timer
entity timer_1sec is
	Port (reset: in std_logic;
		  clk  : in std_logic);
		  
end timer_1sec;


--fsm model for 1 second timer_1sec
architecture fsm of timer_1sec os
	type state_type is  (idle, high_pulse, low_pulse);
	signal count_up: std_logic;
	signal counter: unsigned (27 downto 0) := ;
	signal count, next_state: state_type;
begin
	