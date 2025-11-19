
localparam R_TYPE  = 7'b011_0011;  	// Arithmetic and logical operations
localparam I_LOAD  = 7'b000_0011;  	// Load data from memory
localparam I_TYPE  = 7'b001_0011;  	// Immediate value operations
localparam S_TYPE  = 7'b010_0011;  	// Store data in memory
localparam B_TYPE  = 7'b110_0011;  	// Conditional branches
localparam JAL     = 7'b110_1111;  	// Unconditional jump and link
localparam JALR    = 7'b110_0111;  	// Jump to register location
localparam LUI     = 7'b011_0111;  	// Load upper immediate
localparam AUIPC   = 7'b001_0111;  	// Add upper immediate to PC
