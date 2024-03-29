#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
	asm volatile (
		"sidt %0"
		:
		"=m"(*idtr)
	);
}

void my_load_idt(struct desc_ptr *idtr) {
	asm volatile (
		"lidt %0"
		::
		"m"(*idtr)
	);
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
	gate->offset_low = addr;
	gate->offset_middle = addr >> 16;
	gate->offset_high = addr >> 32;
}

unsigned long my_get_gate_offset(gate_desc *gate) {
	unsigned long ret = 0;
	ret |= gate->offset_low;
	ret |= (unsigned long)gate->offset_middle << 16;
	ret |= (unsigned long)gate->offset_high << 32;
	return ret;
}
