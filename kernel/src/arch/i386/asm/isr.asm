global int_handler
extern dummy_int_handler

; Exception handlers.
global exc_div0_handler
global exc_debug_handler
global exc_nmi_handler
global exc_breakpoint_handler
global exc_overflow_handler
global exc_bound_range_handler
global exc_inv_opcode_handler
global exc_no_dev_handler
global exc_double_fault_handler
global exc_inv_tss_handler
global exc_no_segment_handler
global exc_ss_fault_handler
global exc_gpf_handler
global exc_page_fault_handler
global exc_x87_fp_handler
global exc_alignment_check_handler
global exc_machine_check_handler
global exc_simd_fp_handler
global exc_virt_handler
global exc_security_handler

extern div0_handler
extern debug_handler
extern nmi_handler
extern breakpoint_handler
extern overflow_handler
extern bound_range_handler
extern inv_opcode_handler
extern no_dev_handler
extern double_fault_handler
extern inv_tss_handler
extern no_segment_handler
extern ss_fault_handler
extern gpf_handler
extern page_fault_handler
extern x87_fp_handler
extern alignment_check_handler
extern machine_check_handler
extern simd_fp_handler
extern virt_handler
extern security_handler

; Common handler that saves registers, calls a common function, restores registers and then returns.
%macro common_handler 1
    pusha

    call %1

    popa

    iretd

%endmacro

%macro except_handler_err_code 1
    ; Since GPRs get trashed by an exception anyway we don't need to save them.
    pop esi
    pop edi
    ; Pop the error code as well.
    pop edx
    
    call %1

    iretd
%endmacro

%macro except_handler 1
    pop esi
    pop edi

    call %1

    iretd
%endmacro

section .text
bits 32

int_handler:
    common_handler dummy_int_handler
exc_div0_handler:
    except_handler div0_handler
exc_debug_handler:
    except_handler debug_handler
exc_nmi_handler:
    except_handler nmi_handler
exc_breakpoint_handler:
    except_handler breakpoint_handler
exc_overflow_handler:
    except_handler overflow_handler
exc_bound_range_handler:
    except_handler bound_range_handler
exc_inv_opcode_handler:
    except_handler inv_opcode_handler
exc_no_dev_handler:
    except_handler no_dev_handler
exc_double_fault_handler:
    except_handler_err_code double_fault_handler
exc_inv_tss_handler:
    except_handler_err_code inv_tss_handler
exc_no_segment_handler:
    except_handler_err_code no_segment_handler
exc_ss_fault_handler:
    except_handler_err_code ss_fault_handler
exc_gpf_handler:
    except_handler_err_code gpf_handler
exc_page_fault_handler:
    except_handler_err_code page_fault_handler
exc_x87_fp_handler:
    except_handler x87_fp_handler
exc_alignment_check_handler:
    except_handler_err_code alignment_check_handler
exc_machine_check_handler:
    except_handler machine_check_handler
exc_simd_fp_handler:
    except_handler simd_fp_handler
exc_virt_handler:
    except_handler virt_handler
exc_security_handler:
    except_handler_err_code security_handler
