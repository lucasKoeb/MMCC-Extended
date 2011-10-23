library ieee;
   use ieee.std_logic_1164.all;
   
package pack is
  
  -- Semaphores
  subtype sem_operation is std_logic_vector(1 downto 0);
  constant SEM_CREATE : sem_operation := "11";
  constant SEM_P : sem_operation := "01";
  constant SEM_V : sem_operation := "10";
  -- Semaphores Table
  constant NUM_SEM : integer := 1024;   -- Amount of available semaphores
  constant SEM_SIZE : integer := 9;    -- Number of bits for each semaphore value
  constant SEM_START_ADR : integer := 8200;  -- Initial addres for the semaphores
  
  -- Type signal on n bits
  subtype bus64 is std_logic_vector(63 downto 0);
  subtype bus33 is std_logic_vector(32 downto 0);
  subtype bus32 is std_logic_vector(31 downto 0);
  subtype bus31 is std_logic_vector(30 downto 0);
  subtype bus26 is std_logic_vector(25 downto 0);
  subtype bus24 is std_logic_vector(23 downto 0);
  subtype bus20 is std_logic_vector(19 downto 0);
  subtype bus16 is std_logic_vector(15 downto 0);
  subtype bus8 is std_logic_vector(7 downto 0);
  subtype bus6 is std_logic_vector(5 downto 0);
  subtype bus5 is std_logic_vector(4 downto 0);
  subtype bus4 is std_logic_vector(3 downto 0);
  subtype bus2 is std_logic_vector(1 downto 0);
  subtype bus1 is std_logic;

  component binary_semaphores is
    port (
      address :in bus32;
      reset : in std_logic;
      data_out: out bus32;
      req :in std_logic;
      clock : in std_logic
      
      );
  end component;

-- Semaphores Table:
--type sem_type is array (0 to SEM_SIZE) of std_logic ;
subtype sem_type is std_logic_vector(SEM_SIZE downto 0);
  
-- Table entry type
type table_item is 
record 
  valid : std_logic;
  sem_value : sem_type;
end record;

type table_type is array (natural range 0 to NUM_SEM) of table_item;
  
  function log2_ceil(N: natural) return natural;

 end;
 package body pack is

   function log2_ceil(N: natural) return natural is
   begin
      if N < 2 then
         return 0;
      else
         return 1 + log2_ceil(N/2);
      end if;
   end;

end;

