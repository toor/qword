OUTPUT_FORMAT(binary)
ENTRY(_start)

SECTIONS
{
    . = 0xffffffffc0000000 + 0x100000;

    .text ALIGN(4K) :
    {
        kernel_phys_offset = 0xffffffffc0000000;
        sections_text = (. - kernel_phys_offset);
        KEEP(*(.multiboot))
        *(.text)
        sections_text_end = (. - kernel_phys_offset);
    }

    .data ALIGN(4K) :
    {
        sections_data = (. - kernel_phys_offset);
        *(.data)
        *(.rodata)
        sections_data_end = (. - kernel_phys_offset);
    }

    .bss ALIGN(4K) :
    {
        sections_bss = (. - kernel_phys_offset);
        *(COMMON)
        *(.bss)
        sections_bss_end = (. - kernel_phys_offset);
    }
}
