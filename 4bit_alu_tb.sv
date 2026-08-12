// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_alu_4bit;

    // Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] ALU_Sel;

    // Outputs
    wire [3:0] ALU_Out;
    wire CarryOut;
    wire Zero;

    // Expected Output Trackers for Self-Checking Logic
    reg [3:0] expected_out;
    reg expected_carry;
    integer i;

    // Instantiate the Unit Under Test (UUT)
    alu_4bit uut (
        .A(A), 
        .B(B), 
        .ALU_Sel(ALU_Sel), 
        .ALU_Out(ALU_Out), 
        .CarryOut(CarryOut), 
        .Zero(Zero)
    );

    // Waveform Generation Block
    initial begin
        $dumpfile("alu_4bit_waveform.vcd"); // Defines the name of the output waveform file
        $dumpvars(0, tb_alu_4bit);          // Dumps all variables in this module and its sub-modules (uut)
    end

    // Main Test Vector Execution Block
    initial begin
        // Display header block
        $display("=================================================");
        $display("Starting Self-Checking ALU Testbench with VCD Dump...");
        $display("=================================================");
        
        // Initialize Inputs
        A = 4'b0000; B = 4'b0000; ALU_Sel = 3'b000;
        #10;
        
        // Loop through all 8 operations with distinct test cases
        for (i = 0; i < 8; i = i + 1) begin
            ALU_Sel = i;
            
            // Assign specific inputs depending on the opcode to test corner cases
            case(ALU_Sel)
                3'b000: begin A = 4'b1101; B = 4'b0101; expected_out = 4'b0010; expected_carry = 1'b1; end // 13 + 5 = 18 (2 with Carry 1)
                3'b001: begin A = 4'b1000; B = 4'b0011; expected_out = 4'b0101; expected_carry = 1'b0; end // 8 - 3 = 5
                3'b010: begin A = 4'b1010; B = 4'b1100; expected_out = 4'b1000; expected_carry = 1'b0; end // 1010 AND 1100 = 1000
                3'b011: begin A = 4'b1010; B = 4'b0101; expected_out = 4'b1111; expected_carry = 1'b0; end // 1010 OR 0101 = 1111
                3'b100: begin A = 4'b1111; B = 4'b1010; expected_out = 4'b0101; expected_carry = 1'b0; end // 1111 XOR 1010 = 0101
                3'b101: begin A = 4'b1100; B = 4'b1010; expected_out = 4'b0111; expected_carry = 1'b0; end // 1100 NAND 1010 = 0111
                3'b110: begin A = 4'b0010; B = 4'b0100; expected_out = 4'b0001; expected_carry = 1'b0; end // 2 < 4 = True (1)
                3'b111: begin A = 4'b0101; B = 4'b0000; expected_out = 4'b1010; expected_carry = 1'b0; end // Shift Left 0101 = 1010
            endcase
            
            #10; // Wait for combinational settling
            
            // Check Output Performance
            if ((ALU_Out !== expected_out) || (CarryOut !== expected_carry)) begin
                $display("ERROR: Opcode %b Failed! A=%b, B=%b | Expected: Out=%b Co=%b | Got: Out=%b Co=%b", 
                         ALU_Sel, A, B, expected_out, expected_carry, ALU_Out, CarryOut);
            end else begin
                $display("SUCCESS: Opcode %b Passed. A=%b, B=%b -> Out=%b, Zero=%b", 
                         ALU_Sel, A, B, ALU_Out, Zero);
            end
        end

        // Edge Case Test: Verify Zero Flag triggers correctly
        ALU_Sel = 3'b010; A = 4'b0101; B = 4'b1010; // 0101 AND 1010 = 0000
        #10;
        if (Zero === 1'b1)
            $display("SUCCESS: Zero Flag Verification Passed.");
        else
            $display("ERROR: Zero Flag Failed to assert.");

        $display("=================================================");
        $display("ALU Verification Simulation Finished. Waveform generated.");
        $display("=================================================");
        $finish;
    end

endmodule
