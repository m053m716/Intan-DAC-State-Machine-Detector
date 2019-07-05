/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/main_red_tb.v";
static int ng1[] = {1, 0};
static int ng2[] = {0, 0};
static int ng3[] = {4, 0};
static int ng4[] = {2, 0};
static int ng5[] = {8, 0};
static unsigned int ng6[] = {1U, 0U};
static int ng7[] = {5894, 0};
static unsigned int ng8[] = {3U, 0U};
static int ng9[] = {32255, 0};
static int ng10[] = {30973, 0};
static const char *ng11 = "ampl_data_bin.txt";
static const char *ng12 = "output_main_reduced_2.txt";
static const char *ng13 = "w";
static const char *ng14 = "output_fsm_window_state_1.txt";
static int ng15[] = {100, 0};
static int ng16[] = {205, 0};
static const char *ng17 = "%b\n";
static const char *ng18 = "Current value of DAC_register is %d";



static void Initial_118_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;

LAB0:    t1 = (t0 + 9064U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(118, ng0);

LAB4:    xsi_set_current_line(120, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3344);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(121, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3504);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(122, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3664);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(123, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3824);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(124, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3984);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(125, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4144);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(126, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 4304);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(127, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 4464);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(128, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 4624);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(129, ng0);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 4784);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 2);
    xsi_set_current_line(130, ng0);
    t2 = ((char*)((ng7)));
    t3 = (t0 + 4944);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(131, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 5104);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(132, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5264);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(133, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5424);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(134, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5584);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(135, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5744);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(136, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 5904);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 2);
    xsi_set_current_line(137, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 6064);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 3);
    xsi_set_current_line(138, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 6224);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 7);
    xsi_set_current_line(139, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 6384);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(140, ng0);
    t2 = ((char*)((ng10)));
    t3 = (t0 + 6544);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(141, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 6704);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(142, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 6864);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(143, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 7024);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(144, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 7184);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 2);
    xsi_set_current_line(145, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 7344);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(146, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 7504);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(147, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 7984);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(151, ng0);
    t2 = (t0 + 8872);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(152, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3344);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    goto LAB1;

}

static void Initial_156_1(char *t0)
{
    char t2[8];
    char *t1;
    char *t3;

LAB0:    xsi_set_current_line(156, ng0);

LAB2:    xsi_set_current_line(157, ng0);
    t1 = (t0 + 8144);
    xsi_vlogfile_readmemb(ng11, 0, t1, 0, 0, 0, 0);
    xsi_set_current_line(158, ng0);
    *((int *)t2) = xsi_vlogfile_file_open_of_cname_ctype(ng12, ng13);
    t1 = (t2 + 4);
    *((int *)t1) = 0;
    t3 = (t0 + 7664);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(159, ng0);
    *((int *)t2) = xsi_vlogfile_file_open_of_cname_ctype(ng14, ng13);
    t1 = (t2 + 4);
    *((int *)t1) = 0;
    t3 = (t0 + 7824);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);

LAB1:    return;
}

static void Always_162_2(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;

LAB0:    t1 = (t0 + 9560U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(163, ng0);
    t2 = (t0 + 9368);
    xsi_process_wait(t2, 2000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(164, ng0);
    t4 = (t0 + 3504);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memset(t3, 0, 8);
    t7 = (t6 + 4);
    t8 = *((unsigned int *)t7);
    t9 = (~(t8));
    t10 = *((unsigned int *)t6);
    t11 = (t10 & t9);
    t12 = (t11 & 1U);
    if (t12 != 0)
        goto LAB8;

LAB6:    if (*((unsigned int *)t7) == 0)
        goto LAB5;

LAB7:    t13 = (t3 + 4);
    *((unsigned int *)t3) = 1;
    *((unsigned int *)t13) = 1;

LAB8:    t14 = (t0 + 3504);
    xsi_vlogvar_assign_value(t14, t3, 0, 0, 1);
    goto LAB2;

LAB5:    *((unsigned int *)t3) = 1;
    goto LAB8;

}

static void Always_166_3(char *t0)
{
    char t6[8];
    char t24[8];
    char t40[8];
    char t81[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    char *t23;
    char *t25;
    char *t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    char *t39;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    char *t44;
    char *t45;
    char *t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    char *t54;
    char *t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    int t64;
    int t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    char *t72;
    unsigned int t73;
    unsigned int t74;
    unsigned int t75;
    unsigned int t76;
    unsigned int t77;
    char *t78;
    char *t79;
    char *t80;
    char *t82;
    char *t83;
    char *t84;
    char *t85;
    char *t86;
    char *t87;
    char *t88;
    char *t89;
    char *t90;
    char *t91;

LAB0:    t1 = (t0 + 9808U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(166, ng0);
    t2 = (t0 + 10128);
    *((int *)t2) = 1;
    t3 = (t0 + 9840);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(166, ng0);

LAB5:    xsi_set_current_line(167, ng0);
    t4 = (t0 + 2624U);
    t5 = *((char **)t4);
    t4 = ((char*)((ng2)));
    memset(t6, 0, 8);
    t7 = (t5 + 4);
    t8 = (t4 + 4);
    t9 = *((unsigned int *)t5);
    t10 = *((unsigned int *)t4);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t7);
    t13 = *((unsigned int *)t8);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t7);
    t17 = *((unsigned int *)t8);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB9;

LAB6:    if (t18 != 0)
        goto LAB8;

LAB7:    *((unsigned int *)t6) = 1;

LAB9:    t22 = (t0 + 2304U);
    t23 = *((char **)t22);
    t22 = ((char*)((ng15)));
    memset(t24, 0, 8);
    t25 = (t23 + 4);
    t26 = (t22 + 4);
    t27 = *((unsigned int *)t23);
    t28 = *((unsigned int *)t22);
    t29 = (t27 ^ t28);
    t30 = *((unsigned int *)t25);
    t31 = *((unsigned int *)t26);
    t32 = (t30 ^ t31);
    t33 = (t29 | t32);
    t34 = *((unsigned int *)t25);
    t35 = *((unsigned int *)t26);
    t36 = (t34 | t35);
    t37 = (~(t36));
    t38 = (t33 & t37);
    if (t38 != 0)
        goto LAB13;

LAB10:    if (t36 != 0)
        goto LAB12;

LAB11:    *((unsigned int *)t24) = 1;

LAB13:    t41 = *((unsigned int *)t6);
    t42 = *((unsigned int *)t24);
    t43 = (t41 & t42);
    *((unsigned int *)t40) = t43;
    t44 = (t6 + 4);
    t45 = (t24 + 4);
    t46 = (t40 + 4);
    t47 = *((unsigned int *)t44);
    t48 = *((unsigned int *)t45);
    t49 = (t47 | t48);
    *((unsigned int *)t46) = t49;
    t50 = *((unsigned int *)t46);
    t51 = (t50 != 0);
    if (t51 == 1)
        goto LAB14;

LAB15:
LAB16:    t72 = (t40 + 4);
    t73 = *((unsigned int *)t72);
    t74 = (~(t73));
    t75 = *((unsigned int *)t40);
    t76 = (t75 & t74);
    t77 = (t76 != 0);
    if (t77 > 0)
        goto LAB17;

LAB18:
LAB19:    xsi_set_current_line(171, ng0);
    t2 = (t0 + 2624U);
    t3 = *((char **)t2);
    t2 = ((char*)((ng2)));
    memset(t6, 0, 8);
    t4 = (t3 + 4);
    t5 = (t2 + 4);
    t9 = *((unsigned int *)t3);
    t10 = *((unsigned int *)t2);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t4);
    t13 = *((unsigned int *)t5);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t4);
    t17 = *((unsigned int *)t5);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB24;

LAB21:    if (t18 != 0)
        goto LAB23;

LAB22:    *((unsigned int *)t6) = 1;

LAB24:    t8 = (t0 + 2304U);
    t21 = *((char **)t8);
    t8 = ((char*)((ng16)));
    memset(t24, 0, 8);
    t22 = (t21 + 4);
    t23 = (t8 + 4);
    t27 = *((unsigned int *)t21);
    t28 = *((unsigned int *)t8);
    t29 = (t27 ^ t28);
    t30 = *((unsigned int *)t22);
    t31 = *((unsigned int *)t23);
    t32 = (t30 ^ t31);
    t33 = (t29 | t32);
    t34 = *((unsigned int *)t22);
    t35 = *((unsigned int *)t23);
    t36 = (t34 | t35);
    t37 = (~(t36));
    t38 = (t33 & t37);
    if (t38 != 0)
        goto LAB28;

LAB25:    if (t36 != 0)
        goto LAB27;

LAB26:    *((unsigned int *)t24) = 1;

LAB28:    t41 = *((unsigned int *)t6);
    t42 = *((unsigned int *)t24);
    t43 = (t41 & t42);
    *((unsigned int *)t40) = t43;
    t26 = (t6 + 4);
    t39 = (t24 + 4);
    t44 = (t40 + 4);
    t47 = *((unsigned int *)t26);
    t48 = *((unsigned int *)t39);
    t49 = (t47 | t48);
    *((unsigned int *)t44) = t49;
    t50 = *((unsigned int *)t44);
    t51 = (t50 != 0);
    if (t51 == 1)
        goto LAB29;

LAB30:
LAB31:    t54 = (t40 + 4);
    t73 = *((unsigned int *)t54);
    t74 = (~(t73));
    t75 = *((unsigned int *)t40);
    t76 = (t75 & t74);
    t77 = (t76 != 0);
    if (t77 > 0)
        goto LAB32;

LAB33:
LAB34:    goto LAB2;

LAB8:    t21 = (t6 + 4);
    *((unsigned int *)t6) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB9;

LAB12:    t39 = (t24 + 4);
    *((unsigned int *)t24) = 1;
    *((unsigned int *)t39) = 1;
    goto LAB13;

LAB14:    t52 = *((unsigned int *)t40);
    t53 = *((unsigned int *)t46);
    *((unsigned int *)t40) = (t52 | t53);
    t54 = (t6 + 4);
    t55 = (t24 + 4);
    t56 = *((unsigned int *)t6);
    t57 = (~(t56));
    t58 = *((unsigned int *)t54);
    t59 = (~(t58));
    t60 = *((unsigned int *)t24);
    t61 = (~(t60));
    t62 = *((unsigned int *)t55);
    t63 = (~(t62));
    t64 = (t57 & t59);
    t65 = (t61 & t63);
    t66 = (~(t64));
    t67 = (~(t65));
    t68 = *((unsigned int *)t46);
    *((unsigned int *)t46) = (t68 & t66);
    t69 = *((unsigned int *)t46);
    *((unsigned int *)t46) = (t69 & t67);
    t70 = *((unsigned int *)t40);
    *((unsigned int *)t40) = (t70 & t66);
    t71 = *((unsigned int *)t40);
    *((unsigned int *)t40) = (t71 & t67);
    goto LAB16;

LAB17:    xsi_set_current_line(167, ng0);

LAB20:    xsi_set_current_line(168, ng0);
    t78 = (t0 + 8144);
    t79 = (t78 + 56U);
    t80 = *((char **)t79);
    t82 = (t0 + 8144);
    t83 = (t82 + 72U);
    t84 = *((char **)t83);
    t85 = (t0 + 8144);
    t86 = (t85 + 64U);
    t87 = *((char **)t86);
    t88 = (t0 + 7984);
    t89 = (t88 + 56U);
    t90 = *((char **)t89);
    xsi_vlog_generic_get_array_select_value(t81, 16, t80, t84, t87, 2, 1, t90, 32, 1);
    t91 = (t0 + 3664);
    xsi_vlogvar_wait_assign_value(t91, t81, 0, 0, 16, 0LL);
    xsi_set_current_line(169, ng0);
    t2 = (t0 + 7984);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng1)));
    memset(t6, 0, 8);
    xsi_vlog_signed_add(t6, 32, t4, 32, t5, 32);
    t7 = (t0 + 7984);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 32);
    goto LAB19;

LAB23:    t7 = (t6 + 4);
    *((unsigned int *)t6) = 1;
    *((unsigned int *)t7) = 1;
    goto LAB24;

LAB27:    t25 = (t24 + 4);
    *((unsigned int *)t24) = 1;
    *((unsigned int *)t25) = 1;
    goto LAB28;

LAB29:    t52 = *((unsigned int *)t40);
    t53 = *((unsigned int *)t44);
    *((unsigned int *)t40) = (t52 | t53);
    t45 = (t6 + 4);
    t46 = (t24 + 4);
    t56 = *((unsigned int *)t6);
    t57 = (~(t56));
    t58 = *((unsigned int *)t45);
    t59 = (~(t58));
    t60 = *((unsigned int *)t24);
    t61 = (~(t60));
    t62 = *((unsigned int *)t46);
    t63 = (~(t62));
    t64 = (t57 & t59);
    t65 = (t61 & t63);
    t66 = (~(t64));
    t67 = (~(t65));
    t68 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t68 & t66);
    t69 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t69 & t67);
    t70 = *((unsigned int *)t40);
    *((unsigned int *)t40) = (t70 & t66);
    t71 = *((unsigned int *)t40);
    *((unsigned int *)t40) = (t71 & t67);
    goto LAB31;

LAB32:    xsi_set_current_line(171, ng0);

LAB35:    xsi_set_current_line(172, ng0);
    t55 = (t0 + 7664);
    t72 = (t55 + 56U);
    t78 = *((char **)t72);
    t79 = (t0 + 1984U);
    t80 = *((char **)t79);
    xsi_vlogfile_fwrite(*((unsigned int *)t78), 0, 0, 1, ng17, 2, t0, (char)118, t80, 16);
    xsi_set_current_line(173, ng0);
    t2 = (t0 + 7824);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 1824U);
    t7 = *((char **)t5);
    xsi_vlogfile_fwrite(*((unsigned int *)t4), 0, 0, 1, ng17, 2, t0, (char)118, t7, 32);
    xsi_set_current_line(174, ng0);
    t2 = (t0 + 1984U);
    t3 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng18, 2, t0, (char)118, t3, 16);
    goto LAB34;

}


extern void work_m_00000000003173563074_1242287797_init()
{
	static char *pe[] = {(void *)Initial_118_0,(void *)Initial_156_1,(void *)Always_162_2,(void *)Always_166_3};
	xsi_register_didat("work_m_00000000003173563074_1242287797", "isim/main_red_tb_isim_beh.exe.sim/work/m_00000000003173563074_1242287797.didat");
	xsi_register_executes(pe);
}
