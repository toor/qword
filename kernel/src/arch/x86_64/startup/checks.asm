global check_cpuid
global check_long_mode

extern textmodeprint

%define kernel_phys_offset 0xffffffffc0000000

section .data

calls:
    .textmodeprint      dq textmodeprint - kernel_phys_offset

section .text
bits 32
check_cpuid:
    ; Copy flags into eax via the stack.
    pushfd
    pop eax

    ; Store previous state in ecx for comparison later on.
    mov ecx, eax

    ; Flip 21st bit, ID bit.
    xor eax, 1 << 21
    
    push eax
    popfd
    
    pushfd
    pop eax

    push ecx
    popfd

    cmp eax, ecx
    db 0x75, 0x0b   ; jne
    add esp, 4
    mov dword [esp], .no_cpuid - kernel_phys_offset
    ret
    ret
.no_cpuid:
    mov esi, .msg - kernel_phys_offset
    call [(calls.textmodeprint) - kernel_phys_offset]
.halt:
    cli
    hlt
    jmp .halt - kernel_phys_offset

.msg db "CPUID not supported", 0

check_long_mode:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    db 0x73, 0x0b   ; jnb
    add esp, 4
    mov dword [esp], .no_long_mode - kernel_phys_offset
    ret

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29 ; Check if the LM bit is set in the D register
    db 0x75, 0x0b   ; jnz
    add esp, 4
    mov dword [esp], .no_long_mode - kernel_phys_offset
    ret
    ret
.no_long_mode:
    mov esi, .no_lm_msg - kernel_phys_offset
    call [(calls.textmodeprint) - kernel_phys_offset]
.halt:
    cli
    hlt
    jmp .halt - kernel_phys_offset
.no_lm_msg db "Long mode not available, system halted", 0
