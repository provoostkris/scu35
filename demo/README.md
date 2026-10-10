# SCU35 Demo

This project is a small programmable-logic showcase for the SCU35 evaluation board. It uses the board's 100 MHz differential clock, five RGB LEDs, push butto(s), and DIP switche(s).
The design RTL is in `rtl/scu35_demo.vhd`;
the board mapping constants are defined in `rtl/scu35_demo_pkg.vhd`.

## Controls

- DIP switches 0-7 : reserved
- Button center    : reset
- Button north     : reserved
- Button east      : reserved
- Button south     : reserved
- Button west      : reserved


## Build the bitstream

From the `demo/` directory, create the Vivado project if needed and then build the bitstream. The generated project is `build/demo.xpr` and targets `xcsu35p-sbvb625-2-e`.

```powershell
cd demo
vivado -mode batch -source scripts/create_project.tcl
vivado -mode batch -source scripts/build_bitstream.tcl
```

The `create_project.tcl` script creates or recreates the project and adds the SCU35 constraint file, while `build_bitstream.tcl` opens the project, runs synthesis and implementation, and writes the bitstream. A successful build produces `build/demo.runs/impl_1/scu35_demo.bit`.

To remove the generated project and stale Vivado log/journal files without
recreating the project, run:

```powershell
vivado -mode batch -source scripts/clean_project.tcl
```

`create_project.tcl` runs this cleanup automatically before creating a new
project.

If Vivado reports that the SCU35 board part is unavailable, install the board support package for the SCU35 before running the build.

In Vivado Hardware Manager, connect to the SCU35 target, select **Program Device**, and choose the generated `scu35_demo.bit` file.
