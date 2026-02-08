module ahb_apb_bridge (
    // Inputs from the Fast Side (AHB)
    input HCLK,       // Heartbeat (Clock)
    input HRESETn,    // Restart button (Reset)
    input HSEL,       // "Wake up" signal from Master
    input [31:0] HADDR, // Where data goes (Address)
    input [31:0] HWDATA, // The actual data being sent

    // Outputs to the Slow Side (APB)
    output reg PSEL,    // Selects the worker peripheral
    output reg PENABLE, // The "Execute" signal
    output reg [31:0] PADDR, // Passes the address to worker
    output reg [31:0] PWDATA  // Passes the data to worker
);

    // --- THE BRAIN (Finite State Machine) ---
    
    // Names for our 3 steps (States)
    parameter IDLE   = 2'b00; 
    parameter SETUP  = 2'b01; 
    parameter ACCESS = 2'b10; 

    reg [1:0] current_state, next_state;

    // 1. Memory: This part remembers which step we are on right now
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // 2. Decider: Logic to choose what the NEXT step should be
    always @(*) begin
        case (current_state)
            IDLE:   next_state = (HSEL) ? SETUP : IDLE; // If Boss calls, go to SETUP
            SETUP:  next_state = ACCESS;               // Move to ACCESS automatically
            ACCESS: next_state = IDLE;                 // Finish and go back to sleep
            default: next_state = IDLE;
        endcase
    end

    // 3. Action: Logic to turn the actual output pins ON or OFF
    always @(*) begin
        // Default: Keep everything OFF
        PSEL    = 0;
        PENABLE = 0;
        PADDR   = 0;
        PWDATA  = 0;

        case (current_state)
            IDLE: begin
                // Bridge is sleeping, outputs stay 0
            end

            SETUP: begin
                PSEL  = 1;          // Tell worker: "Get ready!"
                PADDR = HADDR;      // Show the worker the address
            end

            ACCESS: begin
                PSEL    = 1;        // Keep worker selected
                PENABLE = 1;        // Tell worker: "Take the data now!"
                PADDR   = HADDR;    // Keep showing address
                PWDATA  = HWDATA;   // Give the worker the data
            end
        endcase
    end

endmodule