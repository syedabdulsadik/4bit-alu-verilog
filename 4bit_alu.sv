module alu_4bit (
    input  wire [3:0] A, B,        // 4-bit Data Inputs
    input  wire [2:0] ALU_Sel,    // 3-bit Operation Select
    output reg  [3:0] ALU_Out,    // 4-bit Data Output
    output reg        CarryOut,   // Carry Out Flag (For Add/Sub)
    output wire       Zero        // Zero Flag (1 if ALU_Out is 0)
);

    // Continuous assignment for high-performance zero flag detection
    assign Zero = (ALU_Out == 4'b0000);

    always @(*) begin
        // Default values to prevent unwanted latch synthesis
        ALU_Out  = 4'b0000;
        CarryOut = 1'b0;
        
        case (ALU_Sel)
            3'b000: {CarryOut, ALU_Out} = A + B;        // Addition
            3'b001: {CarryOut, ALU_Out} = A - B;        // Subtraction
            3'b010: ALU_Out = A & B;                    // Bitwise AND
            3'b011: ALU_Out = A | B;                    // Bitwise OR
            3'b100: ALU_Out = A ^ B;                    // Bitwise XOR
            3'b101: ALU_Out = ~(A & B);                 // Bitwise NAND
            3'b110: ALU_Out = (A < B) ? 4'b0001 : 4'b0000; // Set Less Than (SLT)
            3'b111: ALU_Out = A << 1;                   // Logical Left Shift
            default: begin
                ALU_Out  = 4'b0000;
                CarryOut = 1'b0;
            end
        endcase
    end
endmodule
