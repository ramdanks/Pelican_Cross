library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

--entitiy for 1 second timer
entity timer_1sec is
	Port (reset, clk : in std_logic;
		  start		 : in std_logic;
		  timer   	 : out std_logic);
		  
end timer_1sec;


--fsm model for 1 second timer_1sec
architecture fsm of timer_1sec is
	type state_type is  (idle, high_pulse, low_pulse);
	signal current_state, next_state: state_type;
	signal count_up: std_logic;
	signal counter: natural range 0 to 999999999 := 0;
begin

	process (reset, clk) is
	begin
		if (reset='1') then
			current_state <= idle;
			counter <= 0;
		elsif (rising_edge(clk)) then
			current_state <= next_state;
			
			if (count_up='1') then
				counter <= counter + 1;
			else
				counter <= 0;
			end if;
		end if;
	end process;
	
	
	process (current_state, counter, start) is
	begin
		count_up <= '0';
		timer <= '0';
		
		case current_state is
			when idle =>
				if (start='0') then
					next_state <= idle;
				else
					next_state <= high_pulse;
				end if;
			
			when high_pulse =>
				timer <= '1';
				if (start='0') then
					next_state <= idle;
				elsif (counter < 49999999) then
					count_up <= '1';
					next_state <= high_pulse;
				else
					count_up <= '1';
					next_state <= low_pulse;
				end if;
				
			when low_pulse =>
				if (start='0') then
					next_state <= idle;
				elsif (counter < 99999999) then
					count_up <= '1';
					next_state <= low_pulse;
				else
					next_state <= high_pulse;
				end if;
			
			when others =>
				next_state <= idle;
		end case;
	end process;
		
end fsm;


