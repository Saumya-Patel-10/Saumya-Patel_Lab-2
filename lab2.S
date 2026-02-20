// Lab 2 — Array Loop Extension (AArch64 / ARM64)
// Goal: compute (1) sum of array elements, and (2) count of positive elements (> 0).
//
// Students: implement ONLY the TODO block. Do not rename symbols.
//
// Build (ARM64 native Ubuntu):
//   gcc -no-pie -O0 -g lab2.S -o lab2
//   ./lab2
//
// Build (x86 Ubuntu with cross toolchain):
//   aarch64-linux-gnu-gcc -no-pie -O0 -g lab2.S -o lab2
// Run on x86 with QEMU user-mode:
//   qemu-aarch64 -L /usr/aarch64-linux-gnu ./lab2

        .text
        .global main
        .extern printf

main:
        // Prologue (keep 16-byte stack alignment)
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!

        // Register map for this lab:
        //   X22 = base address of A
        //   X1  = N (length)
        //   X19 = i (index)
        //   X20 = sum (int64)
        //   X23 = count_pos (int64)
        //   X21 = address scratch / offset scratch
        //   X12 = value scratch (loaded A[i])

        // X22 = &A[0]
        adrp    x22, A
        add     x22, x22, :lo12:A

        // X1 = N
        ldr     x1, =N_value
        ldur    x1, [x1, #0]          // load N_value from memory into X1

        // i = 0
        mov     x19, xzr

        // sum = 0
        mov     x20, xzr

        // count_pos = 0
        mov     x23, xzr

        // -------------------------
        // TODO (STUDENTS WRITE HERE)
        // -------------------------
        // Implement:
        //   for (i = 0; i < N; i++):
        //       sum += A[i]
        //       if (A[i] > 0) count_pos++
        //
        // Requirements:
        //   - Use LSL #3 to multiply i by 8 (int64 element size)
        //   - Use LDUR to load A[i]
        //   - Use CMP and a conditional branch for both:
        //       - loop termination
        //       - (A[i] > 0) decision
        // -------------------------

        // -------------------------
        // END TODO
        // -------------------------

        // Print: "sum = <sum>, count_pos = <count_pos>\n"
        adrp    x0, fmt
        add     x0, x0, :lo12:fmt
        mov     x1, x20               // 2nd arg: sum
        mov     x2, x23               // 3rd arg: count_pos
        bl      printf

        // return 0
        mov     w0, wzr

        // Epilogue
        ldp     x23, x24, [sp], #16
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

        .section .rodata
fmt:
        .asciz  "sum = %ld, count_pos = %ld\n"

        .data
        .align  3
A:
        // You may change these values to test, but do not change the symbol name A.
        .quad   10
        .quad   -3
        .quad   25
        .quad   0
        .quad   -7
        .quad   4

        .align  3
N_value:
        .quad   6

