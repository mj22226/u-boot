/* SPDX-License-Identifier: GPL-2.0+ */
/*
 * (C) 2018 Alexander Graf <agraf@suse.de>
 */

#include <config.h>
#include <linux/linkage.h>

#ifdef CONFIG_ARCH_RV64I
#define STORE_IDX(reg, idx)	sd reg, (idx*8)(a0)
#define LOAD_IDX(reg, idx)	ld reg, (idx*8)(a0)
#else
#define STORE_IDX(reg, idx)	sw reg, (idx*4)(a0)
#define LOAD_IDX(reg, idx)	lw reg, (idx*4)(a0)
#endif

.pushsection .text.setjmp, "ax"
ENTRY(setjmp)
	/* Preserve all callee-saved registers and the SP */
	STORE_IDX(s0, 0)
	STORE_IDX(s1, 1)
	STORE_IDX(s2, 2)
	STORE_IDX(s3, 3)
	STORE_IDX(s4, 4)
	STORE_IDX(s5, 5)
	STORE_IDX(s6, 6)
	STORE_IDX(s7, 7)
	STORE_IDX(s8, 8)
	STORE_IDX(s9, 9)
	STORE_IDX(s10, 10)
	STORE_IDX(s11, 11)
	STORE_IDX(ra, 12)
	STORE_IDX(sp, 13)
	li  a0, 0
	ret
ENDPROC(setjmp)
.popsection

.pushsection .text.longjmp, "ax"
ENTRY(longjmp)
	LOAD_IDX(s0, 0)
	LOAD_IDX(s1, 1)
	LOAD_IDX(s2, 2)
	LOAD_IDX(s3, 3)
	LOAD_IDX(s4, 4)
	LOAD_IDX(s5, 5)
	LOAD_IDX(s6, 6)
	LOAD_IDX(s7, 7)
	LOAD_IDX(s8, 8)
	LOAD_IDX(s9, 9)
	LOAD_IDX(s10, 10)
	LOAD_IDX(s11, 11)
	LOAD_IDX(ra, 12)
	LOAD_IDX(sp, 13)

	/* Move the return value in place, but return 1 if passed 0. */
	seqz a0, a1
	add a0, a0, a1
	ret
ENDPROC(longjmp)
.popsection

.pushsection .text.initjmp, "ax"
ENTRY(initjmp)
	/* a1: entry point address, a2: stack base, a3: stack size */
	add a2, a2, a3
	STORE_IDX(a1, 12)
	STORE_IDX(a2, 13)
	li  a0, 0
	ret
ENDPROC(initjmp)
.popsection
