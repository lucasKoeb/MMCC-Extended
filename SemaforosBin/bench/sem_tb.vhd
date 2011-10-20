library IEEE;
use IEEE.std_logic_1164.all;

use work.pack.all;

entity semaphores_tb is
end;

architecture tb of semaphores_tb is
  
  component binary_semaphores is
    generic (
      max_semaphores : integer := NUM_SEM;
      sem_size : integer := SEM_SIZE;
      start: natural:= SEM_START_ADR
      );

   port(
      address : in bus32;
      reset: in std_logic;
      data_out : out bus32;
      req : in std_logic;
      clock : in std_logic
      );
  end component;
  
  signal address : bus32;
  signal reset : std_logic;
  signal data_out : bus32;
  signal req : std_logic;
  signal clock : std_logic := '0';
begin 

 U_semaphores : binary_semaphores port map(
   address => address,
   reset => reset,
   data_out => data_out,
   req => req,
   clock => clock
   );

  clock <= not clock after 20 ns;
  reset <= '0', '1' after 5 ns, '0' after 70 ns;
  --address <= x"FFFFFC00" after 100 ns; 
  --address <= x"FFFFF400" after 140 ns;
  --address <= x"FFFFF800" after 180 ns; 
  --address <= x"FFFFF400" after 220 ns; 
  --address <= x"00000000" after 260 ns; -- x"FFFFF400" after 220 ns, x"FFFFF400" after 240 ns, x"00000000" after 260 ns;
  req <='1';
process
begin
  address <= x"FFFFFC00"; wait for 40 ns; 
  address <= x"FFFFF400"; wait for 40 ns;
  address <= x"FFFFF800"; wait for 40 ns; 
  address <= x"FFFFF400"; wait for 40 ns; 
  address <= x"00000000"; wait for 40 ns; 
    wait for 8000 ns;
end process;
  
end tb;
