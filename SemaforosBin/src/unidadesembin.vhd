library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

use work.pack.all;

entity binary_semaphores is
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
  clock: in std_logic
);

end;

architecture rtl of binary_semaphores is

  -- Internal registers type
  signal index_size: natural := log2_ceil(NUM_SEM)-1;
  subtype index_register is std_logic_vector(index_size downto 0);
  signal internal_index : index_register;
  signal semaphores_table : table_type;
  signal operation : bus2;
  signal sem_index : index_register;
begin

process(clock)
  variable i : integer := 0;
begin
  if clock'event and clock='1' then

   if reset = '1'  then
     -- Reset index and clean table
     internal_index <= (others => '0');
     for i in 0 to NUM_SEM-1 loop
       semaphores_table(i).valid <= '0';
       semaphores_table(i).sem_value <= (others => '0');
     end loop;
   end if;

   if operation = SEM_CREATE then
     if to_integer(unsigned(internal_index)) < NUM_SEM then
     -- It's possible to create a new semaphore
     semaphores_table(to_integer(unsigned(internal_index))).valid <= '1';
     semaphores_table(to_integer(unsigned(internal_index))).sem_value <= sem_type(address(SEM_SIZE downto 0));
     data_out(31 downto index_size+1) <= (others => '0');
     data_out(index_size downto 0) <= internal_index;
     internal_index <= index_register(unsigned(internal_index)+1);
     else
      --Table is full, return NIL
       data_out(31 downto 0) <= (others => '1');
     end if;
   end if;

   if operation = SEM_P  then
     if semaphores_table(to_integer(unsigned(sem_index))).valid = '1' then
       if semaphores_table(to_integer(unsigned(sem_index))).sem_value > "0000000000" then
         semaphores_table(to_integer(unsigned(sem_index))).sem_value <= sem_type(unsigned(semaphores_table(to_integer(unsigned(sem_index))).sem_value)-1);
         data_out(31 downto 0) <= (others => '0');
       else
         data_out <= (others => '1');
       end if;
     else
       data_out <= (others => '1');
     end if;
   end if;


   if operation = SEM_V then
     if semaphores_table(to_integer(unsigned(sem_index))).valid = '1' then
       semaphores_table(to_integer(unsigned(sem_index))).sem_value <= sem_type(unsigned(semaphores_table(to_integer(unsigned(sem_index))).sem_value)+1);
       data_out <= (others => '0');
     else
       data_out <= (others => '1');
     end if;

   end if;

end if;

end process;


process (address)
begin  -- process
  if address(31 downto 12) = x"FFFFF" then
    -- Valid address, execute operation:

    sem_index <= address(index_size downto 0);
    operation <= address(11 downto 10);

  else
    operation <= (others => '0');
  end if;
end process;
end rtl;
