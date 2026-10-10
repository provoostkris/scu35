library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.and_reduce;
use work.scu35_demo_pkg.all;

entity scu35_demo is
  port (
    sysclk_p :   in std_logic;
    sysclk_n :   in std_logic;
    buttons  :   in std_logic_vector(4 downto 0);
    switches :   in std_logic_vector(7 downto 0);
    rgb_leds :   out std_logic_vector(14 downto 0)
  );
end entity scu35_demo;

architecture rtl of scu35_demo is
  --! Input buffer for differential clock input
  component IBUFDS is
    port (
      I  :  in std_logic;
      IB :  in std_logic;
      O  :  out std_logic
    );
  end component IBUFDS;

  -- button mquad mapping follows the SCU35 XDC: buttons are active low, so we invert them to make them active high.
  alias buttons_c   :  std_logic is buttons(c_button_center);
  alias buttons_s   :  std_logic is buttons(c_button_south);
  alias buttons_n   :  std_logic is buttons(c_button_north);
  alias buttons_w   :  std_logic is buttons(c_button_west);
  alias buttons_e   :  std_logic is buttons(c_button_east);

  -- LED mapping follows the SCU35 XDC: each RGB LED is packed as R,G,B in consecutive bits.
  alias led0_red    :  std_logic is rgb_leds(c_led0_red);
  alias led0_green  :  std_logic is rgb_leds(c_led0_green);
  alias led0_blue   :  std_logic is rgb_leds(c_led0_blue);
  alias led1_red    :  std_logic is rgb_leds(c_led1_red);
  alias led1_green  :  std_logic is rgb_leds(c_led1_green);
  alias led1_blue   :  std_logic is rgb_leds(c_led1_blue);
  alias led2_red    :  std_logic is rgb_leds(c_led2_red);
  alias led2_green  :  std_logic is rgb_leds(c_led2_green);
  alias led2_blue   :  std_logic is rgb_leds(c_led2_blue);
  alias led3_red    :  std_logic is rgb_leds(c_led3_red);
  alias led3_green  :  std_logic is rgb_leds(c_led3_green);
  alias led3_blue   :  std_logic is rgb_leds(c_led3_blue);
  alias led4_red    :  std_logic is rgb_leds(c_led4_red);
  alias led4_green  :  std_logic is rgb_leds(c_led4_green);
  alias led4_blue   :  std_logic is rgb_leds(c_led4_blue);

  signal clk     :  std_logic;
  signal counter :  unsigned(31 downto 0) ;

begin

  -- CLK DIFF input buffer
  clock_input : IBUFDS
    port map (
      I => sysclk_p,
      IB => sysclk_n,
      O => clk
    );

  process (clk)
  begin
    if rising_edge(clk) then
      if buttons_c = c_button_press then
        counter <= (others => '0');
      else
        if and_reduce(std_logic_vector(counter)) = '1' then
          counter <= (others => '0');
        else
          counter <= counter + 1;
        end if;
      end if;
    end if;
  end process;


  rgb_leds <= std_logic_vector(counter(counter'high downto counter'high-rgb_leds'length+1));

end architecture rtl;
