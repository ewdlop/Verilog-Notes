# Quine-McCluskey Algorithm

## Overview

The Quine-McCluskey algorithm (also known as the tabular method) is a systematic method for minimizing Boolean functions. It was developed by Willard V. Quine and Edward J. McCluskey in the 1950s. Unlike Karnaugh maps (K-maps), which are visual and limited to about 4-6 variables, the Quine-McCluskey algorithm can handle any number of variables and is well-suited for computer implementation.

## Algorithm Overview

The Quine-McCluskey algorithm consists of two main steps:

### Step 1: Finding Prime Implicants

1. **List all minterms**: Start with the minterms (product terms) where the function equals 1
2. **Group by number of 1s**: Organize minterms by the number of 1s in their binary representation
3. **Combine adjacent groups**: Compare minterms that differ by only one bit position
4. **Mark combined terms**: Terms that are combined are marked as used
5. **Repeat**: Continue combining until no more combinations are possible
6. **Prime implicants**: Unmarked terms after the process are prime implicants

### Step 2: Selecting Essential Prime Implicants

1. **Create prime implicant chart**: List all prime implicants and the minterms they cover
2. **Identify essential prime implicants**: Prime implicants that are the only ones covering a particular minterm
3. **Select minimal cover**: Choose the minimum set of prime implicants to cover all minterms

## Advantages over Karnaugh Maps

- **Scalability**: Can handle any number of variables (K-maps are limited to 4-6 variables)
- **Systematic approach**: Can be easily programmed and automated
- **Precision**: Eliminates human error in pattern recognition
- **Consistency**: Always produces the minimized form

## Examples in This Directory

### qm_3var.v
Simple 3-variable function demonstrating basic minimization.
- Minterms: 0,1,2,5,7
- Minimized: a'b' + ac + bc

### qm_4var.v
Standard 4-variable function example.
- Minterms: 0,1,2,5,6,7,8,9,14
- Minimized: a'b' + b'c' + ac'd

### qm_4var_complex.v
More complex 4-variable function.
- Minterms: 1,3,4,5,6,7,10,12,13
- Minimized: a'c + ab' + bc'd + a'bd'

### qm_5var.v
5-variable function demonstrating QM's advantage for functions with many variables.
- Minterms: 0,1,4,5,8,9,12,13,16,17,20,21
- Minimized: a'c'e' + a'c'd' + ab'c'

### qm_majority.v
Majority function implementation (outputs 1 if at least 2 of 3 inputs are 1).
- Minterms: 3,5,6,7
- Minimized: ab + ac + bc

### qm_xor_like.v
Complex 4-variable function with limited simplification opportunity.
- Minterms: 1,2,4,7,8,11,13,14
- Note: This function requires all 8 product terms (minimal simplification possible)

### qm_prime_implicant.v
Example demonstrating prime implicant selection.
- Minterms: 0,2,5,6,7,8,10,12,13,14,15
- Minimized: ab + ac + b'c' + a'd

## Comparison with Karnaugh Maps

Both Quine-McCluskey and Karnaugh maps solve the same problem (Boolean function minimization) but differ in approach:

| Feature | Karnaugh Map | Quine-McCluskey |
|---------|--------------|-----------------|
| Method | Visual/Graphical | Tabular/Algorithmic |
| Variable Limit | 4-6 variables | Unlimited |
| Ease of Use | Intuitive for humans | Better for computers |
| Error Prone | Yes (pattern recognition) | No (systematic) |
| Automation | Difficult | Easy |

## Applications

- **Digital circuit design**: Minimizing logic gates in hardware
- **FPGA/ASIC design**: Reducing resource usage
- **Compiler optimization**: Boolean expression simplification
- **Logic synthesis**: Automated design tools

## References

1. Quine, W. V. (1952). "The Problem of Simplifying Truth Functions"
2. McCluskey, E. J. (1956). "Minimization of Boolean Functions"
3. Roth, C. H. (2004). "Fundamentals of Logic Design"

## Related Topics

- Boolean Algebra
- Karnaugh Maps
- Don't Care Conditions
- Prime Implicants and Essential Prime Implicants
- Petrick's Method (for selecting prime implicants)
