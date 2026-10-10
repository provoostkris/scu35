library ieee;
use ieee.std_logic_1164.all;

package scu35_demo_pkg is
  constant c_button_press       : std_logic := '1';

  constant c_button_center      : natural := 0;
  constant c_button_south       : natural := 1;
  constant c_button_north       : natural := 2;
  constant c_button_west        : natural := 3;
  constant c_button_east        : natural := 4;

  constant c_led0_red           : natural := 0;
  constant c_led0_green         : natural := 1;
  constant c_led0_blue          : natural := 2;
  constant c_led1_red           : natural := 3;
  constant c_led1_green         : natural := 4;
  constant c_led1_blue          : natural := 5;
  constant c_led2_red           : natural := 6;
  constant c_led2_green         : natural := 7;
  constant c_led2_blue          : natural := 8;
  constant c_led3_red           : natural := 9;
  constant c_led3_green         : natural := 10;
  constant c_led3_blue          : natural := 11;
  constant c_led4_red           : natural := 12;
  constant c_led4_green         : natural := 13;
  constant c_led4_blue          : natural := 14;
end package scu35_demo_pkg;
