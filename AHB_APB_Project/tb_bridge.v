`timescale 1ns/1ps

module tb_bridge();
    // 1. Create wires to connect to our bridge
    reg HCLK;
    reg HRESETn;
    reg HSEL;
    reg [31:0] HADDR;
    reg [31:0] HWDATA;

    wire PSEL;
    wire PENABLE;
    wire [31:0] PADDR;
    wire [31:0] PWDATA;

    // 2. Connect the "Operator" to the "Machine"
    ahb_apb_bridge dut (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HSEL(HSEL),
        .HADDR(HADDR),
        .HWDATA(HWDATA),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PADDR(PADDR),
        .PWDATA(PWDATA)
    );

    // 3. Create the "Heartbeat" (Clock)
    always #5 HCLK = ~HCLK;

    // 4. The Action Plan
    initial begin
        // Initialize everything to 0
        HCLK = 0;
        HRESETn = 0;
        HSEL = 0;
        HADDR = 0;
        HWDATA = 0;

        // Reset the system
        #15 HRESETn = 1;

        // --- TEST 1: Send Data to Address 100 ---
        #10;
        HSEL = 1;
        HADDR = 32'd100;
        HWDATA = 32'hABCD;
        
        #10;
        HSEL = 0; // Turn off selection after starting

        // Wait and then finish
        #100;
        $display("Simulation Finished!");
        $finish;
    end

    // 5. Create a file for the waveforms (GTKWave)
    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, tb_bridge);
    end
endmodule