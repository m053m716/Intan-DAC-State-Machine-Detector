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
static const char *ng0 = "C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/main_mod_tb.v";
static int ng1[] = {1, 0};
static int ng2[] = {0, 0};
static int ng3[] = {5, 0};
static int ng4[] = {7, 0};
static int ng5[] = {8, 0};
static int ng6[] = {9, 0};
static unsigned int ng7[] = {14U, 0U};
static int ng8[] = {3991, 0};
static unsigned int ng9[] = {15U, 0U};
static int ng10[] = {32532, 0};
static int ng11[] = {32430, 0};
static int ng12[] = {32701, 0};
static int ng13[] = {32968, 0};
static unsigned int ng14[] = {8U, 0U};
static const char *ng15 = "ampl_data_bin.txt";
static const char *ng16 = "output_main_reduced_2.txt";
static const char *ng17 = "w";
static const char *ng18 = "output_fsm_window_state_1.txt";
static int ng19[] = {100, 0};
static int ng20[] = {205, 0};
static const char *ng21 = "%b\n";
static const char *ng22 = "Current value of DAC_register is %d";



static void Initial_186_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;

LAB0:    t1 = (t0 + 14504U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(186, ng0);

LAB4:    xsi_set_current_line(188, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 5264);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(189, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5424);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(190, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5584);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(191, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 5744);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(192, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5904);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(193, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 6064);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(194, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 6224);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(195, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 6384);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(196, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 6544);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(197, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 6704);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(198, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 6864);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(199, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 7024);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(200, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 7184);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(201, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 7344);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(202, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 7504);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(203, ng0);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 7664);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(204, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 7824);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(205, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 7984);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(206, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 8144);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(207, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 8304);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(208, ng0);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 8464);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(209, ng0);
    t2 = ((char*)((ng7)));
    t3 = (t0 + 8624);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(210, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 8784);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(211, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 8944);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(212, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 9104);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(213, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 9264);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(214, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 9424);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(215, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 9584);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(216, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 9744);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(217, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 9904);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(218, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 10064);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(219, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 10224);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(220, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 10384);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(221, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 10544);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(222, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 10704);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 3);
    xsi_set_current_line(223, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 10864);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 7);
    xsi_set_current_line(224, ng0);
    t2 = ((char*)((ng10)));
    t3 = (t0 + 11024);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(225, ng0);
    t2 = ((char*)((ng11)));
    t3 = (t0 + 11184);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(226, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 11344);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(227, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 11504);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(228, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 11664);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(229, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 11824);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(230, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 11984);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(231, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 12144);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(232, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 12304);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(233, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 12464);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(234, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 12624);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(235, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 12784);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(236, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 12944);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(237, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 13424);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(240, ng0);
    t2 = (t0 + 14312);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(241, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5264);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    goto LAB1;

}

static void Initial_247_1(char *t0)
{
    char t2[8];
    char *t1;
    char *t3;

LAB0:    xsi_set_current_line(247, ng0);

LAB2:    xsi_set_current_line(248, ng0);
    t1 = (t0 + 13584);
    xsi_vlogfile_readmemb(ng15, 0, t1, 0, 0, 0, 0);
    xsi_set_current_line(249, ng0);
    *((int *)t2) = xsi_vlogfile_file_open_of_cname_ctype(ng16, ng17);
    t1 = (t2 + 4);
    *((int *)t1) = 0;
    t3 = (t0 + 13104);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(250, ng0);
    *((int *)t2) = xsi_vlogfile_file_open_of_cname_ctype(ng18, ng17);
    t1 = (t2 + 4);
    *((int *)t1) = 0;
    t3 = (t0 + 13264);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);

LAB1:    return;
}

static void Always_253_2(char *t0)
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

LAB0:    t1 = (t0 + 15000U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(254, ng0);
    t2 = (t0 + 14808);
    xsi_process_wait(t2, 2000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(255, ng0);
    t4 = (t0 + 5424);
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

LAB8:    t14 = (t0 + 5424);
    xsi_vlogvar_assign_value(t14, t3, 0, 0, 1);
    goto LAB2;

LAB5:    *((unsigned int *)t3) = 1;
    goto LAB8;

}

static void Always_257_3(char *t0)
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

LAB0:    t1 = (t0 + 15248U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(257, ng0);
    t2 = (t0 + 15568);
    *((int *)t2) = 1;
    t3 = (t0 + 15280);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(257, ng0);

LAB5:    xsi_set_current_line(258, ng0);
    t4 = (t0 + 3584U);
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

LAB9:    t22 = (t0 + 3264U);
    t23 = *((char **)t22);
    t22 = ((char*)((ng19)));
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
LAB19:    xsi_set_current_line(262, ng0);
    t2 = (t0 + 3584U);
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

LAB24:    t8 = (t0 + 3264U);
    t21 = *((char **)t8);
    t8 = ((char*)((ng20)));
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

LAB17:    xsi_set_current_line(258, ng0);

LAB20:    xsi_set_current_line(259, ng0);
    t78 = (t0 + 13584);
    t79 = (t78 + 56U);
    t80 = *((char **)t79);
    t82 = (t0 + 13584);
    t83 = (t82 + 72U);
    t84 = *((char **)t83);
    t85 = (t0 + 13584);
    t86 = (t85 + 64U);
    t87 = *((char **)t86);
    t88 = (t0 + 13424);
    t89 = (t88 + 56U);
    t90 = *((char **)t89);
    xsi_vlog_generic_get_array_select_value(t81, 16, t80, t84, t87, 2, 1, t90, 32, 1);
    t91 = (t0 + 5584);
    xsi_vlogvar_wait_assign_value(t91, t81, 0, 0, 16, 0LL);
    xsi_set_current_line(260, ng0);
    t2 = (t0 + 13424);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng1)));
    memset(t6, 0, 8);
    xsi_vlog_signed_add(t6, 32, t4, 32, t5, 32);
    t7 = (t0 + 13424);
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

LAB32:    xsi_set_current_line(262, ng0);

LAB35:    xsi_set_current_line(263, ng0);
    t55 = (t0 + 13104);
    t72 = (t55 + 56U);
    t78 = *((char **)t72);
    t79 = (t0 + 1984U);
    t80 = *((char **)t79);
    xsi_vlogfile_fwrite(*((unsigned int *)t78), 0, 0, 1, ng21, 2, t0, (char)118, t80, 16);
    xsi_set_current_line(264, ng0);
    t2 = (t0 + 13264);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 1824U);
    t7 = *((char **)t5);
    xsi_vlogfile_fwrite(*((unsigned int *)t4), 0, 0, 1, ng21, 2, t0, (char)118, t7, 32);
    xsi_set_current_line(265, ng0);
    t2 = (t0 + 1984U);
    t3 = *((char **)t2);
    xsi_vlogfile_write(1, 0, 0, ng22, 2, t0, (char)118, t3, 16);
    goto LAB34;

}


extern void work_m_00000000002121727982_4063979098_init()
{
	static char *pe[] = {(void *)Initial_186_0,(void *)Initial_247_1,(void *)Always_253_2,(void *)Always_257_3};
	xsi_register_didat("work_m_00000000002121727982_4063979098", "isim/main_mod_tb_isim_beh.exe.sim/work/m_00000000002121727982_4063979098.didat");
	xsi_register_executes(pe);
}
