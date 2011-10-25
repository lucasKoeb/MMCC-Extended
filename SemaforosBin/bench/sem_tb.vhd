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

  type test_array is array (positive range <>) of bus32;
  constant test_vectors: test_array :=
    (
      x"FFFFF" & "11" & "0000000000",
      x"FFFFF" & "01" & "0000000000",
      x"FFFFF" & "10" & "0000000000",
      x"FFFFF" & "01" & "0000000000",
      x"FFFFF" & "01" & "0000000000"
    );

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
  req <='1';

process
begin
  wait for 100 ns;
  for i in test_vectors'range loop
    address <= test_vectors(i);
    wait for 40 ns;
  end loop;
  address <= x"00000000"; -- Fim dos testes
  wait for 8000 ns;
end process;
end tb;
