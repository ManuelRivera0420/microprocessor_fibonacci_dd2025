# ALU

Arithmetic processing unit. The ALU receives two input operands, an operator selector and produces a result.
The first operand is sourced from a register and the second operand can be another value sourced from a register (R-type instruction) or an immediate value (I-type instruction). A MUX selects which operand will be used depending on the type of instruction sent by the Central Unit.
No output operations flags (carry, overflow, zero) in the implementation.
